<?php

declare(strict_types=1);

/**
 * AEO Prompt 真实请求全流程仿真测试工具包
 * 支持传递检测名称和本地图片路径进行动态测试
 */

require_once __DIR__ . '/vendor/autoload.php';

if (!defined('BASE_PATH')) {
    define('BASE_PATH', __DIR__);
}

use Hyperf\Context\ApplicationContext;
use App\Lib\AI\CheckHandlers\CheckHandlerFactory;
use App\Lib\AI\Finance;

(function () {
    global $argv;
    
    $checkName = $argv[1] ?? '审计报告';
    $imageName = $argv[2] ?? 'sample_audit.png';

    $container = require BASE_PATH . '/config/container.php';
    ApplicationContext::setContainer($container);

    echo "=== AEO 真实请求仿真测试 (检测项: {$checkName}) ===\n\n";

    $localImagePath = BASE_PATH . '/' . $imageName;
    if (!file_exists($localImagePath)) {
        die("❌ 错误：未找到样本图片 {$localImagePath}\n");
    }
    
    $imageData = base64_encode(file_get_contents($localImagePath));
    $base64Url = "data:image/png;base64,{$imageData}";
    echo "✅ 样本图片已加载: {$imageName} (" . round(strlen($imageData)/1024, 2) . " KB)\n";

    try {
        $handler = CheckHandlerFactory::make($checkName);
        $prompt = $handler->getPrompt();
        echo "✅ 提示词加载成功\n";
    } catch (\Exception $e) {
        die("❌ 错误: " . $e->getMessage() . "\n");
    }

    $finance = new Finance();
    $model = 'qwen-vl-max'; 
    
    echo "\n🚀 正在向通义千问 $model 发起真实请求...\n";
    $startTime = microtime(true);
    $rawResponse = $finance->getAiResponse($prompt, $model, $base64Url);
    $endTime = microtime(true);
    
    echo "⏱️ 请求响应耗时: " . round($endTime - $startTime, 2) . "s\n";
    
    if (empty($rawResponse)) {
        die("❌ 错误：AI 返回内容为空。\n");
    }

    echo "\n[AI 原始识别结果]:\n{$rawResponse}\n";

    echo "\n[Handler 业务逻辑执行]:\n";
    $jsonCleaned = preg_replace('/```(?:json)?\n|\n```/', '', $rawResponse);
    $parsedData = json_decode($jsonCleaned, true);
    
    if ($parsedData) {
        $standardized = $handler->parseResult($parsedData);
        echo "1. 数据标准化结果:\n";
        print_r($standardized);

        echo "\n2. 业务审计结论:\n";
        // 提供通用上下文
        $context = [
            'duration_years' => [$standardized['year'] ?? '2023'],
            'company_person_names' => ['李文静', '张三'],
            'company_name' => '测试公司',
            'not_self_total' => 1000,
            'check_name' => $checkName
        ];
        $auditEffect = $handler->performAudit([$standardized], $context);
        
        if ($auditEffect === null) {
            echo "✅ 恭喜！数据符合 AEO 认证标准\n";
        } else {
            echo "❌ 审计不通过: " . $auditEffect . "\n";
        }
    } else {
        echo "❌ 错误：AI 返回的内容无法解析为合法的 JSON 对象。\n";
    }
})();
