<?php

declare(strict_types=1);

namespace App\Lib\AI\CheckHandlers;

/**
 * 检测逻辑工厂类
 */
class CheckHandlerFactory
{
    /**
     * 根据 check_name 获取对应的 Handler 实例
     * @param string $checkName
     * @return CheckHandlerInterface
     */
    public static function make(string $checkName): CheckHandlerInterface
    {
        return match ($checkName) {
            '资产负债率情况' => new FinancialRatioHandler(),
            '审计报告' => new AuditReportHandler(),
            '遵守法律法规' => new LegalComplianceHandler(),
            '行政被处罚金额' => new FineAmountHandler(),
            '被处罚单比例小于报关千分之一' => new PunishmentRatioHandler(),
            default => new KeywordMatchHandler(),
        };
    }
}
