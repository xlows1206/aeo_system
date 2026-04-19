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
        $results = [];

        if (empty($durationYears)) {
            return "未设置公司存续年份, 无法进行资产负债率检查.";
        }

        foreach ($durationYears as $year) {
            // 查找对应年份的数据
            $yearData = null;
            foreach ($data as $item) {
                if ($this->normalizeYear($item['year'] ?? '') === $this->normalizeYear($year)) {
                    $yearData = $item;
                    break;
                }
            }

            if (!$yearData) {
                $results[] = "{$year}年度: 未读取到有效信息";
                continue;
            }

            $liability = $this->normalizeNumber($yearData['liability'] ?? 0);
            $liabilityEquity = $this->normalizeNumber($yearData['liability_equity'] ?? 0);

            if ($liability == 0 && $liabilityEquity == 0) {
                $results[] = "{$year}年度: 未读取到有效数值";
            } else {
                if ($liabilityEquity > 0) {
                    $ratio = bcdiv((string)$liability, (string)$liabilityEquity, 4);
                    $ratioPercent = round(floatval($ratio) * 100, 2) . '%';
                    if (floatval($ratio) > 0.95) {
                        $results[] = "{$year}年度: 不合格, 负债率为 {$ratioPercent}";
                    } else {
                        $results[] = "{$year}年度: 合格, 负债率为 {$ratioPercent}";
                    }
                } else {
                    $results[] = "{$year}年度: 负债与权益合计数据异常";
                }
            }
        }

        // 始终返回所有年份的检测结果，方便核对与 debug
        return empty($results) ? null : implode('; ', $results);
    }

    /**
     * 合格判定：至少有一个存续年份的负债率 ≤ 95% 且数据有效，即视为通过。
     * 与 performAudit 的显示逻辑完全解耦。
     *
     * 依据 backend_memory.md §5 文件检测项目矩阵：
     * "至少有一年负债率 liability / liability_equity <= 95%"
     */
    public function isAccessible(array $data, array $context): bool
    {
        $durationYears = $context['duration_years'] ?? [];

        if (empty($durationYears)) {
            return false;
        }

        foreach ($durationYears as $year) {
            $yearData = null;
            foreach ($data as $item) {
                if ($this->normalizeYear($item['year'] ?? '') === $this->normalizeYear($year)) {
                    $yearData = $item;
                    break;
                }
            }

            if (!$yearData) {
                continue; // 找不到数据，跳到下一年
            }

            $liability = $this->normalizeNumber($yearData['liability'] ?? 0);
            $liabilityEquity = $this->normalizeNumber($yearData['liability_equity'] ?? 0);

            if ($liabilityEquity <= 0 || ($liability == 0 && $liabilityEquity == 0)) {
                continue; // 数据无效，跳到下一年
            }

            $ratio = floatval(bcdiv((string)$liability, (string)$liabilityEquity, 4));
            if ($ratio <= 0.95) {
                return true; // 找到至少一年合格，直接通过
            }
        }

        // 所有年份都不合格或都没有有效数据
        return false;
    }
}
