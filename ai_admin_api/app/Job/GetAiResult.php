<?php

declare(strict_types=1);
/**
 * This file is part of Hyperf.
 *
 * @link     https://www.hyperf.io
 * @document https://hyperf.wiki
 * @contact  group@hyperf.io
 * @license  https://github.com/hyperf/hyperf/blob/master/LICENSE
 */

namespace App\Job;

use App\Lib\AI\CheckHandlers\CheckHandlerFactory;
use App\Lib\AI\Finance;
use App\Lib\Log;
use App\Service\LogService;
use App\Service\RedisService;
use App\Service\ArchiveService;
use Hyperf\AsyncQueue\Job;
use Hyperf\Context\ApplicationContext;
use Hyperf\Coroutine\Parallel;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;
use Hyperf\Filesystem\FilesystemFactory;
use Hyperf\Stringable\Str;
use Iidestiny\Flysystem\Oss\OssAdapter;
use League\Flysystem\Filesystem;

class GetAiResult extends Job
{
    public array $params;

    #[Inject]
    protected RedisService $redisService;

    #[Inject]
    protected LogService $logService;

    protected int $pre_audit_id = 0;
    protected int $number = 0;

    protected string $prefixId = '';

    /**
     * 任务执行失败后的重试次数.
     */
    protected int $maxAttempts = 1;

    public function __construct($params)
    {
        $this->params = $params;
    }

    public function handle(): void
    {
        try {
            $this->pre_audit_id = $this->params['id'];
            $this->number = $this->params['number'];
            $this->prefixId = $this->pre_audit_id . '_' . $this->number;

            $masterId = Db::table('pre_audits')
                ->where('id', $this->pre_audit_id)
                ->where('number', $this->number)
                ->value('master_id');
            // 删除历史缓存信息
            $this->redisService->make()->del('ai_result:' . $this->prefixId);

            Log::get()->info('GetAiResult:start', [
                'params' => $this->params,
            ]);

            $parallel = new Parallel(5);

            $preAuditJson = Db::table('pre_audit_json')
                ->where('pre_audit_id', $this->pre_audit_id)
                ->where('number', $this->number)
                ->first();
            $infos = json_decode($preAuditJson->info, true);
            // 检查结果
            $ai_pre_res = [];

            $finance = new Finance();
            $base_url = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
            $model_name = 'qwen-vl-max'; // 如果需要使用特定模型名称

            $companyInfo = Db::table('company_info')->where('master_id', $masterId)->first();

            $companyPersonName = [$companyInfo?->enterprise_person_name, $companyInfo?->principal_person_name, $companyInfo?->financial_person_name, $companyInfo?->customs_person_name];
            $companyPersonName = array_values(array_filter($companyPersonName));

            $start_year = $companyInfo?->start_year ?? 0;
            $end_year = $companyInfo?->end_year ?? 0;
            $duration_years = [];
            
            if ($start_year > 0 && $end_year > 0 && $start_year <= $end_year) {
                for ($y = $start_year; $y <= $end_year; $y++) {
                    $duration_years[] = (string) $y;
                }
            }
            $context = [
                'duration_years' => $duration_years,
                'company_name' => $companyInfo?->name ?? '',
                'company_person_names' => $companyPersonName,
                'not_self_total' => (int)($companyInfo?->not_self_total ?? 0),
            ];

            $intData = [];
            foreach ($infos as $info) {
                $data = $info['data'];
                $infoIntData = array_filter($data, function ($v) {
                    return is_int($v);
                });
                $intData = array_merge($intData, $infoIntData);
            }
            $all_files = Db::table('files as f')
                ->join('folders as fo', 'f.folder_id', '=', 'fo.id')
                ->join('folder_closure as fc', 'fo.id', '=', 'fc.descendant')
                ->join('folder_check_files as fcf', 'fc.ancestor', '=', 'fcf.folder_id')
                ->whereIn('f.id', $intData)
                ->select([
                    'f.*',
                    'f.id as file_id',
                    'fo.name as folder_name',
                    'fcf.id as check_id',
                    'fcf.check_name',
                    'fcf.check_type',
                    'fcf.check_text',
                    'fcf.standard_id'
                ])
                ->orderBy('fc.distance', 'asc')
                ->get();

            // 按 file_id 去重，确保每个文件只对应其最近的审计项祖先
            $all_files = $all_files->unique('file_id');
            $all_files_group = $all_files->groupBy('f.folder_id');
            $checkGroups = $all_files->groupBy('check_id');

            // 预处理：只对需要 AI 参与的项目加入并行队列
            foreach ($all_files_group as $files) {
                foreach ($files as $file) {
                    // check_type: 1-AI内容理解, 2-关键词检测 都走 AI 流程
                    if (in_array($file->check_type, [1, 2])) {
                        $handler = CheckHandlerFactory::make($file->check_name);
                        $aiStr = $handler->getPrompt(['check_text' => $file->check_text]);

                        $parallel->add(function () use ($file, $finance, $base_url, $model_name, $aiStr) {
                            return $this->extracted($aiStr, $file, $finance, $base_url, $model_name, [1, 2]);
                        });
                    }
                }
            }

            $parallel->wait();

            $results = $this->redisService->make()->hGetAll('ai_result:' . $this->prefixId);
            $fileRes = []; // 按文件 ID 聚合的 AI 原始数据
            foreach ($results as $key => $result) {
                $key_arr = explode('_', $key);
                $result = json_decode($result, true);
                if (! is_array($result)) continue;
                
                $check_id = $key_arr[0];
                $file_id = (int)$key_arr[1];
                $fileRes[$file_id][] = $result;
            }

            // 1. 预处理：按项目 (check_id) 汇总所有文件数据
            $projectDataAggregated = []; // check_id => [all_parsed_data]
            foreach ($checkGroups as $cId => $filesInCheck) {
                $handler = CheckHandlerFactory::make($filesInCheck->first()->check_name);
                foreach ($filesInCheck as $file) {
                    $fileData = $fileRes[$file->file_id] ?? [];
                    $parsed = array_map([$handler, 'parseResult'], $fileData);
                    foreach ($parsed as $p) {
                        $projectDataAggregated[$cId][] = $p;
                    }
                }
            }

            // 2. 生成结果：既有项目总分，也有文件明细
            $projectFileFindings = []; // check_id => [ file_id => [details] ]
            $projectAccess = []; // check_id => bool

            foreach ($checkGroups as $cId => $filesInCheck) {
                $firstFile = $filesInCheck->first();
                $handler = CheckHandlerFactory::make($firstFile->check_name);
                $context['check_name'] = $firstFile->check_name;

                // 项目整体状态：基于所有文件的汇总数据
                $allData = $projectDataAggregated[$cId] ?? [];
                $projectAccess[$cId] = $handler->isAccessible($allData, $context);

                // 文件明细：仅基于该文件的数据
                foreach ($filesInCheck as $file) {
                    if ($file->check_type == 3) {
                        $projectFileFindings[$cId][$file->file_id] = [
                            'name' => $file->name,
                            'text' => '上传即合格',
                            'status' => 1
                        ];
                    } else {
                        $fileData = $fileRes[$file->file_id] ?? [];
                        $parsed = array_map([$handler, 'parseResult'], $fileData);
                        
                        $findingText = $handler->performAudit($parsed, $context);
                        $isPass = $handler->isAccessible($parsed, $context);

                        // 状态修正：如果是空数据且项目整体需要多项配合，则单个文件可能不通过
                        if ($isPass && empty($findingText)) {
                            $successMsgs = $handler->getSuccessMessages($parsed, $context);
                            $findingText = !empty($successMsgs) ? join("; ", $successMsgs) : "文档内容符合标准。";
                        } elseif (empty($findingText)) {
                            $findingText = "未能识别到有效信息。";
                        }

                        $projectFileFindings[$cId][$file->file_id] = [
                            'name' => $file->name,
                            'text' => $findingText,
                            'status' => $isPass ? 1 : 0
                        ];
                    }
                }
            }

            $ai_pre_res = [];
            $aiResult = [];

            foreach ($checkGroups as $cId => $filesInCheck) {
                $firstFile = $filesInCheck->first();
                $projectName = $this->extractProjectName($firstFile->check_name);
                $fileFindings = $projectFileFindings[$cId] ?? [];
                $passed = $projectAccess[$cId] ?? false;

                // 汇总该项目下所有文件的结论（不重复拼接）
                $allTexts = [];
                foreach ($fileFindings as $fid => $fr) {
                    $allTexts[] = "【{$fr['name']}】: {$fr['text']}";
                }
                $result_str = join("; ", $allTexts);

                $ai_pre_res[] = [
                    "folder_id" => (int)$firstFile->folder_id,
                    "standard_id" => (int)$firstFile->standard_id,
                    "folder_name" => (string)$firstFile->folder_name,
                    "master_id" => (int)$masterId,
                    "check_id" => (int)$cId,
                    "result_str" => $result_str,
                    "is_access" => $passed ? 1 : 0
                ];

                $aiResult[] = [
                    'project' => $projectName,
                    'status' => $passed ? 1 : 0,
                    'text' => $result_str,
                    'files' => array_values($fileFindings)
                ];
            }

            $del_ids = [];
            foreach ($ai_pre_res as $ai_pre_re) {
                if (Db::table('pre_audit_results')->where('master_id', $masterId)->where('check_id', $ai_pre_re['check_id'])->exists()) {
                    $del_ids[] = $ai_pre_re['check_id'];
                }
            }
            // 删除之前保存的结果
            Db::table('pre_audit_results')->where('master_id', $masterId)->whereIn('check_id', $del_ids)->delete();
            // 保存预审结果至数据库
            Db::table('pre_audit_results')->insert($ai_pre_res);

            // 判定最终状态：只有当所有项都通过(is_access=1)时，整体才为通过(3)
            $allPassed = true;
            foreach ($ai_pre_res as $item) {
                if ($item['is_access'] == 0) {
                    $allPassed = false;
                    break;
                }
            }
            $status = $allPassed ? 3 : 1;

            Db::table('pre_audit_json')
                ->where('pre_audit_id', $this->pre_audit_id)
                ->where('number', $this->number)
                ->update([
                    'ai_result' => json_encode($aiResult, 320),
                    'status' => $status,
                ]);
            Db::table('pre_audits')
                ->where('id', $this->pre_audit_id)
                ->where('number', $this->number)
                ->update([
                    'status' => $status,
                ]);

            // === AEO 归档与状态同步逻辑开始 ===
            $archiveService = ApplicationContext::getContainer()->get(ArchiveService::class);
            // 统计文件夹维度的结果
            $folderResults = [];
            foreach ($ai_pre_res as $item) {
                $fId = $item['folder_id'];
                if (!isset($folderResults[$fId])) {
                    $folderResults[$fId] = ['is_access' => 1, 'file_ids' => []];
                }
                if ($item['is_access'] == 0) {
                    $folderResults[$fId]['is_access'] = 0;
                }
            }
            // 关联文件ID
            foreach ($all_files_group as $fId => $fGroup) {
                if (isset($folderResults[$fId])) {
                    $folderResults[$fId]['file_ids'] = $fGroup->pluck('file_id')->toArray();
                }
            }
            // 执行状态更新与归档/清理
            foreach ($folderResults as $fId => $res) {
                if ($res['is_access'] == 1) {
                    Db::table('folders')->where('id', $fId)->update(['audit_status' => 1]);
                    $archiveService->archiveProjectFiles((int)$masterId, (int)$fId, $res['file_ids']);
                } else {
                    Db::table('folders')->where('id', $fId)->update(['audit_status' => 2]);
                    $archiveService->purgeProjectArchive((int)$masterId, (int)$fId);
                }
            }
            // === AEO 归档与状态同步逻辑结束 ===

        } catch (\Throwable $e) {
            $aiResult = [['project' => '系统错误', 'status' => 0, 'text' => 'AI 解析过程发生异常, 请稍后重试或联系管理员.']];
            Db::table('pre_audit_json')
                ->where('pre_audit_id', $this->pre_audit_id)
                ->where('number', $this->number)
                ->update([
                    'ai_result' => json_encode($aiResult, 320),
                    'status' => 1,
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
            Db::table('pre_audits')
                ->where('id', $this->pre_audit_id)
                ->where('number', $this->number)
                ->update([
                    'status' => 1,
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);

            Log::get()->error('GetAiResult Fatal Error: ', [
                'message' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString(),
            ]);
        }
    }

    /**
     * @param string $key
     * @param string $aiStr
     * @param mixed $file_list
     * @param Finance $finance
     * @param string $base_url
     * @param string $model_name
     * @param array $pages
     * @return array
     */
    public function extracted(string $aiStr, mixed $file, Finance $finance, string $base_url, string $model_name, array $pages = []): array
    {
        $inner = new Parallel(5);
        $inner->add(function () use ($file, $aiStr, $finance, $base_url, $model_name, $pages) {
            $prefix = 'ai_result:' . $this->prefixId;
            $field_prefix = $file->check_id . '_' . $file->file_id;
            $fileUrl = $file->url;
            $images = [];
            if (!$this->isImage($fileUrl)) {
                // 如果pages为空，则为全部页码，先获取共有多少页
                $pages = $this->getPdfPages($fileUrl);
                // 将PDF转为图片，如果图片已经处理过，则跳过
                $isProcess = true;
                foreach ($pages as $page) {
                    if (!$this->redisService->make()->hExists($prefix, $field_prefix . '_' . $page)) {
                        $isProcess = false;
                        break;
                    }
                }
                if (!$isProcess) {
                    $images = $this->processPdf($fileUrl, $pages);
                }
            } else {
                $images = [1 => $fileUrl];
            }
            foreach ($images as $k => $image) {
                if (!$this->redisService->make()->hExists($prefix, $field_prefix . '_' . $k)) {
                    if ($image == '') {
                        $this->logService->make('ai_result')->error('图片处理失败', [
                            'file_id' => $file->id,
                            'page' => $k,
                            'url' => $fileUrl,
                        ]);
                        continue;
                    }
                    $content = $finance->getAiResponse($aiStr, $model_name, $image);
                    $json_cleaned = preg_replace('/```(?:json)?\n|\n```/', '', $content);
                    $this->redisService->make()->hSet($prefix, $field_prefix . '_' . $k, $json_cleaned);
                }
            }
        });
        return $inner->wait();
    }

    function isImage($filePath)
    {
        if (str_starts_with($filePath, 'http')) {
            $extension = strtolower(pathinfo(parse_url($filePath, PHP_URL_PATH), PATHINFO_EXTENSION));
            return in_array($extension, ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp']);
        }
        if (!file_exists($filePath)) return false;
        $info = @getimagesize($filePath);
        return $info !== false;
    }

    public function getPdfPages($pdfUrl): array
    {
        // 下载pdf文件
        $pdf = file_get_contents($pdfUrl);

        $directory = 'pdf/' . date('Ymd') . '/' . Str::random(10) . '/';

        $filesystem = ApplicationContext::getContainer()->get(FilesystemFactory::class);
        $disk = $filesystem->get('local');
        $disk->createDirectory($directory);
        $disk->createDirectory($directory . 'output');

        $path = BASE_PATH . '/runtime/' . $directory;
        $fileName = time() . Str::random(10) . '.pdf';
        file_put_contents($path . $fileName, $pdf);

        $imagick = new \Imagick();
        $imagick->pingImage($path . $fileName);
        $pafCount = $imagick->getNumberImages();
        $pages = range(1, $pafCount);
        return $pages;
    }

    public function processPdf($pdfUrl, $pages = []): array
    {
        $quality = 60;

        // 下载pdf文件
        $pdf = file_get_contents($pdfUrl);

        $directory = 'pdf/' . date('Ymd') . '/' . Str::random(10) . '/';

        $filesystem = ApplicationContext::getContainer()->get(FilesystemFactory::class);
        $disk = $filesystem->get('local');
        $disk->createDirectory($directory);
        $disk->createDirectory($directory . 'output');

        $path = BASE_PATH . '/runtime/' . $directory;
        $fileName = time() . Str::random(10) . '.pdf';
        file_put_contents($path . $fileName, $pdf);

        $urls = [];
        foreach ($pages as $page) {
            $imagick = new \Imagick();
            $imagick->setResolution(150, 150);
            // Imagick 页码从 0 开始
            $imagick->readImage($path . $fileName . '[' . $page - 1 . ']');

            $imagick->setImageFormat('png');
            $imagick->setImageCompression(\Imagick::COMPRESSION_ZIP);
            $imagick->setImageCompressionQuality($quality);
            $imagick->setOption('png:compression-level', '9');

            // 白底 + 裁剪白边
            $imagick->setImageBackgroundColor('white');
            $imagick = $imagick->flattenImages();
            $imagick->trimImage(0);

            $imagick->writeImage($path . 'output/' . "{$page}.png");

            $imagick->clear();
            $imagick->destroy();

            $url = $this->uploadOss($path . 'output/' . "{$page}.png");


            $urls[$page] = $url;
        }

        return $urls;
    }

    public function uploadOss($file_path): string
    {
        // oss 上传图片
        try {
            $prefix = date('Ymd') . '/images/';
            $accessKeyId = (string)env('OSS_ACCESS_KEY');
            $accessKeySecret = (string)env('OSS_SECRET_KEY');
            $endpoint = (string)env('OSS_ENDPOINT');
            $bucket = (string)env('OSS_BUCKET');

            if (empty($accessKeyId) || str_contains($accessKeyId, 'REPLACE')) {
                Log::get()->error('OSS Configuration Missing or Invalid', ['key' => $accessKeyId]);
                return '';
            }
            $adapter = new OssAdapter($accessKeyId, $accessKeySecret, $endpoint, $bucket, false, $prefix);
            $flysystem = new Filesystem($adapter);

            $fileName = $prefix . time() . Str::random(10) . '.png';
            $flysystem->write($fileName, file_get_contents($file_path));
            return $adapter->getUrl($fileName);
        } catch (\Exception $e) {
            $this->logService->make('ai_result')->error('oss upload failed', [
                'file_path' => $file_path,
                'error' => $e->getMessage(),
            ]);
            return '';
        }
    }

    /**
     * 提取项目名称：仅取最后一级名称并剔除前导编号
     * 对应前端 extractProjectName 逻辑
     */
    private function extractProjectName(string $name): string
    {
        if (empty($name)) return '';
        $parts = explode('/', $name);
        $lastPart = end($parts);
        // 剔除前导编号 (例如 "5-14-资产负债率情况" -> "资产负债率情况")
        return preg_replace('/^[\d.-]+\s*/', '', $lastPart);
    }
}
