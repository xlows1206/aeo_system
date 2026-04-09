<?php

declare(strict_types=1);

namespace App\Lib\AI\CheckHandlers;

/**
 * 通用关键字匹配检测 Handler
 */
class KeywordMatchHandler extends AbstractHandler
{
    protected string $promptFile = 'keyword_match';

    public function performAudit(array $data, array $context): ?string
    {
        $checkName = $context['check_name'] ?? '未知项';
        
        $passed = false;
        foreach ($data as $item) {
            $res = $item['result'] ?? null;
            if ($res === true || $res === 'true') {
                $passed = true;
                break;
            }
        }

        if (!$passed) {
            return "{$checkName}未通过, 未读取到有效关键字信息";
        }

        return null;
    }
}
