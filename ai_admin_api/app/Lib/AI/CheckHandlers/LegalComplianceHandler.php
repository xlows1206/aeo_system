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
        if (count($companyPersonNames) < 4) {
            return "无犯罪记录证明验证失败，公司负责人信息设置不全 (需包含法人、负责人、财务、关务)";
        }

        $allFoundNames = [];
        foreach ($data as $item) {
            if (!empty($item['name'])) {
                $allFoundNames[] = $item['name'];
            }
        }

        $diffPersons = array_diff($companyPersonNames, $allFoundNames);
        if (count($diffPersons) > 0) {
            return implode('、', $diffPersons) . ' 未提供无犯罪记录证明, 请检查.';
        }

        return null;
    }
}
