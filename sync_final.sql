
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `folder_check_files`;
-- 仅清理单项标准的文件夹子项，保留根节点(id 264-300区间)
DELETE FROM `folders` WHERE `standard_id` = 6 AND `id` > 500;
DELETE FROM `folder_closure` WHERE descendant NOT IN (SELECT id FROM folders);

DROP PROCEDURE IF EXISTS SyncStandard6;
DELIMITER //
CREATE PROCEDURE SyncStandard6()
BEGIN
    DECLARE v_fid INT;


-- Path: 单项标准/一、加工贸易以及保税进出口业务
SET @f_____________________ = (SELECT id FROM folders WHERE name = '一、加工贸易以及保税进出口业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f_____________________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (264, '一、加工贸易以及保税进出口业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f_____________________ = 264;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_____________________, @f_____________________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_____________________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/一、加工贸易以及保税进出口业务/1-单证复核及系统逻辑检验
SET @f______________________1____________ = (SELECT id FROM folders WHERE name = '1-单证复核及系统逻辑检验' AND parent_id = @f_____________________ AND standard_id = 6 LIMIT 1);
IF @f______________________1____________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('1-单证复核及系统逻辑检验', 6, 1, 2, @f_____________________, NOW(), NOW(), '关务');
    SET @f______________________1____________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________________1____________, @f______________________1____________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________________1____________, distance + 1 FROM folder_closure WHERE descendant = @f_____________________;
END IF;


-- Path: 单项标准/三、动植物检疫业务
SET @f_______________ = (SELECT id FROM folders WHERE name = '三、动植物检疫业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f_______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (266, '三、动植物检疫业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f_______________ = 266;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________, @f_______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/三、动植物检疫业务/4. 商检制度与台账
SET @f________________4_________ = (SELECT id FROM folders WHERE name = '4. 商检制度与台账' AND parent_id = @f_______________ AND standard_id = 6 LIMIT 1);
IF @f________________4_________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('4. 商检制度与台账', 6, 1, 2, @f_______________, NOW(), NOW(), '关务');
    SET @f________________4_________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4_________, @f________________4_________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f________________4_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________;
END IF;


-- Path: 单项标准/三、动植物检疫业务/4. 商检制度与台账/4-4-1-管理制度
SET @f________________4__________4_4_1_____ = (SELECT id FROM folders WHERE name = '4-4-1-管理制度' AND parent_id = @f________________4_________ AND standard_id = 6 LIMIT 1);
IF @f________________4__________4_4_1_____ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('4-4-1-管理制度', 6, 1, 2, @f________________4_________, NOW(), NOW(), '关务');
    SET @f________________4__________4_4_1_____ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4__________4_4_1_____, @f________________4__________4_4_1_____, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f________________4__________4_4_1_____, distance + 1 FROM folder_closure WHERE descendant = @f________________4_________;
END IF;


-- Path: 单项标准/三、动植物检疫业务
SET @f_______________ = (SELECT id FROM folders WHERE name = '三、动植物检疫业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f_______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (266, '三、动植物检疫业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f_______________ = 266;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________, @f_______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/三、动植物检疫业务/4. 商检制度与台账
SET @f________________4_________ = (SELECT id FROM folders WHERE name = '4. 商检制度与台账' AND parent_id = @f_______________ AND standard_id = 6 LIMIT 1);
IF @f________________4_________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('4. 商检制度与台账', 6, 1, 2, @f_______________, NOW(), NOW(), '关务');
    SET @f________________4_________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4_________, @f________________4_________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f________________4_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________;
END IF;


-- Path: 单项标准/三、动植物检疫业务/4. 商检制度与台账/4-4-2-进境商检查验管理台账
SET @f________________4__________4_4_2___________ = (SELECT id FROM folders WHERE name = '4-4-2-进境商检查验管理台账' AND parent_id = @f________________4_________ AND standard_id = 6 LIMIT 1);
IF @f________________4__________4_4_2___________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('4-4-2-进境商检查验管理台账', 6, 1, 2, @f________________4_________, NOW(), NOW(), '关务');
    SET @f________________4__________4_4_2___________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4__________4_4_2___________, @f________________4__________4_4_2___________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f________________4__________4_4_2___________, distance + 1 FROM folder_closure WHERE descendant = @f________________4_________;
END IF;


-- Path: 单项标准/三、动植物检疫业务
SET @f_______________ = (SELECT id FROM folders WHERE name = '三、动植物检疫业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f_______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (266, '三、动植物检疫业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f_______________ = 266;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________, @f_______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/三、动植物检疫业务/4. 商检制度与台账
SET @f________________4_________ = (SELECT id FROM folders WHERE name = '4. 商检制度与台账' AND parent_id = @f_______________ AND standard_id = 6 LIMIT 1);
IF @f________________4_________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('4. 商检制度与台账', 6, 1, 2, @f_______________, NOW(), NOW(), '关务');
    SET @f________________4_________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4_________, @f________________4_________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f________________4_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________;
END IF;


-- Path: 单项标准/三、动植物检疫业务/4. 商检制度与台账/4-4-3-抽查单证
SET @f________________4__________4_4_3_____ = (SELECT id FROM folders WHERE name = '4-4-3-抽查单证' AND parent_id = @f________________4_________ AND standard_id = 6 LIMIT 1);
IF @f________________4__________4_4_3_____ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('4-4-3-抽查单证', 6, 1, 2, @f________________4_________, NOW(), NOW(), '关务');
    SET @f________________4__________4_4_3_____ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4__________4_4_3_____, @f________________4__________4_4_3_____, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f________________4__________4_4_3_____, distance + 1 FROM folder_closure WHERE descendant = @f________________4_________;
END IF;


-- Path: 单项标准/三、动植物检疫业务
SET @f_______________ = (SELECT id FROM folders WHERE name = '三、动植物检疫业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f_______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (266, '三、动植物检疫业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f_______________ = 266;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________, @f_______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/三、动植物检疫业务/4. 商检制度与台账
SET @f________________4_________ = (SELECT id FROM folders WHERE name = '4. 商检制度与台账' AND parent_id = @f_______________ AND standard_id = 6 LIMIT 1);
IF @f________________4_________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('4. 商检制度与台账', 6, 1, 2, @f_______________, NOW(), NOW(), '关务');
    SET @f________________4_________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4_________, @f________________4_________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f________________4_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________;
END IF;


-- Path: 单项标准/三、动植物检疫业务/4. 商检制度与台账/4-4-4-熏蒸板记录
SET @f________________4__________4_4_4______ = (SELECT id FROM folders WHERE name = '4-4-4-熏蒸板记录' AND parent_id = @f________________4_________ AND standard_id = 6 LIMIT 1);
IF @f________________4__________4_4_4______ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('4-4-4-熏蒸板记录', 6, 1, 2, @f________________4_________, NOW(), NOW(), '关务');
    SET @f________________4__________4_4_4______ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4__________4_4_4______, @f________________4__________4_4_4______, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f________________4__________4_4_4______, distance + 1 FROM folder_closure WHERE descendant = @f________________4_________;
END IF;


-- Path: 单项标准/二、卫生检疫业务
SET @f______________ = (SELECT id FROM folders WHERE name = '二、卫生检疫业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (265, '二、卫生检疫业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 265;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/二、卫生检疫业务/2. 特殊物品单证
SET @f_______________2________ = (SELECT id FROM folders WHERE name = '2. 特殊物品单证' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________2________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('2. 特殊物品单证', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________2________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________2________, @f_______________2________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________2________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/五、进出口商品检验业务
SET @f_________________ = (SELECT id FROM folders WHERE name = '五、进出口商品检验业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f_________________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (267, '五、进出口商品检验业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f_________________ = 267;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_________________, @f_________________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_________________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/五、进出口商品检验业务/9-法检制度
SET @f__________________9_____ = (SELECT id FROM folders WHERE name = '9-法检制度' AND parent_id = @f_________________ AND standard_id = 6 LIMIT 1);
IF @f__________________9_____ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('9-法检制度', 6, 1, 2, @f_________________, NOW(), NOW(), '关务');
    SET @f__________________9_____ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f__________________9_____, @f__________________9_____, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f__________________9_____, distance + 1 FROM folder_closure WHERE descendant = @f_________________;
END IF;


-- Path: 单项标准/八、物流运输业务
SET @f______________ = (SELECT id FROM folders WHERE name = '八、物流运输业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (268, '八、物流运输业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 268;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/八、物流运输业务/运输工具与驾驶人员匹配制度
SET @f____________________________ = (SELECT id FROM folders WHERE name = '运输工具与驾驶人员匹配制度' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f____________________________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('运输工具与驾驶人员匹配制度', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f____________________________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f____________________________, @f____________________________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f____________________________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/八、物流运输业务/运输工具与驾驶人员匹配制度/22-1-运输工具与驾驶人员匹配管理制度
SET @f_____________________________22_1________________ = (SELECT id FROM folders WHERE name = '22-1-运输工具与驾驶人员匹配管理制度' AND parent_id = @f____________________________ AND standard_id = 6 LIMIT 1);
IF @f_____________________________22_1________________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('22-1-运输工具与驾驶人员匹配管理制度', 6, 1, 2, @f____________________________, NOW(), NOW(), '关务');
    SET @f_____________________________22_1________________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_____________________________22_1________________, @f_____________________________22_1________________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_____________________________22_1________________, distance + 1 FROM folder_closure WHERE descendant = @f____________________________;
END IF;


-- Path: 单项标准/八、物流运输业务
SET @f______________ = (SELECT id FROM folders WHERE name = '八、物流运输业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (268, '八、物流运输业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 268;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/八、物流运输业务/运输工具与驾驶人员匹配制度
SET @f____________________________ = (SELECT id FROM folders WHERE name = '运输工具与驾驶人员匹配制度' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f____________________________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('运输工具与驾驶人员匹配制度', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f____________________________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f____________________________, @f____________________________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f____________________________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/八、物流运输业务/运输工具与驾驶人员匹配制度/22-2-台账记录
SET @f_____________________________22_2_____ = (SELECT id FROM folders WHERE name = '22-2-台账记录' AND parent_id = @f____________________________ AND standard_id = 6 LIMIT 1);
IF @f_____________________________22_2_____ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('22-2-台账记录', 6, 1, 2, @f____________________________, NOW(), NOW(), '关务');
    SET @f_____________________________22_2_____ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_____________________________22_2_____, @f_____________________________22_2_____, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_____________________________22_2_____, distance + 1 FROM folder_closure WHERE descendant = @f____________________________;
END IF;


-- Path: 单项标准/八、物流运输业务
SET @f______________ = (SELECT id FROM folders WHERE name = '八、物流运输业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (268, '八、物流运输业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 268;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/八、物流运输业务/运输工具管理制度
SET @f_______________________ = (SELECT id FROM folders WHERE name = '运输工具管理制度' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('运输工具管理制度', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________________, @f_______________________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/八、物流运输业务
SET @f______________ = (SELECT id FROM folders WHERE name = '八、物流运输业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (268, '八、物流运输业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 268;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/八、物流运输业务/运输工具行驶轨迹
SET @f_______________________ = (SELECT id FROM folders WHERE name = '运输工具行驶轨迹' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('运输工具行驶轨迹', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________________, @f_______________________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/八、物流运输业务/运输工具行驶轨迹/21-1-定位系统车载终端管理制度
SET @f________________________21_1_____________ = (SELECT id FROM folders WHERE name = '21-1-定位系统车载终端管理制度' AND parent_id = @f_______________________ AND standard_id = 6 LIMIT 1);
IF @f________________________21_1_____________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('21-1-定位系统车载终端管理制度', 6, 1, 2, @f_______________________, NOW(), NOW(), '关务');
    SET @f________________________21_1_____________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________________21_1_____________, @f________________________21_1_____________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f________________________21_1_____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________________;
END IF;


-- Path: 单项标准/八、物流运输业务
SET @f______________ = (SELECT id FROM folders WHERE name = '八、物流运输业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (268, '八、物流运输业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 268;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/八、物流运输业务/运输工具行驶轨迹
SET @f_______________________ = (SELECT id FROM folders WHERE name = '运输工具行驶轨迹' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('运输工具行驶轨迹', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________________, @f_______________________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/八、物流运输业务/运输工具行驶轨迹/21-2-车辆行驶轨迹监控记录
SET @f________________________21_2___________ = (SELECT id FROM folders WHERE name = '21-2-车辆行驶轨迹监控记录' AND parent_id = @f_______________________ AND standard_id = 6 LIMIT 1);
IF @f________________________21_2___________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('21-2-车辆行驶轨迹监控记录', 6, 1, 2, @f_______________________, NOW(), NOW(), '关务');
    SET @f________________________21_2___________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________________21_2___________, @f________________________21_2___________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f________________________21_2___________, distance + 1 FROM folder_closure WHERE descendant = @f_______________________;
END IF;


-- Path: 单项标准/六、代理报关业务
SET @f______________ = (SELECT id FROM folders WHERE name = '六、代理报关业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (300, '六、代理报关业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 300;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/六、代理报关业务/11. 单证复核及系统逻辑检验
SET @f_______________11_____________ = (SELECT id FROM folders WHERE name = '11. 单证复核及系统逻辑检验' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________11_____________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('11. 单证复核及系统逻辑检验', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________11_____________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_____________, @f_______________11_____________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________11_____________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/六、代理报关业务/11. 单证复核及系统逻辑检验/1-1-进出口单证及复核制度文件
SET @f_______________11______________1_1_____________ = (SELECT id FROM folders WHERE name = '1-1-进出口单证及复核制度文件' AND parent_id = @f_______________11_____________ AND standard_id = 6 LIMIT 1);
IF @f_______________11______________1_1_____________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('1-1-进出口单证及复核制度文件', 6, 1, 2, @f_______________11_____________, NOW(), NOW(), '关务');
    SET @f_______________11______________1_1_____________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11______________1_1_____________, @f_______________11______________1_1_____________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________11______________1_1_____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_____________;
END IF;


-- Path: 单项标准/六、代理报关业务
SET @f______________ = (SELECT id FROM folders WHERE name = '六、代理报关业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (300, '六、代理报关业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 300;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/六、代理报关业务/11. 单证复核及系统逻辑检验
SET @f_______________11_____________ = (SELECT id FROM folders WHERE name = '11. 单证复核及系统逻辑检验' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________11_____________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('11. 单证复核及系统逻辑检验', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________11_____________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_____________, @f_______________11_____________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________11_____________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/六、代理报关业务/11. 单证复核及系统逻辑检验/1-2-系统复审界面截屏
SET @f_______________11______________1_2_________ = (SELECT id FROM folders WHERE name = '1-2-系统复审界面截屏' AND parent_id = @f_______________11_____________ AND standard_id = 6 LIMIT 1);
IF @f_______________11______________1_2_________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('1-2-系统复审界面截屏', 6, 1, 2, @f_______________11_____________, NOW(), NOW(), '关务');
    SET @f_______________11______________1_2_________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11______________1_2_________, @f_______________11______________1_2_________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________11______________1_2_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_____________;
END IF;


-- Path: 单项标准/六、代理报关业务
SET @f______________ = (SELECT id FROM folders WHERE name = '六、代理报关业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (300, '六、代理报关业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 300;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/六、代理报关业务/11. 单证复核及系统逻辑检验
SET @f_______________11_____________ = (SELECT id FROM folders WHERE name = '11. 单证复核及系统逻辑检验' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________11_____________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('11. 单证复核及系统逻辑检验', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________11_____________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_____________, @f_______________11_____________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________11_____________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/六、代理报关业务/11. 单证复核及系统逻辑检验/1-3-历年退改单率统计
SET @f_______________11______________1_3_________ = (SELECT id FROM folders WHERE name = '1-3-历年退改单率统计' AND parent_id = @f_______________11_____________ AND standard_id = 6 LIMIT 1);
IF @f_______________11______________1_3_________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('1-3-历年退改单率统计', 6, 1, 2, @f_______________11_____________, NOW(), NOW(), '关务');
    SET @f_______________11______________1_3_________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11______________1_3_________, @f_______________11______________1_3_________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________11______________1_3_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_____________;
END IF;


-- Path: 单项标准/六、代理报关业务
SET @f______________ = (SELECT id FROM folders WHERE name = '六、代理报关业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (300, '六、代理报关业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 300;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/六、代理报关业务/11. 单证复核及系统逻辑检验
SET @f_______________11_____________ = (SELECT id FROM folders WHERE name = '11. 单证复核及系统逻辑检验' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________11_____________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('11. 单证复核及系统逻辑检验', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________11_____________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_____________, @f_______________11_____________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________11_____________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/六、代理报关业务/11. 单证复核及系统逻辑检验/1-4-历年单一窗口数据取值截屏
SET @f_______________11______________1_4_____________ = (SELECT id FROM folders WHERE name = '1-4-历年单一窗口数据取值截屏' AND parent_id = @f_______________11_____________ AND standard_id = 6 LIMIT 1);
IF @f_______________11______________1_4_____________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('1-4-历年单一窗口数据取值截屏', 6, 1, 2, @f_______________11_____________, NOW(), NOW(), '关务');
    SET @f_______________11______________1_4_____________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11______________1_4_____________, @f_______________11______________1_4_____________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________11______________1_4_____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_____________;
END IF;


-- Path: 单项标准/六、代理报关业务
SET @f______________ = (SELECT id FROM folders WHERE name = '六、代理报关业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (300, '六、代理报关业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 300;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/六、代理报关业务/11. 单证复核及系统逻辑检验
SET @f_______________11_____________ = (SELECT id FROM folders WHERE name = '11. 单证复核及系统逻辑检验' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________11_____________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('11. 单证复核及系统逻辑检验', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________11_____________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_____________, @f_______________11_____________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________11_____________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/六、代理报关业务/11. 单证复核及系统逻辑检验/1-5-系统逻辑检验截屏
SET @f_______________11______________1_5_________ = (SELECT id FROM folders WHERE name = '1-5-系统逻辑检验截屏' AND parent_id = @f_______________11_____________ AND standard_id = 6 LIMIT 1);
IF @f_______________11______________1_5_________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('1-5-系统逻辑检验截屏', 6, 1, 2, @f_______________11_____________, NOW(), NOW(), '关务');
    SET @f_______________11______________1_5_________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11______________1_5_________, @f_______________11______________1_5_________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________11______________1_5_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_____________;
END IF;


-- Path: 单项标准/六、代理报关业务
SET @f______________ = (SELECT id FROM folders WHERE name = '六、代理报关业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (300, '六、代理报关业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 300;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/六、代理报关业务/11. 单证复核及系统逻辑检验
SET @f_______________11_____________ = (SELECT id FROM folders WHERE name = '11. 单证复核及系统逻辑检验' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________11_____________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('11. 单证复核及系统逻辑检验', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________11_____________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_____________, @f_______________11_____________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________11_____________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/六、代理报关业务/11. 单证复核及系统逻辑检验/1-6-历年单证抽取记录
SET @f_______________11______________1_6_________ = (SELECT id FROM folders WHERE name = '1-6-历年单证抽取记录' AND parent_id = @f_______________11_____________ AND standard_id = 6 LIMIT 1);
IF @f_______________11______________1_6_________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('1-6-历年单证抽取记录', 6, 1, 2, @f_______________11_____________, NOW(), NOW(), '关务');
    SET @f_______________11______________1_6_________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11______________1_6_________, @f_______________11______________1_6_________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________11______________1_6_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_____________;
END IF;


-- Path: 单项标准/六、代理报关业务
SET @f______________ = (SELECT id FROM folders WHERE name = '六、代理报关业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (300, '六、代理报关业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 300;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/六、代理报关业务/12. 海关法律法规培训
SET @f_______________12__________ = (SELECT id FROM folders WHERE name = '12. 海关法律法规培训' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________12__________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('12. 海关法律法规培训', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________12__________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12__________, @f_______________12__________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________12__________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/六、代理报关业务/12. 海关法律法规培训/2-7-海关法律法规培训管理办法
SET @f_______________12___________2_7_____________ = (SELECT id FROM folders WHERE name = '2-7-海关法律法规培训管理办法' AND parent_id = @f_______________12__________ AND standard_id = 6 LIMIT 1);
IF @f_______________12___________2_7_____________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('2-7-海关法律法规培训管理办法', 6, 1, 2, @f_______________12__________, NOW(), NOW(), '关务');
    SET @f_______________12___________2_7_____________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12___________2_7_____________, @f_______________12___________2_7_____________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________12___________2_7_____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________12__________;
END IF;


-- Path: 单项标准/六、代理报关业务
SET @f______________ = (SELECT id FROM folders WHERE name = '六、代理报关业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (300, '六、代理报关业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 300;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/六、代理报关业务/12. 海关法律法规培训
SET @f_______________12__________ = (SELECT id FROM folders WHERE name = '12. 海关法律法规培训' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________12__________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('12. 海关法律法规培训', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________12__________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12__________, @f_______________12__________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________12__________, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/六、代理报关业务/12. 海关法律法规培训/2-8-客户海关法律法规培训签到记录和培训课件
SET @f_______________12___________2_8____________________ = (SELECT id FROM folders WHERE name = '2-8-客户海关法律法规培训签到记录和培训课件' AND parent_id = @f_______________12__________ AND standard_id = 6 LIMIT 1);
IF @f_______________12___________2_8____________________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('2-8-客户海关法律法规培训签到记录和培训课件', 6, 1, 2, @f_______________12__________, NOW(), NOW(), '关务');
    SET @f_______________12___________2_8____________________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12___________2_8____________________, @f_______________12___________2_8____________________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________12___________2_8____________________, distance + 1 FROM folder_closure WHERE descendant = @f_______________12__________;
END IF;


-- Path: 单项标准/六、代理报关业务
SET @f______________ = (SELECT id FROM folders WHERE name = '六、代理报关业务' AND parent_id = 0 AND standard_id = 6 LIMIT 1);
IF @f______________ IS NULL THEN
    INSERT INTO folders (id, name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES (300, '六、代理报关业务', 6, 1, 2, 0, NOW(), NOW(), '关务');
    SET @f______________ = 300;
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________, @f______________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f______________, distance + 1 FROM folder_closure WHERE descendant = 0;
END IF;


-- Path: 单项标准/六、代理报关业务/13. 延伸认证
SET @f_______________13______ = (SELECT id FROM folders WHERE name = '13. 延伸认证' AND parent_id = @f______________ AND standard_id = 6 LIMIT 1);
IF @f_______________13______ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('13. 延伸认证', 6, 1, 2, @f______________, NOW(), NOW(), '关务');
    SET @f_______________13______ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13______, @f_______________13______, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________13______, distance + 1 FROM folder_closure WHERE descendant = @f______________;
END IF;


-- Path: 单项标准/六、代理报关业务/13. 延伸认证/3-9-延伸认证情况说明文件
SET @f_______________13_______3_9___________ = (SELECT id FROM folders WHERE name = '3-9-延伸认证情况说明文件' AND parent_id = @f_______________13______ AND standard_id = 6 LIMIT 1);
IF @f_______________13_______3_9___________ IS NULL THEN
    INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ('3-9-延伸认证情况说明文件', 6, 1, 2, @f_______________13______, NOW(), NOW(), '关务');
    SET @f_______________13_______3_9___________ = LAST_INSERT_ID();
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13_______3_9___________, @f_______________13_______3_9___________, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, @f_______________13_______3_9___________, distance + 1 FROM folder_closure WHERE descendant = @f_______________13______;
END IF;


-- Start Inserting Audit Items
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f________________4__________4_4_1_____, '三、1 商品检查与进出口法检制度', 6, 0, '三、1 商品检查与进出口法检制度', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传：1. 仓库操作部木质包装管理制度
2. 客户服务部进出境商检与进出口法检制度' WHERE `id` = @f________________4__________4_4_1_____;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f________________4__________4_4_3_____, '三、3 抽查单证文件', 6, 0, '三、3 抽查单证文件', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传：历年抽查单证相关文件。' WHERE `id` = @f________________4__________4_4_3_____;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f________________4__________4_4_4______, '三、4 熏蒸板记录', 6, 0, '三、4 熏蒸板记录', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传：1. 空置熏蒸板存放区文件
2. 整进整出熏蒸板记录文件' WHERE `id` = @f________________4__________4_4_4______;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_______________2________, '二、2 特殊物品单证', 6, 0, '二、2 特殊物品单证', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传：历年特殊物品单证文件夹' WHERE `id` = @f_______________2________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_______________2________, '二、3 特殊物品安全管理制度', 6, 0, '二、3 特殊物品安全管理制度', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传：1. 特殊物品-温控货物操作指导手册
2. 单证归档管理制度（电子）
3. 单证归档管理制度（纸质）' WHERE `id` = @f_______________2________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f______________________1____________, '一、1 进出口单证复核&保管制度', 6, 0, '一、1 进出口单证复核&保管制度', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传：1. 客户服务部单证复核流程
2. 单证归档管理制度（电子）
3. 单证归档管理制度（纸质）' WHERE `id` = @f______________________1____________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f________________4__________4_4_2___________, '三、2 进境商检查验管理台账历年纪录', 6, 0, '三、2 进境商检查验管理台账历年纪录', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传：历年进境商检查验管理台账记录。' WHERE `id` = @f________________4__________4_4_2___________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f__________________9_____, '进出口商品检验 、 法检制度', 6, 0, '进出口商品检验 、 法检制度', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传进出境商检与进出口法检管理制度文件。' WHERE `id` = @f__________________9_____;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_______________________, '八、物流运输业务 - 20 运输工具管理制度', 6, 0, '八、物流运输业务 - 20 运输工具管理制度', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传运输工具管理相关的操作规范或制度文件（如运输部操作规范）。' WHERE `id` = @f_______________________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f________________________21_1_____________, '八、物流运输业务 - 21-1 运输工具轨迹管理制度', 6, 0, '八、物流运输业务 - 21-1 运输工具轨迹管理制度', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传定位系统车载终端管理制度文件。' WHERE `id` = @f________________________21_1_____________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f________________________21_2___________, '八、物流运输业务 - 21-2 车辆行驶轨迹记录', 6, 0, '八、物流运输业务 - 21-2 车辆行驶轨迹记录', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传各年度车辆行驶轨迹监控数据及汇总台账。' WHERE `id` = @f________________________21_2___________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_____________________________22_1________________, '八、物流运输业务 - 22-1 驾驶员安全与匹配制度', 6, 0, '八、物流运输业务 - 22-1 驾驶员安全与匹配制度', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传驾驶员安全管理制度、司机提货流程及身份检查规范。' WHERE `id` = @f_____________________________22_1________________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_____________________________22_2_____, '八、物流运输业务 - 22-2 车辆与司机登记台账', 6, 0, '八、物流运输业务 - 22-2 车辆与司机登记台账', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传车辆信息表、各年度提送货车辆进出登记台账。' WHERE `id` = @f_____________________________22_2_____;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_______________11______________1_1_____________, '六、代理报关业务 - 1 进出口单证及复核制度文件', 6, 0, '六、代理报关业务 - 1 进出口单证及复核制度文件', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传以下文件：
1. 进出口单证及复核制度文件' WHERE `id` = @f_______________11______________1_1_____________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_______________11______________1_2_________, '六、代理报关业务 - 2 系统复审界面截屏', 6, 0, '六、代理报关业务 - 2 系统复审界面截屏', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传以下文件：
1. 系统复审界面截屏' WHERE `id` = @f_______________11______________1_2_________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_______________11______________1_3_________, '六、代理报关业务 - 3 历年退改单率统计', 6, 0, '六、代理报关业务 - 3 历年退改单率统计', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传以下文件：
1. 历年退改单率统计' WHERE `id` = @f_______________11______________1_3_________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_______________11______________1_4_____________, '六、代理报关业务 - 4 历年单一窗口数据取值截屏', 6, 0, '六、代理报关业务 - 4 历年单一窗口数据取值截屏', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传以下文件：
1. 历年单一窗口数据取值截屏' WHERE `id` = @f_______________11______________1_4_____________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_______________11______________1_5_________, '六、代理报关业务 - 5 系统逻辑检验截屏', 6, 0, '六、代理报关业务 - 5 系统逻辑检验截屏', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传以下文件：
1. 系统逻辑检验截屏' WHERE `id` = @f_______________11______________1_5_________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_______________11______________1_6_________, '六、代理报关业务 - 6 历年单证抽取记录', 6, 0, '六、代理报关业务 - 6 历年单证抽取记录', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传以下文件：
1. 历年单证抽取记录，包括出口、出境、进口、进境' WHERE `id` = @f_______________11______________1_6_________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_______________12___________2_7_____________, '六、代理报关业务 - 7 海关法律法规培训管理办法', 6, 0, '六、代理报关业务 - 7 海关法律法规培训管理办法', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传以下文件：
1. 海关法律法规培训管理办法' WHERE `id` = @f_______________12___________2_7_____________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_______________12___________2_8____________________, '六、代理报关业务 - 8 客户海关法律法规培训签到记录和培训课件', 6, 0, '六、代理报关业务 - 8 客户海关法律法规培训签到记录和培训课件', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传以下文件：
1. 客户海关法律法规培训签到记录和培训课件' WHERE `id` = @f_______________12___________2_8____________________;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (@f_______________13_______3_9___________, '六、代理报关业务 - 9 延伸认证情况说明文件', 6, 0, '六、代理报关业务 - 9 延伸认证情况说明文件', 2, NOW(), NOW());
UPDATE `folders` SET `description` = '请上传以下文件：
1. 延伸认证情况说明文件' WHERE `id` = @f_______________13_______3_9___________;

END //
DELIMITER ;
CALL SyncStandard6();
DROP PROCEDURE SyncStandard6;
SET FOREIGN_KEY_CHECKS = 1;
