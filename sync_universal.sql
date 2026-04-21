
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `folder_check_files`;

-- 注意：不清理 folders, 因为 folders_inserts.sql 会重置它。
-- 我们仅在这里动态创建那些在 inserts 中没覆盖到的层级。

DROP PROCEDURE IF EXISTS SyncUniversal;
DELIMITER //
CREATE PROCEDURE SyncUniversal()
BEGIN


    SET @f_______________1_________ = (SELECT id FROM folders WHERE name = '1-关企沟通联系合作' AND parent_id = 500 AND standard_id = 2 LIMIT 1);
    IF @f_______________1_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-关企沟通联系合作', 2, 1, 2, 500, NOW(), NOW(), '人事');
        SET @f_______________1_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________1_________, @f_______________1_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________1_________, distance + 1 FROM folder_closure WHERE descendant = 500;
    END IF;

    SET @f_______________1__________1_1_________ = (SELECT id FROM folders WHERE name = '1-1-关企联系合作机制' AND parent_id = @f_______________1_________ AND standard_id = 2 LIMIT 1);
    IF @f_______________1__________1_1_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-1-关企联系合作机制', 2, 1, 2, @f_______________1_________, NOW(), NOW(), '人事');
        SET @f_______________1__________1_1_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________1__________1_1_________, @f_______________1__________1_1_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________1__________1_1_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________1_________;
    END IF;

    SET @f_______________1_________ = (SELECT id FROM folders WHERE name = '1-关企沟通联系合作' AND parent_id = 500 AND standard_id = 2 LIMIT 1);
    IF @f_______________1_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-关企沟通联系合作', 2, 1, 2, 500, NOW(), NOW(), '人事');
        SET @f_______________1_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________1_________, @f_______________1_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________1_________, distance + 1 FROM folder_closure WHERE descendant = 500;
    END IF;

    SET @f_______________1__________1_2_____ = (SELECT id FROM folders WHERE name = '1-2-岗位职责' AND parent_id = @f_______________1_________ AND standard_id = 2 LIMIT 1);
    IF @f_______________1__________1_2_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-2-岗位职责', 2, 1, 2, @f_______________1_________, NOW(), NOW(), '人事');
        SET @f_______________1__________1_2_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________1__________1_2_____, @f_______________1__________1_2_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________1__________1_2_____, distance + 1 FROM folder_closure WHERE descendant = @f_______________1_________;
    END IF;

    SET @f_______________2______ = (SELECT id FROM folders WHERE name = '2-进出口单证' AND parent_id = 504 AND standard_id = 4 LIMIT 1);
    IF @f_______________2______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-进出口单证', 4, 1, 2, 504, NOW(), NOW(), '关务');
        SET @f_______________2______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________2______, @f_______________2______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________2______, distance + 1 FROM folder_closure WHERE descendant = 504;
    END IF;

    SET @f_______________2_______2_3__________ = (SELECT id FROM folders WHERE name = '2-3-进出口单证复核制度' AND parent_id = @f_______________2______ AND standard_id = 4 LIMIT 1);
    IF @f_______________2_______2_3__________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-3-进出口单证复核制度', 4, 1, 2, @f_______________2______, NOW(), NOW(), '关务');
        SET @f_______________2_______2_3__________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________2_______2_3__________, @f_______________2_______2_3__________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________2_______2_3__________, distance + 1 FROM folder_closure WHERE descendant = @f_______________2______;
    END IF;

    SET @f_______________2______ = (SELECT id FROM folders WHERE name = '2-进出口单证' AND parent_id = 504 AND standard_id = 4 LIMIT 1);
    IF @f_______________2______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-进出口单证', 4, 1, 2, 504, NOW(), NOW(), '关务');
        SET @f_______________2______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________2______, @f_______________2______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________2______, distance + 1 FROM folder_closure WHERE descendant = 504;
    END IF;

    SET @f_______________2_______2_4__________ = (SELECT id FROM folders WHERE name = '2-4-进出口单证保管制度' AND parent_id = @f_______________2______ AND standard_id = 4 LIMIT 1);
    IF @f_______________2_______2_4__________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-4-进出口单证保管制度', 4, 1, 2, @f_______________2______, NOW(), NOW(), '关务');
        SET @f_______________2_______2_4__________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________2_______2_4__________, @f_______________2_______2_4__________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________2_______2_4__________, distance + 1 FROM folder_closure WHERE descendant = @f_______________2______;
    END IF;

    SET @f_______________2______ = (SELECT id FROM folders WHERE name = '2-进出口单证' AND parent_id = 504 AND standard_id = 4 LIMIT 1);
    IF @f_______________2______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-进出口单证', 4, 1, 2, 504, NOW(), NOW(), '关务');
        SET @f_______________2______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________2______, @f_______________2______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________2______, distance + 1 FROM folder_closure WHERE descendant = 504;
    END IF;

    SET @f_______________2_______2_5____________ = (SELECT id FROM folders WHERE name = '2-5-禁止类产品合规审查制度' AND parent_id = @f_______________2______ AND standard_id = 4 LIMIT 1);
    IF @f_______________2_______2_5____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-5-禁止类产品合规审查制度', 4, 1, 2, @f_______________2______, NOW(), NOW(), '关务');
        SET @f_______________2_______2_5____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________2_______2_5____________, @f_______________2_______2_5____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________2_______2_5____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________2______;
    END IF;

    SET @f_______________2______ = (SELECT id FROM folders WHERE name = '2-进出口单证' AND parent_id = 504 AND standard_id = 4 LIMIT 1);
    IF @f_______________2______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-进出口单证', 4, 1, 2, 504, NOW(), NOW(), '关务');
        SET @f_______________2______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________2______, @f_______________2______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________2______, distance + 1 FROM folder_closure WHERE descendant = 504;
    END IF;

    SET @f_______________2_______2_6___________ = (SELECT id FROM folders WHERE name = '2-6-企业认证电子资料档案' AND parent_id = @f_______________2______ AND standard_id = 4 LIMIT 1);
    IF @f_______________2_______2_6___________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-6-企业认证电子资料档案', 4, 1, 2, @f_______________2______, NOW(), NOW(), '关务');
        SET @f_______________2_______2_6___________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________2_______2_6___________, @f_______________2_______2_6___________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________2_______2_6___________, distance + 1 FROM folder_closure WHERE descendant = @f_______________2______;
    END IF;

    SET @f_______________3_____ = (SELECT id FROM folders WHERE name = '3-信息系统' AND parent_id = 510 AND standard_id = 3 LIMIT 1);
    IF @f_______________3_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-信息系统', 3, 1, 2, 510, NOW(), NOW(), '行政');
        SET @f_______________3_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________3_____, @f_______________3_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________3_____, distance + 1 FROM folder_closure WHERE descendant = 510;
    END IF;

    SET @f_______________3______3_7_______ = (SELECT id FROM folders WHERE name = '3-7-信息系统说明' AND parent_id = @f_______________3_____ AND standard_id = 3 LIMIT 1);
    IF @f_______________3______3_7_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-7-信息系统说明', 3, 1, 2, @f_______________3_____, NOW(), NOW(), '行政');
        SET @f_______________3______3_7_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________3______3_7_______, @f_______________3______3_7_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________3______3_7_______, distance + 1 FROM folder_closure WHERE descendant = @f_______________3_____;
    END IF;

    SET @f_______________3_____ = (SELECT id FROM folders WHERE name = '3-信息系统' AND parent_id = 510 AND standard_id = 3 LIMIT 1);
    IF @f_______________3_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-信息系统', 3, 1, 2, 510, NOW(), NOW(), '行政');
        SET @f_______________3_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________3_____, @f_______________3_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________3_____, distance + 1 FROM folder_closure WHERE descendant = 510;
    END IF;

    SET @f_______________3______3_8________ = (SELECT id FROM folders WHERE name = '3-8-系统数据的保管' AND parent_id = @f_______________3_____ AND standard_id = 3 LIMIT 1);
    IF @f_______________3______3_8________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-8-系统数据的保管', 3, 1, 2, @f_______________3_____, NOW(), NOW(), '行政');
        SET @f_______________3______3_8________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________3______3_8________, @f_______________3______3_8________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________3______3_8________, distance + 1 FROM folder_closure WHERE descendant = @f_______________3_____;
    END IF;

    SET @f_______________3_____ = (SELECT id FROM folders WHERE name = '3-信息系统' AND parent_id = 510 AND standard_id = 3 LIMIT 1);
    IF @f_______________3_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-信息系统', 3, 1, 2, 510, NOW(), NOW(), '行政');
        SET @f_______________3_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________3_____, @f_______________3_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________3_____, distance + 1 FROM folder_closure WHERE descendant = 510;
    END IF;

    SET @f_______________3______3_9_________ = (SELECT id FROM folders WHERE name = '3-9-信息安全管理制度' AND parent_id = @f_______________3_____ AND standard_id = 3 LIMIT 1);
    IF @f_______________3______3_9_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-9-信息安全管理制度', 3, 1, 2, @f_______________3_____, NOW(), NOW(), '行政');
        SET @f_______________3______3_9_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________3______3_9_________, @f_______________3______3_9_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________3______3_9_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________3_____;
    END IF;

    SET @f_______________4________ = (SELECT id FROM folders WHERE name = '4-内部审计和改进' AND parent_id = 515 AND standard_id = 5 LIMIT 1);
    IF @f_______________4________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-内部审计和改进', 5, 1, 2, 515, NOW(), NOW(), '审计部');
        SET @f_______________4________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________4________, @f_______________4________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________4________, distance + 1 FROM folder_closure WHERE descendant = 515;
    END IF;

    SET @f_______________4_________4_10_______ = (SELECT id FROM folders WHERE name = '4-10-内部审计制度' AND parent_id = @f_______________4________ AND standard_id = 5 LIMIT 1);
    IF @f_______________4_________4_10_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-10-内部审计制度', 5, 1, 2, @f_______________4________, NOW(), NOW(), '审计部');
        SET @f_______________4_________4_10_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________4_________4_10_______, @f_______________4_________4_10_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________4_________4_10_______, distance + 1 FROM folder_closure WHERE descendant = @f_______________4________;
    END IF;

    SET @f_______________4________ = (SELECT id FROM folders WHERE name = '4-内部审计和改进' AND parent_id = 515 AND standard_id = 5 LIMIT 1);
    IF @f_______________4________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-内部审计和改进', 5, 1, 2, 515, NOW(), NOW(), '审计部');
        SET @f_______________4________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________4________, @f_______________4________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________4________, distance + 1 FROM folder_closure WHERE descendant = 515;
    END IF;

    SET @f_______________4_________4_11_______ = (SELECT id FROM folders WHERE name = '4-11-内审记录报告' AND parent_id = @f_______________4________ AND standard_id = 5 LIMIT 1);
    IF @f_______________4_________4_11_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-11-内审记录报告', 5, 1, 2, @f_______________4________, NOW(), NOW(), '审计部');
        SET @f_______________4_________4_11_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________4_________4_11_______, @f_______________4_________4_11_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________4_________4_11_______, distance + 1 FROM folder_closure WHERE descendant = @f_______________4________;
    END IF;

    SET @f_______________4________ = (SELECT id FROM folders WHERE name = '4-内部审计和改进' AND parent_id = 515 AND standard_id = 5 LIMIT 1);
    IF @f_______________4________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-内部审计和改进', 5, 1, 2, 515, NOW(), NOW(), '审计部');
        SET @f_______________4________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________4________, @f_______________4________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________4________, distance + 1 FROM folder_closure WHERE descendant = 515;
    END IF;

    SET @f_______________4_________4_12__________ = (SELECT id FROM folders WHERE name = '4-12-改进和责任追究机制' AND parent_id = @f_______________4________ AND standard_id = 5 LIMIT 1);
    IF @f_______________4_________4_12__________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-12-改进和责任追究机制', 5, 1, 2, @f_______________4________, NOW(), NOW(), '审计部');
        SET @f_______________4_________4_12__________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________4_________4_12__________, @f_______________4_________4_12__________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________4_________4_12__________, distance + 1 FROM folder_closure WHERE descendant = @f_______________4________;
    END IF;

    SET @f_______________6_______ = (SELECT id FROM folders WHERE name = '6-遵守法律法规' AND parent_id = 520 AND standard_id = 5 LIMIT 1);
    IF @f_______________6_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('6-遵守法律法规', 5, 1, 2, 520, NOW(), NOW(), '审计部');
        SET @f_______________6_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________6_______, @f_______________6_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________6_______, distance + 1 FROM folder_closure WHERE descendant = 520;
    END IF;

    SET @f_______________6________6_15_1____________ = (SELECT id FROM folders WHERE name = '6-15-1-无犯罪记录管理层声明书' AND parent_id = @f_______________6_______ AND standard_id = 5 LIMIT 1);
    IF @f_______________6________6_15_1____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('6-15-1-无犯罪记录管理层声明书', 5, 1, 2, @f_______________6_______, NOW(), NOW(), '审计部');
        SET @f_______________6________6_15_1____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________6________6_15_1____________, @f_______________6________6_15_1____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________6________6_15_1____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________6_______;
    END IF;

    SET @f_______________6_______ = (SELECT id FROM folders WHERE name = '6-遵守法律法规' AND parent_id = 520 AND standard_id = 5 LIMIT 1);
    IF @f_______________6_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('6-遵守法律法规', 5, 1, 2, 520, NOW(), NOW(), '审计部');
        SET @f_______________6_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________6_______, @f_______________6_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________6_______, distance + 1 FROM folder_closure WHERE descendant = 520;
    END IF;

    SET @f_______________6________6_16_17_18 = (SELECT id FROM folders WHERE name = '6-16&17&18' AND parent_id = @f_______________6_______ AND standard_id = 5 LIMIT 1);
    IF @f_______________6________6_16_17_18 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('6-16&17&18', 5, 1, 2, @f_______________6_______, NOW(), NOW(), '审计部');
        SET @f_______________6________6_16_17_18 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________6________6_16_17_18, @f_______________6________6_16_17_18, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________6________6_16_17_18, distance + 1 FROM folder_closure WHERE descendant = @f_______________6_______;
    END IF;

    SET @f_______________7______ = (SELECT id FROM folders WHERE name = '7-进出口记录' AND parent_id = 524 AND standard_id = 4 LIMIT 1);
    IF @f_______________7______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('7-进出口记录', 4, 1, 2, 524, NOW(), NOW(), '关务');
        SET @f_______________7______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________7______, @f_______________7______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________7______, distance + 1 FROM folder_closure WHERE descendant = 524;
    END IF;

    SET @f_______________7_______7_19_1_________ = (SELECT id FROM folders WHERE name = '7-19-1年内进出口活动证明' AND parent_id = @f_______________7______ AND standard_id = 4 LIMIT 1);
    IF @f_______________7_______7_19_1_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('7-19-1年内进出口活动证明', 4, 1, 2, @f_______________7______, NOW(), NOW(), '关务');
        SET @f_______________7_______7_19_1_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________7_______7_19_1_________, @f_______________7_______7_19_1_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________7_______7_19_1_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________7______;
    END IF;

    SET @f_______________5_____ = (SELECT id FROM folders WHERE name = '5-财务状况' AND parent_id = 527 AND standard_id = 1 LIMIT 1);
    IF @f_______________5_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('5-财务状况', 1, 1, 2, 527, NOW(), NOW(), '财务');
        SET @f_______________5_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________5_____, @f_______________5_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________5_____, distance + 1 FROM folder_closure WHERE descendant = 527;
    END IF;

    SET @f_______________5______5_13_____ = (SELECT id FROM folders WHERE name = '5-13-审计报告' AND parent_id = @f_______________5_____ AND standard_id = 1 LIMIT 1);
    IF @f_______________5______5_13_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('5-13-审计报告', 1, 1, 2, @f_______________5_____, NOW(), NOW(), '财务');
        SET @f_______________5______5_13_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________5______5_13_____, @f_______________5______5_13_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________5______5_13_____, distance + 1 FROM folder_closure WHERE descendant = @f_______________5_____;
    END IF;

    SET @f_______________5_____ = (SELECT id FROM folders WHERE name = '5-财务状况' AND parent_id = 527 AND standard_id = 1 LIMIT 1);
    IF @f_______________5_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('5-财务状况', 1, 1, 2, 527, NOW(), NOW(), '财务');
        SET @f_______________5_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________5_____, @f_______________5_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________5_____, distance + 1 FROM folder_closure WHERE descendant = 527;
    END IF;

    SET @f_______________5______5_14________ = (SELECT id FROM folders WHERE name = '5-14-资产负债率情况' AND parent_id = @f_______________5_____ AND standard_id = 1 LIMIT 1);
    IF @f_______________5______5_14________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('5-14-资产负债率情况', 1, 1, 2, @f_______________5_____, NOW(), NOW(), '财务');
        SET @f_______________5______5_14________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________5______5_14________, @f_______________5______5_14________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________5______5_14________, distance + 1 FROM folder_closure WHERE descendant = @f_______________5_____;
    END IF;

    SET @f_______________11_______ = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_______________11_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_______________11_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_______, @f_______________11_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_______, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_______________11________11_31___________ = (SELECT id FROM folders WHERE name = '11-31-经营场所安全管理制度' AND parent_id = @f_______________11_______ AND standard_id = 3 LIMIT 1);
    IF @f_______________11________11_31___________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-31-经营场所安全管理制度', 3, 1, 2, @f_______________11_______, NOW(), NOW(), '行政');
        SET @f_______________11________11_31___________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11________11_31___________, @f_______________11________11_31___________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11________11_31___________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_______;
    END IF;

    SET @f_______________11_______ = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_______________11_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_______________11_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_______, @f_______________11_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_______, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_______________11________11_32________ = (SELECT id FROM folders WHERE name = '11-32-经营场所建筑物' AND parent_id = @f_______________11_______ AND standard_id = 3 LIMIT 1);
    IF @f_______________11________11_32________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-32-经营场所建筑物', 3, 1, 2, @f_______________11_______, NOW(), NOW(), '行政');
        SET @f_______________11________11_32________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11________11_32________, @f_______________11________11_32________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11________11_32________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_______;
    END IF;

    SET @f_______________11_______ = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_______________11_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_______________11_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_______, @f_______________11_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_______, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_______________11________11_33__________ = (SELECT id FROM folders WHERE name = '11-33-锁闭装置及钥匙保管' AND parent_id = @f_______________11_______ AND standard_id = 3 LIMIT 1);
    IF @f_______________11________11_33__________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-33-锁闭装置及钥匙保管', 3, 1, 2, @f_______________11_______, NOW(), NOW(), '行政');
        SET @f_______________11________11_33__________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11________11_33__________, @f_______________11________11_33__________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11________11_33__________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_______;
    END IF;

    SET @f_______________11_______ = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_______________11_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_______________11_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_______, @f_______________11_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_______, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_______________11________11_34___ = (SELECT id FROM folders WHERE name = '11-34-照明' AND parent_id = @f_______________11_______ AND standard_id = 3 LIMIT 1);
    IF @f_______________11________11_34___ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-34-照明', 3, 1, 2, @f_______________11_______, NOW(), NOW(), '行政');
        SET @f_______________11________11_34___ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11________11_34___, @f_______________11________11_34___, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11________11_34___, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_______;
    END IF;

    SET @f_______________11_______ = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_______________11_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_______________11_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_______, @f_______________11_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_______, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_______________11________11_35__________ = (SELECT id FROM folders WHERE name = '11-35-车辆和人员进出管理' AND parent_id = @f_______________11_______ AND standard_id = 3 LIMIT 1);
    IF @f_______________11________11_35__________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-35-车辆和人员进出管理', 3, 1, 2, @f_______________11_______, NOW(), NOW(), '行政');
        SET @f_______________11________11_35__________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11________11_35__________, @f_______________11________11_35__________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11________11_35__________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_______;
    END IF;

    SET @f_______________11_______ = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_______________11_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_______________11_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_______, @f_______________11_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_______, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_______________11________11_36______________ = (SELECT id FROM folders WHERE name = '11-36-单证存放和仓储区域受控管理' AND parent_id = @f_______________11_______ AND standard_id = 3 LIMIT 1);
    IF @f_______________11________11_36______________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-36-单证存放和仓储区域受控管理', 3, 1, 2, @f_______________11_______, NOW(), NOW(), '行政');
        SET @f_______________11________11_36______________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11________11_36______________, @f_______________11________11_36______________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11________11_36______________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_______;
    END IF;

    SET @f_______________11_______ = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_______________11_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_______________11_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_______, @f_______________11_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_______, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_______________11________11_37___________ = (SELECT id FROM folders WHERE name = '11-37-重要敏感区域视频监控' AND parent_id = @f_______________11_______ AND standard_id = 3 LIMIT 1);
    IF @f_______________11________11_37___________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-37-重要敏感区域视频监控', 3, 1, 2, @f_______________11_______, NOW(), NOW(), '行政');
        SET @f_______________11________11_37___________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11________11_37___________, @f_______________11________11_37___________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11________11_37___________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11_______;
    END IF;

    SET @f_______________12_____ = (SELECT id FROM folders WHERE name = '12-人员安全' AND parent_id = 540 AND standard_id = 2 LIMIT 1);
    IF @f_______________12_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-人员安全', 2, 1, 2, 540, NOW(), NOW(), '人事');
        SET @f_______________12_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12_____, @f_______________12_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________12_____, distance + 1 FROM folder_closure WHERE descendant = 540;
    END IF;

    SET @f_______________12______12_38_________ = (SELECT id FROM folders WHERE name = '12-38-员工入职离职管理' AND parent_id = @f_______________12_____ AND standard_id = 2 LIMIT 1);
    IF @f_______________12______12_38_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-38-员工入职离职管理', 2, 1, 2, @f_______________12_____, NOW(), NOW(), '人事');
        SET @f_______________12______12_38_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12______12_38_________, @f_______________12______12_38_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________12______12_38_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________12_____;
    END IF;

    SET @f_______________12_____ = (SELECT id FROM folders WHERE name = '12-人员安全' AND parent_id = 540 AND standard_id = 2 LIMIT 1);
    IF @f_______________12_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-人员安全', 2, 1, 2, 540, NOW(), NOW(), '人事');
        SET @f_______________12_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12_____, @f_______________12_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________12_____, distance + 1 FROM folder_closure WHERE descendant = 540;
    END IF;

    SET @f_______________12______12_39_____________ = (SELECT id FROM folders WHERE name = '12-39-新员工&安全敏感岗位背调' AND parent_id = @f_______________12_____ AND standard_id = 2 LIMIT 1);
    IF @f_______________12______12_39_____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-39-新员工&安全敏感岗位背调', 2, 1, 2, @f_______________12_____, NOW(), NOW(), '人事');
        SET @f_______________12______12_39_____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12______12_39_____________, @f_______________12______12_39_____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________12______12_39_____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________12_____;
    END IF;

    SET @f_______________12_____ = (SELECT id FROM folders WHERE name = '12-人员安全' AND parent_id = 540 AND standard_id = 2 LIMIT 1);
    IF @f_______________12_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-人员安全', 2, 1, 2, 540, NOW(), NOW(), '人事');
        SET @f_______________12_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12_____, @f_______________12_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________12_____, distance + 1 FROM folder_closure WHERE descendant = 540;
    END IF;

    SET @f_______________12______12_40________________ = (SELECT id FROM folders WHERE name = '12-40-员工身份识别和离职员工取消授权' AND parent_id = @f_______________12_____ AND standard_id = 2 LIMIT 1);
    IF @f_______________12______12_40________________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-40-员工身份识别和离职员工取消授权', 2, 1, 2, @f_______________12_____, NOW(), NOW(), '人事');
        SET @f_______________12______12_40________________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12______12_40________________, @f_______________12______12_40________________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________12______12_40________________, distance + 1 FROM folder_closure WHERE descendant = @f_______________12_____;
    END IF;

    SET @f_______________12_____ = (SELECT id FROM folders WHERE name = '12-人员安全' AND parent_id = 540 AND standard_id = 2 LIMIT 1);
    IF @f_______________12_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-人员安全', 2, 1, 2, 540, NOW(), NOW(), '人事');
        SET @f_______________12_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12_____, @f_______________12_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________12_____, distance + 1 FROM folder_closure WHERE descendant = 540;
    END IF;

    SET @f_______________12______12_41_________ = (SELECT id FROM folders WHERE name = '12-41-访客进出登记管理' AND parent_id = @f_______________12_____ AND standard_id = 2 LIMIT 1);
    IF @f_______________12______12_41_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-41-访客进出登记管理', 2, 1, 2, @f_______________12_____, NOW(), NOW(), '人事');
        SET @f_______________12______12_41_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12______12_41_________, @f_______________12______12_41_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________12______12_41_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________12_____;
    END IF;

    SET @f_______________13________ = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_______________13________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_______________13________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13________, @f_______________13________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13________, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_______________13_________13_42____________ = (SELECT id FROM folders WHERE name = '13-42-货物-物品安全管理制度' AND parent_id = @f_______________13________ AND standard_id = 5 LIMIT 1);
    IF @f_______________13_________13_42____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-42-货物-物品安全管理制度', 5, 1, 2, @f_______________13________, NOW(), NOW(), '审计部');
        SET @f_______________13_________13_42____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13_________13_42____________, @f_______________13_________13_42____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13_________13_42____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________13________;
    END IF;

    SET @f_______________13________ = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_______________13________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_______________13________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13________, @f_______________13________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13________, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_______________13_________13_43_________ = (SELECT id FROM folders WHERE name = '13-43-集装箱七点检查法' AND parent_id = @f_______________13________ AND standard_id = 5 LIMIT 1);
    IF @f_______________13_________13_43_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-43-集装箱七点检查法', 5, 1, 2, @f_______________13________, NOW(), NOW(), '审计部');
        SET @f_______________13_________13_43_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13_________13_43_________, @f_______________13_________13_43_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13_________13_43_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________13________;
    END IF;

    SET @f_______________13________ = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_______________13________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_______________13________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13________, @f_______________13________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13________, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_______________13_________13_44______ = (SELECT id FROM folders WHERE name = '13-44-集装箱封条' AND parent_id = @f_______________13________ AND standard_id = 5 LIMIT 1);
    IF @f_______________13_________13_44______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-44-集装箱封条', 5, 1, 2, @f_______________13________, NOW(), NOW(), '审计部');
        SET @f_______________13_________13_44______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13_________13_44______, @f_______________13_________13_44______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13_________13_44______, distance + 1 FROM folder_closure WHERE descendant = @f_______________13________;
    END IF;

    SET @f_______________13________ = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_______________13________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_______________13________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13________, @f_______________13________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13________, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_______________13_________13_45________ = (SELECT id FROM folders WHERE name = '13-45-集装箱存储制度' AND parent_id = @f_______________13________ AND standard_id = 5 LIMIT 1);
    IF @f_______________13_________13_45________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-45-集装箱存储制度', 5, 1, 2, @f_______________13________, NOW(), NOW(), '审计部');
        SET @f_______________13_________13_45________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13_________13_45________, @f_______________13_________13_45________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13_________13_45________, distance + 1 FROM folder_closure WHERE descendant = @f_______________13________;
    END IF;

    SET @f_______________13________ = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_______________13________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_______________13________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13________, @f_______________13________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13________, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_______________13_________13_46_______ = (SELECT id FROM folders WHERE name = '13-46-司机身份核实' AND parent_id = @f_______________13________ AND standard_id = 5 LIMIT 1);
    IF @f_______________13_________13_46_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-46-司机身份核实', 5, 1, 2, @f_______________13________, NOW(), NOW(), '审计部');
        SET @f_______________13_________13_46_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13_________13_46_______, @f_______________13_________13_46_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13_________13_46_______, distance + 1 FROM folder_closure WHERE descendant = @f_______________13________;
    END IF;

    SET @f_______________13________ = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 553 AND standard_id = 4 LIMIT 1);
    IF @f_______________13________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 4, 1, 2, 553, NOW(), NOW(), '关务');
        SET @f_______________13________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13________, @f_______________13________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13________, distance + 1 FROM folder_closure WHERE descendant = 553;
    END IF;

    SET @f_______________13_________13_47__________ = (SELECT id FROM folders WHERE name = '13-47-装运和接收货物物品' AND parent_id = @f_______________13________ AND standard_id = 4 LIMIT 1);
    IF @f_______________13_________13_47__________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-47-装运和接收货物物品', 4, 1, 2, @f_______________13________, NOW(), NOW(), '关务');
        SET @f_______________13_________13_47__________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13_________13_47__________, @f_______________13_________13_47__________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13_________13_47__________, distance + 1 FROM folder_closure WHERE descendant = @f_______________13________;
    END IF;

    SET @f_______________13________ = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_______________13________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_______________13________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13________, @f_______________13________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13________, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_______________13_________13_48_____________ = (SELECT id FROM folders WHERE name = '13-48-货物-物品差异及报告程序' AND parent_id = @f_______________13________ AND standard_id = 5 LIMIT 1);
    IF @f_______________13_________13_48_____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-48-货物-物品差异及报告程序', 5, 1, 2, @f_______________13________, NOW(), NOW(), '审计部');
        SET @f_______________13_________13_48_____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13_________13_48_____________, @f_______________13_________13_48_____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13_________13_48_____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________13________;
    END IF;

    SET @f_______________13________ = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_______________13________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_______________13________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13________, @f_______________13________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13________, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_______________13_________13_49_______ = (SELECT id FROM folders WHERE name = '13-49-出口安全制度' AND parent_id = @f_______________13________ AND standard_id = 5 LIMIT 1);
    IF @f_______________13_________13_49_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-49-出口安全制度', 5, 1, 2, @f_______________13________, NOW(), NOW(), '审计部');
        SET @f_______________13_________13_49_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13_________13_49_______, @f_______________13_________13_49_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13_________13_49_______, distance + 1 FROM folder_closure WHERE descendant = @f_______________13________;
    END IF;

    SET @f_______________14_______ = (SELECT id FROM folders WHERE name = '14-运输工具安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_______________14_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-运输工具安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_______________14_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________14_______, @f_______________14_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________14_______, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_______________14________14_50___________ = (SELECT id FROM folders WHERE name = '14-50-运输工具安全管理制度' AND parent_id = @f_______________14_______ AND standard_id = 3 LIMIT 1);
    IF @f_______________14________14_50___________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-50-运输工具安全管理制度', 3, 1, 2, @f_______________14_______, NOW(), NOW(), '行政');
        SET @f_______________14________14_50___________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________14________14_50___________, @f_______________14________14_50___________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________14________14_50___________, distance + 1 FROM folder_closure WHERE descendant = @f_______________14_______;
    END IF;

    SET @f_______________14_______ = (SELECT id FROM folders WHERE name = '14-运输工具安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_______________14_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-运输工具安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_______________14_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________14_______, @f_______________14_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________14_______, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_______________14________14_51_______ = (SELECT id FROM folders WHERE name = '14-51-运输工具检查' AND parent_id = @f_______________14_______ AND standard_id = 3 LIMIT 1);
    IF @f_______________14________14_51_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-51-运输工具检查', 3, 1, 2, @f_______________14_______, NOW(), NOW(), '行政');
        SET @f_______________14________14_51_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________14________14_51_______, @f_______________14________14_51_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________14________14_51_______, distance + 1 FROM folder_closure WHERE descendant = @f_______________14_______;
    END IF;

    SET @f_______________14_______ = (SELECT id FROM folders WHERE name = '14-运输工具安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_______________14_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-运输工具安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_______________14_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________14_______, @f_______________14_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________14_______, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_______________14________14_52_________ = (SELECT id FROM folders WHERE name = '14-52-运输工具存储制度' AND parent_id = @f_______________14_______ AND standard_id = 3 LIMIT 1);
    IF @f_______________14________14_52_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-52-运输工具存储制度', 3, 1, 2, @f_______________14_______, NOW(), NOW(), '行政');
        SET @f_______________14________14_52_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________14________14_52_________, @f_______________14________14_52_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________14________14_52_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________14_______;
    END IF;

    SET @f_______________14_______ = (SELECT id FROM folders WHERE name = '14-运输工具安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_______________14_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-运输工具安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_______________14_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________14_______, @f_______________14_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________14_______, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_______________14________14_53_____ = (SELECT id FROM folders WHERE name = '14-53-安全培训' AND parent_id = @f_______________14_______ AND standard_id = 3 LIMIT 1);
    IF @f_______________14________14_53_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-53-安全培训', 3, 1, 2, @f_______________14_______, NOW(), NOW(), '行政');
        SET @f_______________14________14_53_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________14________14_53_____, @f_______________14________14_53_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________14________14_53_____, distance + 1 FROM folder_closure WHERE descendant = @f_______________14_______;
    END IF;

    SET @f_______________15_______ = (SELECT id FROM folders WHERE name = '15-商业伙伴安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_______________15_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-商业伙伴安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_______________15_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________15_______, @f_______________15_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________15_______, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_______________15________15_54___________ = (SELECT id FROM folders WHERE name = '15-54-商业伙伴安全管理制度' AND parent_id = @f_______________15_______ AND standard_id = 5 LIMIT 1);
    IF @f_______________15________15_54___________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-54-商业伙伴安全管理制度', 5, 1, 2, @f_______________15_______, NOW(), NOW(), '审计部');
        SET @f_______________15________15_54___________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________15________15_54___________, @f_______________15________15_54___________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________15________15_54___________, distance + 1 FROM folder_closure WHERE descendant = @f_______________15_______;
    END IF;

    SET @f_______________15_______ = (SELECT id FROM folders WHERE name = '15-商业伙伴安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_______________15_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-商业伙伴安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_______________15_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________15_______, @f_______________15_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________15_______, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_______________15________15_55_____ = (SELECT id FROM folders WHERE name = '15-55-全面评估' AND parent_id = @f_______________15_______ AND standard_id = 5 LIMIT 1);
    IF @f_______________15________15_55_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-55-全面评估', 5, 1, 2, @f_______________15_______, NOW(), NOW(), '审计部');
        SET @f_______________15________15_55_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________15________15_55_____, @f_______________15________15_55_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________15________15_55_____, distance + 1 FROM folder_closure WHERE descendant = @f_______________15_______;
    END IF;

    SET @f_______________15_______ = (SELECT id FROM folders WHERE name = '15-商业伙伴安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_______________15_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-商业伙伴安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_______________15_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________15_______, @f_______________15_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________15_______, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_______________15________15_56_____________ = (SELECT id FROM folders WHERE name = '15-56-优化贸易安全管理书面文件' AND parent_id = @f_______________15_______ AND standard_id = 5 LIMIT 1);
    IF @f_______________15________15_56_____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-56-优化贸易安全管理书面文件', 5, 1, 2, @f_______________15_______, NOW(), NOW(), '审计部');
        SET @f_______________15________15_56_____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________15________15_56_____________, @f_______________15________15_56_____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________15________15_56_____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________15_______;
    END IF;

    SET @f_______________15_______ = (SELECT id FROM folders WHERE name = '15-商业伙伴安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_______________15_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-商业伙伴安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_______________15_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________15_______, @f_______________15_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________15_______, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_______________15________15_57_____ = (SELECT id FROM folders WHERE name = '15-57-监控检查' AND parent_id = @f_______________15_______ AND standard_id = 5 LIMIT 1);
    IF @f_______________15________15_57_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-57-监控检查', 5, 1, 2, @f_______________15_______, NOW(), NOW(), '审计部');
        SET @f_______________15________15_57_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________15________15_57_____, @f_______________15________15_57_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________15________15_57_____, distance + 1 FROM folder_closure WHERE descendant = @f_______________15_______;
    END IF;

    SET @f_______________16____________ = (SELECT id FROM folders WHERE name = '16-海关业务和贸易安全培训' AND parent_id = 553 AND standard_id = 4 LIMIT 1);
    IF @f_______________16____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-海关业务和贸易安全培训', 4, 1, 2, 553, NOW(), NOW(), '关务');
        SET @f_______________16____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________16____________, @f_______________16____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________16____________, distance + 1 FROM folder_closure WHERE descendant = 553;
    END IF;

    SET @f_______________16_____________16_58________________ = (SELECT id FROM folders WHERE name = '16-58-法律法规和贸易安全内部培训制度' AND parent_id = @f_______________16____________ AND standard_id = 4 LIMIT 1);
    IF @f_______________16_____________16_58________________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-58-法律法规和贸易安全内部培训制度', 4, 1, 2, @f_______________16____________, NOW(), NOW(), '关务');
        SET @f_______________16_____________16_58________________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________16_____________16_58________________, @f_______________16_____________16_58________________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________16_____________16_58________________, distance + 1 FROM folder_closure WHERE descendant = @f_______________16____________;
    END IF;

    SET @f_______________16____________ = (SELECT id FROM folders WHERE name = '16-海关业务和贸易安全培训' AND parent_id = 553 AND standard_id = 4 LIMIT 1);
    IF @f_______________16____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-海关业务和贸易安全培训', 4, 1, 2, 553, NOW(), NOW(), '关务');
        SET @f_______________16____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________16____________, @f_______________16____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________16____________, distance + 1 FROM folder_closure WHERE descendant = 553;
    END IF;

    SET @f_______________16_____________16_59_________ = (SELECT id FROM folders WHERE name = '16-59-海关法律法规培训' AND parent_id = @f_______________16____________ AND standard_id = 4 LIMIT 1);
    IF @f_______________16_____________16_59_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-59-海关法律法规培训', 4, 1, 2, @f_______________16____________, NOW(), NOW(), '关务');
        SET @f_______________16_____________16_59_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________16_____________16_59_________, @f_______________16_____________16_59_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________16_____________16_59_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________16____________;
    END IF;

    SET @f_______________16____________ = (SELECT id FROM folders WHERE name = '16-海关业务和贸易安全培训' AND parent_id = 553 AND standard_id = 4 LIMIT 1);
    IF @f_______________16____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-海关业务和贸易安全培训', 4, 1, 2, 553, NOW(), NOW(), '关务');
        SET @f_______________16____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________16____________, @f_______________16____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________16____________, distance + 1 FROM folder_closure WHERE descendant = 553;
    END IF;

    SET @f_______________16_____________16_60_______ = (SELECT id FROM folders WHERE name = '16-60-货物安全培训' AND parent_id = @f_______________16____________ AND standard_id = 4 LIMIT 1);
    IF @f_______________16_____________16_60_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-60-货物安全培训', 4, 1, 2, @f_______________16____________, NOW(), NOW(), '关务');
        SET @f_______________16_____________16_60_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________16_____________16_60_______, @f_______________16_____________16_60_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________16_____________16_60_______, distance + 1 FROM folder_closure WHERE descendant = @f_______________16____________;
    END IF;

    SET @f_______________16____________ = (SELECT id FROM folders WHERE name = '16-海关业务和贸易安全培训' AND parent_id = 553 AND standard_id = 4 LIMIT 1);
    IF @f_______________16____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-海关业务和贸易安全培训', 4, 1, 2, 553, NOW(), NOW(), '关务');
        SET @f_______________16____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________16____________, @f_______________16____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________16____________, distance + 1 FROM folder_closure WHERE descendant = 553;
    END IF;

    SET @f_______________16_____________16_61_______ = (SELECT id FROM folders WHERE name = '16-61-危机管理培训' AND parent_id = @f_______________16____________ AND standard_id = 4 LIMIT 1);
    IF @f_______________16_____________16_61_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-61-危机管理培训', 4, 1, 2, @f_______________16____________, NOW(), NOW(), '关务');
        SET @f_______________16_____________16_61_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________16_____________16_61_______, @f_______________16_____________16_61_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________16_____________16_61_______, distance + 1 FROM folder_closure WHERE descendant = @f_______________16____________;
    END IF;

    SET @f_______________16____________ = (SELECT id FROM folders WHERE name = '16-海关业务和贸易安全培训' AND parent_id = 553 AND standard_id = 4 LIMIT 1);
    IF @f_______________16____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-海关业务和贸易安全培训', 4, 1, 2, 553, NOW(), NOW(), '关务');
        SET @f_______________16____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________16____________, @f_______________16____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________16____________, distance + 1 FROM folder_closure WHERE descendant = 553;
    END IF;

    SET @f_______________16_____________16_62_______ = (SELECT id FROM folders WHERE name = '16-62-信息安全培训' AND parent_id = @f_______________16____________ AND standard_id = 4 LIMIT 1);
    IF @f_______________16_____________16_62_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-62-信息安全培训', 4, 1, 2, @f_______________16____________, NOW(), NOW(), '关务');
        SET @f_______________16_____________16_62_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________16_____________16_62_______, @f_______________16_____________16_62_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________16_____________16_62_______, distance + 1 FROM folder_closure WHERE descendant = @f_______________16____________;
    END IF;

    SET @f________________4________ = (SELECT id FROM folders WHERE name = '4-商检制度与台账' AND parent_id = 266 AND standard_id = 6 LIMIT 1);
    IF @f________________4________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-商检制度与台账', 6, 1, 2, 266, NOW(), NOW(), '单项标准');
        SET @f________________4________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4________, @f________________4________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f________________4________, distance + 1 FROM folder_closure WHERE descendant = 266;
    END IF;

    SET @f________________4_________4_4_1_____ = (SELECT id FROM folders WHERE name = '4-4-1-管理制度' AND parent_id = @f________________4________ AND standard_id = 6 LIMIT 1);
    IF @f________________4_________4_4_1_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-4-1-管理制度', 6, 1, 2, @f________________4________, NOW(), NOW(), '单项标准');
        SET @f________________4_________4_4_1_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4_________4_4_1_____, @f________________4_________4_4_1_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f________________4_________4_4_1_____, distance + 1 FROM folder_closure WHERE descendant = @f________________4________;
    END IF;

    SET @f________________4________ = (SELECT id FROM folders WHERE name = '4-商检制度与台账' AND parent_id = 266 AND standard_id = 6 LIMIT 1);
    IF @f________________4________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-商检制度与台账', 6, 1, 2, 266, NOW(), NOW(), '单项标准');
        SET @f________________4________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4________, @f________________4________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f________________4________, distance + 1 FROM folder_closure WHERE descendant = 266;
    END IF;

    SET @f________________4_________4_4_3_____ = (SELECT id FROM folders WHERE name = '4-4-3-抽查单证' AND parent_id = @f________________4________ AND standard_id = 6 LIMIT 1);
    IF @f________________4_________4_4_3_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-4-3-抽查单证', 6, 1, 2, @f________________4________, NOW(), NOW(), '单项标准');
        SET @f________________4_________4_4_3_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4_________4_4_3_____, @f________________4_________4_4_3_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f________________4_________4_4_3_____, distance + 1 FROM folder_closure WHERE descendant = @f________________4________;
    END IF;

    SET @f________________4________ = (SELECT id FROM folders WHERE name = '4-商检制度与台账' AND parent_id = 266 AND standard_id = 6 LIMIT 1);
    IF @f________________4________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-商检制度与台账', 6, 1, 2, 266, NOW(), NOW(), '单项标准');
        SET @f________________4________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4________, @f________________4________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f________________4________, distance + 1 FROM folder_closure WHERE descendant = 266;
    END IF;

    SET @f________________4_________4_4_4______ = (SELECT id FROM folders WHERE name = '4-4-4-熏蒸板记录' AND parent_id = @f________________4________ AND standard_id = 6 LIMIT 1);
    IF @f________________4_________4_4_4______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-4-4-熏蒸板记录', 6, 1, 2, @f________________4________, NOW(), NOW(), '单项标准');
        SET @f________________4_________4_4_4______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4_________4_4_4______, @f________________4_________4_4_4______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f________________4_________4_4_4______, distance + 1 FROM folder_closure WHERE descendant = @f________________4________;
    END IF;

    SET @f_______________2_______ = (SELECT id FROM folders WHERE name = '2-特殊物品单证' AND parent_id = 265 AND standard_id = 6 LIMIT 1);
    IF @f_______________2_______ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-特殊物品单证', 6, 1, 2, 265, NOW(), NOW(), '单项标准');
        SET @f_______________2_______ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________2_______, @f_______________2_______, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________2_______, distance + 1 FROM folder_closure WHERE descendant = 265;
    END IF;

    SET @f______________________1____________ = (SELECT id FROM folders WHERE name = '1-单证复核及系统逻辑检验' AND parent_id = 264 AND standard_id = 6 LIMIT 1);
    IF @f______________________1____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-单证复核及系统逻辑检验', 6, 1, 2, 264, NOW(), NOW(), '单项标准');
        SET @f______________________1____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f______________________1____________, @f______________________1____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f______________________1____________, distance + 1 FROM folder_closure WHERE descendant = 264;
    END IF;

    SET @f________________4________ = (SELECT id FROM folders WHERE name = '4-商检制度与台账' AND parent_id = 266 AND standard_id = 6 LIMIT 1);
    IF @f________________4________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-商检制度与台账', 6, 1, 2, 266, NOW(), NOW(), '单项标准');
        SET @f________________4________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4________, @f________________4________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f________________4________, distance + 1 FROM folder_closure WHERE descendant = 266;
    END IF;

    SET @f________________4_________4_4_2___________ = (SELECT id FROM folders WHERE name = '4-4-2-进境商检查验管理台账' AND parent_id = @f________________4________ AND standard_id = 6 LIMIT 1);
    IF @f________________4_________4_4_2___________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-4-2-进境商检查验管理台账', 6, 1, 2, @f________________4________, NOW(), NOW(), '单项标准');
        SET @f________________4_________4_4_2___________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________4_________4_4_2___________, @f________________4_________4_4_2___________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f________________4_________4_4_2___________, distance + 1 FROM folder_closure WHERE descendant = @f________________4________;
    END IF;

    SET @f__________________9_____ = (SELECT id FROM folders WHERE name = '9-法检制度' AND parent_id = 267 AND standard_id = 6 LIMIT 1);
    IF @f__________________9_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('9-法检制度', 6, 1, 2, 267, NOW(), NOW(), '单项标准');
        SET @f__________________9_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f__________________9_____, @f__________________9_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f__________________9_____, distance + 1 FROM folder_closure WHERE descendant = 267;
    END IF;

    SET @f_______________________ = (SELECT id FROM folders WHERE name = '运输工具管理制度' AND parent_id = 268 AND standard_id = 6 LIMIT 1);
    IF @f_______________________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('运输工具管理制度', 6, 1, 2, 268, NOW(), NOW(), '单项标准');
        SET @f_______________________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________________, @f_______________________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________________, distance + 1 FROM folder_closure WHERE descendant = 268;
    END IF;

    SET @f_______________________ = (SELECT id FROM folders WHERE name = '运输工具行驶轨迹' AND parent_id = 268 AND standard_id = 6 LIMIT 1);
    IF @f_______________________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('运输工具行驶轨迹', 6, 1, 2, 268, NOW(), NOW(), '单项标准');
        SET @f_______________________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________________, @f_______________________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________________, distance + 1 FROM folder_closure WHERE descendant = 268;
    END IF;

    SET @f________________________21_1_____________ = (SELECT id FROM folders WHERE name = '21-1-定位系统车载终端管理制度' AND parent_id = @f_______________________ AND standard_id = 6 LIMIT 1);
    IF @f________________________21_1_____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('21-1-定位系统车载终端管理制度', 6, 1, 2, @f_______________________, NOW(), NOW(), '单项标准');
        SET @f________________________21_1_____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________________21_1_____________, @f________________________21_1_____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f________________________21_1_____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________________;
    END IF;

    SET @f_______________________ = (SELECT id FROM folders WHERE name = '运输工具行驶轨迹' AND parent_id = 268 AND standard_id = 6 LIMIT 1);
    IF @f_______________________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('运输工具行驶轨迹', 6, 1, 2, 268, NOW(), NOW(), '单项标准');
        SET @f_______________________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________________, @f_______________________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________________, distance + 1 FROM folder_closure WHERE descendant = 268;
    END IF;

    SET @f________________________21_2___________ = (SELECT id FROM folders WHERE name = '21-2-车辆行驶轨迹监控记录' AND parent_id = @f_______________________ AND standard_id = 6 LIMIT 1);
    IF @f________________________21_2___________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('21-2-车辆行驶轨迹监控记录', 6, 1, 2, @f_______________________, NOW(), NOW(), '单项标准');
        SET @f________________________21_2___________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f________________________21_2___________, @f________________________21_2___________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f________________________21_2___________, distance + 1 FROM folder_closure WHERE descendant = @f_______________________;
    END IF;

    SET @f____________________________ = (SELECT id FROM folders WHERE name = '运输工具与驾驶人员匹配制度' AND parent_id = 268 AND standard_id = 6 LIMIT 1);
    IF @f____________________________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('运输工具与驾驶人员匹配制度', 6, 1, 2, 268, NOW(), NOW(), '单项标准');
        SET @f____________________________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f____________________________, @f____________________________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f____________________________, distance + 1 FROM folder_closure WHERE descendant = 268;
    END IF;

    SET @f_____________________________22_1________________ = (SELECT id FROM folders WHERE name = '22-1-运输工具与驾驶人员匹配管理制度' AND parent_id = @f____________________________ AND standard_id = 6 LIMIT 1);
    IF @f_____________________________22_1________________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('22-1-运输工具与驾驶人员匹配管理制度', 6, 1, 2, @f____________________________, NOW(), NOW(), '单项标准');
        SET @f_____________________________22_1________________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_____________________________22_1________________, @f_____________________________22_1________________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_____________________________22_1________________, distance + 1 FROM folder_closure WHERE descendant = @f____________________________;
    END IF;

    SET @f____________________________ = (SELECT id FROM folders WHERE name = '运输工具与驾驶人员匹配制度' AND parent_id = 268 AND standard_id = 6 LIMIT 1);
    IF @f____________________________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('运输工具与驾驶人员匹配制度', 6, 1, 2, 268, NOW(), NOW(), '单项标准');
        SET @f____________________________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f____________________________, @f____________________________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f____________________________, distance + 1 FROM folder_closure WHERE descendant = 268;
    END IF;

    SET @f_____________________________22_2_____ = (SELECT id FROM folders WHERE name = '22-2-台账记录' AND parent_id = @f____________________________ AND standard_id = 6 LIMIT 1);
    IF @f_____________________________22_2_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('22-2-台账记录', 6, 1, 2, @f____________________________, NOW(), NOW(), '单项标准');
        SET @f_____________________________22_2_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_____________________________22_2_____, @f_____________________________22_2_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_____________________________22_2_____, distance + 1 FROM folder_closure WHERE descendant = @f____________________________;
    END IF;

    SET @f_______________11____________ = (SELECT id FROM folders WHERE name = '11-单证复核及系统逻辑检验' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_______________11____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-单证复核及系统逻辑检验', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_______________11____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11____________, @f_______________11____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11____________, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_______________11_____________1_1_____________ = (SELECT id FROM folders WHERE name = '1-1-进出口单证及复核制度文件' AND parent_id = @f_______________11____________ AND standard_id = 6 LIMIT 1);
    IF @f_______________11_____________1_1_____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-1-进出口单证及复核制度文件', 6, 1, 2, @f_______________11____________, NOW(), NOW(), '单项标准');
        SET @f_______________11_____________1_1_____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_____________1_1_____________, @f_______________11_____________1_1_____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_____________1_1_____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11____________;
    END IF;

    SET @f_______________11____________ = (SELECT id FROM folders WHERE name = '11-单证复核及系统逻辑检验' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_______________11____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-单证复核及系统逻辑检验', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_______________11____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11____________, @f_______________11____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11____________, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_______________11_____________1_2_________ = (SELECT id FROM folders WHERE name = '1-2-系统复审界面截屏' AND parent_id = @f_______________11____________ AND standard_id = 6 LIMIT 1);
    IF @f_______________11_____________1_2_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-2-系统复审界面截屏', 6, 1, 2, @f_______________11____________, NOW(), NOW(), '单项标准');
        SET @f_______________11_____________1_2_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_____________1_2_________, @f_______________11_____________1_2_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_____________1_2_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11____________;
    END IF;

    SET @f_______________11____________ = (SELECT id FROM folders WHERE name = '11-单证复核及系统逻辑检验' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_______________11____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-单证复核及系统逻辑检验', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_______________11____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11____________, @f_______________11____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11____________, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_______________11_____________1_3_________ = (SELECT id FROM folders WHERE name = '1-3-历年退改单率统计' AND parent_id = @f_______________11____________ AND standard_id = 6 LIMIT 1);
    IF @f_______________11_____________1_3_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-3-历年退改单率统计', 6, 1, 2, @f_______________11____________, NOW(), NOW(), '单项标准');
        SET @f_______________11_____________1_3_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_____________1_3_________, @f_______________11_____________1_3_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_____________1_3_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11____________;
    END IF;

    SET @f_______________11____________ = (SELECT id FROM folders WHERE name = '11-单证复核及系统逻辑检验' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_______________11____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-单证复核及系统逻辑检验', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_______________11____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11____________, @f_______________11____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11____________, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_______________11_____________1_4_____________ = (SELECT id FROM folders WHERE name = '1-4-历年单一窗口数据取值截屏' AND parent_id = @f_______________11____________ AND standard_id = 6 LIMIT 1);
    IF @f_______________11_____________1_4_____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-4-历年单一窗口数据取值截屏', 6, 1, 2, @f_______________11____________, NOW(), NOW(), '单项标准');
        SET @f_______________11_____________1_4_____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_____________1_4_____________, @f_______________11_____________1_4_____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_____________1_4_____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11____________;
    END IF;

    SET @f_______________11____________ = (SELECT id FROM folders WHERE name = '11-单证复核及系统逻辑检验' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_______________11____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-单证复核及系统逻辑检验', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_______________11____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11____________, @f_______________11____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11____________, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_______________11_____________1_5_________ = (SELECT id FROM folders WHERE name = '1-5-系统逻辑检验截屏' AND parent_id = @f_______________11____________ AND standard_id = 6 LIMIT 1);
    IF @f_______________11_____________1_5_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-5-系统逻辑检验截屏', 6, 1, 2, @f_______________11____________, NOW(), NOW(), '单项标准');
        SET @f_______________11_____________1_5_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_____________1_5_________, @f_______________11_____________1_5_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_____________1_5_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11____________;
    END IF;

    SET @f_______________11____________ = (SELECT id FROM folders WHERE name = '11-单证复核及系统逻辑检验' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_______________11____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-单证复核及系统逻辑检验', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_______________11____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11____________, @f_______________11____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11____________, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_______________11_____________1_6_________ = (SELECT id FROM folders WHERE name = '1-6-历年单证抽取记录' AND parent_id = @f_______________11____________ AND standard_id = 6 LIMIT 1);
    IF @f_______________11_____________1_6_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-6-历年单证抽取记录', 6, 1, 2, @f_______________11____________, NOW(), NOW(), '单项标准');
        SET @f_______________11_____________1_6_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________11_____________1_6_________, @f_______________11_____________1_6_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________11_____________1_6_________, distance + 1 FROM folder_closure WHERE descendant = @f_______________11____________;
    END IF;

    SET @f_______________12_________ = (SELECT id FROM folders WHERE name = '12-海关法律法规培训' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_______________12_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-海关法律法规培训', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_______________12_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12_________, @f_______________12_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________12_________, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_______________12__________2_7_____________ = (SELECT id FROM folders WHERE name = '2-7-海关法律法规培训管理办法' AND parent_id = @f_______________12_________ AND standard_id = 6 LIMIT 1);
    IF @f_______________12__________2_7_____________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-7-海关法律法规培训管理办法', 6, 1, 2, @f_______________12_________, NOW(), NOW(), '单项标准');
        SET @f_______________12__________2_7_____________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12__________2_7_____________, @f_______________12__________2_7_____________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________12__________2_7_____________, distance + 1 FROM folder_closure WHERE descendant = @f_______________12_________;
    END IF;

    SET @f_______________12_________ = (SELECT id FROM folders WHERE name = '12-海关法律法规培训' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_______________12_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-海关法律法规培训', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_______________12_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12_________, @f_______________12_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________12_________, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_______________12__________2_8____________________ = (SELECT id FROM folders WHERE name = '2-8-客户海关法律法规培训签到记录和培训课件' AND parent_id = @f_______________12_________ AND standard_id = 6 LIMIT 1);
    IF @f_______________12__________2_8____________________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-8-客户海关法律法规培训签到记录和培训课件', 6, 1, 2, @f_______________12_________, NOW(), NOW(), '单项标准');
        SET @f_______________12__________2_8____________________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________12__________2_8____________________, @f_______________12__________2_8____________________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________12__________2_8____________________, distance + 1 FROM folder_closure WHERE descendant = @f_______________12_________;
    END IF;

    SET @f_______________13_____ = (SELECT id FROM folders WHERE name = '13-延伸认证' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_______________13_____ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-延伸认证', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_______________13_____ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13_____, @f_______________13_____, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13_____, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_______________13______3_9___________ = (SELECT id FROM folders WHERE name = '3-9-延伸认证情况说明文件' AND parent_id = @f_______________13_____ AND standard_id = 6 LIMIT 1);
    IF @f_______________13______3_9___________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-9-延伸认证情况说明文件', 6, 1, 2, @f_______________13_____, NOW(), NOW(), '单项标准');
        SET @f_______________13______3_9___________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_______________13______3_9___________, @f_______________13______3_9___________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_______________13______3_9___________, distance + 1 FROM folder_closure WHERE descendant = @f_______________13_____;
    END IF;

    SET @f__________________10___________ = (SELECT id FROM folders WHERE name = '10-历年法检查验管理台账' AND parent_id = 267 AND standard_id = 6 LIMIT 1);
    IF @f__________________10___________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('10-历年法检查验管理台账', 6, 1, 2, 267, NOW(), NOW(), '单项标准');
        SET @f__________________10___________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f__________________10___________, @f__________________10___________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f__________________10___________, distance + 1 FROM folder_closure WHERE descendant = 267;
    END IF;

    SET @f__________________11_________ = (SELECT id FROM folders WHERE name = '11-历年抽查单证文件' AND parent_id = 267 AND standard_id = 6 LIMIT 1);
    IF @f__________________11_________ IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-历年抽查单证文件', 6, 1, 2, 267, NOW(), NOW(), '单项标准');
        SET @f__________________11_________ = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f__________________11_________, @f__________________11_________, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f__________________11_________, distance + 1 FROM folder_closure WHERE descendant = 267;
    END IF;

    -- Start Inserting Audit Items
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________1__________1_1_________, '关企沟通联系合作 、 关企联系合作机制', 2, 0, '关企沟通联系合作 、 关企联系合作机制', 1, '“关企联系工作”或“关企联系合作机制”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 关企联系合作机制制度文件（涵盖公司与海关沟通合作的管理规范）
2. 关企联系合作机制的年度更新版本（如有分年度版本，请按年份分别上传）' WHERE `id` = @f_______________1__________1_1_________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________1__________1_2_____, '关企沟通联系合作 、 岗位职责', 2, 0, '关企沟通联系合作 、 岗位职责', 1, '“贸易安全”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 组织架构图
2. 岗位任职条件与职责说明文件（含贸易安全相关岗位的职责描述）
3. 关键岗位任命书（如贸易安全负责人、AEO联络员等任命文件）
4. 如有多年版本，请按年份（公司存续年份）分别上传' WHERE `id` = @f_______________1__________1_2_____;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________2_______2_3__________, '进出口单证 、 进出口单证复核制度', 4, 0, '进出口单证 、 进出口单证复核制度', 1, '“单证复核流程”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 进出口单证复核管理制度文件
2. 各年度进出口单证复核操作记录（按年份分别上传，涵盖公司存续年份）
3. 单证复核抽查记录（含报关单、装箱单、发票等原始单据抽查样本）' WHERE `id` = @f_______________2_______2_3__________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________2_______2_4__________, '进出口单证 、 进出口单证保管制度', 4, 0, '进出口单证 、 进出口单证保管制度', 1, '“单证归档”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 进出口单证保管管理制度文件
2. 各年度单证保管抽查记录（含实际单证样本，按年度/期次上传，涵盖公司存续年份）
注：单证类型包括但不限于报关单、提单、发票等，建议每年至少上传2个检查时间节点的记录' WHERE `id` = @f_______________2_______2_4__________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________2_______2_5____________, '进出口单证 、 禁止类产品合规审查制度', 4, 0, '进出口单证 、 禁止类产品合规审查制度', 1, '“HS CODE/原产国/MSDS/货物性质”、“安全准入”、“禁止类产品合规审查”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 禁止类产品合规审查制度文件（如有年度更新，按年份上传，涵盖公司存续年份）
2. 禁限类产品公告及目录（国家主管部门发布的相关禁止进出口货物目录）
3. 合规审查记录或自查表（可按年度归纳上传）' WHERE `id` = @f_______________2_______2_5____________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________2_______2_6___________, '进出口单证 、 企业认证电子资料档案', 4, 0, '进出口单证 、 企业认证电子资料档案', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 企业认证电子资料档案汇编（包含AEO认证相关的授权文件、证书等电子存档）' WHERE `id` = @f_______________2_______2_6___________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________3______3_7_______, '信息系统 、 信息系统说明', 3, 0, '信息系统 、 信息系统说明', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 各信息系统操作手册（如EIP系统、WMS仓储系统、JDY系统、金蝶K3等，按系统分别上传）
2. 信息系统抽查记录（包含系统截图、进出库查询记录、异常报错记录等，按年度上传，涵盖公司存续年份）' WHERE `id` = @f_______________3______3_7_______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________3______3_8________, '信息系统 、 系统数据的保管', 3, 0, '信息系统 、 系统数据的保管', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 信息安全管理手册 / IT数据保管制度（按版本年份上传，请上传当前有效版本）
2. 系统数据保留期限截图（证明数据保存周期不少于3年，按时间段分别上传）' WHERE `id` = @f_______________3______3_8________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________3______3_9_________, '信息系统 、 信息安全管理制度', 3, 0, '信息系统 、 信息安全管理制度', 1, '“信息安全管理”、“员工手册”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. IT信息安全管理手册 / 员工手册（按版本年份上传）
2. 密码管理策略记录（密码定期修改策略截图、密码到期修改记录）
3. 机房门禁记录（按年度节点上传，如每年2个时间点，涵盖公司存续年份）
4. 杀毒软件运行截图（按年度上传）' WHERE `id` = @f_______________3______3_9_________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________4_________4_10_______, '内部审计和改进 、 内部审计制度', 5, 0, '内部审计和改进 、 内部审计制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 内部审核制度文件（按版本年份上传，请上传当前有效版本）' WHERE `id` = @f_______________4_________4_10_______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________4_________4_11_______, '内部审计和改进 、 内审记录报告', 5, 0, '内部审计和改进 、 内审记录报告', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 各年度AEO内部审核报告（涵盖公司存续年度，部分年份有上下半年两份，请按年份/期次分别上传）
   参考格式：yyyy AEO内审报告.pdf 或 yyyy-I / yyyy-II AEO内审报告.pdf' WHERE `id` = @f_______________4_________4_11_______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________4_________4_12__________, '内部审计和改进 、 改进和责任追究机制', 5, 0, '内部审计和改进 、 改进和责任追究机制', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 内审改进机制文件（包含改进机制说明、内部审核不合格报告、纠正措施记录等）
2. 责任追究制度文件（如员工手册实施细则中的责任追究部分）
3. 关企联系合作报告流程文件' WHERE `id` = @f_______________4_________4_12__________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________6________6_15_1____________, '遵守法律法规 、 6-15-1 无犯罪记录管理层声明书', 5, 0, '遵守法律法规 、 6-15-1 无犯罪记录管理层声明书', 3, '-', NOW(), NOW());
    UPDATE `folders` SET `description` = '请对照以下海关对于无犯罪记录的要求开展核查：
1. 公司法定代表人、负责海关事务的高级管理人员（小村博之、川锅和弘）以及财务负责人、贸易安全负责人、报关业务负责人、AEO联络员是否在认证有效期内（近2年）存在刑事犯罪记录。
2. 企业是否曾发生由于走私犯罪受过刑事处罚的情形。
3. 请上传管理层对应的无犯罪记录声明书，需由相关负责人签署。' WHERE `id` = @f_______________6________6_15_1____________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________6________6_16_17_18, '遵守法律法规 、 6-16&17&18 报关单行政处罚合规', 5, 0, '遵守法律法规 、 6-16&17&18 报关单行政处罚合规', 3, '-', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件（对应原 6-16、6-17、6-18 审核项）：
1. 企业行政处罚记录说明或各年度无行政处罚证明材料
2. 被处罚报关单明细及对应的行政处罚决定书（如有）
3. 法律法规遵守相关证明材料（如行政许可证、相关资质证书等）
注：审核标准为行政处罚金额累计≤5万元，且被处罚报关单比例＜1‰' WHERE `id` = @f_______________6________6_16_17_18;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________7_______7_19_1_________, '进出口记录 、 1年内进出口活动证明', 4, 0, '进出口记录 、 1年内进出口活动证明', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 1年内进出口活动证明（如海关进出口统计报表、报关记录汇总，或海关签发的证明文件）
2. 如有不同年度版本，请按年份分别上传' WHERE `id` = @f_______________7_______7_19_1_________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________5______5_13_____, '财务状况 、 审计报告', 1, 0, '财务状况 、 审计报告', 3, '-', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 各年度财务审计报告（涵盖公司存续年份，每年一份，由第三方会计师事务所出具）' WHERE `id` = @f_______________5______5_13_____;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________5______5_14________, '财务状况 、 资产负债率情况', 1, 0, '财务状况 、 资产负债率情况', 3, '-', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 各年度资产负债率数据说明文件（含资产负债表或财务分析报告，涵盖公司存续年份）
2. 如有专项资产负债率计算说明，请一并上传' WHERE `id` = @f_______________5______5_14________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11________11_31___________, '经营场所安全 、 经营场所安全管理制度', 3, 0, '经营场所安全 、 经营场所安全管理制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 经营场所安全管理制度文件（含办公区、仓库、园区等区域的安全管理规范）
2. 如有年度更新版本，请按年份分别上传' WHERE `id` = @f_______________11________11_31___________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11________11_32________, '经营场所安全 、 经营场所建筑物', 3, 0, '经营场所安全 、 经营场所建筑物', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 经营场所建筑物照片或说明（含外观、围墙、门禁等设施的现场图片）
2. 建筑物平面图或场所示意图
3. 如有多个经营场所或多年度更新记录，请按场所/年份分别上传' WHERE `id` = @f_______________11________11_32________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11________11_33__________, '经营场所安全 、 锁闭装置及钥匙保管', 3, 0, '经营场所安全 、 锁闭装置及钥匙保管', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 锁闭装置及钥匙保管制度文件
2. 锁闭装置实物照片（含门锁、密码锁、电子门禁等设施）
3. 钥匙/门禁卡领用登记记录（按年度上传，涵盖公司存续年份）' WHERE `id` = @f_______________11________11_33__________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11________11_34___, '经营场所安全 、 照明', 3, 0, '经营场所安全 、 照明', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 经营场所照明设施照片（含仓库内外、停车区域、门禁区域等）
2. 照明检查记录或维护记录（按年度上传）' WHERE `id` = @f_______________11________11_34___;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11________11_35__________, '经营场所安全 、 车辆和人员进出管理', 3, 0, '经营场所安全 、 车辆和人员进出管理', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 车辆与人员进出管理制度文件
2. 进出登记记录（如门卫签到表、车辆出入台账、门禁系统记录截图等，按年度上传，涵盖公司存续年份）
3. 现场照片（如门卫亭、道闸、人行通道等设施）' WHERE `id` = @f_______________11________11_35__________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11________11_36______________, '经营场所安全 、 单证存放和仓储区域受控管理', 3, 0, '经营场所安全 、 单证存放和仓储区域受控管理', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 单证存放管理制度及仓储区域受控管理制度
2. 单证存放区域实物照片（如文件柜、档案室等）
3. 仓储区域管控措施说明或现场图片' WHERE `id` = @f_______________11________11_36______________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11________11_37___________, '经营场所安全 、 重要敏感区域视频监控', 3, 0, '经营场所安全 、 重要敏感区域视频监控', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 视频监控系统说明（含监控点位分布图或照片）
2. 监控录像保存制度及保存时长说明
3. 监控系统运行状态截图或巡检记录（按年度上传）' WHERE `id` = @f_______________11________11_37___________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________12______12_38_________, '人员安全 、 员工入职离职管理', 2, 0, '人员安全 、 员工入职离职管理', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 员工入职管理制度文件（含入职前背景核查流程）
2. 员工离职管理制度文件（含权限注销、资产归还等流程）
3. 如有年度版本更新，请按年份分别上传' WHERE `id` = @f_______________12______12_38_________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________12______12_39_____________, '人员安全 、 新员工&安全敏感岗位背调', 2, 0, '人员安全 、 新员工&安全敏感岗位背调', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 新员工及安全敏感岗位背景调查制度文件
2. 背调记录样本（如背调报告、员工授权书等，按年份归纳，涵盖公司存续年份）
3. 安全敏感岗位名单或说明' WHERE `id` = @f_______________12______12_39_____________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________12______12_40________________, '人员安全 、 员工身份识别和离职员工取消授权', 2, 0, '人员安全 、 员工身份识别和离职员工取消授权', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 员工身份识别管理制度（含工牌、门禁卡发放及管理规范）
2. 离职员工权限注销记录（按年度上传，涵盖公司存续年份）
3. 员工工牌或身份识别系统说明截图' WHERE `id` = @f_______________12______12_40________________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________12______12_41_________, '人员安全 、 访客进出登记管理', 2, 0, '人员安全 、 访客进出登记管理', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 访客进出登记管理制度文件
2. 访客登记记录表样本（按年度上传，涵盖公司存续年份）
3. 访客接待区域或门卫处现场照片' WHERE `id` = @f_______________12______12_41_________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________13_________13_42____________, '货物、物品安全 、 货物、物品安全管理制度', 5, 0, '货物、物品安全 、 货物、物品安全管理制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 货物与物品安全管理制度文件（含收货、发货、仓储全流程的安全管控规范）
2. 如有年度版本更新，请按年份分别上传' WHERE `id` = @f_______________13_________13_42____________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________13_________13_43_________, '货物、物品安全 、 集装箱七点检查法', 5, 0, '货物、物品安全 、 集装箱七点检查法', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 集装箱七点检查法操作规范文件
2. 各年度集装箱七点检查记录（按年份上传，涵盖公司存续年份，建议每年至少2个时间节点）' WHERE `id` = @f_______________13_________13_43_________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________13_________13_44______, '货物、物品安全 、 集装箱封条', 5, 0, '货物、物品安全 、 集装箱封条', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 集装箱封条管理制度文件
2. 集装箱封条实物照片或使用记录（按年份上传，涵盖公司存续年份）' WHERE `id` = @f_______________13_________13_44______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________13_________13_45________, '货物、物品安全 、 集装箱存储制度', 5, 0, '货物、物品安全 、 集装箱存储制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 集装箱存储管理制度文件
2. 相关年度集装箱存放区域照片或管理记录' WHERE `id` = @f_______________13_________13_45________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________13_________13_46_______, '货物、物品安全 、 司机身份核实', 5, 0, '货物、物品安全 、 司机身份核实', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 司机身份核实管理制度文件
2. 各年度司机身份核实记录（如核实登记表、驾照复印件存档等，按年份上传，涵盖公司存续年份）' WHERE `id` = @f_______________13_________13_46_______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________13_________13_47__________, '货物、物品安全 、 装运和接收货物物品', 4, 0, '货物、物品安全 、 装运和接收货物物品', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 货物装运与接收操作规范文件
2. 各年度货物收发记录样本（如入库单、出库单、验货记录等，按年份上传，涵盖公司存续年份）' WHERE `id` = @f_______________13_________13_47__________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________13_________13_48_____________, '货物、物品安全 、 货物、物品差异及报告程序', 5, 0, '货物、物品安全 、 货物、物品差异及报告程序', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 货物差异处理及报告程序文件（含差异发现、上报、处置全流程说明）
2. 差异报告记录样本（如有）' WHERE `id` = @f_______________13_________13_48_____________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________13_________13_49_______, '货物、物品安全 、 出口安全制度', 5, 0, '货物、物品安全 、 出口安全制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 出口安全管理制度文件（含出口货物安全控制的规范与流程）' WHERE `id` = @f_______________13_________13_49_______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________14________14_50___________, '运输工具安全 、 运输工具安全管理制度', 3, 0, '运输工具安全 、 运输工具安全管理制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 运输工具安全管理制度文件（含车辆检查、维护、安全标准等管理规范）' WHERE `id` = @f_______________14________14_50___________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________14________14_51_______, '运输工具安全 、 运输工具检查', 3, 0, '运输工具安全 、 运输工具检查', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 运输工具检查标准或操作规范文件
2. 各年度车辆出车前安全检查记录（按年份上传，涵盖公司存续年份）
3. 各年度车辆定期检查记录（如季度/年度车辆检查报告，按年份上传）' WHERE `id` = @f_______________14________14_51_______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________14________14_52_________, '运输工具安全 、 运输工具存储制度', 3, 0, '运输工具安全 、 运输工具存储制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 运输工具存储管理制度文件（如运输部操作规范中的车辆停放与保管规定）' WHERE `id` = @f_______________14________14_52_________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________14________14_53_____, '运输工具安全 、 安全培训', 3, 0, '运输工具安全 、 安全培训', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 运输安全相关制度文件（如运输部操作规范）
2. 各年度运输安全培训记录（按月份/年份上传，涵盖公司存续年份）
   注：培训记录请按年份归纳，每年按月度培训记录分别上传' WHERE `id` = @f_______________14________14_53_____;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________15________15_54___________, '商业伙伴安全 、 商业伙伴安全管理制度', 5, 0, '商业伙伴安全 、 商业伙伴安全管理制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 商业伙伴安全管理制度文件（含对客户、供应商等合作伙伴的安全管控规范）' WHERE `id` = @f_______________15________15_54___________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________15________15_55_____, '商业伙伴安全 、 全面评估', 5, 0, '商业伙伴安全 、 全面评估', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件（分客户和供应商两类分别准备）：
【客户类】
1. 与客户有关的评估与监测程序说明文件
2. 商业合作伙伴清单（按年份上传，涵盖公司存续年份）
3. 客户调查表（按年份上传，涵盖公司存续年份）
4. 客户评价表（按年份分别上传，按公司存续年份各一份）
5. 贸易安全考评表
【供应商类】
6. 供应商（运输、报关等类别）调查表、评价表及考评表（按年份分别上传）' WHERE `id` = @f_______________15________15_55_____;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________15________15_56_____________, '商业伙伴安全 、 优化贸易安全管理书面文件', 5, 0, '商业伙伴安全 、 优化贸易安全管理书面文件', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 与运输供应商签订的贸易安全补充协议
2. 与报关供应商签订的贸易安全补充协议
3. 向客户发送的贸易安全告知书（按客户分别上传，涵盖全部主要客户）' WHERE `id` = @f_______________15________15_56_____________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________15________15_57_____, '商业伙伴安全 、 监控检查', 5, 0, '商业伙伴安全 、 监控检查', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件（分客户和供应商两类分别准备）：
【客户类】
1. 与客户监控检查相关的评估与监测程序说明
2. 客户贸易安全考评表
3. 客户评价表（按年份分别上传，涵盖公司存续年份）
【供应商类】
4. 运输供应商贸易安全考评表（按年份分别上传，涵盖公司存续年份）
5. 报关供应商贸易安全考评表（按年份分别上传）
6. 仓库供应商贸易安全考评表（按年份分别上传）' WHERE `id` = @f_______________15________15_57_____;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________16_____________16_58________________, '海关业务和贸易安全培训 、 法律法规和贸易安全内部培训制度', 4, 0, '海关业务和贸易安全培训 、 法律法规和贸易安全内部培训制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 人力资源管理程序（含员工培训相关规定，按版本年份上传，请上传当前有效版本）
2. 各年度内部培训计划（按年份分别上传，按公司存续年份各一份）' WHERE `id` = @f_______________16_____________16_58________________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________16_____________16_59_________, '海关业务和贸易安全培训 、 海关法律法规培训', 4, 0, '海关业务和贸易安全培训 、 海关法律法规培训', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 人力资源管理程序（按版本年份上传）
2. 各次培训记录表（区分员工培训和内审员培训，按培训日期分别上传，涵盖公司存续年份）' WHERE `id` = @f_______________16_____________16_59_________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________16_____________16_60_______, '海关业务和贸易安全培训 、 货物安全培训', 4, 0, '海关业务和贸易安全培训 、 货物安全培训', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 仓库安全管理手册 / 运输部操作规范（按版本年份上传）
2. 运输安全培训记录（按月份上传，涵盖公司存续年份）
3. 仓库安全培训记录（按年度上传，涵盖公司存续年份）
   注：培训记录请按年份分别整理归纳后上传' WHERE `id` = @f_______________16_____________16_60_______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________16_____________16_61_______, '海关业务和贸易安全培训 、 危机管理培训', 4, 0, '海关业务和贸易安全培训 、 危机管理培训', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 危机管理相关制度文件（含应急预案，如火灾、台风、地震、车辆故障等应急预案，以及自然灾害应急手册）
2. 各年度危机管理培训记录（按年份分别上传，涵盖公司存续年份）' WHERE `id` = @f_______________16_____________16_61_______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________16_____________16_62_______, '海关业务和贸易安全培训 、 信息安全培训', 4, 0, '海关业务和贸易安全培训 、 信息安全培训', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. IT信息安全管理手册（按版本年份上传）
2. 各次信息安全培训记录（按培训日期分别上传，涵盖公司存续年份，含员工信息安全培训及网络安全培训）' WHERE `id` = @f_______________16_____________16_62_______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f________________4_________4_4_1_____, '三、1 商品检查与进出口法检制度', 6, 0, '三、1 商品检查与进出口法检制度', 1, '“商检”、“法检”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：1. 仓库操作部木质包装管理制度
2. 客户服务部进出境商检与进出口法检制度' WHERE `id` = @f________________4_________4_4_1_____;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f________________4_________4_4_3_____, '三、3 抽查单证文件', 6, 0, '三、3 抽查单证文件', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：历年抽查单证相关文件。' WHERE `id` = @f________________4_________4_4_3_____;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f________________4_________4_4_4______, '三、4 熏蒸板记录', 6, 0, '三、4 熏蒸板记录', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：1. 空置熏蒸板存放区文件
2. 整进整出熏蒸板记录文件' WHERE `id` = @f________________4_________4_4_4______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________2_______, '二、2 特殊物品单证', 6, 0, '二、2 特殊物品单证', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：历年特殊物品单证文件夹' WHERE `id` = @f_______________2_______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________2_______, '二、3 特殊物品安全管理制度', 6, 0, '二、3 特殊物品安全管理制度', 1, '“单证管理”、“复核”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：1. 特殊物品-温控货物操作指导手册
2. 单证归档管理制度（电子）
3. 单证归档管理制度（纸质）' WHERE `id` = @f_______________2_______;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f______________________1____________, '一、1 进出口单证复核&保管制度', 6, 0, '一、1 进出口单证复核&保管制度', 1, '“单证管理”、“复核”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：1. 客户服务部单证复核流程
2. 单证归档管理制度（电子）
3. 单证归档管理制度（纸质）' WHERE `id` = @f______________________1____________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f________________4_________4_4_2___________, '三、2 进境商检查验管理台账历年纪录', 6, 0, '三、2 进境商检查验管理台账历年纪录', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：历年进境商检查验管理台账记录。' WHERE `id` = @f________________4_________4_4_2___________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f__________________9_____, '进出口商品检验 、 法检制度', 6, 0, '进出口商品检验 、 法检制度', 1, '“商检”、“法检”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传进出境商检与进出口法检管理制度文件。' WHERE `id` = @f__________________9_____;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________________, '八、物流运输业务 - 20 运输工具管理制度', 6, 0, '八、物流运输业务 - 20 运输工具管理制度', 1, '“车辆管理”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传运输工具管理相关的操作规范或制度文件（如运输部操作规范）。' WHERE `id` = @f_______________________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f________________________21_1_____________, '八、物流运输业务 - 21-1 运输工具轨迹管理制度', 6, 0, '八、物流运输业务 - 21-1 运输工具轨迹管理制度', 1, '“定位监控”、“轨迹系统”、“车载终端”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传定位系统车载终端管理制度文件。' WHERE `id` = @f________________________21_1_____________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f________________________21_2___________, '八、物流运输业务 - 21-2 车辆行驶轨迹记录', 6, 0, '八、物流运输业务 - 21-2 车辆行驶轨迹记录', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传各年度车辆行驶轨迹监控数据及汇总台账。' WHERE `id` = @f________________________21_2___________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_____________________________22_1________________, '八、物流运输业务 - 22-1 驾驶员安全与匹配制度', 6, 0, '八、物流运输业务 - 22-1 驾驶员安全与匹配制度', 1, '“驾驶员审核”、“身份检查”、“人员匹配”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传驾驶员安全管理制度、司机提货流程及身份检查规范。' WHERE `id` = @f_____________________________22_1________________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_____________________________22_2_____, '八、物流运输业务 - 22-2 车辆与司机登记台账', 6, 0, '八、物流运输业务 - 22-2 车辆与司机登记台账', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传车辆信息表、各年度提送货车辆进出登记台账。' WHERE `id` = @f_____________________________22_2_____;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11_____________1_1_____________, '六、代理报关业务 - 1 进出口单证及复核制度文件', 6, 0, '六、代理报关业务 - 1 进出口单证及复核制度文件', 1, '“进出口单证”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 进出口单证及复核制度文件' WHERE `id` = @f_______________11_____________1_1_____________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11_____________1_2_________, '六、代理报关业务 - 2 系统复审界面截屏', 6, 0, '六、代理报关业务 - 2 系统复审界面截屏', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 系统复审界面截屏' WHERE `id` = @f_______________11_____________1_2_________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11_____________1_3_________, '六、代理报关业务 - 3 历年退改单率统计', 6, 0, '六、代理报关业务 - 3 历年退改单率统计', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 历年退改单率统计' WHERE `id` = @f_______________11_____________1_3_________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11_____________1_4_____________, '六、代理报关业务 - 4 历年单一窗口数据取值截屏', 6, 0, '六、代理报关业务 - 4 历年单一窗口数据取值截屏', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 历年单一窗口数据取值截屏' WHERE `id` = @f_______________11_____________1_4_____________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11_____________1_5_________, '六、代理报关业务 - 5 系统逻辑检验截屏', 6, 0, '六、代理报关业务 - 5 系统逻辑检验截屏', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 系统逻辑检验截屏' WHERE `id` = @f_______________11_____________1_5_________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________11_____________1_6_________, '六、代理报关业务 - 6 历年单证抽取记录', 6, 0, '六、代理报关业务 - 6 历年单证抽取记录', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 历年单证抽取记录，包括出口、出境、进口、进境' WHERE `id` = @f_______________11_____________1_6_________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________12__________2_7_____________, '六、代理报关业务 - 7 海关法律法规培训管理办法', 6, 0, '六、代理报关业务 - 7 海关法律法规培训管理办法', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 海关法律法规培训管理办法' WHERE `id` = @f_______________12__________2_7_____________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________12__________2_8____________________, '六、代理报关业务 - 8 客户海关法律法规培训签到记录和培训课件', 6, 0, '六、代理报关业务 - 8 客户海关法律法规培训签到记录和培训课件', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 客户海关法律法规培训签到记录和培训课件' WHERE `id` = @f_______________12__________2_8____________________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_______________13______3_9___________, '六、代理报关业务 - 9 延伸认证情况说明文件', 6, 0, '六、代理报关业务 - 9 延伸认证情况说明文件', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 延伸认证情况说明文件' WHERE `id` = @f_______________13______3_9___________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f__________________10___________, '五、2 历年法检查验管理台账', 6, 0, '五、2 历年法检查验管理台账', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：历年法检查验管理台账。' WHERE `id` = @f__________________10___________;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f__________________11_________, '五、3 历年抽查单证文件', 6, 0, '五、3 历年抽查单证文件', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：历年抽查单证文件。' WHERE `id` = @f__________________11_________;

END //
DELIMITER ;
CALL SyncUniversal();
DROP PROCEDURE SyncUniversal;
SET FOREIGN_KEY_CHECKS = 1;
