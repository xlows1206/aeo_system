<?php

declare(strict_types=1);

namespace App\Lib\AI\CheckHandlers;

/**
 * 被处罚单比例检测 Handler
 */
class PunishmentRatioHandler extends AbstractHandler
{
    protected string $promptFile = 'punishment_ratio';

    public function performAudit(array $data, array $context): ?string
    {
        $notSelfTotal = (int)($context['not_self_total'] ?? 0);
        if ($notSelfTotal <= 0) {
            return "[ERROR] 报关单总量未设置，无法计算千分之一比例";
        }

        $matchCount = 0;
        $totalItems = count($data);

        foreach ($data as $item) {
            $res = $item['result'] ?? null;
            if ($res === true || $res === 'true') {
                $matchCount++;
            }
        }

        $ratio = ($matchCount / $notSelfTotal);
        $ratioPercent = round($ratio * 100, 4) . "%";
        
        $statusText = $ratio < 0.001 ? "符合标准 (低于千分之一)" : "不符合标准 (超出千分之一限额)";
        
        return "报关单总量: {$notSelfTotal}, 命中处罚记录: {$matchCount}, 计算比例: {$ratioPercent}。结论: {$statusText}";
    }

    public function isAccessible(array $data, array $context): bool
    {
        $notSelfTotal = (int)($context['not_self_total'] ?? 0);
        if ($notSelfTotal <= 0) return false;

        $matchCount = 0;
        foreach ($data as $item) {
            $res = $item['result'] ?? null;
            if ($res === true || $res === 'true') {
                $matchCount++;
            }
        }

        return ($matchCount / $notSelfTotal) < 0.001;
    }

    public function getSuccessMessages(array $data, array $context): array
    {
        return ["经核验，该项下的违规报关单比例低于千分之一，符合海关合规审查标准。"];
    }
}
