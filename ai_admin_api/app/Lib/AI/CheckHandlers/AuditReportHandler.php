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

        $errors = [];
        $foundYears = [];
        foreach ($data as $item) {
            $year = $item['year'] ?? '';
            $result = $item['result'] ?? '';
            if (($result === true || $result === 'true') && $year) {
                $foundYears[] = (string)$year;
            }
        }

        if (count($foundYears) < count($durationYears)) {
            foreach ($durationYears as $year) {
                if (!in_array((string)$year, $foundYears)) {
                    $errors[] = "{$year}年度审计报告未通过或未读取有效信息";
                }
            }
        }

        return empty($errors) ? null : implode('; ', $errors);
    }
}
