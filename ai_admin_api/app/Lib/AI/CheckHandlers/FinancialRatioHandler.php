<?php

declare(strict_types=1);

namespace App\Lib\AI\CheckHandlers;

/**
 * 资产负债率检测 Handler
 */
class FinancialRatioHandler extends AbstractHandler
{
    protected string $promptFile = 'financial_ratio';

    public function parseResult(array $rawResult): array
    {
        return [
            'year' => $rawResult['year'] ?? null,
            'liability' => $rawResult['liability'] ?? 0,
            'liability_equity' => $rawResult['liability_equity'] ?? 0,
        ];
    }

    public function performAudit(array $data, array $context): ?string
    {
        $durationYears = $context['duration_years'] ?? [];
        $errors = [];

        if (empty($durationYears)) {
            return "未设置公司存续年份, 无法进行资产负债率检查.";
        }

        foreach ($durationYears as $year) {
            // 查找对应年份的数据
            $yearData = null;
            foreach ($data as $item) {
                if (($item['year'] ?? '') == $year) {
                    $yearData = $item;
                    break;
                }
            }

            if (!$yearData) {
                $errors[] = "{$year}年度资产负债率未读取到有效信息";
                continue;
            }

            $liability = floatval(str_replace(',', '', (string)($yearData['liability'] ?? 0)));
            $liabilityEquity = floatval(str_replace(',', '', (string)($yearData['liability_equity'] ?? 0)));

            if ($liability == 0 && $liabilityEquity == 0) {
                $errors[] = "{$year}年度资产负债率未读取到有效数值";
            } else {
                if ($liabilityEquity > 0) {
                    $ratio = bcdiv((string)$liability, (string)$liabilityEquity, 4);
                    if (floatval($ratio) > 0.95) {
                        $errors[] = "{$year}年度资产负债率不合格, 负债率为 " . (floatval($ratio) * 100) . "%";
                    }
                } else {
                    $errors[] = "{$year}年度负债与权益合计数据异常";
                }
            }
        }

        return empty($errors) ? null : implode('; ', $errors);
    }
}
