-- 1. 确保 folder_check_files 的唯一性 (保留最新的一条，删除基于 folder_id 的重复项)
DELETE f1 FROM folder_check_files f1
INNER JOIN folder_check_files f2 
WHERE f1.id < f2.id AND f1.folder_id = f2.folder_id;

-- 2. 补全缺失的 folders 记录 (单项标准 standard_id=6)
-- 业务大类根节点
INSERT IGNORE INTO `folders` (`id`, `name`, `standard_id`, `user_id`, `master_id`, `parent_id`, `created_at`, `updated_at`) VALUES
(264, '一、加工贸易以及保税进出口业务', 6, 1, 2, 0, NOW(), NOW()),
(265, '二、卫生检疫业务', 6, 1, 2, 0, NOW(), NOW()),
(266, '三、动植物检疫业务', 6, 1, 2, 0, NOW(), NOW()),
(267, '五、进出口商品检验业务', 6, 1, 2, 0, NOW(), NOW()),
(268, '八、物流运输业务', 6, 1, 2, 0, NOW(), NOW()),
(300, '六、代理报关业务', 6, 1, 2, 0, NOW(), NOW());

-- 具体的二级/三级文件夹记录
INSERT IGNORE INTO `folders` (`id`, `name`, `standard_id`, `user_id`, `master_id`, `parent_id`, `created_at`, `updated_at`) VALUES
(269, '一-1 进出口单证复核&保管制度', 6, 1, 2, 264, NOW(), NOW()),
(372, '二-2 特殊物品单证', 6, 1, 2, 265, NOW(), NOW()),
(373, '二-3 特殊物品安全管理制度', 6, 1, 2, 265, NOW(), NOW()),
(377, '三-4 商检制度&台账', 6, 1, 2, 266, NOW(), NOW()),
(276, '三-4-1 制度', 6, 1, 2, 377, NOW(), NOW()),
(388, '三-4-2 进境商检查验管理台账', 6, 1, 2, 377, NOW(), NOW()),
(389, '三-4-3 抽查单证', 6, 1, 2, 377, NOW(), NOW()),
(279, '三-4-4 熏蒸板记录', 6, 1, 2, 377, NOW(), NOW()),
(378, '五-9 法检制度', 6, 1, 2, 267, NOW(), NOW()),
(379, '八-20 运输工具管理制度', 6, 1, 2, 268, NOW(), NOW()),
(380, '八-21 运输工具行驶轨迹', 6, 1, 2, 268, NOW(), NOW()),
(381, '八-21-1 制度', 6, 1, 2, 380, NOW(), NOW()),
(382, '八-21-2 轨迹记录', 6, 1, 2, 380, NOW(), NOW()),
(383, '八-22 运输工具与驾驶人员匹配制度', 6, 1, 2, 268, NOW(), NOW()),
(384, '八-22-1 制度', 6, 1, 2, 383, NOW(), NOW()),
(385, '八-22-2 记录', 6, 1, 2, 383, NOW(), NOW()),
(301, '六-1 代理报关单证管理制度', 6, 1, 2, 300, NOW(), NOW()),
(302, '六-2 代理报关单证复核制度', 6, 1, 2, 300, NOW(), NOW()),
(303, '六-3 代理报关单证保管制度', 6, 1, 2, 300, NOW(), NOW()),
(304, '六-4 代理报关业务系统说明', 6, 1, 2, 300, NOW(), NOW()),
(305, '六-5 系统逻辑检验截屏', 6, 1, 2, 300, NOW(), NOW()),
(306, '六-6 历年单证抽取记录', 6, 1, 2, 300, NOW(), NOW()),
(307, '六-7 海关法律法规培训管理办法', 6, 1, 2, 300, NOW(), NOW()),
(308, '六-8 客户海关法律法规培训签到记录和培训课件', 6, 1, 2, 300, NOW(), NOW()),
(309, '六-9 延伸认证情况说明文件', 6, 1, 2, 300, NOW(), NOW());

-- 3. 重建 folder_closure 闭包表 (针对 standard_id=6)
DELETE FROM folder_closure WHERE descendant IN (SELECT id FROM folders WHERE standard_id = 6);
INSERT INTO folder_closure (ancestor, descendant, distance)
SELECT id, id, 0 FROM folders WHERE standard_id = 6;
INSERT INTO folder_closure (ancestor, descendant, distance)
SELECT parent_id, id, 1 FROM folders WHERE standard_id = 6 AND parent_id != 0;
-- 跨层级 (Distance 2)
INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
SELECT fc1.ancestor, fc2.descendant, fc1.distance + fc2.distance
FROM folder_closure fc1 
JOIN folder_closure fc2 ON fc1.descendant = fc2.ancestor
WHERE fc1.distance = 1 AND fc2.distance = 1 AND fc1.ancestor != 0;
-- 跨层级 (Distance 3)
INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
SELECT fc1.ancestor, fc2.descendant, fc1.distance + fc2.distance
FROM folder_closure fc1 
JOIN folder_closure fc2 ON fc1.descendant = fc2.ancestor
WHERE fc1.distance = 2 AND fc2.distance = 1 AND fc1.ancestor != 0;
