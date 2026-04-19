<?php

declare(strict_types=1);

namespace App\Lib\AI\CheckHandlers;

/**
 * 审计报告检测 Handler
 */
class AuditReportHandler extends AbstractHandler
{
    protected string $promptFile = 'audit_report';

    public function performAudit(array $data, array $context): ?string
    {
        $durationYears = $context['duration_years'] ?? [];
        if (empty($durationYears)) {
            return "未设置公司存续年份, 无法进行审计报告检查.";
        }

        // 结果聚合：按年份存储最新的状态和原因
        $yearlyResults = [];
        foreach ($data as $pageResult) {
            if (!is_array($pageResult)) continue;
            foreach ($pageResult as $item) {
                $year = $this->normalizeYear($item['year'] ?? '');
                if (!$year) continue;
                
                // 如果该年份还没存，或者当前存的是 error，则尝试用 pass/fail 覆盖（优先保留有意义的审核结果）
                if (!isset($yearlyResults[$year]) || $yearlyResults[$year]['status'] === 'error') {
                    $yearlyResults[$year] = [
                        'status' => $item['status'] ?? 'error',
                        'review' => $item['review'] ?? '未知',
                        'reason' => $item['reason'] ?? '',
                    ];
                }
            }
        }

        $errors = [];
        foreach ($durationYears as $year) {
            $yearStr = (string)$year;
            if (!isset($yearlyResults[$yearStr])) {
                $errors[] = "〔未能读取有效信息〕{$yearStr}年度: 资料中未找到该年度相关的审计报告";
                continue;
            }

            $res = $yearlyResults[$yearStr];
            if ($res['status'] === 'fail') {
                $errors[] = "〔审计不通过〕{$yearStr}年度: 审计意见为'{$res['review']}'，原因: {$res['reason']}";
            } elseif ($res['status'] === 'error') {
                $errors[] = "〔未能读取有效信息〕{$yearStr}年度: {$res['reason']}";
            }
        }

        return empty($errors) ? null : implode('; ', $errors);
    }
}
