<?php

declare(strict_types=1);

namespace App\Lib\AI\CheckHandlers;

/**
 * 行政被处罚金额检测 Handler
 */
class FineAmountHandler extends AbstractHandler
{
    protected string $promptFile = 'fine_amount';

    public function performAudit(array $data, array $context): ?string
    {
        $companyName = $context['company_name'] ?? '';
        $notSelfTotal = $context['not_self_total'] ?? 0;
        
        $totalAmount = 0;
        $violationCount = 0;

        foreach ($data as $item) {
            // 匹配公司名称
            if (($item['company'] ?? '') === $companyName) {
                $totalAmount += floatval($item['amount'] ?? 0);
                // 这里逻辑参考原代码：如果不是自查则计入比例
                // 注意：原代码逻辑稍微有点混乱，一部分在行政处罚一部分在比例检测
                // 我们在各 Handler 中各施其职
            }
        }

        $errors = [];
        if ($totalAmount > 50000) {
            $errors[] = "行政被处罚金额累计超过5万元 (当前: {$totalAmount})";
        }

        return empty($errors) ? null : implode('; ', $errors);
    }
}
