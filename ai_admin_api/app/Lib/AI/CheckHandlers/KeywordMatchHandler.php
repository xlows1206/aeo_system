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
            $status = strtolower((string)($item['status'] ?? ($item['result'] ?? '')));
            if ($status === 'pass' || $status === 'true' || $item['result'] === true) {
                $passed = true;
                break;
            }
        }

        if (!$passed) {
            return "{$checkName}审核未通过：未在上传文档中匹配到关键条款。";
        }
        return null;
    }

    public function getSuccessMessages(array $data, array $context): array
    {
        $checkName = $context['check_name'] ?? '项目';
        return ["上传的资料已通过关键词校验，符合《{$checkName}》标准。"];
    }
}
