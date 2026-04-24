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
        $totalAmount = 0;
        $foundCounts = 0;

        foreach ($data as $item) {
            if (isset($item['amount'])) {
                $amt = $this->normalizeNumber($item['amount']);
                $totalAmount += $amt;
                $foundCounts++;
            }
        }

        $statusText = $totalAmount <= 50000 ? "符合标准 (未超过 5 万元)" : "不符合标准 (已超过 5 万元限额)";
        
        return "识别到处罚记录数: {$foundCounts}, 处罚金额累计: {$totalAmount} 元。结论: {$statusText}";
    }

    public function isAccessible(array $data, array $context): bool
    {
        $totalAmount = 0;
        foreach ($data as $item) {
            if (isset($item['amount'])) {
                $totalAmount += $this->normalizeNumber($item['amount']);
            }
        }

        return $totalAmount <= 50000;
    }

    public function getSuccessMessages(array $data, array $context): array
    {
        return ["经核查，企业近两年内行政处罚累计金额未超过 5 万元，符合海关合规审查要求。"];
    }
}
