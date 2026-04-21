-- AEO Audit System - Data Schema Update
-- Adding example_url to folders table
-- Created: 2026-04-21

ALTER TABLE `folders` 
  ADD COLUMN `example_url` VARCHAR(255) NULL COMMENT '示例图片URL' AFTER `description`;

-- 更新一些核心审核项目的示例图 (占位符，后续由 AI 生成并提示填入)
-- 6-15-1-无犯罪记录管理层声明书 (Standard 6)
UPDATE `folders` SET `example_url` = 'https://aeo-static.oss-cn-shanghai.aliyuncs.com/templates/legal_compliance_sample.png' WHERE `name` LIKE '%无犯罪记录%';

-- 5-13-审计报告 (Standard 5 - 财务)
UPDATE `folders` SET `example_url` = 'https://aeo-static.oss-cn-shanghai.aliyuncs.com/templates/audit_report_sample.png' WHERE `name` LIKE '%审计报告%';

-- 资产负债情况
UPDATE `folders` SET `example_url` = 'https://aeo-static.oss-cn-shanghai.aliyuncs.com/templates/financial_ratio_sample.png' WHERE `name` LIKE '%资产负债%';
