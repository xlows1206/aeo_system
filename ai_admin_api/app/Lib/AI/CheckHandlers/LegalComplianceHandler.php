<?php

declare(strict_types=1);

namespace App\Lib\AI\CheckHandlers;

/**
 * 遵守法律法规检测 Handler
 */
class LegalComplianceHandler extends AbstractHandler
{
    protected string $promptFile = 'legal_compliance';

    public function performAudit(array $data, array $context): ?string
    {
        $fileFindings = [];

        foreach ($data as $item) {
            $name = $item['name'] ?? '未知人员';
            $status = strtolower((string)($item['status'] ?? ($item['result'] ?? '')));

            if ($status === 'error') {
                $fileFindings[] = "【{$name}】解析失败: " . ($item['reason'] ?? '请检查文件清晰度');
                continue;
            }

            if ($status === 'failed') {
                $fileFindings[] = "【{$name}】审核不通过: " . ($item['reason'] ?? '文件不符合 AEO 要求');
                continue;
            }

            // 兼容性检查：如果是旧逻辑的 boolean
            if (isset($item['is_title_correct']) && $item['is_title_correct'] === false) {
                $fileFindings[] = "【{$name}】文件类型不匹配: " . ($item['reason'] ?? '不是有效的证明文件');
                continue;
            }

            if (isset($item['has_no_criminal_record']) && $item['has_no_criminal_record'] === false) {
                $fileFindings[] = "【{$name}】内容审核不通过: " . ($item['reason'] ?? '存在犯罪记录或意图不明');
                continue;
            }

            $fileFindings[] = "【{$name}】无犯罪记录证明校验通过。";
        }

        if (empty($fileFindings)) {
            return "未能从该文件中读取到有效的个人身份或无犯罪记录信息。";
        }

        return implode('; ', $fileFindings);
    }

    public function isAccessible(array $data, array $context): bool
    {
        $companyPersonNames = $context['company_person_names'] ?? [];
        if (empty($companyPersonNames)) return false;

        $passedNames = [];
        foreach ($data as $item) {
            if (($item['has_no_criminal_record'] ?? false) === true && !empty($item['name'])) {
                $passedNames[] = $item['name'];
            }
        }

        // 必须覆盖所有负责人
        foreach ($companyPersonNames as $name) {
            if (!in_array($name, $passedNames)) {
                return false;
            }
        }

        return true;
    }

    public function getSuccessMessages(array $data, array $context): array
    {
        return ["所有公司关键负责人的无犯罪记录证明均已核验通过。"];
    }
}
