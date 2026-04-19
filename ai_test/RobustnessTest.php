<?php

declare(strict_types=1);

require_once '/opt/www/vendor/autoload.php';

use App\Lib\AI\CheckHandlers\FinancialRatioHandler;

$handler = new FinancialRatioHandler();

$context = ['duration_years' => ['2020', '2021']];

$testCases = [
    'Year with suffix' => [
        'data' => [['year' => '2020年', 'liability' => '100', 'liability_equity' => '1000']],
        'expected' => 'Success (matched 2020)'
    ],
    'Numbers with units' => [
        'data' => [['year' => '2020', 'liability' => '100.00万元', 'liability_equity' => '1000.00万元']],
        'expected' => 'Success (parsed 100 and 1000)'
    ],
    'Empty/Zero' => [
        'data' => [['year' => '2020', 'liability' => '0', 'liability_equity' => '0']],
        'expected' => 'Failure (未读取到有效数值)'
    ],
    'No matching year' => [
        'data' => [['year' => '2019', 'liability' => '100', 'liability_equity' => '1000']],
        'expected' => 'Failure (2020年度: 未读取到有效信息)'
    ]
];

echo "Testing FinancialRatioHandler Robustness:\n\n";

foreach ($testCases as $name => $case) {
    echo "--- $name ---\n";
    $result = $handler->performAudit($case['data'], $context);
    echo "Result: " . ($result ?: "PASS") . "\n\n";
}
