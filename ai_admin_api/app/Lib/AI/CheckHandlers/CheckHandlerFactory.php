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
    public static function make(?string $checkName): CheckHandlerInterface
    {
        $checkName = $checkName ?? '';
        
        // 1. 如果包含 " 、 "，取最后一节内容 (例如 "财务状况 、 资产负债率情况" -> "资产负债率情况")
        if (str_contains($checkName, ' 、 ')) {
            $parts = explode(' 、 ', $checkName);
            $checkName = end($parts);
        }

        // 2. 剔除前导编号 (例如 "6-15-1 无犯罪记录管理层声明书" -> "无犯罪记录管理层声明书")
        $coreName = preg_replace('/^[\d.&-]+\s*/', '', trim($checkName));

        return match ($coreName) {
            '资产负债率情况' => new FinancialRatioHandler(),
            '审计报告' => new AuditReportHandler(),
            '无犯罪记录管理层声明书' => new LegalComplianceHandler(),
            '报关单行政处罚合规' => new FineAmountHandler(),
            '行政被处罚金额' => new FineAmountHandler(),
            '被处罚单比例小于报关千分之一' => new PunishmentRatioHandler(),
            default => new KeywordMatchHandler(),
        };
    }
}
