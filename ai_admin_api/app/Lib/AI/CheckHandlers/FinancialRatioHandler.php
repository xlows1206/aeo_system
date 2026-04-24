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
            'result' => $rawResult['result'] ?? ($rawResult['status'] ?? 'success'),
            'reason' => $rawResult['reason'] ?? '',
            'year' => $rawResult['year'] ?? null,
            'liability' => $rawResult['liability'] ?? 0,
            'liability_equity' => $rawResult['liability_equity'] ?? 0,
            'ratio' => $rawResult['ratio'] ?? null,
            'status' => $rawResult['status'] ?? ($rawResult['result'] ?? null),
        ];
    }

    public function performAudit(array $data, array $context): ?string
    {
        $yearlyResults = [];
        foreach ($data as $item) {
            if (!is_array($item)) continue;
            
            $year = $this->normalizeYear($item['year'] ?? '');
            if (!$year) continue;

            // 如果已经有成功的结论，不再覆盖（除非当前是错误）
            if (isset($yearlyResults[$year]) && $yearlyResults[$year]['status'] !== 'error') {
                continue;
            }

            $liability = $this->normalizeNumber($item['liability'] ?? 0);
            $liabilityEquity = $this->normalizeNumber($item['liability_equity'] ?? 0);
            
            // 优先用 AI 返回的比率，如果没有则计算
            $ratio = 0;
            if (isset($item['ratio']) && $item['ratio'] !== null) {
                $ratio = $this->normalizeNumber($item['ratio']);
            }
            
            if ($ratio == 0 && $liabilityEquity > 0) {
                $ratio = floatval(bcdiv((string)$liability, (string)$liabilityEquity, 4));
            }

            // 状态判定逻辑：如果有比率，以比率为准；没有比率则看 AI 结论
            $status = 'error';
            $aiStatus = strtolower((string)($item['status'] ?? ($item['result'] ?? '')));
            
            if ($ratio > 0) {
                $status = ($ratio <= 0.95) ? 'pass' : 'fail';
            } elseif ($aiStatus === 'pass' || $aiStatus === 'success') {
                $status = 'pass';
            } elseif ($aiStatus === 'fail' || $aiStatus === 'failed') {
                $status = 'fail';
            }

            $yearlyResults[$year] = [
                'status' => $status,
                'ratio' => $ratio,
                'reason' => $item['reason'] ?? '',
            ];
        }

        if (empty($yearlyResults)) {
            return "未能从该文件中读取到有效的财务比率信息。";
        }

        $findings = [];
        foreach ($yearlyResults as $year => $res) {
            $yearStr = (string)$year;
            $ratioPercent = round($res['ratio'] * 100, 2) . "%";
            
            if ($res['status'] === 'pass') {
                $findings[] = "{$yearStr}年度: 资产负债率为 {$ratioPercent} (符合标准)";
            } elseif ($res['status'] === 'fail') {
                $findings[] = "{$yearStr}年度: 资产负债率为 {$ratioPercent} (不符合 AEO ≤ 95% 标准)";
            } else {
                $findings[] = "{$yearStr}年度: [数据异常] " . ($res['reason'] ?: '解析到的数据不完整');
            }
        }

        return implode('; ', $findings);
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
     * 合格判定：只要有任意一年不高于 95% 就算通过。
     * 只有当所有年份都高于 95% 或数据完全无效时才判定为不通过。
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

            // 如果该年份数据无效或提取失败，跳过该年份的判定，看其他年份
            if (!$yearData || ($yearData['result'] ?? '') === 'error') {
                continue;
            }

            $liability = $this->normalizeNumber($yearData['liability'] ?? 0);
            $liabilityEquity = $this->normalizeNumber($yearData['liability_equity'] ?? 0);

            if ($liabilityEquity > 0) {
                $ratio = floatval(bcdiv((string)$liability, (string)$liabilityEquity, 4));
                if ($ratio <= 0.95) {
                    return true; // 只要有一年合格，整体就通过
                }
            }
        }

        return false; // 所有年份都不合格或均无有效数据
    }
}
