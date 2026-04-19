-- AEO Audit System - Data Schema Update
-- Created: 2026-04-18

ALTER TABLE `folders` 
  ADD COLUMN `description` TEXT NULL COMMENT '上传文件说明',
  ADD COLUMN `department` VARCHAR(100) NULL COMMENT '对应部门';
