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
                        if ($file->check_name == '资产负债率情况') {
                            $aiStr =
                                '# 角色
                                            你是一个专业且谨慎仔细的文员，非常擅长于从图片中抽取相关信息。
                                            # 任务
                                            你需要从提供资料的"期末余额列"中提取分别叫做“负债合计”、“负债和所有者权益(或股东权益)合计”行的数据，并以以下格式输出结果。
                                            请注意，你需要的值是“负债和所有者权益(或股东权益)合计”，而不是“所有者权益合计”这一行数据。
                                            # 输出格式
                                            请你以下面的JSON格式输出数据,"负债合计"命名为"liability","负债和所有者权益(或股东权益)合计"命名为"liability_equity",保留两位小数。
                                               {
                                                  "year": "{年份}",
                                                  "liability": "{负债合计}",
                                                  "liability_equity": "{负债和所有者权益(或股东权益)合计}"
                                                }';
                        } elseif ($file->check_name == '审计报告') {
                            $aiStr = '# 角色
                                            你是一个专业且谨慎仔细的文员，非常擅长于从文档资料中抽取相关信息并且判断是否符合业务规定。
                                              # 任务
                                              你需要仔细从提供的资料中提取会计事务所的审计意见并存入{scratch_pad}，"无法表示意见"、“有保留意见”、“无法出具”等意见为不通过，"无保留意见"为通过,请你根据内容输出{review}，输出结果true或false
                                              # 输出格式
                                              {
                                                "year": "{year}",
                                                "review": "{scratch_pad}",
                                                “result”: “{review}”
                                              }';
                        } elseif ($file->check_name == '遵守法律法规') {
                            $aiStr = '
                                            # 角色
                                            你是一个专业且谨慎仔细的文员，非常擅长于从文档资料中抽取相关信息并且判断是否符合业务规定。
                                            # 任务
                                            请你提取资料中的名字、证件号码存储到{scratch_pad}中,根据输出格式输出对应内容。
                                            # 输出格式
                                            请你以下面的JSON格式输出数据
                                            {
                                            "name":"{name}",
                                            "id":"{id}"
                                            "year":"{year}"
                                            }';
                        } elseif ($file->check_name == '行政被处罚金额') {
                            $aiStr = "请你输出如下信息并用括号内字段命名，以JSON格式输出：时间(time)，被罚款单位(company)，罚款金额（amount）,单位为元";
                        } elseif ($file->check_name == '被处罚单比例小于报关千分之一') {
                            $aiStr = "请你识别文件中是否包含'“经自查”'关键字，以JSON格式只输出result字段内容，包含为true，否则false，禁止输出其他内容。";
                        } else {
                            $aiStr = "请你识别文件中是否包含'$file->check_text'关键字，以JSON格式只输出result字段内容，包含为true，否则false，禁止输出其他内容。";
                        }
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
                switch ($file->check_name) {
                    case '遵守法律法规':
                        $res[$file->check_name][] = [
                            'file_id' => $file->file_id,
                            'name' => $result['name'] ??  null,
                            'file_name' => $file->file_name,
                            'folder_id' => $file->folder_id,
                            'folder_name' => $file->folder_name,
                            'check_name' => $file->check_name,
                        ];
                        break;
                    case '资产负债率情况':
                        $res[$file->check_name][$result['year']] = [
                            'file_id' => $file->file_id,
                            'year' => $result['year'] ?? null,
                            'liability' => $result['liability'] ?? null,
                            'liability_equity' => $result['liability_equity'] ?? null,
                            'file_name' => $file->file_name,
                            'folder_id' => $file->folder_id,
                            'folder_name' => $file->folder_name,
                            'check_name' => $file->check_name,
                        ];
                        break;
                    case '行政被处罚金额':
                        $res[$file->check_name][] = [
                            'file_id' => $file->file_id,
                            'year' => $result['time'] ?? null,
                            'company' => $result['company'] ?? null,
                            'amount' => $result['amount'] ?? null,
                            'file_name' => $file->file_name,
                            'folder_id' => $file->folder_id,
                            'folder_name' => $file->folder_name,
                            'check_name' => $file->check_name,
                        ];
                        break;
                    case '被处罚单比例小于报关千分之一':
                        if (!$result['result'] || $result['result'] == 'false') {
                            if (!isset($res[$file->check_name])) {
                                $res[$file->check_name]['false_count'] = 1;
                            } else {
                                $res[$file->check_name]['false_count'] += 1;
                            }
                        }
                        $res[$file->check_name][] = [
                            'file_id' => $file->file_id,
                            'year' => $result['year'] ?? null,
                            'result' => $result['result'] ?? null,
                            'file_name' => $file->file_name,
                            'folder_id' => $file->folder_id,
                            'folder_name' => $file->folder_name,
                            'check_name' => $file->check_name,
                        ];
                        break;
                    case '审计报告':
                        if ($result['result'] || $result['result'] == 'true') {
                            $res[$file->check_name][$result['year']] = [
                                'file_id' => $file->file_id,
                                'year' => $result['year'] ?? null,
                                'result' => $result['result'] ?? null,
                                'file_name' => $file->file_name,
                                'folder_id' => $file->folder_id,
                                'folder_name' => $file->folder_name,
                                'check_name' => $file->check_name,
                            ];
                        }
                        break;
                    default:
                        $res[$file->check_name] = [
                            'file_id' => $file->file_id,
                            'result' => $result['result'] ?? null,
                            'file_name' => $file->file_name,
                            'folder_id' => $file->folder_id,
                            'folder_name' => $file->folder_name,
                            'check_name' => $file->check_name,
                        ];
                }
            }
            $resInfo = [];
            foreach ($res as $key => $results) {
                $check_name = $key;
                switch ($check_name) {
                    case '遵守法律法规':
                        $allPersons = [];
                        foreach ($results as $result) {
                            $result = json_decode($result, true);
                            foreach ($result as $value) {
                                $allPersons[] = $value['name'] ?? '';
                            }
                        }

                        if (count($companyPersonName) < 4) {
                            $resInfo[$check_name][] = '无犯罪记录证明验证失败，未设置公司主要负责人信息';
                            break;
                        }

                        // 跟公司主要人取差，如果存在差集，则不合格
                        $diffPersons = array_diff($companyPersonName, $allPersons);
                        if (count($diffPersons) > 0) {
                            $resInfo[$check_name][] = implode('、', $diffPersons) . ' 未提供无犯罪记录证明, 请检查.';
                        }
                        break;
                    case '资产负债率情况':
                        if (count($duration_years) == 0) {
                            $resInfo[$check_name][] = '未设置公司存续年份, 无法进行' . $check_name . '检查.';
                            break;
                        }
                        foreach ($duration_years as $year) {
                            if (!isset($results[$year])) {
                                $resInfo[$check_name][] = $year . '年度' . $check_name . '未读取有效信息';
                            } else {
                                if (isset($results[$year])) {
                                    // 如果 liability 和 liability_equity 都存在，则认为有效
                                    $liability_equity = 0;
                                    $liability = 0;
                                    foreach ($results as $result) {
                                        $liabilityItem = $result['liability'] ?? 0;
                                        $liability_equityItem = $result['liability_equity'] ?? 0;
                                        if ($liabilityItem > 0 && $liability_equityItem > 0) {
                                            $liability = str_replace(',', '', $liabilityItem);
                                            $liability_equity = str_replace(',', '', $liability_equityItem);
                                        }
                                    }

                                    if ($liability == 0 && $liability_equity == 0) {
                                        // 未读取有效信息
                                        $resInfo[$check_name][] = $year . '年度' . $check_name . '未读取有效信息';
                                    } else {
                                        $ratio = bcdiv($liability, $liability_equity, 2);
                                        if ($ratio > 0.95) {
                                            // 不合格
                                            $resInfo[$check_name][] = $year . '年度' . $check_name . '不合格, 负债率为' . $ratio * 100 . '%';
                                        }
                                    }
                                } else {
                                    $resInfo[$check_name][] = $year . '年度' . $check_name . '未读取有效信息';
                                }
                            }
                        }
                        break;
                    case '行政被处罚金额':
                        $amount = 0;
                        $count = 0;
                        foreach ($results as $result) {
                            if ($result['company'] == $companyInfo->company_name) {
                                $amount += $result['amount'];
                                if ($result['is_self'] == 'false') {
                                    $count++;
                                }
                            }
                        }
                        if ($amount > 50000) {
                            $resInfo[$check_name][] = $check_name . '超过5万';
                        }
                        if ($count / $companyInfo->not_self_total > 0.001) {
                            $resInfo[$check_name][] = $check_name . ' 存在被查处罚（不存在“经自查”字段）的报关单 超过 报关单总数 千分之一';
                        }
                        break;
                    case '被处罚单比例小于报关千分之一':
                        $count = $results['false_count'] ?? 0;
                        if ($count / $companyInfo->not_self_total > 0.001) {
                            $resInfo[$check_name][] = $check_name . ' 存在被查处罚（不存在“经自查”字段）的报关单 超过 报关单总数 千分之一';
                        }
                        break;
                    case '审计报告':
                        if (count($duration_years) == 0) {
                            $resInfo[$check_name][] = '未设置公司存续年份, 无法进行' . $check_name . '检查.';
                            break;
                        }
                        if (count($duration_years) > count($results)) {
                            $resInfo[$check_name][] = $check_name . '未通过, 未读取到'.$duration_year.'年有效信息';
                            foreach ($duration_years as $year) {
                                if (!isset($results[$year])) {
                                    $resInfo[$check_name][] = $year . '年度' . $check_name . '未通过, 未读取有效信息';
                                }
                            }
                        }
                        break;
                    default:
                        if (!$results['result'] || $results['result'] == 'false') {
                            $resInfo[$check_name][] = $check_name . '未通过, 未读取有效信息';
                        }
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
