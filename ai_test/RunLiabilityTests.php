<?php

declare(strict_types=1);

$autoloads = [
    __DIR__ . '/vendor/autoload.php',
    __DIR__ . '/../vendor/autoload.php',
    '/opt/www/vendor/autoload.php'
];
$autoload = null;
foreach ($autoloads as $path) {
    if (file_exists($path)) {
        $autoload = $path;
        break;
    }
}
require_once $autoload;

if (!defined('BASE_PATH')) {
    define('BASE_PATH', '/opt/www');
}

use Hyperf\Context\ApplicationContext;
use App\Lib\AI\CheckHandlers\CheckHandlerFactory;
use App\Lib\AI\Finance;

(function () {
    $container = require BASE_PATH . '/config/container.php';
    ApplicationContext::setContainer($container);

    echo "=== 负债率真实仿真测试 (2020-2022年) ===\n\n";

    $handler = CheckHandlerFactory::make('资产负债率情况');
    $finance = new Finance();
    $model = 'qwen-vl-max';
    $prompt = $handler->getPrompt();

    $context = ['duration_years' => ['2020', '2021', '2022']];

    $testCases = [
        '测试通过' => __DIR__ . '/../test_case/01_负债率/测试通过',
        '测试不通过' => __DIR__ . '/../test_case/01_负债率/测试不通过',
    ];

    foreach ($testCases as $caseName => $folderPath) {
        echo "============== [ $caseName ] ==============\n";
        
        $files = array_filter(glob($folderPath . '/*'), function($file) {
            return in_array(strtolower(pathinfo($file, PATHINFO_EXTENSION)), ['png', 'jpg', 'jpeg']);
        });
        if (empty($files)) {
            echo "⚠️ 未找到测试图片\n\n";
            continue;
        }

        $allData = [];

        foreach ($files as $file) {
            echo "处理文件: " . basename($file) . "...\n";
            $imageData = base64_encode(file_get_contents($file));
            // Guess mime type roughly based on extension
            $ext = strtolower(pathinfo($file, PATHINFO_EXTENSION));
            $mime = $ext === 'png' ? 'image/png' : 'image/jpeg';
            $base64Url = "data:{$mime};base64,{$imageData}";

            $rawResponse = $finance->getAiResponse($prompt, $model, $base64Url);
            $jsonCleaned = preg_replace('/```(?:json)?\n|\n```/', '', $rawResponse);
            $parsedData = json_decode($jsonCleaned, true);

            if ($parsedData) {
                $standardized = $handler->parseResult($parsedData);
                $allData[] = $standardized;
                echo "  -> AI 提取识别成功: 年份 {$standardized['year']}, 负债 {$standardized['liability']}, 总计 {$standardized['liability_equity']}\n";
            } else {
                echo "  -> ❌ AI 提取失败: {$rawResponse}\n";
            }
        }

        echo "\n执行测试判定...\n";
        $auditEffect = $handler->performAudit($allData, $context);
        $isAccessible = $handler->isAccessible($allData, $context);

        echo "审核明细 (performAudit): " . ($auditEffect ?: '无异常报错') . "\n";
        echo "最终判定 (isAccessible): " . ($isAccessible ? '✅ 通过 (合格)' : '❌ 不通过 (不合格)') . "\n\n";
    }
})();
