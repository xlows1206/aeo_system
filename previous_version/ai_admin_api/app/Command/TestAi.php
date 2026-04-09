<?php

declare(strict_types=1);

namespace App\Command;

use App\Lib\AI\Finance;
use Hyperf\Command\Command as HyperfCommand;
use Hyperf\Command\Annotation\Command;
use Psr\Container\ContainerInterface;

#[Command]
class TestAi extends HyperfCommand
{
    public function __construct(protected ContainerInterface $container)
    {
        parent::__construct('test:ai');
    }

    public function configure(): void
    {
        parent::configure();
        $this->setDescription('Hyperf Demo Command');
    }

    public function handle(): void
    {
        $finance = new Finance();
        $base_url = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
        $model_name = 'qwen-vl-max'; // 如果需要使用特定模型名称

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
                    }';


        $image = 'https://aeo2025.oss-cn-shanghai.aliyuncs.com/20250804/images/175428245545916781754282455xPJUENqElmqsjLoV.png';

        $content = $finance->getAiResponse($base_url, $aiStr, $model_name, $image);

        var_dump($content);
    }
}
