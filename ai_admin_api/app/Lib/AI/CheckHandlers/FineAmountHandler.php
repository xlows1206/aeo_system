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
        $errors = [];

        foreach ($data as $item) {
            if (($item['result'] ?? '') === 'error') {
                $errors[] = "[ERROR] 资料解析失败: " . ($item['reason'] ?? '未知错误');
                continue;
            }

            // 匹配公司名称
            if (($item['company'] ?? '') === $companyName) {
                $totalAmount += $this->normalizeNumber($item['amount'] ?? 0);
            }
        }

        if ($totalAmount > 50000) {
            $errors[] = "行政被处罚金额累计超过 5 万元 (当前: {$totalAmount} 元)";
        }

        return empty($errors) ? null : implode('; ', $errors);
    }
}
