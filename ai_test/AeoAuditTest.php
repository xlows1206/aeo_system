<?php

declare(strict_types=1);

/**
 * AEO 验收测试项全量验证脚本 (针对重构后的 Handler 逻辑) - 离线运行版
 * 位置：根目录/ai_test/AeoAuditTest.php
 */

$autoloads = [
    __DIR__ . '/vendor/autoload.php',
    __DIR__ . '/../ai_admin_api/vendor/autoload.php'
];
$autoload = null;
foreach ($autoloads as $path) {
    if (file_exists($path)) {
        $autoload = $path;
        break;
    }
}

if (!$autoload) {
    die("❌ 错误：未找到后端 autoload 文件。请检查依赖是否已安装。\n");
}

require_once $autoload;

use App\Lib\AI\CheckHandlers\CheckHandlerFactory;

if (!defined('BASE_PATH')) {
    $basePath = realpath(__DIR__ . '/../ai_admin_api') ?: __DIR__;
    define('BASE_PATH', $basePath);
}

class AeoTester
{
    private array $results = [];

    public function run()
    {
        echo "=== AEO 检测逻辑全量重构验收测试 (外部运行模式) ===\n\n";

        // 1. 资产负债率 (Financial Ratio)
        $this->testCase('1. 资产负债率 (90% Pass)', '资产负债率情况', 
            [['year' => '2023', 'liability' => '900,000', 'liability_equity' => '1,000,000']], 
            ['duration_years' => ['2023']], null);
        
        $this->testCase('1. 资产负债率 (96% Fail)', '资产负债率情况', 
            [['year' => '2023', 'liability' => '960,000', 'liability_equity' => '1,000,000']], 
            ['duration_years' => ['2023']], '不合格');

        // 2. 审计报告 (Audit Report)
        $this->testCase('2. 审计报告 (Pass)', '审计报告', 
            [['year' => '2023', 'result' => true]], 
            ['duration_years' => ['2023']], null);
            
        $this->testCase('2. 审计报告 (Fail - 无法出具)', '审计报告', 
            [['year' => '2023', 'result' => false]], 
            ['duration_years' => ['2023']], '未通过');

        // 3. 遵守法律法规 (Legal Compliance)
        $this->testCase('3. 遵守法律法规 (人员不齐 Fail)', '遵守法律法规', 
            [['name' => '李文静']], 
            ['company_person_names' => ['李文静', '张三', '李四', '王五']], '未提供无犯罪记录证明');

        $this->testCase('3. 遵守法律法规 (不足4人报错 Fail)', '遵守法律法规', 
            [['name' => '李文静'], ['name' => '张三']], 
            ['company_person_names' => ['李文静', '张三']], '公司负责人信息设置不全');

        $this->testCase('3. 遵守法律法规 (名单全覆盖 Pass)', '遵守法律法规', 
            [['name' => '李文静'], ['name' => '张三'], ['name' => '李四'], ['name' => '王五']], 
            ['company_person_names' => ['李文静', '张三', '李四', '王五']], null);

        // 4. 行政被处罚金额 (Fine Amount)
        $this->testCase('4. 行政处罚金额 (50,000 Pass)', '行政被处罚金额', 
            [['company' => 'AEO公司', 'amount' => 50000]], 
            ['company_name' => 'AEO公司'], null);

        $this->testCase('4. 行政处罚金额 (50,001 Fail)', '行政被处罚金额', 
            [['company' => 'AEO公司', 'amount' => 50001]], 
            ['company_name' => 'AEO公司'], '超过5万元');

        // 5. 被处罚单比例 (Punishment Ratio)
        $this->testCase('5. 处罚比例 (1/2000 Pass)', '被处罚单比例小于报关千分之一', 
            [['result' => false]], 
            ['not_self_total' => 2000], null);

        $this->testCase('5. 处罚比例 (1/1000 Fail - 严格小于)', '被处罚单比例小于报关千分之一', 
            [['result' => false]], 
            ['not_self_total' => 1000], '超过报关单总数千分之一');

        // 6-12. 关键词通用检测 (Keyword Match)
        $this->testCase('6. 关企联系机制 (Pass)', '关企联系合作机制', [['result' => true]], ['check_name' => '关企联系合作机制'], null);
        $this->testCase('6. 关企联系机制 (Fail)', '关企联系合作机制', [['result' => false]], ['check_name' => '关企联系合作机制'], '未通过');

        $this->testCase('7. 贸易安全任命书 (Pass)', '贸易安全岗位任命书', [['result' => true]], ['check_name' => '贸易安全岗位任命书'], null);
        $this->testCase('7. 贸易安全任命书 (Fail)', '贸易安全岗位任命书', [['result' => false]], ['check_name' => '贸易安全岗位任命书'], '未通过');

        $this->testCase('8. 岗位职责和任职条件 (Pass)', '岗位职责和任职条件', [['result' => true]], ['check_name' => '岗位职责和任职条件'], null);
        $this->testCase('8. 岗位职责和任职条件 (Fail)', '岗位职责和任职条件', [['result' => false]], ['check_name' => '岗位职责和任职条件'], '未通过');

        $this->testCase('11. 单证归档制度 (Pass)', '进出口单证归档制度', [['result' => true]], ['check_name' => '进出口单证归档制度'], null);
        $this->testCase('11. 单证归档制度 (Fail)', '进出口单证归档制度', [['result' => false]], ['check_name' => '进出口单证归档制度'], '未通过');

        $this->testCase('12. 禁止类审查 (Pass)', '禁止类产品合规审查', [['result' => true]], ['check_name' => '禁止类产品合规审查'], null);
        $this->testCase('12. 禁止类审查 (Fail)', '禁止类产品合规审查', [['result' => false]], ['check_name' => '禁止类产品合规审查'], '未通过');
        
        $this->printSummary();
    }

    private function testCase($name, $checkName, $mockData, $context, $expectedErrorSubstr)
    {
        try {
            $handler = CheckHandlerFactory::make($checkName);
            $actualError = $handler->performAudit($mockData, $context);

            if ($expectedErrorSubstr === null) {
                $passed = ($actualError === null);
            } else {
                $passed = ($actualError !== null && str_contains($actualError, $expectedErrorSubstr));
            }

            $this->results[] = [
                'name' => $name,
                'status' => $passed ? '✅ PASS' : '❌ FAIL',
                'actual' => $actualError ?? 'SUCCESS'
            ];
        } catch (\Throwable $e) {
            $this->results[] = [
                'name' => $name,
                'status' => '⚠️ ERROR',
                'actual' => $e->getMessage()
            ];
        }
    }

    private function printSummary()
    {
        printf("%-40s | %-10s | %-30s\n", "测试项", "状态", "实际输出");
        echo str_repeat("-", 90) . "\n";
        foreach ($this->results as $res) {
            printf("%-37s | %-12s | %-30s\n", $res['name'], $res['status'], $res['actual']);
        }
    }
}

$tester = new AeoTester();
$tester->run();
