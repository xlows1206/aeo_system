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
        $notSelfTotal = $context['not_self_total'] ?? 0;
        if ($notSelfTotal <= 0) {
            return null; // 防止除零
        }

        $falseCount = 0;
        foreach ($data as $item) {
            $res = $item['result'] ?? null;
            if ($res === false || $res === 'false') {
                $falseCount++;
            }
        }

        if ($falseCount / $notSelfTotal >= 0.001) {
            return "存在被查处罚（不存在“经自查”字段）的报关单超过报关单总数千分之一 (比例: " . ($falseCount / $notSelfTotal * 100) . "%)";
        }

        return null;
    }
}
