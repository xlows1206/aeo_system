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
        $companyPersonNames = $context['company_person_names'] ?? [];
        if (count($companyPersonNames) < 1) {
            return "无犯罪记录证明验证失败，公司负责人信息未设置";
        }

        $allFoundNames = [];
        $errors = [];

        foreach ($data as $item) {
            if (isset($item['is_title_correct']) && $item['is_title_correct'] === false) {
                $errors[] = "文件标题/类型不匹配 (" . ($item['reason'] ?? '请上传无犯罪记录证明') . ")";
                continue;
            }

            if (isset($item['has_no_criminal_record']) && $item['has_no_criminal_record'] === false) {
                $errors[] = "语义核对失败: 资料中未明确表达“无犯罪记录”意图 (" . ($item['reason'] ?? '详见文档内容') . ")";
                continue;
            }

            if (!empty($item['name'])) {
                $allFoundNames[] = $item['name'];
            }
        }

        // 身份匹配：提取到的姓名必须是公司设置的负责人之一
        $diffPersons = array_diff($companyPersonNames, $allFoundNames);
        if (count($diffPersons) > 0) {
            return implode('、', $diffPersons) . ' 未提供合格的无犯罪记录证明 (或姓名匹配失败), 请检查资料。';
        }

        return empty($errors) ? null : implode('; ', $errors);
    }
}
