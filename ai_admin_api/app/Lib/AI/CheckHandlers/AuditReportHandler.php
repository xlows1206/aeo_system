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
        // 结果聚合：仅针对当前输入数据中存在的年份生成结论
        $yearlyResults = [];
        foreach ($data as $item) {
            if (!is_array($item)) continue;
            
            $year = $this->normalizeYear($item['year'] ?? '');
            if (!$year) continue;
            
            if (!isset($yearlyResults[$year]) || $yearlyResults[$year]['status'] === 'error') {
                $rawStatus = strtolower((string)($item['status'] ?? ($item['result'] ?? 'error')));
                $status = 'error';
                if ($rawStatus === 'pass' || $rawStatus === 'success') $status = 'pass';
                if ($rawStatus === 'fail' || $rawStatus === 'failed') $status = 'fail';

                $yearlyResults[$year] = [
                    'status' => $status,
                    'review' => $item['review'] ?? '未知',
                    'reason' => $item['reason'] ?? '',
                ];
            }
        }

        if (empty($yearlyResults)) {
            return "未能从该文件中读取到有效的审计报告信息。";
        }

        $findings = [];
        foreach ($yearlyResults as $year => $res) {
            $yearStr = (string)$year;
            $statusText = $res['status'] === 'pass' ? '符合标准' : ($res['status'] === 'fail' ? '不符合标准' : '解析失败');
            $findings[] = "{$yearStr}年度: {$statusText} (审计意见: {$res['review']}) " . ($res['reason'] ? "原因: {$res['reason']}" : "");
        }

        return implode('; ', $findings);
    }

    public function isAccessible(array $data, array $context): bool
    {
        $durationYears = $context['duration_years'] ?? [];
        if (empty($durationYears)) return false;

        $yearlyResults = [];
        foreach ($data as $item) {
            if (!is_array($item)) continue;
            $year = $this->normalizeYear($item['year'] ?? '');
            if ($year) {
                $yearlyResults[$year] = $item['status'] ?? ($item['result'] ?? 'error');
            }
        }

        foreach ($durationYears as $year) {
            if (($yearlyResults[(string)$year] ?? '') !== 'pass') {
                return false;
            }
        }

        return true;
    }

    public function getSuccessMessages(array $data, array $context): array
    {
        return ["存续期内所有年度审计报告均符合“无保留意见”标准。"];
    }
}
