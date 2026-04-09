<?php

declare(strict_types=1);

/**
 * AEO Prompt 真实请求验证脚本
 * 功能：联通阿里云通义千问 API，验证提示词识别效果
 */

require_once __DIR__ . '/../ai_admin_api/vendor/autoload.php';

use App\Lib\AI\CheckHandlers\CheckHandlerFactory;
use App\Lib\AI\Finance;

if (!defined('BASE_PATH')) {
    define('BASE_PATH', realpath(__DIR__ . '/../ai_admin_api'));
}

class PromptRealTester
{
    private string $testImageUrl;

    public function __construct(string $imageUrl)
    {
        $this->testImageUrl = $imageUrl;
    }

    public function testFinancialRatio()
    {
        echo "--- 正在测试：资产负债率提示词 ---\n";
        echo "图片 URL: {$this->testImageUrl}\n";

        // 1. 获取检测项 Handler 和 Prompt
        $handler = CheckHandlerFactory::make('资产负债率情况');
        $prompt = $handler->getPrompt();

        echo "\n[发送的提示词]:\n{$prompt}\n";

        // 2. 调用真实 AI 接口
        $finance = new Finance();
        $model = 'qwen-vl-max'; // 使用多模态大模型
        
        echo "\n正在请求通义千问 $model ...\n";
        $startTime = microtime(true);
        $rawResponse = $finance->getAiResponse($prompt, $model, $this->testImageUrl);
        $endTime = microtime(true);
        
        echo "响应用时: " . round($endTime - $startTime, 2) . "s\n";
        echo "\n[AI 原始返回]:\n{$rawResponse}\n";

        // 3. 验证 Handler 解析逻辑
        echo "\n[Handler 标准化解析结果]:\n";
        // 清洗 AI 返回的 Markdown 代码块
        $jsonCleaned = preg_replace('/```(?:json)?\n|\n```/', '', $rawResponse);
        $parsedData = json_decode($jsonCleaned, true);
        
        if ($parsedData) {
            $standardized = $handler->parseResult($parsedData);
            print_r($standardized);

            // 4. 验证审计判定
            echo "\n[审计判定结论]:\n";
            $auditEffect = $handler->performAudit([$standardized], ['duration_years' => [$standardized['year'] ?? date('Y')]]);
            echo ($auditEffect === null ? "✅ 通过审计" : "❌ 未通过: " . $auditEffect) . "\n";
        } else {
            echo "❌ 错误：AI 返回内容无法解析为 JSON。\n";
        }
    }
}

// 注意：此处需要传入一个公网可访问的图片 URL
// 如果您想测试我生成的模拟图，我将先执行上传动作
$sampleUrl = $argv[1] ?? 'https://img1.baidu.com/it/u=3049187376,464878235&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667';

$tester = new PromptRealTester($sampleUrl);
$tester->testFinancialRatio();
