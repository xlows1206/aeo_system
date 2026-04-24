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
            return "[ERROR] 报关单总量未设置，无法计算千分之一比例";
        }

        $falseCount = 0;
        $errors = [];

        foreach ($data as $item) {
            $res = $item['result'] ?? null;
            if ($res === 'error') {
                $errors[] = "[ERROR] 部分资料解析失败: " . ($item['reason'] ?? '请检查文件清晰度');
                continue;
            }

            if ($res === false || $res === 'false') {
                $falseCount++;
            }
        }

        if ($falseCount / $notSelfTotal >= 0.001) {
            $errors[] = "存在非自查处罚报关单超过千分之一 (比例: " . round($falseCount / $notSelfTotal * 100, 4) . "%)";
        }

        return empty($errors) ? null : implode('; ', $errors);
    }
}
