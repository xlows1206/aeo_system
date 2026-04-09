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
            // 公司存续年份
            $duration_year = $companyInfo?->duration_year ?? 0;
            // 根据年份算出年份
            $duration_years = [];
            for ($i = 0; $i < $duration_year; $i++) {
                $duration_years[] = date('Y', strtotime('-' . $i . 'year'));
            }
            $intData = [];
            foreach ($infos as $info) {
                $data = $info['data'];
                $infoIntData = array_filter($data, function ($v) {
                    return is_int($v);
                });
                $intData = array_merge($intData, $infoIntData);
            }
            $all_files = Db::table('files as f')
                ->leftJoin('folders as fo', 'f.folder_id', '=', 'fo.id')
                ->leftJoin('folder_check_files as fcf', 'fcf.folder_id', '=', 'fo.id')
                ->whereIn('f.id', $intData)
                ->select(['*', 'f.id as file_id', 'fo.name as folder_name', 'fcf.id as check_id'])
                ->get();
            $all_files_group = $all_files->groupBy('f.folder_id');

            foreach ($all_files_group as $files) {
                foreach ($files as $file) {
                    if ($file->check_type == 1) {
                        $handler = CheckHandlerFactory::make($file->check_name);
                        $aiStr = $handler->getPrompt(['check_text' => $file->check_text]);

                        $parallel->add(function () use ($file, $finance, $base_url, $model_name, $aiStr) {
                            return $this->extracted($aiStr, $file, $finance, $base_url, $model_name, [1, 2, 3]);
                        });
                    } else {
                        $ai_pre_res[] = [
                            "folder_id" => $file->folder_id,
                            "standard_id" => $file->standard_id,
                            "folder_name" => $file->file_name,
                            "check_id" => $file->check_id,
                            "master_id" => $masterId,
                            "is_access" => 1
                        ];
                    }
                }
            }

            $parallel->wait();

            $results = $this->redisService->make()->hGetAll('ai_result:' . $this->prefixId);
            $res = [];
            foreach ($results as $key => $result) {
                Log::get()->info($result);
                $key_arr = explode('_', $key);
                $result = json_decode($result, true);
                $check_id = $key_arr[0];
                $file = $all_files->where('check_id', $check_id)->first();
                if ($file) {
                    $handler = CheckHandlerFactory::make($file->check_name);
                    $res[$file->check_name][] = $handler->parseResult($result);
                }
            }
            $resInfo = [];
            $context = [
                'company_name' => $companyInfo->company_name ?? '',
                'company_person_names' => $companyPersonName,
                'duration_years' => $duration_years,
                'not_self_total' => $companyInfo->not_self_total ?? 0,
            ];

            foreach ($res as $check_name => $aggregatedData) {
                $handler = CheckHandlerFactory::make($check_name);
                $auditResult = $handler->performAudit($aggregatedData, array_merge($context, ['check_name' => $check_name]));
                if ($auditResult) {
                    $resInfo[$check_name] = explode('; ', $auditResult);
                }
            }

            $aiResult = [];
            foreach ($all_files as $file) {
                if (isset($resInfo[$file->check_name]) && count($resInfo[$file->check_name]) > 0) {
                    $ai_pre_res[] = [
                        "folder_id" => $file->folder_id,
                        "standard_id" => $file->standard_id,
                        "folder_name" => $file->file_name,
                        "master_id" => $masterId,
                        "check_id" => $file->check_id,
                        "failed_str" => join(",", $resInfo[$file->check_name]),
                        "is_access" => 0
                    ];
                    foreach ($resInfo[$file->check_name] as $fail_err) {
                        $aiResult[] = $fail_err;
                    }
                } else {
                    $ai_pre_res[] = [
                        "folder_id" => $file->folder_id,
                        "standard_id" => $file->standard_id,
                        "folder_name" => $file->file_name,
                        "master_id" => $masterId,
                        "check_id" => $file->check_id,
                        "is_access" => 1
                    ];
                }
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

            $aiResult = array_unique($aiResult);

            $status = 0;
            if (count($aiResult) > 1) {
                $status = 1;
            }
            if (count($aiResult) == 1) {
                $status = 2;
            }
            if (count($aiResult) == 0) {
                $status = 3;
            }

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

        } catch (\Exception $e) {
            $aiResult = ['获取结果失败, 请重新提交资料.'];
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

            var_dump($e);
            Log::get()->error('GetAiResult Error: ', [
                'message' => $e,
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
            $field_prefix = $file->check_id;
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
            $accessKeyId = getenv('OSS_ACCESS_KEY');
            $accessKeySecret = getenv('OSS_SECRET_KEY');
            $endpoint = getenv('OSS_ENDPOINT');
            $bucket = getenv('OSS_BUCKET');
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
}
