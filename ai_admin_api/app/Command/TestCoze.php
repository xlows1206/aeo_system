<?php

declare(strict_types=1);

namespace App\Command;

use App\Lib\AI\Finance;
use App\Service\LogService;
use App\Service\RedisService;
use Hyperf\Command\Command as HyperfCommand;
use Hyperf\Command\Annotation\Command;
use Hyperf\Coroutine\Parallel;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;
use Hyperf\Stringable\Str;
use Iidestiny\Flysystem\Oss\OssAdapter;
use League\Flysystem\Filesystem;
use Psr\Container\ContainerInterface;

#[Command]
class TestCoze extends HyperfCommand
{
    #[Inject]
    protected RedisService $redisService;

    #[Inject]
    protected Filesystem $filesystem;

    #[Inject]
    protected LogService $logService;


    protected int $pre_audit_id = 4;

    public function __construct(protected ContainerInterface $container)
    {
        parent::__construct('test:coze');
    }

    public function configure()
    {
        parent::configure();
    }

    public function handle(): void
    {
//
//        $this->test();
//        return;
        $parallel = new Parallel(5);

        $preAuditJson = Db::table('pre_audit_json')
            ->where('pre_audit_id', $this->pre_audit_id)
            ->first();
        $infos = json_decode($preAuditJson->info, true);

        foreach ($infos as $info) {
            $name = $info['name'];
            $data = $info['data'];

            // 取出data中int类型的数据
            $intData = array_filter($data, function ($v) {
                return is_int($v);
            });

            // 找出这些文件对应的上级目录
            $files = Db::table('files as f')
                ->leftJoin('folders as fo', 'f.folder_id', '=', 'fo.id')
                ->whereIn('f.id', $intData)
                ->select('f.id', 'f.name', 'f.url', 'fo.name as folder_name')
                ->get()
                ->groupBy('folder_name');

            $finance = new Finance();
            $base_url = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
            $model_name = 'qwen-vl-max'; // 如果需要使用特定模型名称
//            $model_name = 'qwen-vl-ocr-latest'; // 如果需要使用特定模型名称

            // checkList
            // 5-13 审计报告: result 为true
            // 5-14 资产负债率情况: liability / liability_equity > 0.95 则不通过
            // 3-7-1 系统操作手册: result 为true
            // 3-8-1 制度: result 为true
            // 3-9-1 制度: result 为true
            // 1-2 岗位职责 ： result 为true
            // 1-1 关企联系合作机制 ： result 为true
            // 2-3-1 制度 ： result 为true
            // 2-4-1 单位归档制度 ： result 为true
            // 2-5-1 禁止类产品合规审查制度 ： result 为true
            // 6-16&17&18 ： penalty_amount > 5.0 则不通过
            // 6-15-2 无犯罪记录证明。需要检查企业人员是否全部无犯罪证明


            switch ($name) {
                case '财务':
                    foreach ($files as $folder_name => $file_list) {
//                        $tempFolderName = preg_replace('/[^\x{4e00}-\x{9fa5}]/u', '', (string)$folder_name);
                        // 1. 需要检查审计报告
                        if ($folder_name == '5-13 审计报告') {
                            $parallel->add(function () use ($folder_name, $file_list, $finance, $base_url, $model_name) {
                                $aiStr = '
                                        # 角色
                                          你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                                          # 任务
                                         报告中有文字包括“无保留意见”认定通过，且不存在“无法出具”、“有保留意见”内容，,对应结果 result 为 true 或者 false， 请你以下面的JSON格式输出数据 {
                                          "file_name": "{file_name}",
                                          "year": "{year}",
                                          "result": "{result}",
                                          }，禁止输出其他内容';

                                return $this->extracted($folder_name, $aiStr, $file_list, $finance, $base_url, $model_name, [1, 2, 3]);
                            });
                        }
                        // 2. 需要检查资产负债率情况
                        if ($folder_name == '5-14 资产负债率情况') {
                            $parallel->add(function () use ($folder_name, $file_list, $finance, $base_url, $model_name) {
                                $aiStr = '
                                       # 角色
                                        你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                                        # 任务
                                        你需要从提供资料的"期末余额列"中提取分别叫做“负债合计”、“负债和所有者权益(或股东权益)合计”行的数据，并以<输出格式>的范式输出结果。
                                        请注意，你需要的值是“负债和所有者权益(或股东权益)合计，而不是“所有者权益合计”这一行数据。
                                        # 输出格式
                                        请你以下面的JSON格式输出数据,"负债合计"命名为\'liability\',"负债和所有者权益(或股东权益)合计"命名为\'liability_equity\',保留两位小数。
                                        {
                                          "year": "{年份}",
                                          "liability": "{负债合计}",
                                          "liability_equity": "{负债和所有者权益(或股东权益)合计}"
                                        }，禁止输出其他内容';
                                return $this->extracted($folder_name, $aiStr, $file_list, $finance, $base_url, $model_name, [3, 4]);
                            });
                        }
                    }
                    break;
                case '行政':
                    foreach ($files as $folder_name => $file_list) {
                        // 只取出文件夹中的中文
                        if ($folder_name == '3-7-1 系统操作手册') {
                            $parallel->add(function () use ($folder_name, $file_list, $finance, $base_url, $model_name) {
                                $aiStr = '
                                        # 角色
                                          你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                                          # 任务
                                          请你识别文件中是否包含“操作手册”或“操作说明”或“用户手册”内容,对应结果 result 为 true 或者 false， 请你以下面的JSON格式输出数据 {
                                          "file_name": "{file_name}",
                                          "result": "{result}",
                                          }，禁止输出其他内容';

                                return $this->extracted($folder_name, $aiStr, $file_list, $finance, $base_url, $model_name, [1]);
                            });
                        }
                        if ($folder_name == '3-8-1 制度') {
                            $parallel->add(function () use ($folder_name, $file_list, $finance, $base_url, $model_name) {
                                $aiStr = '
                                        # 角色
                                          你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                                          # 任务
                                          请你识别文件中是否包含“信息安全管理”内容,对应结果 result 为 true 或者 false， 请你以下面的JSON格式输出数据 {
                                          "file_name": "{file_name}",
                                          "result": "{result}",
                                          }，禁止输出其他内容';

                                return $this->extracted($folder_name, $aiStr, $file_list, $finance, $base_url, $model_name, [1]);
                            });
                        }
                        if ($folder_name == '3-9-1 制度') {
                            $parallel->add(function () use ($folder_name, $file_list, $finance, $base_url, $model_name) {
                                $aiStr = '
                                        # 角色
                                          你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                                          # 任务
                                          请你识别文件中是否包含“员工手册”内容,对应结果 result 为 true 或者 false， 请你以下面的JSON格式输出数据 {
                                          "file_name": "{file_name}",
                                          "result": "{result}",
                                          }，禁止输出其他内容';
                                return $this->extracted($folder_name, $aiStr, $file_list, $finance, $base_url, $model_name, [1]);
                            });
                        }
                    }
                    break;
                case '关务':
                    foreach ($files as $folder_name => $file_list) {
                        // 只取出文件夹中的中文
                        if ($folder_name == '1-2 岗位职责') {
                            $parallel->add(function () use ($folder_name, $file_list, $finance, $base_url, $model_name) {
                                $aiStr = '
                                        # 角色
                                          你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                                          # 任务
                                          请你识别文件中是否包含“贸易安全”内容,对应结果 result 为 true 或者 false， 请你以下面的JSON格式输出数据 {
                                          "file_name": "{file_name}",
                                          "result": "{result}",
                                          }，禁止输出其他内容';

                                return $this->extracted($folder_name, $aiStr, $file_list, $finance, $base_url, $model_name, [1]);
                            });
                        }

                        if ($folder_name == '1-1 关企联系合作机制') {
                            $parallel->add(function () use ($folder_name, $file_list, $finance, $base_url, $model_name) {
                                $aiStr = '
                                        # 角色
                                          你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                                          # 任务
                                          请你识别文件中是否包含“关企联系工作”或“关企联系合作机制”内容,对应结果 result 为 true 或者 false， 请你以下面的JSON格式输出数据 {
                                          "file_name": "{file_name}",
                                          "result": "{result}",
                                          }，禁止输出其他内容';

                                return $this->extracted($folder_name, $aiStr, $file_list, $finance, $base_url, $model_name, [1]);
                            });
                        }

                        if ($folder_name == '2-3-1 制度') {
                            $parallel->add(function () use ($folder_name, $file_list, $finance, $base_url, $model_name) {
                                $aiStr = '
                                        # 角色
                                          你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                                          # 任务
                                          请你识别文件中是否包含“单证复核流程”内容, 对应结果 result 为 true 或者 false， 请你以下面的JSON格式输出数据 {
                                          "file_name": "{file_name}",
                                          "result": "{result}",
                                          }，禁止输出其他内容';

                                return $this->extracted($folder_name, $aiStr, $file_list, $finance, $base_url, $model_name, [1]);
                            });
                        }

                        if ($folder_name == '2-4-1 单位归档制度') {
                            $parallel->add(function () use ($folder_name, $file_list, $finance, $base_url, $model_name) {
                                $aiStr = '
                                        # 角色
                                          你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                                          # 任务
                                          请你识别文件中是否包含“电子单证归档管理”内容, 对应结果 result 为 true 或者 false， 请你以下面的JSON格式输出数据 {
                                          "file_name": "{file_name}",
                                          "result": "{result}",
                                          }，禁止输出其他内容';

                                return $this->extracted($folder_name, $aiStr, $file_list, $finance, $base_url, $model_name, [1]);
                            });
                        }

                        if ($folder_name == '2-5-1 禁止类产品合规审查制度') {
                            $parallel->add(function () use ($folder_name, $file_list, $finance, $base_url, $model_name) {
                                $aiStr = '
                                        # 角色
                                          你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                                          # 任务
                                          请你识别文件中是否包含“HS CODE/原产国/MSDS/货物性质”内容, 对应结果 result 为 true 或者 false， 请你以下面的JSON格式输出数据 {
                                          "file_name": "{file_name}",
                                          "result": "{result}",
                                          }，禁止输出其他内容';

                                return $this->extracted($folder_name, $aiStr, $file_list, $finance, $base_url, $model_name, [1]);
                            });
                        }

                        if ($folder_name == '6-16&17&18') {
                            $parallel->add(function () use ($folder_name, $file_list, $finance, $base_url, $model_name) {
                                $aiStr = '
                                        # 角色
                                          你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                                          # 任务
                                          请你提取文件中的处罚金额，结果为penalty_amount，单位为万元保留小数点后一位，并给出你的推测依据，并附带原文信息，依据为base_on，请你以下面的JSON格式输出数据 {
                                          "file_name": "{file_name}",
                                          "penalty_amount": "{penalty_amount}",
                                          "base_on": "{base_on}",
                                          }，禁止输出其他内容';

                                return $this->extracted($folder_name, $aiStr, $file_list, $finance, $base_url, $model_name, [1]);
                            });
                        }
                    }
                    break;
                case '审计部':
                    foreach ($files as $folder_name => $file_list) {
                        if ($folder_name == '6-15-2 无犯罪记录证明') {
                            $parallel->add(function () use ($folder_name, $file_list, $finance, $base_url, $model_name) {
                                $aiStr = '
                                        # 角色
                                           你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                                          # 任务
                                          请你从下载对应的无犯罪证明文件，并从文件中的提取全部的姓名和身份证号码，如果没有成功提取，则输出False，请你以下面的JSON格式输出数据
                                          请你以下面的JSON格式输出数据：
                                           [
                                            {
                                            "file_name": "{file_name}",
                                            "result": "True|False"，
                                            "name": "{姓名}",
                                            "card": "{身份证号码}"
                                            }
                                           ]，禁止输出其他内容
                                         ';
                                return $this->extracted($folder_name, $aiStr, $file_list, $finance, $base_url, $model_name);
                            });
                        }
                    }
                    break;
                default:
                    break;
            }
        }

        $parallel->wait();
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
    public function extracted(string $key, string $aiStr, mixed $file_list, Finance $finance, string $base_url, string $model_name, array $pages = []): array
    {
        $inner = new Parallel(5);
        foreach ($file_list as $file) {
            $inner->add(function () use ($key, $file, $aiStr, $finance, $base_url, $model_name, $pages) {
                $prefix = 'ai_result:' . $this->pre_audit_id . ':' . $key . ':' . $file->id;
                $fileName = $file->name;
                $fileUrl = $file->url;
                // 如果pages为空，则为全部页码，先获取共有多少页
                if (count($pages) == 0) {
                    // 读取全部
                    $pages = $this->getPdfPages($fileUrl);
                }

                // 将PDF转为图片，如果图片已经处理过，则跳过
                $isProcess = true;
                foreach ($pages as $page) {
                    $image_key = $prefix . ':' . $page;
                    if (!$this->redisService->make()->exists($image_key)) {
                        $isProcess = false;
                        break;
                    }
                }
                if (!$isProcess) {
                    $images = $this->processPdf($fileUrl, $pages);
                    foreach ($images as $key => $image) {
                        if (!$this->redisService->make()->exists($prefix . ':' . $key)) {
                            if ($image == '') {
                                $this->logService->make('ai_result')->error('图片处理失败', [
                                    'file_id' => $file->id,
                                    'page' => $key,
                                    'url' => $fileUrl,
                                ]);
                                continue;
                            }
                            $aiStr .= "-文件名称：{$fileName}, 页码：{$key}\n";
                            $content = $finance->getAiResponse($base_url, $aiStr, $model_name, $image);
                            var_dump($image);
                            var_dump($content);
                            $json_cleaned = preg_replace('/```(?:json)?\n|\n```/', '', $content);
                            $this->redisService->make()->set($prefix . ':' . $key, $json_cleaned);
                            // 将key值维护到一个key中，方便后续验证
                            $this->redisService->make()->lPush('ai_result:' . $this->pre_audit_id . ':keys', $prefix . ':' . $key);
                        }
                    }
                }
            });
        }
        return $inner->wait();
    }

    public function getPdfPages($pdfUrl): array
    {
        // 下载pdf文件
        $pdf = file_get_contents($pdfUrl);

        $directory = 'pdf/' . date('Ymd') . '/' . Str::random(10) . '/';

        $this->filesystem->createDirectory($directory);
        $this->filesystem->createDirectory($directory . 'output');

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

        $this->filesystem->createDirectory($directory);
        $this->filesystem->createDirectory($directory . 'output');

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
//
//        $page = 1;
//        foreach ($imagick as $img) {
//            if (count($pages) == 0 || in_array($page, $pages)) {
//                $img->setImageFormat('png'); // 可改为 png
//                // 设置压缩选项
//                $img->setImageCompression(\Imagick::COMPRESSION_ZIP);
//                $img->setImageCompressionQuality(10); // 0~100
//
//                // 设置白色背景，避免透明转黑
//                $img->setImageBackgroundColor('white');
//
//                // 裁剪白边
//                $imagick->trimImage(0);
//
//                $img->writeImage($path . 'output/' . "{$page}.png");
////                $url = $this->uploadOss($path . 'output/' . "{$page}.jpg");
////                $urls[$page] = $url;
//            }
//            $page++;
//        }
//        $imagick->clear();
//        $imagick->destroy();
//        return $urls;
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
            var_dump([
                'message' => $e->getMessage(),
                'file' => $file_path,
                'error' => 'file upload failed'
            ]);
            return '';
        }
    }

    public function test()
    {
        $urls = $this->processPdf('http://aeo2025.oss-cn-shanghai.aliyuncs.com/20250619/images/175031631348503591750316313FyJQFxbtmuyV52aX.pdf', [1, 2, 3]);
        var_dump($urls);
//        var_dump('开始测试' . time());
//        $finance = new Finance();
//        $base_url = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
////        $model_name = 'qwen-vl-ocr-latest'; // 如果需要使用特定模型名称
//        $model_name = 'qwen-vl-max'; // 如果需要使用特定模型名称
//
//
//        $url = 'http://aeo2025.oss-cn-shanghai.aliyuncs.com/20250704/images/1751602913386279217516029136uxhKc0FGXDvhp9a.jpg';
//
//        var_dump('图片处理完成' . time());
//
//        // url 转 base64
//        $aiStr = '
//            # 角色
//            你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
//            # 任务
//            你需要从提供资料的"期末余额列"中提取分别叫做“负债合计”、“负债和所有者权益(或股东权益)合计”行的数据，并以<输出格式>的范式输出结果。
//            请注意，你需要的值是“负债和所有者权益(或股东权益)合计，而不是“所有者权益合计”这一行数据。
//            # 输出格式
//            请你以下面的JSON格式输出数据,"负债合计"命名为"liability","负债和所有者权益(或股东权益)合计"命名为"liability_equity",保留两位小数。
//            {
//              "year": "2020",
//              "liability": "2,053,300.00",
//              "liability_equity": "1,572,024.60"
//            }
//        ';
//        $content = $finance->getAiResponse($base_url, $aiStr, $model_name, $url);
//
//        var_dump($content);
    }
}
