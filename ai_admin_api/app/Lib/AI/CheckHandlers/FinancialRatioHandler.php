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
            'result' => $rawResult['result'] ?? 'success',
            'reason' => $rawResult['reason'] ?? '',
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
            $yearData = null;
            foreach ($data as $item) {
                if ($this->normalizeYear($item['year'] ?? '') === $this->normalizeYear($year)) {
                    $yearData = $item;
                    break;
                }
            }

            if (!$yearData || ($yearData['result'] ?? '') === 'error') {
                $reason = $yearData['reason'] ?? '未读取到有效财务信息';
                $errors[] = "{$year}年度: [ERROR] {$reason}";
                continue;
            }

            $liability = $this->normalizeNumber($yearData['liability'] ?? 0);
            $liabilityEquity = $this->normalizeNumber($yearData['liability_equity'] ?? 0);

            if ($liabilityEquity > 0) {
                $ratio = bcdiv((string)$liability, (string)$liabilityEquity, 4);
                if (floatval($ratio) > 0.95) {
                    $ratioPercent = round(floatval($ratio) * 100, 2) . '%';
                    $errors[] = "{$year}年度: 资产负债率为 {$ratioPercent} (不符合 AEO ≤ 95% 标准)";
                }
            } else {
                $errors[] = "{$year}年度: [ERROR] 权益合计为0，数据无效";
            }
        }

        return empty($errors) ? null : implode('; ', $errors);
    }

    public function getSuccessMessages(array $data, array $context): array
    {
        $durationYears = $context['duration_years'] ?? [];
        $success = [];

        foreach ($durationYears as $year) {
            foreach ($data as $item) {
                if ($this->normalizeYear($item['year'] ?? '') === $this->normalizeYear($year)) {
                    $liability = $this->normalizeNumber($item['liability'] ?? 0);
                    $liabilityEquity = $this->normalizeNumber($item['liability_equity'] ?? 0);
                    if ($liabilityEquity > 0) {
                        $ratio = bcdiv((string)$liability, (string)$liabilityEquity, 4);
                        if (floatval($ratio) <= 0.95) {
                            $ratioPercent = round(floatval($ratio) * 100, 2) . '%';
                            $success[] = "{$year}年度: 资产负债率为 {$ratioPercent} (符合标准)";
                        }
                    }
                }
            }
        }
        return $success;
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

            if (!$yearData || ($yearData['result'] ?? '') === 'error') {
                return false; // 缺少任何一个存续年份的数据或提取失败，视为不通过
            }

            $liability = $this->normalizeNumber($yearData['liability'] ?? 0);
            $liabilityEquity = $this->normalizeNumber($yearData['liability_equity'] ?? 0);

            if ($liabilityEquity <= 0) {
                return false; // 数据异常
            }

            $ratio = floatval(bcdiv((string)$liability, (string)$liabilityEquity, 4));
            if ($ratio > 0.95) {
                return false; // 只要有一年不合格，整体就不通过
            }
        }

        return true; // 所有年份都合格
    }
}
