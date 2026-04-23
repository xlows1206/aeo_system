
SET FOREIGN_KEY_CHECKS = 0;

-- 1. 修正后端数据库根节点标点符号 (从 - 改为 、)
UPDATE `folders` SET `name` = '一、加工贸易以及保税进出口业务' WHERE `id` = 264;
UPDATE `folders` SET `name` = '二、卫生检疫业务' WHERE `id` = 265;
UPDATE `folders` SET `name` = '三、动植物检疫业务' WHERE `id` = 266;
UPDATE `folders` SET `name` = '五、进出口商品检验业务' WHERE `id` = 267;
UPDATE `folders` SET `name` = '八、物流运输业务' WHERE `id` = 268;
UPDATE `folders` SET `name` = '六、代理报关业务' WHERE `id` = 300;

-- 2. 清理旧的绑定关系和单项标准的子项 (防止编号重复)
TRUNCATE TABLE `folder_check_files`;
DELETE FROM `folders` WHERE `standard_id` = 6 AND `id` > 500;
DELETE FROM `folder_closure` WHERE descendant NOT IN (SELECT id FROM folders);

DROP PROCEDURE IF EXISTS SyncUniversal;
DELIMITER //
CREATE PROCEDURE SyncUniversal()
BEGIN


    SET @f_241007227b7cc3002bad24d745070490 = (SELECT id FROM folders WHERE name = '1-关企沟通联系合作' AND parent_id = 500 AND standard_id = 2 LIMIT 1);
    IF @f_241007227b7cc3002bad24d745070490 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-关企沟通联系合作', 2, 1, 2, 500, NOW(), NOW(), '人事');
        SET @f_241007227b7cc3002bad24d745070490 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_241007227b7cc3002bad24d745070490, @f_241007227b7cc3002bad24d745070490, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_241007227b7cc3002bad24d745070490, distance + 1 FROM folder_closure WHERE descendant = 500;
    END IF;

    SET @f_8e1d71830c121ab497287c41241da635 = (SELECT id FROM folders WHERE name = '1-1-关企联系合作机制' AND parent_id = @f_241007227b7cc3002bad24d745070490 AND standard_id = 2 LIMIT 1);
    IF @f_8e1d71830c121ab497287c41241da635 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-1-关企联系合作机制', 2, 1, 2, @f_241007227b7cc3002bad24d745070490, NOW(), NOW(), '人事');
        SET @f_8e1d71830c121ab497287c41241da635 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_8e1d71830c121ab497287c41241da635, @f_8e1d71830c121ab497287c41241da635, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_8e1d71830c121ab497287c41241da635, distance + 1 FROM folder_closure WHERE descendant = @f_241007227b7cc3002bad24d745070490;
    END IF;

    SET @f_241007227b7cc3002bad24d745070490 = (SELECT id FROM folders WHERE name = '1-关企沟通联系合作' AND parent_id = 500 AND standard_id = 2 LIMIT 1);
    IF @f_241007227b7cc3002bad24d745070490 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-关企沟通联系合作', 2, 1, 2, 500, NOW(), NOW(), '人事');
        SET @f_241007227b7cc3002bad24d745070490 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_241007227b7cc3002bad24d745070490, @f_241007227b7cc3002bad24d745070490, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_241007227b7cc3002bad24d745070490, distance + 1 FROM folder_closure WHERE descendant = 500;
    END IF;

    SET @f_e4a430d1b3d507c3e5f2ff70ad883b08 = (SELECT id FROM folders WHERE name = '1-2-岗位职责' AND parent_id = @f_241007227b7cc3002bad24d745070490 AND standard_id = 2 LIMIT 1);
    IF @f_e4a430d1b3d507c3e5f2ff70ad883b08 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-2-岗位职责', 2, 1, 2, @f_241007227b7cc3002bad24d745070490, NOW(), NOW(), '人事');
        SET @f_e4a430d1b3d507c3e5f2ff70ad883b08 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_e4a430d1b3d507c3e5f2ff70ad883b08, @f_e4a430d1b3d507c3e5f2ff70ad883b08, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_e4a430d1b3d507c3e5f2ff70ad883b08, distance + 1 FROM folder_closure WHERE descendant = @f_241007227b7cc3002bad24d745070490;
    END IF;

    SET @f_2097829a565848185a434e598f5c727b = (SELECT id FROM folders WHERE name = '2-进出口单证' AND parent_id = 504 AND standard_id = 4 LIMIT 1);
    IF @f_2097829a565848185a434e598f5c727b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-进出口单证', 4, 1, 2, 504, NOW(), NOW(), '关务');
        SET @f_2097829a565848185a434e598f5c727b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_2097829a565848185a434e598f5c727b, @f_2097829a565848185a434e598f5c727b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_2097829a565848185a434e598f5c727b, distance + 1 FROM folder_closure WHERE descendant = 504;
    END IF;

    SET @f_20d36d863b595a16b314f3f400c77dff = (SELECT id FROM folders WHERE name = '2-3-进出口单证复核制度' AND parent_id = @f_2097829a565848185a434e598f5c727b AND standard_id = 4 LIMIT 1);
    IF @f_20d36d863b595a16b314f3f400c77dff IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-3-进出口单证复核制度', 4, 1, 2, @f_2097829a565848185a434e598f5c727b, NOW(), NOW(), '关务');
        SET @f_20d36d863b595a16b314f3f400c77dff = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_20d36d863b595a16b314f3f400c77dff, @f_20d36d863b595a16b314f3f400c77dff, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_20d36d863b595a16b314f3f400c77dff, distance + 1 FROM folder_closure WHERE descendant = @f_2097829a565848185a434e598f5c727b;
    END IF;

    SET @f_2097829a565848185a434e598f5c727b = (SELECT id FROM folders WHERE name = '2-进出口单证' AND parent_id = 504 AND standard_id = 4 LIMIT 1);
    IF @f_2097829a565848185a434e598f5c727b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-进出口单证', 4, 1, 2, 504, NOW(), NOW(), '关务');
        SET @f_2097829a565848185a434e598f5c727b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_2097829a565848185a434e598f5c727b, @f_2097829a565848185a434e598f5c727b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_2097829a565848185a434e598f5c727b, distance + 1 FROM folder_closure WHERE descendant = 504;
    END IF;

    SET @f_ab0792d61ddc79363d89c02836d3c7a2 = (SELECT id FROM folders WHERE name = '2-4-进出口单证保管制度' AND parent_id = @f_2097829a565848185a434e598f5c727b AND standard_id = 4 LIMIT 1);
    IF @f_ab0792d61ddc79363d89c02836d3c7a2 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-4-进出口单证保管制度', 4, 1, 2, @f_2097829a565848185a434e598f5c727b, NOW(), NOW(), '关务');
        SET @f_ab0792d61ddc79363d89c02836d3c7a2 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_ab0792d61ddc79363d89c02836d3c7a2, @f_ab0792d61ddc79363d89c02836d3c7a2, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_ab0792d61ddc79363d89c02836d3c7a2, distance + 1 FROM folder_closure WHERE descendant = @f_2097829a565848185a434e598f5c727b;
    END IF;

    SET @f_2097829a565848185a434e598f5c727b = (SELECT id FROM folders WHERE name = '2-进出口单证' AND parent_id = 504 AND standard_id = 4 LIMIT 1);
    IF @f_2097829a565848185a434e598f5c727b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-进出口单证', 4, 1, 2, 504, NOW(), NOW(), '关务');
        SET @f_2097829a565848185a434e598f5c727b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_2097829a565848185a434e598f5c727b, @f_2097829a565848185a434e598f5c727b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_2097829a565848185a434e598f5c727b, distance + 1 FROM folder_closure WHERE descendant = 504;
    END IF;

    SET @f_adfaae52a53fc5deacc6f2b4150fc91e = (SELECT id FROM folders WHERE name = '2-5-禁止类产品合规审查制度' AND parent_id = @f_2097829a565848185a434e598f5c727b AND standard_id = 4 LIMIT 1);
    IF @f_adfaae52a53fc5deacc6f2b4150fc91e IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-5-禁止类产品合规审查制度', 4, 1, 2, @f_2097829a565848185a434e598f5c727b, NOW(), NOW(), '关务');
        SET @f_adfaae52a53fc5deacc6f2b4150fc91e = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_adfaae52a53fc5deacc6f2b4150fc91e, @f_adfaae52a53fc5deacc6f2b4150fc91e, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_adfaae52a53fc5deacc6f2b4150fc91e, distance + 1 FROM folder_closure WHERE descendant = @f_2097829a565848185a434e598f5c727b;
    END IF;

    SET @f_2097829a565848185a434e598f5c727b = (SELECT id FROM folders WHERE name = '2-进出口单证' AND parent_id = 504 AND standard_id = 4 LIMIT 1);
    IF @f_2097829a565848185a434e598f5c727b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-进出口单证', 4, 1, 2, 504, NOW(), NOW(), '关务');
        SET @f_2097829a565848185a434e598f5c727b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_2097829a565848185a434e598f5c727b, @f_2097829a565848185a434e598f5c727b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_2097829a565848185a434e598f5c727b, distance + 1 FROM folder_closure WHERE descendant = 504;
    END IF;

    SET @f_d1ae94545d31f52a84e61a854f37b944 = (SELECT id FROM folders WHERE name = '2-6-企业认证电子资料档案' AND parent_id = @f_2097829a565848185a434e598f5c727b AND standard_id = 4 LIMIT 1);
    IF @f_d1ae94545d31f52a84e61a854f37b944 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-6-企业认证电子资料档案', 4, 1, 2, @f_2097829a565848185a434e598f5c727b, NOW(), NOW(), '关务');
        SET @f_d1ae94545d31f52a84e61a854f37b944 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_d1ae94545d31f52a84e61a854f37b944, @f_d1ae94545d31f52a84e61a854f37b944, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_d1ae94545d31f52a84e61a854f37b944, distance + 1 FROM folder_closure WHERE descendant = @f_2097829a565848185a434e598f5c727b;
    END IF;

    SET @f_d4d0e6b16133e73d4c6d9dcb941ce5ad = (SELECT id FROM folders WHERE name = '3-信息系统' AND parent_id = 510 AND standard_id = 3 LIMIT 1);
    IF @f_d4d0e6b16133e73d4c6d9dcb941ce5ad IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-信息系统', 3, 1, 2, 510, NOW(), NOW(), '行政');
        SET @f_d4d0e6b16133e73d4c6d9dcb941ce5ad = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_d4d0e6b16133e73d4c6d9dcb941ce5ad, @f_d4d0e6b16133e73d4c6d9dcb941ce5ad, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_d4d0e6b16133e73d4c6d9dcb941ce5ad, distance + 1 FROM folder_closure WHERE descendant = 510;
    END IF;

    SET @f_2837d8cbf6f78e0007a585a36117b7df = (SELECT id FROM folders WHERE name = '3-7-信息系统说明' AND parent_id = @f_d4d0e6b16133e73d4c6d9dcb941ce5ad AND standard_id = 3 LIMIT 1);
    IF @f_2837d8cbf6f78e0007a585a36117b7df IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-7-信息系统说明', 3, 1, 2, @f_d4d0e6b16133e73d4c6d9dcb941ce5ad, NOW(), NOW(), '行政');
        SET @f_2837d8cbf6f78e0007a585a36117b7df = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_2837d8cbf6f78e0007a585a36117b7df, @f_2837d8cbf6f78e0007a585a36117b7df, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_2837d8cbf6f78e0007a585a36117b7df, distance + 1 FROM folder_closure WHERE descendant = @f_d4d0e6b16133e73d4c6d9dcb941ce5ad;
    END IF;

    SET @f_d4d0e6b16133e73d4c6d9dcb941ce5ad = (SELECT id FROM folders WHERE name = '3-信息系统' AND parent_id = 510 AND standard_id = 3 LIMIT 1);
    IF @f_d4d0e6b16133e73d4c6d9dcb941ce5ad IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-信息系统', 3, 1, 2, 510, NOW(), NOW(), '行政');
        SET @f_d4d0e6b16133e73d4c6d9dcb941ce5ad = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_d4d0e6b16133e73d4c6d9dcb941ce5ad, @f_d4d0e6b16133e73d4c6d9dcb941ce5ad, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_d4d0e6b16133e73d4c6d9dcb941ce5ad, distance + 1 FROM folder_closure WHERE descendant = 510;
    END IF;

    SET @f_16f258e400f921a94a5c598d3d5be75b = (SELECT id FROM folders WHERE name = '3-8-系统数据的保管' AND parent_id = @f_d4d0e6b16133e73d4c6d9dcb941ce5ad AND standard_id = 3 LIMIT 1);
    IF @f_16f258e400f921a94a5c598d3d5be75b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-8-系统数据的保管', 3, 1, 2, @f_d4d0e6b16133e73d4c6d9dcb941ce5ad, NOW(), NOW(), '行政');
        SET @f_16f258e400f921a94a5c598d3d5be75b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_16f258e400f921a94a5c598d3d5be75b, @f_16f258e400f921a94a5c598d3d5be75b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_16f258e400f921a94a5c598d3d5be75b, distance + 1 FROM folder_closure WHERE descendant = @f_d4d0e6b16133e73d4c6d9dcb941ce5ad;
    END IF;

    SET @f_d4d0e6b16133e73d4c6d9dcb941ce5ad = (SELECT id FROM folders WHERE name = '3-信息系统' AND parent_id = 510 AND standard_id = 3 LIMIT 1);
    IF @f_d4d0e6b16133e73d4c6d9dcb941ce5ad IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-信息系统', 3, 1, 2, 510, NOW(), NOW(), '行政');
        SET @f_d4d0e6b16133e73d4c6d9dcb941ce5ad = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_d4d0e6b16133e73d4c6d9dcb941ce5ad, @f_d4d0e6b16133e73d4c6d9dcb941ce5ad, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_d4d0e6b16133e73d4c6d9dcb941ce5ad, distance + 1 FROM folder_closure WHERE descendant = 510;
    END IF;

    SET @f_0832fbf4d3f986e943d39d14b4bf597b = (SELECT id FROM folders WHERE name = '3-9-信息安全管理制度' AND parent_id = @f_d4d0e6b16133e73d4c6d9dcb941ce5ad AND standard_id = 3 LIMIT 1);
    IF @f_0832fbf4d3f986e943d39d14b4bf597b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-9-信息安全管理制度', 3, 1, 2, @f_d4d0e6b16133e73d4c6d9dcb941ce5ad, NOW(), NOW(), '行政');
        SET @f_0832fbf4d3f986e943d39d14b4bf597b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_0832fbf4d3f986e943d39d14b4bf597b, @f_0832fbf4d3f986e943d39d14b4bf597b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_0832fbf4d3f986e943d39d14b4bf597b, distance + 1 FROM folder_closure WHERE descendant = @f_d4d0e6b16133e73d4c6d9dcb941ce5ad;
    END IF;

    SET @f_f9caacc8597ba4cc3aa988a35a2dd8dd = (SELECT id FROM folders WHERE name = '4-内部审计和改进' AND parent_id = 515 AND standard_id = 5 LIMIT 1);
    IF @f_f9caacc8597ba4cc3aa988a35a2dd8dd IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-内部审计和改进', 5, 1, 2, 515, NOW(), NOW(), '审计部');
        SET @f_f9caacc8597ba4cc3aa988a35a2dd8dd = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f9caacc8597ba4cc3aa988a35a2dd8dd, @f_f9caacc8597ba4cc3aa988a35a2dd8dd, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f9caacc8597ba4cc3aa988a35a2dd8dd, distance + 1 FROM folder_closure WHERE descendant = 515;
    END IF;

    SET @f_0299b9d98eaf5e76438e3410451e91a5 = (SELECT id FROM folders WHERE name = '4-10-内部审计制度' AND parent_id = @f_f9caacc8597ba4cc3aa988a35a2dd8dd AND standard_id = 5 LIMIT 1);
    IF @f_0299b9d98eaf5e76438e3410451e91a5 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-10-内部审计制度', 5, 1, 2, @f_f9caacc8597ba4cc3aa988a35a2dd8dd, NOW(), NOW(), '审计部');
        SET @f_0299b9d98eaf5e76438e3410451e91a5 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_0299b9d98eaf5e76438e3410451e91a5, @f_0299b9d98eaf5e76438e3410451e91a5, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_0299b9d98eaf5e76438e3410451e91a5, distance + 1 FROM folder_closure WHERE descendant = @f_f9caacc8597ba4cc3aa988a35a2dd8dd;
    END IF;

    SET @f_f9caacc8597ba4cc3aa988a35a2dd8dd = (SELECT id FROM folders WHERE name = '4-内部审计和改进' AND parent_id = 515 AND standard_id = 5 LIMIT 1);
    IF @f_f9caacc8597ba4cc3aa988a35a2dd8dd IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-内部审计和改进', 5, 1, 2, 515, NOW(), NOW(), '审计部');
        SET @f_f9caacc8597ba4cc3aa988a35a2dd8dd = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f9caacc8597ba4cc3aa988a35a2dd8dd, @f_f9caacc8597ba4cc3aa988a35a2dd8dd, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f9caacc8597ba4cc3aa988a35a2dd8dd, distance + 1 FROM folder_closure WHERE descendant = 515;
    END IF;

    SET @f_eb5e0feaf77c7d212fdac305d0120936 = (SELECT id FROM folders WHERE name = '4-11-内审记录报告' AND parent_id = @f_f9caacc8597ba4cc3aa988a35a2dd8dd AND standard_id = 5 LIMIT 1);
    IF @f_eb5e0feaf77c7d212fdac305d0120936 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-11-内审记录报告', 5, 1, 2, @f_f9caacc8597ba4cc3aa988a35a2dd8dd, NOW(), NOW(), '审计部');
        SET @f_eb5e0feaf77c7d212fdac305d0120936 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_eb5e0feaf77c7d212fdac305d0120936, @f_eb5e0feaf77c7d212fdac305d0120936, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_eb5e0feaf77c7d212fdac305d0120936, distance + 1 FROM folder_closure WHERE descendant = @f_f9caacc8597ba4cc3aa988a35a2dd8dd;
    END IF;

    SET @f_f9caacc8597ba4cc3aa988a35a2dd8dd = (SELECT id FROM folders WHERE name = '4-内部审计和改进' AND parent_id = 515 AND standard_id = 5 LIMIT 1);
    IF @f_f9caacc8597ba4cc3aa988a35a2dd8dd IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-内部审计和改进', 5, 1, 2, 515, NOW(), NOW(), '审计部');
        SET @f_f9caacc8597ba4cc3aa988a35a2dd8dd = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f9caacc8597ba4cc3aa988a35a2dd8dd, @f_f9caacc8597ba4cc3aa988a35a2dd8dd, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f9caacc8597ba4cc3aa988a35a2dd8dd, distance + 1 FROM folder_closure WHERE descendant = 515;
    END IF;

    SET @f_f0f933f28d8351546d3867e8bdeb15df = (SELECT id FROM folders WHERE name = '4-12-改进和责任追究机制' AND parent_id = @f_f9caacc8597ba4cc3aa988a35a2dd8dd AND standard_id = 5 LIMIT 1);
    IF @f_f0f933f28d8351546d3867e8bdeb15df IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-12-改进和责任追究机制', 5, 1, 2, @f_f9caacc8597ba4cc3aa988a35a2dd8dd, NOW(), NOW(), '审计部');
        SET @f_f0f933f28d8351546d3867e8bdeb15df = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f0f933f28d8351546d3867e8bdeb15df, @f_f0f933f28d8351546d3867e8bdeb15df, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f0f933f28d8351546d3867e8bdeb15df, distance + 1 FROM folder_closure WHERE descendant = @f_f9caacc8597ba4cc3aa988a35a2dd8dd;
    END IF;

    SET @f_a3e6d51121c8c574c644c4b558737787 = (SELECT id FROM folders WHERE name = '6-遵守法律法规' AND parent_id = 520 AND standard_id = 5 LIMIT 1);
    IF @f_a3e6d51121c8c574c644c4b558737787 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('6-遵守法律法规', 5, 1, 2, 520, NOW(), NOW(), '审计部');
        SET @f_a3e6d51121c8c574c644c4b558737787 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_a3e6d51121c8c574c644c4b558737787, @f_a3e6d51121c8c574c644c4b558737787, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_a3e6d51121c8c574c644c4b558737787, distance + 1 FROM folder_closure WHERE descendant = 520;
    END IF;

    SET @f_b9b4cbf71ca8195b46466e25753384cd = (SELECT id FROM folders WHERE name = '6-15-1-无犯罪记录管理层声明书' AND parent_id = @f_a3e6d51121c8c574c644c4b558737787 AND standard_id = 5 LIMIT 1);
    IF @f_b9b4cbf71ca8195b46466e25753384cd IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('6-15-1-无犯罪记录管理层声明书', 5, 1, 2, @f_a3e6d51121c8c574c644c4b558737787, NOW(), NOW(), '审计部');
        SET @f_b9b4cbf71ca8195b46466e25753384cd = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_b9b4cbf71ca8195b46466e25753384cd, @f_b9b4cbf71ca8195b46466e25753384cd, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_b9b4cbf71ca8195b46466e25753384cd, distance + 1 FROM folder_closure WHERE descendant = @f_a3e6d51121c8c574c644c4b558737787;
    END IF;

    SET @f_a3e6d51121c8c574c644c4b558737787 = (SELECT id FROM folders WHERE name = '6-遵守法律法规' AND parent_id = 520 AND standard_id = 5 LIMIT 1);
    IF @f_a3e6d51121c8c574c644c4b558737787 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('6-遵守法律法规', 5, 1, 2, 520, NOW(), NOW(), '审计部');
        SET @f_a3e6d51121c8c574c644c4b558737787 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_a3e6d51121c8c574c644c4b558737787, @f_a3e6d51121c8c574c644c4b558737787, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_a3e6d51121c8c574c644c4b558737787, distance + 1 FROM folder_closure WHERE descendant = 520;
    END IF;

    SET @f_57fbedef7123c7affcce97e6f1dbbb5e = (SELECT id FROM folders WHERE name = '6-16&17&18 报关单行政处罚合规' AND parent_id = @f_a3e6d51121c8c574c644c4b558737787 AND standard_id = 5 LIMIT 1);
    IF @f_57fbedef7123c7affcce97e6f1dbbb5e IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('6-16&17&18 报关单行政处罚合规', 5, 1, 2, @f_a3e6d51121c8c574c644c4b558737787, NOW(), NOW(), '审计部');
        SET @f_57fbedef7123c7affcce97e6f1dbbb5e = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_57fbedef7123c7affcce97e6f1dbbb5e, @f_57fbedef7123c7affcce97e6f1dbbb5e, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_57fbedef7123c7affcce97e6f1dbbb5e, distance + 1 FROM folder_closure WHERE descendant = @f_a3e6d51121c8c574c644c4b558737787;
    END IF;

    SET @f_bbeaaacffb5754ccda43b4695018ad3e = (SELECT id FROM folders WHERE name = '7-进出口记录' AND parent_id = 524 AND standard_id = 4 LIMIT 1);
    IF @f_bbeaaacffb5754ccda43b4695018ad3e IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('7-进出口记录', 4, 1, 2, 524, NOW(), NOW(), '关务');
        SET @f_bbeaaacffb5754ccda43b4695018ad3e = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_bbeaaacffb5754ccda43b4695018ad3e, @f_bbeaaacffb5754ccda43b4695018ad3e, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_bbeaaacffb5754ccda43b4695018ad3e, distance + 1 FROM folder_closure WHERE descendant = 524;
    END IF;

    SET @f_6a38321a2ecc77750f61bfda7655343d = (SELECT id FROM folders WHERE name = '7-19-1年内进出口活动证明' AND parent_id = @f_bbeaaacffb5754ccda43b4695018ad3e AND standard_id = 4 LIMIT 1);
    IF @f_6a38321a2ecc77750f61bfda7655343d IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('7-19-1年内进出口活动证明', 4, 1, 2, @f_bbeaaacffb5754ccda43b4695018ad3e, NOW(), NOW(), '关务');
        SET @f_6a38321a2ecc77750f61bfda7655343d = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_6a38321a2ecc77750f61bfda7655343d, @f_6a38321a2ecc77750f61bfda7655343d, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_6a38321a2ecc77750f61bfda7655343d, distance + 1 FROM folder_closure WHERE descendant = @f_bbeaaacffb5754ccda43b4695018ad3e;
    END IF;

    SET @f_63ca7cda57d3d734c35046285333b073 = (SELECT id FROM folders WHERE name = '5-财务状况' AND parent_id = 527 AND standard_id = 1 LIMIT 1);
    IF @f_63ca7cda57d3d734c35046285333b073 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('5-财务状况', 1, 1, 2, 527, NOW(), NOW(), '财务');
        SET @f_63ca7cda57d3d734c35046285333b073 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_63ca7cda57d3d734c35046285333b073, @f_63ca7cda57d3d734c35046285333b073, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_63ca7cda57d3d734c35046285333b073, distance + 1 FROM folder_closure WHERE descendant = 527;
    END IF;

    SET @f_801364dcc88d163958839256923d2bef = (SELECT id FROM folders WHERE name = '5-13-审计报告' AND parent_id = @f_63ca7cda57d3d734c35046285333b073 AND standard_id = 1 LIMIT 1);
    IF @f_801364dcc88d163958839256923d2bef IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('5-13-审计报告', 1, 1, 2, @f_63ca7cda57d3d734c35046285333b073, NOW(), NOW(), '财务');
        SET @f_801364dcc88d163958839256923d2bef = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_801364dcc88d163958839256923d2bef, @f_801364dcc88d163958839256923d2bef, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_801364dcc88d163958839256923d2bef, distance + 1 FROM folder_closure WHERE descendant = @f_63ca7cda57d3d734c35046285333b073;
    END IF;

    SET @f_63ca7cda57d3d734c35046285333b073 = (SELECT id FROM folders WHERE name = '5-财务状况' AND parent_id = 527 AND standard_id = 1 LIMIT 1);
    IF @f_63ca7cda57d3d734c35046285333b073 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('5-财务状况', 1, 1, 2, 527, NOW(), NOW(), '财务');
        SET @f_63ca7cda57d3d734c35046285333b073 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_63ca7cda57d3d734c35046285333b073, @f_63ca7cda57d3d734c35046285333b073, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_63ca7cda57d3d734c35046285333b073, distance + 1 FROM folder_closure WHERE descendant = 527;
    END IF;

    SET @f_ff9a7159e3ba11c0fa95b0e2a1a55fe6 = (SELECT id FROM folders WHERE name = '5-14-资产负债率情况' AND parent_id = @f_63ca7cda57d3d734c35046285333b073 AND standard_id = 1 LIMIT 1);
    IF @f_ff9a7159e3ba11c0fa95b0e2a1a55fe6 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('5-14-资产负债率情况', 1, 1, 2, @f_63ca7cda57d3d734c35046285333b073, NOW(), NOW(), '财务');
        SET @f_ff9a7159e3ba11c0fa95b0e2a1a55fe6 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_ff9a7159e3ba11c0fa95b0e2a1a55fe6, @f_ff9a7159e3ba11c0fa95b0e2a1a55fe6, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_ff9a7159e3ba11c0fa95b0e2a1a55fe6, distance + 1 FROM folder_closure WHERE descendant = @f_63ca7cda57d3d734c35046285333b073;
    END IF;

    SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_65b26d7d5090cd676bd24aacdf2ccb6b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_65b26d7d5090cd676bd24aacdf2ccb6b, @f_65b26d7d5090cd676bd24aacdf2ccb6b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_65b26d7d5090cd676bd24aacdf2ccb6b, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_042b6cbb9446ebba368ce95e3c23315a = (SELECT id FROM folders WHERE name = '11-31-经营场所安全管理制度' AND parent_id = @f_65b26d7d5090cd676bd24aacdf2ccb6b AND standard_id = 3 LIMIT 1);
    IF @f_042b6cbb9446ebba368ce95e3c23315a IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-31-经营场所安全管理制度', 3, 1, 2, @f_65b26d7d5090cd676bd24aacdf2ccb6b, NOW(), NOW(), '行政');
        SET @f_042b6cbb9446ebba368ce95e3c23315a = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_042b6cbb9446ebba368ce95e3c23315a, @f_042b6cbb9446ebba368ce95e3c23315a, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_042b6cbb9446ebba368ce95e3c23315a, distance + 1 FROM folder_closure WHERE descendant = @f_65b26d7d5090cd676bd24aacdf2ccb6b;
    END IF;

    SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_65b26d7d5090cd676bd24aacdf2ccb6b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_65b26d7d5090cd676bd24aacdf2ccb6b, @f_65b26d7d5090cd676bd24aacdf2ccb6b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_65b26d7d5090cd676bd24aacdf2ccb6b, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_0c9ff66910da2dee807c0684ab58f905 = (SELECT id FROM folders WHERE name = '11-32-经营场所建筑物' AND parent_id = @f_65b26d7d5090cd676bd24aacdf2ccb6b AND standard_id = 3 LIMIT 1);
    IF @f_0c9ff66910da2dee807c0684ab58f905 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-32-经营场所建筑物', 3, 1, 2, @f_65b26d7d5090cd676bd24aacdf2ccb6b, NOW(), NOW(), '行政');
        SET @f_0c9ff66910da2dee807c0684ab58f905 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_0c9ff66910da2dee807c0684ab58f905, @f_0c9ff66910da2dee807c0684ab58f905, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_0c9ff66910da2dee807c0684ab58f905, distance + 1 FROM folder_closure WHERE descendant = @f_65b26d7d5090cd676bd24aacdf2ccb6b;
    END IF;

    SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_65b26d7d5090cd676bd24aacdf2ccb6b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_65b26d7d5090cd676bd24aacdf2ccb6b, @f_65b26d7d5090cd676bd24aacdf2ccb6b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_65b26d7d5090cd676bd24aacdf2ccb6b, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_547c416fed64c50933099467393a19a3 = (SELECT id FROM folders WHERE name = '11-33-锁闭装置及钥匙保管' AND parent_id = @f_65b26d7d5090cd676bd24aacdf2ccb6b AND standard_id = 3 LIMIT 1);
    IF @f_547c416fed64c50933099467393a19a3 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-33-锁闭装置及钥匙保管', 3, 1, 2, @f_65b26d7d5090cd676bd24aacdf2ccb6b, NOW(), NOW(), '行政');
        SET @f_547c416fed64c50933099467393a19a3 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_547c416fed64c50933099467393a19a3, @f_547c416fed64c50933099467393a19a3, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_547c416fed64c50933099467393a19a3, distance + 1 FROM folder_closure WHERE descendant = @f_65b26d7d5090cd676bd24aacdf2ccb6b;
    END IF;

    SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_65b26d7d5090cd676bd24aacdf2ccb6b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_65b26d7d5090cd676bd24aacdf2ccb6b, @f_65b26d7d5090cd676bd24aacdf2ccb6b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_65b26d7d5090cd676bd24aacdf2ccb6b, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_fcbc1f3ff29760bd4ef2499bc83f225c = (SELECT id FROM folders WHERE name = '11-34-照明' AND parent_id = @f_65b26d7d5090cd676bd24aacdf2ccb6b AND standard_id = 3 LIMIT 1);
    IF @f_fcbc1f3ff29760bd4ef2499bc83f225c IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-34-照明', 3, 1, 2, @f_65b26d7d5090cd676bd24aacdf2ccb6b, NOW(), NOW(), '行政');
        SET @f_fcbc1f3ff29760bd4ef2499bc83f225c = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_fcbc1f3ff29760bd4ef2499bc83f225c, @f_fcbc1f3ff29760bd4ef2499bc83f225c, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_fcbc1f3ff29760bd4ef2499bc83f225c, distance + 1 FROM folder_closure WHERE descendant = @f_65b26d7d5090cd676bd24aacdf2ccb6b;
    END IF;

    SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_65b26d7d5090cd676bd24aacdf2ccb6b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_65b26d7d5090cd676bd24aacdf2ccb6b, @f_65b26d7d5090cd676bd24aacdf2ccb6b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_65b26d7d5090cd676bd24aacdf2ccb6b, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_67103813373213261524ae32b60ce307 = (SELECT id FROM folders WHERE name = '11-35-车辆和人员进出管理' AND parent_id = @f_65b26d7d5090cd676bd24aacdf2ccb6b AND standard_id = 3 LIMIT 1);
    IF @f_67103813373213261524ae32b60ce307 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-35-车辆和人员进出管理', 3, 1, 2, @f_65b26d7d5090cd676bd24aacdf2ccb6b, NOW(), NOW(), '行政');
        SET @f_67103813373213261524ae32b60ce307 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_67103813373213261524ae32b60ce307, @f_67103813373213261524ae32b60ce307, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_67103813373213261524ae32b60ce307, distance + 1 FROM folder_closure WHERE descendant = @f_65b26d7d5090cd676bd24aacdf2ccb6b;
    END IF;

    SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_65b26d7d5090cd676bd24aacdf2ccb6b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_65b26d7d5090cd676bd24aacdf2ccb6b, @f_65b26d7d5090cd676bd24aacdf2ccb6b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_65b26d7d5090cd676bd24aacdf2ccb6b, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_890b61f1e759722bad0cf01883a86261 = (SELECT id FROM folders WHERE name = '11-36-单证存放和仓储区域受控管理' AND parent_id = @f_65b26d7d5090cd676bd24aacdf2ccb6b AND standard_id = 3 LIMIT 1);
    IF @f_890b61f1e759722bad0cf01883a86261 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-36-单证存放和仓储区域受控管理', 3, 1, 2, @f_65b26d7d5090cd676bd24aacdf2ccb6b, NOW(), NOW(), '行政');
        SET @f_890b61f1e759722bad0cf01883a86261 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_890b61f1e759722bad0cf01883a86261, @f_890b61f1e759722bad0cf01883a86261, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_890b61f1e759722bad0cf01883a86261, distance + 1 FROM folder_closure WHERE descendant = @f_65b26d7d5090cd676bd24aacdf2ccb6b;
    END IF;

    SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = (SELECT id FROM folders WHERE name = '11-经营场所安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_65b26d7d5090cd676bd24aacdf2ccb6b IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-经营场所安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_65b26d7d5090cd676bd24aacdf2ccb6b = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_65b26d7d5090cd676bd24aacdf2ccb6b, @f_65b26d7d5090cd676bd24aacdf2ccb6b, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_65b26d7d5090cd676bd24aacdf2ccb6b, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_9ad4323b6dab7dda37ed98ca9f5c805e = (SELECT id FROM folders WHERE name = '11-37-重要敏感区域视频监控' AND parent_id = @f_65b26d7d5090cd676bd24aacdf2ccb6b AND standard_id = 3 LIMIT 1);
    IF @f_9ad4323b6dab7dda37ed98ca9f5c805e IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-37-重要敏感区域视频监控', 3, 1, 2, @f_65b26d7d5090cd676bd24aacdf2ccb6b, NOW(), NOW(), '行政');
        SET @f_9ad4323b6dab7dda37ed98ca9f5c805e = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_9ad4323b6dab7dda37ed98ca9f5c805e, @f_9ad4323b6dab7dda37ed98ca9f5c805e, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_9ad4323b6dab7dda37ed98ca9f5c805e, distance + 1 FROM folder_closure WHERE descendant = @f_65b26d7d5090cd676bd24aacdf2ccb6b;
    END IF;

    SET @f_7a13926b19ecced8ce387e4ed00fbfc6 = (SELECT id FROM folders WHERE name = '12-人员安全' AND parent_id = 540 AND standard_id = 2 LIMIT 1);
    IF @f_7a13926b19ecced8ce387e4ed00fbfc6 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-人员安全', 2, 1, 2, 540, NOW(), NOW(), '人事');
        SET @f_7a13926b19ecced8ce387e4ed00fbfc6 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7a13926b19ecced8ce387e4ed00fbfc6, @f_7a13926b19ecced8ce387e4ed00fbfc6, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7a13926b19ecced8ce387e4ed00fbfc6, distance + 1 FROM folder_closure WHERE descendant = 540;
    END IF;

    SET @f_6078290632f9303a52f12637ba85850a = (SELECT id FROM folders WHERE name = '12-38-员工入职离职管理' AND parent_id = @f_7a13926b19ecced8ce387e4ed00fbfc6 AND standard_id = 2 LIMIT 1);
    IF @f_6078290632f9303a52f12637ba85850a IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-38-员工入职离职管理', 2, 1, 2, @f_7a13926b19ecced8ce387e4ed00fbfc6, NOW(), NOW(), '人事');
        SET @f_6078290632f9303a52f12637ba85850a = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_6078290632f9303a52f12637ba85850a, @f_6078290632f9303a52f12637ba85850a, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_6078290632f9303a52f12637ba85850a, distance + 1 FROM folder_closure WHERE descendant = @f_7a13926b19ecced8ce387e4ed00fbfc6;
    END IF;

    SET @f_7a13926b19ecced8ce387e4ed00fbfc6 = (SELECT id FROM folders WHERE name = '12-人员安全' AND parent_id = 540 AND standard_id = 2 LIMIT 1);
    IF @f_7a13926b19ecced8ce387e4ed00fbfc6 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-人员安全', 2, 1, 2, 540, NOW(), NOW(), '人事');
        SET @f_7a13926b19ecced8ce387e4ed00fbfc6 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7a13926b19ecced8ce387e4ed00fbfc6, @f_7a13926b19ecced8ce387e4ed00fbfc6, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7a13926b19ecced8ce387e4ed00fbfc6, distance + 1 FROM folder_closure WHERE descendant = 540;
    END IF;

    SET @f_edd5592fb69f45a88387009709b5806f = (SELECT id FROM folders WHERE name = '12-39-新员工&安全敏感岗位背调' AND parent_id = @f_7a13926b19ecced8ce387e4ed00fbfc6 AND standard_id = 2 LIMIT 1);
    IF @f_edd5592fb69f45a88387009709b5806f IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-39-新员工&安全敏感岗位背调', 2, 1, 2, @f_7a13926b19ecced8ce387e4ed00fbfc6, NOW(), NOW(), '人事');
        SET @f_edd5592fb69f45a88387009709b5806f = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_edd5592fb69f45a88387009709b5806f, @f_edd5592fb69f45a88387009709b5806f, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_edd5592fb69f45a88387009709b5806f, distance + 1 FROM folder_closure WHERE descendant = @f_7a13926b19ecced8ce387e4ed00fbfc6;
    END IF;

    SET @f_7a13926b19ecced8ce387e4ed00fbfc6 = (SELECT id FROM folders WHERE name = '12-人员安全' AND parent_id = 540 AND standard_id = 2 LIMIT 1);
    IF @f_7a13926b19ecced8ce387e4ed00fbfc6 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-人员安全', 2, 1, 2, 540, NOW(), NOW(), '人事');
        SET @f_7a13926b19ecced8ce387e4ed00fbfc6 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7a13926b19ecced8ce387e4ed00fbfc6, @f_7a13926b19ecced8ce387e4ed00fbfc6, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7a13926b19ecced8ce387e4ed00fbfc6, distance + 1 FROM folder_closure WHERE descendant = 540;
    END IF;

    SET @f_df175e41d64c8b84d3269643ec7cb61d = (SELECT id FROM folders WHERE name = '12-40-员工身份识别和离职员工取消授权' AND parent_id = @f_7a13926b19ecced8ce387e4ed00fbfc6 AND standard_id = 2 LIMIT 1);
    IF @f_df175e41d64c8b84d3269643ec7cb61d IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-40-员工身份识别和离职员工取消授权', 2, 1, 2, @f_7a13926b19ecced8ce387e4ed00fbfc6, NOW(), NOW(), '人事');
        SET @f_df175e41d64c8b84d3269643ec7cb61d = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_df175e41d64c8b84d3269643ec7cb61d, @f_df175e41d64c8b84d3269643ec7cb61d, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_df175e41d64c8b84d3269643ec7cb61d, distance + 1 FROM folder_closure WHERE descendant = @f_7a13926b19ecced8ce387e4ed00fbfc6;
    END IF;

    SET @f_7a13926b19ecced8ce387e4ed00fbfc6 = (SELECT id FROM folders WHERE name = '12-人员安全' AND parent_id = 540 AND standard_id = 2 LIMIT 1);
    IF @f_7a13926b19ecced8ce387e4ed00fbfc6 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-人员安全', 2, 1, 2, 540, NOW(), NOW(), '人事');
        SET @f_7a13926b19ecced8ce387e4ed00fbfc6 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7a13926b19ecced8ce387e4ed00fbfc6, @f_7a13926b19ecced8ce387e4ed00fbfc6, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7a13926b19ecced8ce387e4ed00fbfc6, distance + 1 FROM folder_closure WHERE descendant = 540;
    END IF;

    SET @f_76f8856967987010c5a93b15de09a349 = (SELECT id FROM folders WHERE name = '12-41-访客进出登记管理' AND parent_id = @f_7a13926b19ecced8ce387e4ed00fbfc6 AND standard_id = 2 LIMIT 1);
    IF @f_76f8856967987010c5a93b15de09a349 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-41-访客进出登记管理', 2, 1, 2, @f_7a13926b19ecced8ce387e4ed00fbfc6, NOW(), NOW(), '人事');
        SET @f_76f8856967987010c5a93b15de09a349 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_76f8856967987010c5a93b15de09a349, @f_76f8856967987010c5a93b15de09a349, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_76f8856967987010c5a93b15de09a349, distance + 1 FROM folder_closure WHERE descendant = @f_7a13926b19ecced8ce387e4ed00fbfc6;
    END IF;

    SET @f_f0333d98c8e4f2563f5bccf11c196136 = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_f0333d98c8e4f2563f5bccf11c196136 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_f0333d98c8e4f2563f5bccf11c196136 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f0333d98c8e4f2563f5bccf11c196136, @f_f0333d98c8e4f2563f5bccf11c196136, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f0333d98c8e4f2563f5bccf11c196136, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_f15775b01b1ca88312c2dec4c7883711 = (SELECT id FROM folders WHERE name = '13-42-货物-物品安全管理制度' AND parent_id = @f_f0333d98c8e4f2563f5bccf11c196136 AND standard_id = 5 LIMIT 1);
    IF @f_f15775b01b1ca88312c2dec4c7883711 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-42-货物-物品安全管理制度', 5, 1, 2, @f_f0333d98c8e4f2563f5bccf11c196136, NOW(), NOW(), '审计部');
        SET @f_f15775b01b1ca88312c2dec4c7883711 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f15775b01b1ca88312c2dec4c7883711, @f_f15775b01b1ca88312c2dec4c7883711, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f15775b01b1ca88312c2dec4c7883711, distance + 1 FROM folder_closure WHERE descendant = @f_f0333d98c8e4f2563f5bccf11c196136;
    END IF;

    SET @f_f0333d98c8e4f2563f5bccf11c196136 = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_f0333d98c8e4f2563f5bccf11c196136 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_f0333d98c8e4f2563f5bccf11c196136 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f0333d98c8e4f2563f5bccf11c196136, @f_f0333d98c8e4f2563f5bccf11c196136, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f0333d98c8e4f2563f5bccf11c196136, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_03dc14bf9c5569a90a4bd7f860330148 = (SELECT id FROM folders WHERE name = '13-43-集装箱七点检查法' AND parent_id = @f_f0333d98c8e4f2563f5bccf11c196136 AND standard_id = 5 LIMIT 1);
    IF @f_03dc14bf9c5569a90a4bd7f860330148 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-43-集装箱七点检查法', 5, 1, 2, @f_f0333d98c8e4f2563f5bccf11c196136, NOW(), NOW(), '审计部');
        SET @f_03dc14bf9c5569a90a4bd7f860330148 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_03dc14bf9c5569a90a4bd7f860330148, @f_03dc14bf9c5569a90a4bd7f860330148, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_03dc14bf9c5569a90a4bd7f860330148, distance + 1 FROM folder_closure WHERE descendant = @f_f0333d98c8e4f2563f5bccf11c196136;
    END IF;

    SET @f_f0333d98c8e4f2563f5bccf11c196136 = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_f0333d98c8e4f2563f5bccf11c196136 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_f0333d98c8e4f2563f5bccf11c196136 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f0333d98c8e4f2563f5bccf11c196136, @f_f0333d98c8e4f2563f5bccf11c196136, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f0333d98c8e4f2563f5bccf11c196136, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_e1c98e14cd2212b8255c14e500e126e4 = (SELECT id FROM folders WHERE name = '13-44-集装箱封条' AND parent_id = @f_f0333d98c8e4f2563f5bccf11c196136 AND standard_id = 5 LIMIT 1);
    IF @f_e1c98e14cd2212b8255c14e500e126e4 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-44-集装箱封条', 5, 1, 2, @f_f0333d98c8e4f2563f5bccf11c196136, NOW(), NOW(), '审计部');
        SET @f_e1c98e14cd2212b8255c14e500e126e4 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_e1c98e14cd2212b8255c14e500e126e4, @f_e1c98e14cd2212b8255c14e500e126e4, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_e1c98e14cd2212b8255c14e500e126e4, distance + 1 FROM folder_closure WHERE descendant = @f_f0333d98c8e4f2563f5bccf11c196136;
    END IF;

    SET @f_f0333d98c8e4f2563f5bccf11c196136 = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_f0333d98c8e4f2563f5bccf11c196136 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_f0333d98c8e4f2563f5bccf11c196136 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f0333d98c8e4f2563f5bccf11c196136, @f_f0333d98c8e4f2563f5bccf11c196136, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f0333d98c8e4f2563f5bccf11c196136, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_ac4b52f6beb709efa97f1f15b1995855 = (SELECT id FROM folders WHERE name = '13-45-集装箱存储制度' AND parent_id = @f_f0333d98c8e4f2563f5bccf11c196136 AND standard_id = 5 LIMIT 1);
    IF @f_ac4b52f6beb709efa97f1f15b1995855 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-45-集装箱存储制度', 5, 1, 2, @f_f0333d98c8e4f2563f5bccf11c196136, NOW(), NOW(), '审计部');
        SET @f_ac4b52f6beb709efa97f1f15b1995855 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_ac4b52f6beb709efa97f1f15b1995855, @f_ac4b52f6beb709efa97f1f15b1995855, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_ac4b52f6beb709efa97f1f15b1995855, distance + 1 FROM folder_closure WHERE descendant = @f_f0333d98c8e4f2563f5bccf11c196136;
    END IF;

    SET @f_f0333d98c8e4f2563f5bccf11c196136 = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_f0333d98c8e4f2563f5bccf11c196136 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_f0333d98c8e4f2563f5bccf11c196136 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f0333d98c8e4f2563f5bccf11c196136, @f_f0333d98c8e4f2563f5bccf11c196136, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f0333d98c8e4f2563f5bccf11c196136, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_5cd83d128c86e5f9fe3876853396bf28 = (SELECT id FROM folders WHERE name = '13-46-司机身份核实' AND parent_id = @f_f0333d98c8e4f2563f5bccf11c196136 AND standard_id = 5 LIMIT 1);
    IF @f_5cd83d128c86e5f9fe3876853396bf28 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-46-司机身份核实', 5, 1, 2, @f_f0333d98c8e4f2563f5bccf11c196136, NOW(), NOW(), '审计部');
        SET @f_5cd83d128c86e5f9fe3876853396bf28 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_5cd83d128c86e5f9fe3876853396bf28, @f_5cd83d128c86e5f9fe3876853396bf28, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_5cd83d128c86e5f9fe3876853396bf28, distance + 1 FROM folder_closure WHERE descendant = @f_f0333d98c8e4f2563f5bccf11c196136;
    END IF;

    SET @f_f0333d98c8e4f2563f5bccf11c196136 = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 553 AND standard_id = 4 LIMIT 1);
    IF @f_f0333d98c8e4f2563f5bccf11c196136 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 4, 1, 2, 553, NOW(), NOW(), '关务');
        SET @f_f0333d98c8e4f2563f5bccf11c196136 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f0333d98c8e4f2563f5bccf11c196136, @f_f0333d98c8e4f2563f5bccf11c196136, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f0333d98c8e4f2563f5bccf11c196136, distance + 1 FROM folder_closure WHERE descendant = 553;
    END IF;

    SET @f_1a1254f028892c5c60e376b6987b474d = (SELECT id FROM folders WHERE name = '13-47-装运和接收货物物品' AND parent_id = @f_f0333d98c8e4f2563f5bccf11c196136 AND standard_id = 4 LIMIT 1);
    IF @f_1a1254f028892c5c60e376b6987b474d IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-47-装运和接收货物物品', 4, 1, 2, @f_f0333d98c8e4f2563f5bccf11c196136, NOW(), NOW(), '关务');
        SET @f_1a1254f028892c5c60e376b6987b474d = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_1a1254f028892c5c60e376b6987b474d, @f_1a1254f028892c5c60e376b6987b474d, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_1a1254f028892c5c60e376b6987b474d, distance + 1 FROM folder_closure WHERE descendant = @f_f0333d98c8e4f2563f5bccf11c196136;
    END IF;

    SET @f_f0333d98c8e4f2563f5bccf11c196136 = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_f0333d98c8e4f2563f5bccf11c196136 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_f0333d98c8e4f2563f5bccf11c196136 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f0333d98c8e4f2563f5bccf11c196136, @f_f0333d98c8e4f2563f5bccf11c196136, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f0333d98c8e4f2563f5bccf11c196136, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_352ea919a809c04568e2ef2d4ae052c5 = (SELECT id FROM folders WHERE name = '13-48-货物-物品差异及报告程序' AND parent_id = @f_f0333d98c8e4f2563f5bccf11c196136 AND standard_id = 5 LIMIT 1);
    IF @f_352ea919a809c04568e2ef2d4ae052c5 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-48-货物-物品差异及报告程序', 5, 1, 2, @f_f0333d98c8e4f2563f5bccf11c196136, NOW(), NOW(), '审计部');
        SET @f_352ea919a809c04568e2ef2d4ae052c5 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_352ea919a809c04568e2ef2d4ae052c5, @f_352ea919a809c04568e2ef2d4ae052c5, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_352ea919a809c04568e2ef2d4ae052c5, distance + 1 FROM folder_closure WHERE descendant = @f_f0333d98c8e4f2563f5bccf11c196136;
    END IF;

    SET @f_f0333d98c8e4f2563f5bccf11c196136 = (SELECT id FROM folders WHERE name = '13-货物-物品安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_f0333d98c8e4f2563f5bccf11c196136 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-货物-物品安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_f0333d98c8e4f2563f5bccf11c196136 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_f0333d98c8e4f2563f5bccf11c196136, @f_f0333d98c8e4f2563f5bccf11c196136, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_f0333d98c8e4f2563f5bccf11c196136, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_e1dac6385749fd1bd4caa7cdfb2b6717 = (SELECT id FROM folders WHERE name = '13-49-出口安全制度' AND parent_id = @f_f0333d98c8e4f2563f5bccf11c196136 AND standard_id = 5 LIMIT 1);
    IF @f_e1dac6385749fd1bd4caa7cdfb2b6717 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-49-出口安全制度', 5, 1, 2, @f_f0333d98c8e4f2563f5bccf11c196136, NOW(), NOW(), '审计部');
        SET @f_e1dac6385749fd1bd4caa7cdfb2b6717 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_e1dac6385749fd1bd4caa7cdfb2b6717, @f_e1dac6385749fd1bd4caa7cdfb2b6717, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_e1dac6385749fd1bd4caa7cdfb2b6717, distance + 1 FROM folder_closure WHERE descendant = @f_f0333d98c8e4f2563f5bccf11c196136;
    END IF;

    SET @f_8963dfd5010fcd96c8786058e1b2dd80 = (SELECT id FROM folders WHERE name = '14-运输工具安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_8963dfd5010fcd96c8786058e1b2dd80 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-运输工具安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_8963dfd5010fcd96c8786058e1b2dd80 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_8963dfd5010fcd96c8786058e1b2dd80, @f_8963dfd5010fcd96c8786058e1b2dd80, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_8963dfd5010fcd96c8786058e1b2dd80, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_92603d42a5c33fdbcd6a9e31e8ead4a7 = (SELECT id FROM folders WHERE name = '14-50-运输工具安全管理制度' AND parent_id = @f_8963dfd5010fcd96c8786058e1b2dd80 AND standard_id = 3 LIMIT 1);
    IF @f_92603d42a5c33fdbcd6a9e31e8ead4a7 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-50-运输工具安全管理制度', 3, 1, 2, @f_8963dfd5010fcd96c8786058e1b2dd80, NOW(), NOW(), '行政');
        SET @f_92603d42a5c33fdbcd6a9e31e8ead4a7 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_92603d42a5c33fdbcd6a9e31e8ead4a7, @f_92603d42a5c33fdbcd6a9e31e8ead4a7, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_92603d42a5c33fdbcd6a9e31e8ead4a7, distance + 1 FROM folder_closure WHERE descendant = @f_8963dfd5010fcd96c8786058e1b2dd80;
    END IF;

    SET @f_8963dfd5010fcd96c8786058e1b2dd80 = (SELECT id FROM folders WHERE name = '14-运输工具安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_8963dfd5010fcd96c8786058e1b2dd80 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-运输工具安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_8963dfd5010fcd96c8786058e1b2dd80 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_8963dfd5010fcd96c8786058e1b2dd80, @f_8963dfd5010fcd96c8786058e1b2dd80, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_8963dfd5010fcd96c8786058e1b2dd80, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_09ff27bfd98cfc67ea24af378128d717 = (SELECT id FROM folders WHERE name = '14-51-运输工具检查' AND parent_id = @f_8963dfd5010fcd96c8786058e1b2dd80 AND standard_id = 3 LIMIT 1);
    IF @f_09ff27bfd98cfc67ea24af378128d717 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-51-运输工具检查', 3, 1, 2, @f_8963dfd5010fcd96c8786058e1b2dd80, NOW(), NOW(), '行政');
        SET @f_09ff27bfd98cfc67ea24af378128d717 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_09ff27bfd98cfc67ea24af378128d717, @f_09ff27bfd98cfc67ea24af378128d717, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_09ff27bfd98cfc67ea24af378128d717, distance + 1 FROM folder_closure WHERE descendant = @f_8963dfd5010fcd96c8786058e1b2dd80;
    END IF;

    SET @f_8963dfd5010fcd96c8786058e1b2dd80 = (SELECT id FROM folders WHERE name = '14-运输工具安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_8963dfd5010fcd96c8786058e1b2dd80 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-运输工具安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_8963dfd5010fcd96c8786058e1b2dd80 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_8963dfd5010fcd96c8786058e1b2dd80, @f_8963dfd5010fcd96c8786058e1b2dd80, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_8963dfd5010fcd96c8786058e1b2dd80, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_b7ad7b5ba6c1baafaa1062c7d4594590 = (SELECT id FROM folders WHERE name = '14-52-运输工具存储制度' AND parent_id = @f_8963dfd5010fcd96c8786058e1b2dd80 AND standard_id = 3 LIMIT 1);
    IF @f_b7ad7b5ba6c1baafaa1062c7d4594590 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-52-运输工具存储制度', 3, 1, 2, @f_8963dfd5010fcd96c8786058e1b2dd80, NOW(), NOW(), '行政');
        SET @f_b7ad7b5ba6c1baafaa1062c7d4594590 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_b7ad7b5ba6c1baafaa1062c7d4594590, @f_b7ad7b5ba6c1baafaa1062c7d4594590, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_b7ad7b5ba6c1baafaa1062c7d4594590, distance + 1 FROM folder_closure WHERE descendant = @f_8963dfd5010fcd96c8786058e1b2dd80;
    END IF;

    SET @f_8963dfd5010fcd96c8786058e1b2dd80 = (SELECT id FROM folders WHERE name = '14-运输工具安全' AND parent_id = 531 AND standard_id = 3 LIMIT 1);
    IF @f_8963dfd5010fcd96c8786058e1b2dd80 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-运输工具安全', 3, 1, 2, 531, NOW(), NOW(), '行政');
        SET @f_8963dfd5010fcd96c8786058e1b2dd80 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_8963dfd5010fcd96c8786058e1b2dd80, @f_8963dfd5010fcd96c8786058e1b2dd80, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_8963dfd5010fcd96c8786058e1b2dd80, distance + 1 FROM folder_closure WHERE descendant = 531;
    END IF;

    SET @f_ba8388249bd8b98c90ed5f51d35de950 = (SELECT id FROM folders WHERE name = '14-53-安全培训' AND parent_id = @f_8963dfd5010fcd96c8786058e1b2dd80 AND standard_id = 3 LIMIT 1);
    IF @f_ba8388249bd8b98c90ed5f51d35de950 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('14-53-安全培训', 3, 1, 2, @f_8963dfd5010fcd96c8786058e1b2dd80, NOW(), NOW(), '行政');
        SET @f_ba8388249bd8b98c90ed5f51d35de950 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_ba8388249bd8b98c90ed5f51d35de950, @f_ba8388249bd8b98c90ed5f51d35de950, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_ba8388249bd8b98c90ed5f51d35de950, distance + 1 FROM folder_closure WHERE descendant = @f_8963dfd5010fcd96c8786058e1b2dd80;
    END IF;

    SET @f_7c93a1d3cf5fd453c840867f0af65b97 = (SELECT id FROM folders WHERE name = '15-商业伙伴安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_7c93a1d3cf5fd453c840867f0af65b97 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-商业伙伴安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_7c93a1d3cf5fd453c840867f0af65b97 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7c93a1d3cf5fd453c840867f0af65b97, @f_7c93a1d3cf5fd453c840867f0af65b97, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7c93a1d3cf5fd453c840867f0af65b97, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_9990d29f82c43e97a2c83ecc22ced356 = (SELECT id FROM folders WHERE name = '15-54-商业伙伴安全管理制度' AND parent_id = @f_7c93a1d3cf5fd453c840867f0af65b97 AND standard_id = 5 LIMIT 1);
    IF @f_9990d29f82c43e97a2c83ecc22ced356 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-54-商业伙伴安全管理制度', 5, 1, 2, @f_7c93a1d3cf5fd453c840867f0af65b97, NOW(), NOW(), '审计部');
        SET @f_9990d29f82c43e97a2c83ecc22ced356 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_9990d29f82c43e97a2c83ecc22ced356, @f_9990d29f82c43e97a2c83ecc22ced356, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_9990d29f82c43e97a2c83ecc22ced356, distance + 1 FROM folder_closure WHERE descendant = @f_7c93a1d3cf5fd453c840867f0af65b97;
    END IF;

    SET @f_7c93a1d3cf5fd453c840867f0af65b97 = (SELECT id FROM folders WHERE name = '15-商业伙伴安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_7c93a1d3cf5fd453c840867f0af65b97 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-商业伙伴安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_7c93a1d3cf5fd453c840867f0af65b97 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7c93a1d3cf5fd453c840867f0af65b97, @f_7c93a1d3cf5fd453c840867f0af65b97, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7c93a1d3cf5fd453c840867f0af65b97, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_7d914029799fb2732603050bb90e52fe = (SELECT id FROM folders WHERE name = '15-55-全面评估' AND parent_id = @f_7c93a1d3cf5fd453c840867f0af65b97 AND standard_id = 5 LIMIT 1);
    IF @f_7d914029799fb2732603050bb90e52fe IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-55-全面评估', 5, 1, 2, @f_7c93a1d3cf5fd453c840867f0af65b97, NOW(), NOW(), '审计部');
        SET @f_7d914029799fb2732603050bb90e52fe = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7d914029799fb2732603050bb90e52fe, @f_7d914029799fb2732603050bb90e52fe, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7d914029799fb2732603050bb90e52fe, distance + 1 FROM folder_closure WHERE descendant = @f_7c93a1d3cf5fd453c840867f0af65b97;
    END IF;

    SET @f_7c93a1d3cf5fd453c840867f0af65b97 = (SELECT id FROM folders WHERE name = '15-商业伙伴安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_7c93a1d3cf5fd453c840867f0af65b97 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-商业伙伴安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_7c93a1d3cf5fd453c840867f0af65b97 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7c93a1d3cf5fd453c840867f0af65b97, @f_7c93a1d3cf5fd453c840867f0af65b97, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7c93a1d3cf5fd453c840867f0af65b97, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_5d24657dcddf514da24e2617a34d3af2 = (SELECT id FROM folders WHERE name = '15-56-优化贸易安全管理书面文件' AND parent_id = @f_7c93a1d3cf5fd453c840867f0af65b97 AND standard_id = 5 LIMIT 1);
    IF @f_5d24657dcddf514da24e2617a34d3af2 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-56-优化贸易安全管理书面文件', 5, 1, 2, @f_7c93a1d3cf5fd453c840867f0af65b97, NOW(), NOW(), '审计部');
        SET @f_5d24657dcddf514da24e2617a34d3af2 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_5d24657dcddf514da24e2617a34d3af2, @f_5d24657dcddf514da24e2617a34d3af2, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_5d24657dcddf514da24e2617a34d3af2, distance + 1 FROM folder_closure WHERE descendant = @f_7c93a1d3cf5fd453c840867f0af65b97;
    END IF;

    SET @f_7c93a1d3cf5fd453c840867f0af65b97 = (SELECT id FROM folders WHERE name = '15-商业伙伴安全' AND parent_id = 546 AND standard_id = 5 LIMIT 1);
    IF @f_7c93a1d3cf5fd453c840867f0af65b97 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-商业伙伴安全', 5, 1, 2, 546, NOW(), NOW(), '审计部');
        SET @f_7c93a1d3cf5fd453c840867f0af65b97 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7c93a1d3cf5fd453c840867f0af65b97, @f_7c93a1d3cf5fd453c840867f0af65b97, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7c93a1d3cf5fd453c840867f0af65b97, distance + 1 FROM folder_closure WHERE descendant = 546;
    END IF;

    SET @f_5da59f1a402ec3c339c1670fbd166ef1 = (SELECT id FROM folders WHERE name = '15-57-监控检查' AND parent_id = @f_7c93a1d3cf5fd453c840867f0af65b97 AND standard_id = 5 LIMIT 1);
    IF @f_5da59f1a402ec3c339c1670fbd166ef1 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('15-57-监控检查', 5, 1, 2, @f_7c93a1d3cf5fd453c840867f0af65b97, NOW(), NOW(), '审计部');
        SET @f_5da59f1a402ec3c339c1670fbd166ef1 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_5da59f1a402ec3c339c1670fbd166ef1, @f_5da59f1a402ec3c339c1670fbd166ef1, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_5da59f1a402ec3c339c1670fbd166ef1, distance + 1 FROM folder_closure WHERE descendant = @f_7c93a1d3cf5fd453c840867f0af65b97;
    END IF;

    SET @f_b3c0f892b9fa25b018d797e36564be9c = (SELECT id FROM folders WHERE name = '16-海关业务和贸易安全培训' AND parent_id = 553 AND standard_id = 4 LIMIT 1);
    IF @f_b3c0f892b9fa25b018d797e36564be9c IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-海关业务和贸易安全培训', 4, 1, 2, 553, NOW(), NOW(), '关务');
        SET @f_b3c0f892b9fa25b018d797e36564be9c = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_b3c0f892b9fa25b018d797e36564be9c, @f_b3c0f892b9fa25b018d797e36564be9c, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_b3c0f892b9fa25b018d797e36564be9c, distance + 1 FROM folder_closure WHERE descendant = 553;
    END IF;

    SET @f_d32daf863a47dded9a628d23840d8370 = (SELECT id FROM folders WHERE name = '16-58-法律法规和贸易安全内部培训制度' AND parent_id = @f_b3c0f892b9fa25b018d797e36564be9c AND standard_id = 4 LIMIT 1);
    IF @f_d32daf863a47dded9a628d23840d8370 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-58-法律法规和贸易安全内部培训制度', 4, 1, 2, @f_b3c0f892b9fa25b018d797e36564be9c, NOW(), NOW(), '关务');
        SET @f_d32daf863a47dded9a628d23840d8370 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_d32daf863a47dded9a628d23840d8370, @f_d32daf863a47dded9a628d23840d8370, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_d32daf863a47dded9a628d23840d8370, distance + 1 FROM folder_closure WHERE descendant = @f_b3c0f892b9fa25b018d797e36564be9c;
    END IF;

    SET @f_b3c0f892b9fa25b018d797e36564be9c = (SELECT id FROM folders WHERE name = '16-海关业务和贸易安全培训' AND parent_id = 553 AND standard_id = 4 LIMIT 1);
    IF @f_b3c0f892b9fa25b018d797e36564be9c IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-海关业务和贸易安全培训', 4, 1, 2, 553, NOW(), NOW(), '关务');
        SET @f_b3c0f892b9fa25b018d797e36564be9c = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_b3c0f892b9fa25b018d797e36564be9c, @f_b3c0f892b9fa25b018d797e36564be9c, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_b3c0f892b9fa25b018d797e36564be9c, distance + 1 FROM folder_closure WHERE descendant = 553;
    END IF;

    SET @f_26d3ec10693826d19e062f201ffa4c30 = (SELECT id FROM folders WHERE name = '16-59-海关法律法规培训' AND parent_id = @f_b3c0f892b9fa25b018d797e36564be9c AND standard_id = 4 LIMIT 1);
    IF @f_26d3ec10693826d19e062f201ffa4c30 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-59-海关法律法规培训', 4, 1, 2, @f_b3c0f892b9fa25b018d797e36564be9c, NOW(), NOW(), '关务');
        SET @f_26d3ec10693826d19e062f201ffa4c30 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_26d3ec10693826d19e062f201ffa4c30, @f_26d3ec10693826d19e062f201ffa4c30, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_26d3ec10693826d19e062f201ffa4c30, distance + 1 FROM folder_closure WHERE descendant = @f_b3c0f892b9fa25b018d797e36564be9c;
    END IF;

    SET @f_b3c0f892b9fa25b018d797e36564be9c = (SELECT id FROM folders WHERE name = '16-海关业务和贸易安全培训' AND parent_id = 553 AND standard_id = 4 LIMIT 1);
    IF @f_b3c0f892b9fa25b018d797e36564be9c IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-海关业务和贸易安全培训', 4, 1, 2, 553, NOW(), NOW(), '关务');
        SET @f_b3c0f892b9fa25b018d797e36564be9c = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_b3c0f892b9fa25b018d797e36564be9c, @f_b3c0f892b9fa25b018d797e36564be9c, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_b3c0f892b9fa25b018d797e36564be9c, distance + 1 FROM folder_closure WHERE descendant = 553;
    END IF;

    SET @f_0dfd8c7dbbace22af75b81323a3f37a9 = (SELECT id FROM folders WHERE name = '16-60-货物安全培训' AND parent_id = @f_b3c0f892b9fa25b018d797e36564be9c AND standard_id = 4 LIMIT 1);
    IF @f_0dfd8c7dbbace22af75b81323a3f37a9 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-60-货物安全培训', 4, 1, 2, @f_b3c0f892b9fa25b018d797e36564be9c, NOW(), NOW(), '关务');
        SET @f_0dfd8c7dbbace22af75b81323a3f37a9 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_0dfd8c7dbbace22af75b81323a3f37a9, @f_0dfd8c7dbbace22af75b81323a3f37a9, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_0dfd8c7dbbace22af75b81323a3f37a9, distance + 1 FROM folder_closure WHERE descendant = @f_b3c0f892b9fa25b018d797e36564be9c;
    END IF;

    SET @f_b3c0f892b9fa25b018d797e36564be9c = (SELECT id FROM folders WHERE name = '16-海关业务和贸易安全培训' AND parent_id = 553 AND standard_id = 4 LIMIT 1);
    IF @f_b3c0f892b9fa25b018d797e36564be9c IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-海关业务和贸易安全培训', 4, 1, 2, 553, NOW(), NOW(), '关务');
        SET @f_b3c0f892b9fa25b018d797e36564be9c = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_b3c0f892b9fa25b018d797e36564be9c, @f_b3c0f892b9fa25b018d797e36564be9c, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_b3c0f892b9fa25b018d797e36564be9c, distance + 1 FROM folder_closure WHERE descendant = 553;
    END IF;

    SET @f_3a6881be96d9c5989574ad2affaa658c = (SELECT id FROM folders WHERE name = '16-61-危机管理培训' AND parent_id = @f_b3c0f892b9fa25b018d797e36564be9c AND standard_id = 4 LIMIT 1);
    IF @f_3a6881be96d9c5989574ad2affaa658c IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-61-危机管理培训', 4, 1, 2, @f_b3c0f892b9fa25b018d797e36564be9c, NOW(), NOW(), '关务');
        SET @f_3a6881be96d9c5989574ad2affaa658c = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_3a6881be96d9c5989574ad2affaa658c, @f_3a6881be96d9c5989574ad2affaa658c, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_3a6881be96d9c5989574ad2affaa658c, distance + 1 FROM folder_closure WHERE descendant = @f_b3c0f892b9fa25b018d797e36564be9c;
    END IF;

    SET @f_b3c0f892b9fa25b018d797e36564be9c = (SELECT id FROM folders WHERE name = '16-海关业务和贸易安全培训' AND parent_id = 553 AND standard_id = 4 LIMIT 1);
    IF @f_b3c0f892b9fa25b018d797e36564be9c IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-海关业务和贸易安全培训', 4, 1, 2, 553, NOW(), NOW(), '关务');
        SET @f_b3c0f892b9fa25b018d797e36564be9c = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_b3c0f892b9fa25b018d797e36564be9c, @f_b3c0f892b9fa25b018d797e36564be9c, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_b3c0f892b9fa25b018d797e36564be9c, distance + 1 FROM folder_closure WHERE descendant = 553;
    END IF;

    SET @f_278beadba9cc8a616d125cd1b972e763 = (SELECT id FROM folders WHERE name = '16-62-信息安全培训' AND parent_id = @f_b3c0f892b9fa25b018d797e36564be9c AND standard_id = 4 LIMIT 1);
    IF @f_278beadba9cc8a616d125cd1b972e763 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('16-62-信息安全培训', 4, 1, 2, @f_b3c0f892b9fa25b018d797e36564be9c, NOW(), NOW(), '关务');
        SET @f_278beadba9cc8a616d125cd1b972e763 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_278beadba9cc8a616d125cd1b972e763, @f_278beadba9cc8a616d125cd1b972e763, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_278beadba9cc8a616d125cd1b972e763, distance + 1 FROM folder_closure WHERE descendant = @f_b3c0f892b9fa25b018d797e36564be9c;
    END IF;

    SET @f_fe89ed094ebe40ca3e087e171d2fa996 = (SELECT id FROM folders WHERE name = '4-商检制度与台账' AND parent_id = 266 AND standard_id = 6 LIMIT 1);
    IF @f_fe89ed094ebe40ca3e087e171d2fa996 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-商检制度与台账', 6, 1, 2, 266, NOW(), NOW(), '单项标准');
        SET @f_fe89ed094ebe40ca3e087e171d2fa996 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_fe89ed094ebe40ca3e087e171d2fa996, @f_fe89ed094ebe40ca3e087e171d2fa996, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_fe89ed094ebe40ca3e087e171d2fa996, distance + 1 FROM folder_closure WHERE descendant = 266;
    END IF;

    SET @f_75db620cc01a0de68c2101516e72d208 = (SELECT id FROM folders WHERE name = '4-4-1-管理制度' AND parent_id = @f_fe89ed094ebe40ca3e087e171d2fa996 AND standard_id = 6 LIMIT 1);
    IF @f_75db620cc01a0de68c2101516e72d208 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-4-1-管理制度', 6, 1, 2, @f_fe89ed094ebe40ca3e087e171d2fa996, NOW(), NOW(), '单项标准');
        SET @f_75db620cc01a0de68c2101516e72d208 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_75db620cc01a0de68c2101516e72d208, @f_75db620cc01a0de68c2101516e72d208, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_75db620cc01a0de68c2101516e72d208, distance + 1 FROM folder_closure WHERE descendant = @f_fe89ed094ebe40ca3e087e171d2fa996;
    END IF;

    SET @f_fe89ed094ebe40ca3e087e171d2fa996 = (SELECT id FROM folders WHERE name = '4-商检制度与台账' AND parent_id = 266 AND standard_id = 6 LIMIT 1);
    IF @f_fe89ed094ebe40ca3e087e171d2fa996 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-商检制度与台账', 6, 1, 2, 266, NOW(), NOW(), '单项标准');
        SET @f_fe89ed094ebe40ca3e087e171d2fa996 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_fe89ed094ebe40ca3e087e171d2fa996, @f_fe89ed094ebe40ca3e087e171d2fa996, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_fe89ed094ebe40ca3e087e171d2fa996, distance + 1 FROM folder_closure WHERE descendant = 266;
    END IF;

    SET @f_78e502dfaa31e9656eadf162fd69b318 = (SELECT id FROM folders WHERE name = '4-4-3-抽查单证' AND parent_id = @f_fe89ed094ebe40ca3e087e171d2fa996 AND standard_id = 6 LIMIT 1);
    IF @f_78e502dfaa31e9656eadf162fd69b318 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-4-3-抽查单证', 6, 1, 2, @f_fe89ed094ebe40ca3e087e171d2fa996, NOW(), NOW(), '单项标准');
        SET @f_78e502dfaa31e9656eadf162fd69b318 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_78e502dfaa31e9656eadf162fd69b318, @f_78e502dfaa31e9656eadf162fd69b318, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_78e502dfaa31e9656eadf162fd69b318, distance + 1 FROM folder_closure WHERE descendant = @f_fe89ed094ebe40ca3e087e171d2fa996;
    END IF;

    SET @f_fe89ed094ebe40ca3e087e171d2fa996 = (SELECT id FROM folders WHERE name = '4-商检制度与台账' AND parent_id = 266 AND standard_id = 6 LIMIT 1);
    IF @f_fe89ed094ebe40ca3e087e171d2fa996 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-商检制度与台账', 6, 1, 2, 266, NOW(), NOW(), '单项标准');
        SET @f_fe89ed094ebe40ca3e087e171d2fa996 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_fe89ed094ebe40ca3e087e171d2fa996, @f_fe89ed094ebe40ca3e087e171d2fa996, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_fe89ed094ebe40ca3e087e171d2fa996, distance + 1 FROM folder_closure WHERE descendant = 266;
    END IF;

    SET @f_8f03a3809245319695cdb3d10eb2714c = (SELECT id FROM folders WHERE name = '4-4-4-熏蒸板记录' AND parent_id = @f_fe89ed094ebe40ca3e087e171d2fa996 AND standard_id = 6 LIMIT 1);
    IF @f_8f03a3809245319695cdb3d10eb2714c IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-4-4-熏蒸板记录', 6, 1, 2, @f_fe89ed094ebe40ca3e087e171d2fa996, NOW(), NOW(), '单项标准');
        SET @f_8f03a3809245319695cdb3d10eb2714c = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_8f03a3809245319695cdb3d10eb2714c, @f_8f03a3809245319695cdb3d10eb2714c, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_8f03a3809245319695cdb3d10eb2714c, distance + 1 FROM folder_closure WHERE descendant = @f_fe89ed094ebe40ca3e087e171d2fa996;
    END IF;

    SET @f_b10ee10c417fecf06b113580f651f1e6 = (SELECT id FROM folders WHERE name = '2-特殊物品单证' AND parent_id = 265 AND standard_id = 6 LIMIT 1);
    IF @f_b10ee10c417fecf06b113580f651f1e6 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-特殊物品单证', 6, 1, 2, 265, NOW(), NOW(), '单项标准');
        SET @f_b10ee10c417fecf06b113580f651f1e6 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_b10ee10c417fecf06b113580f651f1e6, @f_b10ee10c417fecf06b113580f651f1e6, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_b10ee10c417fecf06b113580f651f1e6, distance + 1 FROM folder_closure WHERE descendant = 265;
    END IF;

    SET @f_4d26e6c91a5b734547908f9305ea2a5f = (SELECT id FROM folders WHERE name = '3-特殊物品安全管理制度' AND parent_id = 265 AND standard_id = 6 LIMIT 1);
    IF @f_4d26e6c91a5b734547908f9305ea2a5f IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-特殊物品安全管理制度', 6, 1, 2, 265, NOW(), NOW(), '单项标准');
        SET @f_4d26e6c91a5b734547908f9305ea2a5f = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_4d26e6c91a5b734547908f9305ea2a5f, @f_4d26e6c91a5b734547908f9305ea2a5f, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_4d26e6c91a5b734547908f9305ea2a5f, distance + 1 FROM folder_closure WHERE descendant = 265;
    END IF;

    SET @f_bc8ec9e78d821e895a63093869421c47 = (SELECT id FROM folders WHERE name = '1-单证复核及系统逻辑检验' AND parent_id = 264 AND standard_id = 6 LIMIT 1);
    IF @f_bc8ec9e78d821e895a63093869421c47 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-单证复核及系统逻辑检验', 6, 1, 2, 264, NOW(), NOW(), '单项标准');
        SET @f_bc8ec9e78d821e895a63093869421c47 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_bc8ec9e78d821e895a63093869421c47, @f_bc8ec9e78d821e895a63093869421c47, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_bc8ec9e78d821e895a63093869421c47, distance + 1 FROM folder_closure WHERE descendant = 264;
    END IF;

    SET @f_fe89ed094ebe40ca3e087e171d2fa996 = (SELECT id FROM folders WHERE name = '4-商检制度与台账' AND parent_id = 266 AND standard_id = 6 LIMIT 1);
    IF @f_fe89ed094ebe40ca3e087e171d2fa996 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-商检制度与台账', 6, 1, 2, 266, NOW(), NOW(), '单项标准');
        SET @f_fe89ed094ebe40ca3e087e171d2fa996 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_fe89ed094ebe40ca3e087e171d2fa996, @f_fe89ed094ebe40ca3e087e171d2fa996, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_fe89ed094ebe40ca3e087e171d2fa996, distance + 1 FROM folder_closure WHERE descendant = 266;
    END IF;

    SET @f_dd6c90bb716fed24dbd0389e2604eb19 = (SELECT id FROM folders WHERE name = '4-4-2-进境商检查验管理台账' AND parent_id = @f_fe89ed094ebe40ca3e087e171d2fa996 AND standard_id = 6 LIMIT 1);
    IF @f_dd6c90bb716fed24dbd0389e2604eb19 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('4-4-2-进境商检查验管理台账', 6, 1, 2, @f_fe89ed094ebe40ca3e087e171d2fa996, NOW(), NOW(), '单项标准');
        SET @f_dd6c90bb716fed24dbd0389e2604eb19 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_dd6c90bb716fed24dbd0389e2604eb19, @f_dd6c90bb716fed24dbd0389e2604eb19, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_dd6c90bb716fed24dbd0389e2604eb19, distance + 1 FROM folder_closure WHERE descendant = @f_fe89ed094ebe40ca3e087e171d2fa996;
    END IF;

    SET @f_780dbca59d8bc74473fb0d5b6f71282c = (SELECT id FROM folders WHERE name = '9-法检制度' AND parent_id = 267 AND standard_id = 6 LIMIT 1);
    IF @f_780dbca59d8bc74473fb0d5b6f71282c IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('9-法检制度', 6, 1, 2, 267, NOW(), NOW(), '单项标准');
        SET @f_780dbca59d8bc74473fb0d5b6f71282c = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_780dbca59d8bc74473fb0d5b6f71282c, @f_780dbca59d8bc74473fb0d5b6f71282c, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_780dbca59d8bc74473fb0d5b6f71282c, distance + 1 FROM folder_closure WHERE descendant = 267;
    END IF;

    SET @f_2648ecdb4284cb709576ed37051af3df = (SELECT id FROM folders WHERE name = '运输工具管理制度' AND parent_id = 268 AND standard_id = 6 LIMIT 1);
    IF @f_2648ecdb4284cb709576ed37051af3df IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('运输工具管理制度', 6, 1, 2, 268, NOW(), NOW(), '单项标准');
        SET @f_2648ecdb4284cb709576ed37051af3df = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_2648ecdb4284cb709576ed37051af3df, @f_2648ecdb4284cb709576ed37051af3df, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_2648ecdb4284cb709576ed37051af3df, distance + 1 FROM folder_closure WHERE descendant = 268;
    END IF;

    SET @f_aa78f14991113157f1cf3b11f78995d0 = (SELECT id FROM folders WHERE name = '运输工具行驶轨迹' AND parent_id = 268 AND standard_id = 6 LIMIT 1);
    IF @f_aa78f14991113157f1cf3b11f78995d0 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('运输工具行驶轨迹', 6, 1, 2, 268, NOW(), NOW(), '单项标准');
        SET @f_aa78f14991113157f1cf3b11f78995d0 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_aa78f14991113157f1cf3b11f78995d0, @f_aa78f14991113157f1cf3b11f78995d0, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_aa78f14991113157f1cf3b11f78995d0, distance + 1 FROM folder_closure WHERE descendant = 268;
    END IF;

    SET @f_e3568d067d64a020afd3bfd90787756d = (SELECT id FROM folders WHERE name = '21-1-定位系统车载终端管理制度' AND parent_id = @f_aa78f14991113157f1cf3b11f78995d0 AND standard_id = 6 LIMIT 1);
    IF @f_e3568d067d64a020afd3bfd90787756d IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('21-1-定位系统车载终端管理制度', 6, 1, 2, @f_aa78f14991113157f1cf3b11f78995d0, NOW(), NOW(), '单项标准');
        SET @f_e3568d067d64a020afd3bfd90787756d = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_e3568d067d64a020afd3bfd90787756d, @f_e3568d067d64a020afd3bfd90787756d, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_e3568d067d64a020afd3bfd90787756d, distance + 1 FROM folder_closure WHERE descendant = @f_aa78f14991113157f1cf3b11f78995d0;
    END IF;

    SET @f_aa78f14991113157f1cf3b11f78995d0 = (SELECT id FROM folders WHERE name = '运输工具行驶轨迹' AND parent_id = 268 AND standard_id = 6 LIMIT 1);
    IF @f_aa78f14991113157f1cf3b11f78995d0 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('运输工具行驶轨迹', 6, 1, 2, 268, NOW(), NOW(), '单项标准');
        SET @f_aa78f14991113157f1cf3b11f78995d0 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_aa78f14991113157f1cf3b11f78995d0, @f_aa78f14991113157f1cf3b11f78995d0, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_aa78f14991113157f1cf3b11f78995d0, distance + 1 FROM folder_closure WHERE descendant = 268;
    END IF;

    SET @f_9f0e7cea82de96cb4db5c6fa63070f26 = (SELECT id FROM folders WHERE name = '21-2-车辆行驶轨迹监控记录' AND parent_id = @f_aa78f14991113157f1cf3b11f78995d0 AND standard_id = 6 LIMIT 1);
    IF @f_9f0e7cea82de96cb4db5c6fa63070f26 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('21-2-车辆行驶轨迹监控记录', 6, 1, 2, @f_aa78f14991113157f1cf3b11f78995d0, NOW(), NOW(), '单项标准');
        SET @f_9f0e7cea82de96cb4db5c6fa63070f26 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_9f0e7cea82de96cb4db5c6fa63070f26, @f_9f0e7cea82de96cb4db5c6fa63070f26, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_9f0e7cea82de96cb4db5c6fa63070f26, distance + 1 FROM folder_closure WHERE descendant = @f_aa78f14991113157f1cf3b11f78995d0;
    END IF;

    SET @f_5ca3dfdcfe924a55a109c0e1d7d3e146 = (SELECT id FROM folders WHERE name = '运输工具与驾驶人员匹配制度' AND parent_id = 268 AND standard_id = 6 LIMIT 1);
    IF @f_5ca3dfdcfe924a55a109c0e1d7d3e146 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('运输工具与驾驶人员匹配制度', 6, 1, 2, 268, NOW(), NOW(), '单项标准');
        SET @f_5ca3dfdcfe924a55a109c0e1d7d3e146 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_5ca3dfdcfe924a55a109c0e1d7d3e146, @f_5ca3dfdcfe924a55a109c0e1d7d3e146, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_5ca3dfdcfe924a55a109c0e1d7d3e146, distance + 1 FROM folder_closure WHERE descendant = 268;
    END IF;

    SET @f_df8cffbee2ff15c98cb8247f3f3a6f10 = (SELECT id FROM folders WHERE name = '22-1-运输工具与驾驶人员匹配管理制度' AND parent_id = @f_5ca3dfdcfe924a55a109c0e1d7d3e146 AND standard_id = 6 LIMIT 1);
    IF @f_df8cffbee2ff15c98cb8247f3f3a6f10 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('22-1-运输工具与驾驶人员匹配管理制度', 6, 1, 2, @f_5ca3dfdcfe924a55a109c0e1d7d3e146, NOW(), NOW(), '单项标准');
        SET @f_df8cffbee2ff15c98cb8247f3f3a6f10 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_df8cffbee2ff15c98cb8247f3f3a6f10, @f_df8cffbee2ff15c98cb8247f3f3a6f10, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_df8cffbee2ff15c98cb8247f3f3a6f10, distance + 1 FROM folder_closure WHERE descendant = @f_5ca3dfdcfe924a55a109c0e1d7d3e146;
    END IF;

    SET @f_5ca3dfdcfe924a55a109c0e1d7d3e146 = (SELECT id FROM folders WHERE name = '运输工具与驾驶人员匹配制度' AND parent_id = 268 AND standard_id = 6 LIMIT 1);
    IF @f_5ca3dfdcfe924a55a109c0e1d7d3e146 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('运输工具与驾驶人员匹配制度', 6, 1, 2, 268, NOW(), NOW(), '单项标准');
        SET @f_5ca3dfdcfe924a55a109c0e1d7d3e146 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_5ca3dfdcfe924a55a109c0e1d7d3e146, @f_5ca3dfdcfe924a55a109c0e1d7d3e146, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_5ca3dfdcfe924a55a109c0e1d7d3e146, distance + 1 FROM folder_closure WHERE descendant = 268;
    END IF;

    SET @f_246460b03ce03dc9028df14f9b70e6a5 = (SELECT id FROM folders WHERE name = '22-2-台账记录' AND parent_id = @f_5ca3dfdcfe924a55a109c0e1d7d3e146 AND standard_id = 6 LIMIT 1);
    IF @f_246460b03ce03dc9028df14f9b70e6a5 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('22-2-台账记录', 6, 1, 2, @f_5ca3dfdcfe924a55a109c0e1d7d3e146, NOW(), NOW(), '单项标准');
        SET @f_246460b03ce03dc9028df14f9b70e6a5 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_246460b03ce03dc9028df14f9b70e6a5, @f_246460b03ce03dc9028df14f9b70e6a5, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_246460b03ce03dc9028df14f9b70e6a5, distance + 1 FROM folder_closure WHERE descendant = @f_5ca3dfdcfe924a55a109c0e1d7d3e146;
    END IF;

    SET @f_7e16d3c44b50d5e60e05fef9a33409f5 = (SELECT id FROM folders WHERE name = '11-单证复核及系统逻辑检验' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_7e16d3c44b50d5e60e05fef9a33409f5 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-单证复核及系统逻辑检验', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_7e16d3c44b50d5e60e05fef9a33409f5 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7e16d3c44b50d5e60e05fef9a33409f5, @f_7e16d3c44b50d5e60e05fef9a33409f5, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7e16d3c44b50d5e60e05fef9a33409f5, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_e56b9c928628984a8e2776d1385d5d21 = (SELECT id FROM folders WHERE name = '1-1-进出口单证及复核制度文件' AND parent_id = @f_7e16d3c44b50d5e60e05fef9a33409f5 AND standard_id = 6 LIMIT 1);
    IF @f_e56b9c928628984a8e2776d1385d5d21 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-1-进出口单证及复核制度文件', 6, 1, 2, @f_7e16d3c44b50d5e60e05fef9a33409f5, NOW(), NOW(), '单项标准');
        SET @f_e56b9c928628984a8e2776d1385d5d21 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_e56b9c928628984a8e2776d1385d5d21, @f_e56b9c928628984a8e2776d1385d5d21, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_e56b9c928628984a8e2776d1385d5d21, distance + 1 FROM folder_closure WHERE descendant = @f_7e16d3c44b50d5e60e05fef9a33409f5;
    END IF;

    SET @f_7e16d3c44b50d5e60e05fef9a33409f5 = (SELECT id FROM folders WHERE name = '11-单证复核及系统逻辑检验' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_7e16d3c44b50d5e60e05fef9a33409f5 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-单证复核及系统逻辑检验', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_7e16d3c44b50d5e60e05fef9a33409f5 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7e16d3c44b50d5e60e05fef9a33409f5, @f_7e16d3c44b50d5e60e05fef9a33409f5, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7e16d3c44b50d5e60e05fef9a33409f5, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_33a23502eacd7c57698a6fc37eed6745 = (SELECT id FROM folders WHERE name = '1-2-系统复审界面截屏' AND parent_id = @f_7e16d3c44b50d5e60e05fef9a33409f5 AND standard_id = 6 LIMIT 1);
    IF @f_33a23502eacd7c57698a6fc37eed6745 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-2-系统复审界面截屏', 6, 1, 2, @f_7e16d3c44b50d5e60e05fef9a33409f5, NOW(), NOW(), '单项标准');
        SET @f_33a23502eacd7c57698a6fc37eed6745 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_33a23502eacd7c57698a6fc37eed6745, @f_33a23502eacd7c57698a6fc37eed6745, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_33a23502eacd7c57698a6fc37eed6745, distance + 1 FROM folder_closure WHERE descendant = @f_7e16d3c44b50d5e60e05fef9a33409f5;
    END IF;

    SET @f_7e16d3c44b50d5e60e05fef9a33409f5 = (SELECT id FROM folders WHERE name = '11-单证复核及系统逻辑检验' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_7e16d3c44b50d5e60e05fef9a33409f5 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-单证复核及系统逻辑检验', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_7e16d3c44b50d5e60e05fef9a33409f5 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7e16d3c44b50d5e60e05fef9a33409f5, @f_7e16d3c44b50d5e60e05fef9a33409f5, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7e16d3c44b50d5e60e05fef9a33409f5, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_854ae3707b7af1653c362b7d3f4b0fc9 = (SELECT id FROM folders WHERE name = '1-3-历年退改单率统计' AND parent_id = @f_7e16d3c44b50d5e60e05fef9a33409f5 AND standard_id = 6 LIMIT 1);
    IF @f_854ae3707b7af1653c362b7d3f4b0fc9 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-3-历年退改单率统计', 6, 1, 2, @f_7e16d3c44b50d5e60e05fef9a33409f5, NOW(), NOW(), '单项标准');
        SET @f_854ae3707b7af1653c362b7d3f4b0fc9 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_854ae3707b7af1653c362b7d3f4b0fc9, @f_854ae3707b7af1653c362b7d3f4b0fc9, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_854ae3707b7af1653c362b7d3f4b0fc9, distance + 1 FROM folder_closure WHERE descendant = @f_7e16d3c44b50d5e60e05fef9a33409f5;
    END IF;

    SET @f_7e16d3c44b50d5e60e05fef9a33409f5 = (SELECT id FROM folders WHERE name = '11-单证复核及系统逻辑检验' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_7e16d3c44b50d5e60e05fef9a33409f5 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-单证复核及系统逻辑检验', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_7e16d3c44b50d5e60e05fef9a33409f5 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7e16d3c44b50d5e60e05fef9a33409f5, @f_7e16d3c44b50d5e60e05fef9a33409f5, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7e16d3c44b50d5e60e05fef9a33409f5, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_26361bcc28dfcbb4fb4339ee671939b6 = (SELECT id FROM folders WHERE name = '1-4-历年单一窗口数据取值截屏' AND parent_id = @f_7e16d3c44b50d5e60e05fef9a33409f5 AND standard_id = 6 LIMIT 1);
    IF @f_26361bcc28dfcbb4fb4339ee671939b6 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-4-历年单一窗口数据取值截屏', 6, 1, 2, @f_7e16d3c44b50d5e60e05fef9a33409f5, NOW(), NOW(), '单项标准');
        SET @f_26361bcc28dfcbb4fb4339ee671939b6 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_26361bcc28dfcbb4fb4339ee671939b6, @f_26361bcc28dfcbb4fb4339ee671939b6, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_26361bcc28dfcbb4fb4339ee671939b6, distance + 1 FROM folder_closure WHERE descendant = @f_7e16d3c44b50d5e60e05fef9a33409f5;
    END IF;

    SET @f_7e16d3c44b50d5e60e05fef9a33409f5 = (SELECT id FROM folders WHERE name = '11-单证复核及系统逻辑检验' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_7e16d3c44b50d5e60e05fef9a33409f5 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-单证复核及系统逻辑检验', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_7e16d3c44b50d5e60e05fef9a33409f5 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7e16d3c44b50d5e60e05fef9a33409f5, @f_7e16d3c44b50d5e60e05fef9a33409f5, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7e16d3c44b50d5e60e05fef9a33409f5, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_6fff0ae37a844f02f381404447a4f5af = (SELECT id FROM folders WHERE name = '1-5-系统逻辑检验截屏' AND parent_id = @f_7e16d3c44b50d5e60e05fef9a33409f5 AND standard_id = 6 LIMIT 1);
    IF @f_6fff0ae37a844f02f381404447a4f5af IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-5-系统逻辑检验截屏', 6, 1, 2, @f_7e16d3c44b50d5e60e05fef9a33409f5, NOW(), NOW(), '单项标准');
        SET @f_6fff0ae37a844f02f381404447a4f5af = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_6fff0ae37a844f02f381404447a4f5af, @f_6fff0ae37a844f02f381404447a4f5af, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_6fff0ae37a844f02f381404447a4f5af, distance + 1 FROM folder_closure WHERE descendant = @f_7e16d3c44b50d5e60e05fef9a33409f5;
    END IF;

    SET @f_7e16d3c44b50d5e60e05fef9a33409f5 = (SELECT id FROM folders WHERE name = '11-单证复核及系统逻辑检验' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_7e16d3c44b50d5e60e05fef9a33409f5 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-单证复核及系统逻辑检验', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_7e16d3c44b50d5e60e05fef9a33409f5 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_7e16d3c44b50d5e60e05fef9a33409f5, @f_7e16d3c44b50d5e60e05fef9a33409f5, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_7e16d3c44b50d5e60e05fef9a33409f5, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_4199d99723e0742ebe0c174bdcf6b776 = (SELECT id FROM folders WHERE name = '1-6-历年单证抽取记录' AND parent_id = @f_7e16d3c44b50d5e60e05fef9a33409f5 AND standard_id = 6 LIMIT 1);
    IF @f_4199d99723e0742ebe0c174bdcf6b776 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('1-6-历年单证抽取记录', 6, 1, 2, @f_7e16d3c44b50d5e60e05fef9a33409f5, NOW(), NOW(), '单项标准');
        SET @f_4199d99723e0742ebe0c174bdcf6b776 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_4199d99723e0742ebe0c174bdcf6b776, @f_4199d99723e0742ebe0c174bdcf6b776, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_4199d99723e0742ebe0c174bdcf6b776, distance + 1 FROM folder_closure WHERE descendant = @f_7e16d3c44b50d5e60e05fef9a33409f5;
    END IF;

    SET @f_72b8babe3883605f49791d28d9cfffd7 = (SELECT id FROM folders WHERE name = '12-海关法律法规培训' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_72b8babe3883605f49791d28d9cfffd7 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-海关法律法规培训', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_72b8babe3883605f49791d28d9cfffd7 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_72b8babe3883605f49791d28d9cfffd7, @f_72b8babe3883605f49791d28d9cfffd7, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_72b8babe3883605f49791d28d9cfffd7, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_9b620604a3bca5eada3cdb63ab76aa38 = (SELECT id FROM folders WHERE name = '2-7-海关法律法规培训管理办法' AND parent_id = @f_72b8babe3883605f49791d28d9cfffd7 AND standard_id = 6 LIMIT 1);
    IF @f_9b620604a3bca5eada3cdb63ab76aa38 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-7-海关法律法规培训管理办法', 6, 1, 2, @f_72b8babe3883605f49791d28d9cfffd7, NOW(), NOW(), '单项标准');
        SET @f_9b620604a3bca5eada3cdb63ab76aa38 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_9b620604a3bca5eada3cdb63ab76aa38, @f_9b620604a3bca5eada3cdb63ab76aa38, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_9b620604a3bca5eada3cdb63ab76aa38, distance + 1 FROM folder_closure WHERE descendant = @f_72b8babe3883605f49791d28d9cfffd7;
    END IF;

    SET @f_72b8babe3883605f49791d28d9cfffd7 = (SELECT id FROM folders WHERE name = '12-海关法律法规培训' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_72b8babe3883605f49791d28d9cfffd7 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('12-海关法律法规培训', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_72b8babe3883605f49791d28d9cfffd7 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_72b8babe3883605f49791d28d9cfffd7, @f_72b8babe3883605f49791d28d9cfffd7, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_72b8babe3883605f49791d28d9cfffd7, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_94a2b03a73e1e50c1cd1ddaaa5504c02 = (SELECT id FROM folders WHERE name = '2-8-客户海关法律法规培训签到记录和培训课件' AND parent_id = @f_72b8babe3883605f49791d28d9cfffd7 AND standard_id = 6 LIMIT 1);
    IF @f_94a2b03a73e1e50c1cd1ddaaa5504c02 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('2-8-客户海关法律法规培训签到记录和培训课件', 6, 1, 2, @f_72b8babe3883605f49791d28d9cfffd7, NOW(), NOW(), '单项标准');
        SET @f_94a2b03a73e1e50c1cd1ddaaa5504c02 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_94a2b03a73e1e50c1cd1ddaaa5504c02, @f_94a2b03a73e1e50c1cd1ddaaa5504c02, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_94a2b03a73e1e50c1cd1ddaaa5504c02, distance + 1 FROM folder_closure WHERE descendant = @f_72b8babe3883605f49791d28d9cfffd7;
    END IF;

    SET @f_468b7a477a2ef849002c509442e0168e = (SELECT id FROM folders WHERE name = '13-延伸认证' AND parent_id = 300 AND standard_id = 6 LIMIT 1);
    IF @f_468b7a477a2ef849002c509442e0168e IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('13-延伸认证', 6, 1, 2, 300, NOW(), NOW(), '单项标准');
        SET @f_468b7a477a2ef849002c509442e0168e = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_468b7a477a2ef849002c509442e0168e, @f_468b7a477a2ef849002c509442e0168e, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_468b7a477a2ef849002c509442e0168e, distance + 1 FROM folder_closure WHERE descendant = 300;
    END IF;

    SET @f_55078a21ee27bc3fc67ea395d92e90da = (SELECT id FROM folders WHERE name = '3-9-延伸认证情况说明文件' AND parent_id = @f_468b7a477a2ef849002c509442e0168e AND standard_id = 6 LIMIT 1);
    IF @f_55078a21ee27bc3fc67ea395d92e90da IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('3-9-延伸认证情况说明文件', 6, 1, 2, @f_468b7a477a2ef849002c509442e0168e, NOW(), NOW(), '单项标准');
        SET @f_55078a21ee27bc3fc67ea395d92e90da = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_55078a21ee27bc3fc67ea395d92e90da, @f_55078a21ee27bc3fc67ea395d92e90da, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_55078a21ee27bc3fc67ea395d92e90da, distance + 1 FROM folder_closure WHERE descendant = @f_468b7a477a2ef849002c509442e0168e;
    END IF;

    SET @f_8405c1fa7f0174ef71edcf6fc9f3b83a = (SELECT id FROM folders WHERE name = '10-历年法检查验管理台账' AND parent_id = 267 AND standard_id = 6 LIMIT 1);
    IF @f_8405c1fa7f0174ef71edcf6fc9f3b83a IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('10-历年法检查验管理台账', 6, 1, 2, 267, NOW(), NOW(), '单项标准');
        SET @f_8405c1fa7f0174ef71edcf6fc9f3b83a = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_8405c1fa7f0174ef71edcf6fc9f3b83a, @f_8405c1fa7f0174ef71edcf6fc9f3b83a, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_8405c1fa7f0174ef71edcf6fc9f3b83a, distance + 1 FROM folder_closure WHERE descendant = 267;
    END IF;

    SET @f_b2ff7a72d8a3099912b6e22134456600 = (SELECT id FROM folders WHERE name = '11-历年抽查单证文件' AND parent_id = 267 AND standard_id = 6 LIMIT 1);
    IF @f_b2ff7a72d8a3099912b6e22134456600 IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('11-历年抽查单证文件', 6, 1, 2, 267, NOW(), NOW(), '单项标准');
        SET @f_b2ff7a72d8a3099912b6e22134456600 = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES (@f_b2ff7a72d8a3099912b6e22134456600, @f_b2ff7a72d8a3099912b6e22134456600, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, @f_b2ff7a72d8a3099912b6e22134456600, distance + 1 FROM folder_closure WHERE descendant = 267;
    END IF;

    -- 3. 开始同步审核项目 (以 CSV 为准)
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_8e1d71830c121ab497287c41241da635, '关企沟通联系合作 、 关企联系合作机制', 2, 0, '关企沟通联系合作 、 关企联系合作机制', 1, '“关企联系工作”或“关企联系合作机制”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 关企联系合作机制制度文件（涵盖公司与海关沟通合作的管理规范）
2. 关企联系合作机制的年度更新版本（如有分年度版本，请按年份分别上传）' WHERE `id` = @f_8e1d71830c121ab497287c41241da635;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_e4a430d1b3d507c3e5f2ff70ad883b08, '关企沟通联系合作 、 岗位职责', 2, 0, '关企沟通联系合作 、 岗位职责', 1, '“贸易安全”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 组织架构图
2. 岗位任职条件与职责说明文件（含贸易安全相关岗位的职责描述）
3. 关键岗位任命书（如贸易安全负责人、AEO联络员等任命文件）
4. 如有多年版本，请按年份（公司存续年份）分别上传' WHERE `id` = @f_e4a430d1b3d507c3e5f2ff70ad883b08;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_20d36d863b595a16b314f3f400c77dff, '进出口单证 、 进出口单证复核制度', 4, 0, '进出口单证 、 进出口单证复核制度', 1, '“单证复核流程”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 进出口单证复核管理制度文件
2. 各年度进出口单证复核操作记录（按年份分别上传，涵盖公司存续年份）
3. 单证复核抽查记录（含报关单、装箱单、发票等原始单据抽查样本）' WHERE `id` = @f_20d36d863b595a16b314f3f400c77dff;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_ab0792d61ddc79363d89c02836d3c7a2, '进出口单证 、 进出口单证保管制度', 4, 0, '进出口单证 、 进出口单证保管制度', 1, '“单证归档”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 进出口单证保管管理制度文件
2. 各年度单证保管抽查记录（含实际单证样本，按年度/期次上传，涵盖公司存续年份）
注：单证类型包括但不限于报关单、提单、发票等，建议每年至少上传2个检查时间节点的记录' WHERE `id` = @f_ab0792d61ddc79363d89c02836d3c7a2;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_adfaae52a53fc5deacc6f2b4150fc91e, '进出口单证 、 禁止类产品合规审查制度', 4, 0, '进出口单证 、 禁止类产品合规审查制度', 1, '“HS CODE/原产国/MSDS/货物性质”、“安全准入”、“禁止类产品合规审查”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 禁止类产品合规审查制度文件（如有年度更新，按年份上传，涵盖公司存续年份）
2. 禁限类产品公告及目录（国家主管部门发布的相关禁止进出口货物目录）
3. 合规审查记录或自查表（可按年度归纳上传）' WHERE `id` = @f_adfaae52a53fc5deacc6f2b4150fc91e;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_d1ae94545d31f52a84e61a854f37b944, '进出口单证 、 企业认证电子资料档案', 4, 0, '进出口单证 、 企业认证电子资料档案', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 企业认证电子资料档案汇编（包含AEO认证相关的授权文件、证书等电子存档）' WHERE `id` = @f_d1ae94545d31f52a84e61a854f37b944;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_2837d8cbf6f78e0007a585a36117b7df, '信息系统 、 信息系统说明', 3, 0, '信息系统 、 信息系统说明', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 各信息系统操作手册（如EIP系统、WMS仓储系统、JDY系统、金蝶K3等，按系统分别上传）
2. 信息系统抽查记录（包含系统截图、进出库查询记录、异常报错记录等，按年度上传，涵盖公司存续年份）' WHERE `id` = @f_2837d8cbf6f78e0007a585a36117b7df;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_16f258e400f921a94a5c598d3d5be75b, '信息系统 、 系统数据的保管', 3, 0, '信息系统 、 系统数据的保管', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 信息安全管理手册 / IT数据保管制度（按版本年份上传，请上传当前有效版本）
2. 系统数据保留期限截图（证明数据保存周期不少于3年，按时间段分别上传）' WHERE `id` = @f_16f258e400f921a94a5c598d3d5be75b;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_0832fbf4d3f986e943d39d14b4bf597b, '信息系统 、 信息安全管理制度', 3, 0, '信息系统 、 信息安全管理制度', 1, '“信息安全管理”、“员工手册”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. IT信息安全管理手册 / 员工手册（按版本年份上传）
2. 密码管理策略记录（密码定期修改策略截图、密码到期修改记录）
3. 机房门禁记录（按年度节点上传，如每年2个时间点，涵盖公司存续年份）
4. 杀毒软件运行截图（按年度上传）' WHERE `id` = @f_0832fbf4d3f986e943d39d14b4bf597b;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_0299b9d98eaf5e76438e3410451e91a5, '内部审计和改进 、 内部审计制度', 5, 0, '内部审计和改进 、 内部审计制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 内部审核制度文件（按版本年份上传，请上传当前有效版本）' WHERE `id` = @f_0299b9d98eaf5e76438e3410451e91a5;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_eb5e0feaf77c7d212fdac305d0120936, '内部审计和改进 、 内审记录报告', 5, 0, '内部审计和改进 、 内审记录报告', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 各年度AEO内部审核报告（涵盖公司存续年度，部分年份有上下半年两份，请按年份/期次分别上传）
   参考格式：yyyy AEO内审报告.pdf 或 yyyy-I / yyyy-II AEO内审报告.pdf' WHERE `id` = @f_eb5e0feaf77c7d212fdac305d0120936;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_f0f933f28d8351546d3867e8bdeb15df, '内部审计和改进 、 改进和责任追究机制', 5, 0, '内部审计和改进 、 改进和责任追究机制', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 内审改进机制文件（包含改进机制说明、内部审核不合格报告、纠正措施记录等）
2. 责任追究制度文件（如员工手册实施细则中的责任追究部分）
3. 关企联系合作报告流程文件' WHERE `id` = @f_f0f933f28d8351546d3867e8bdeb15df;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_b9b4cbf71ca8195b46466e25753384cd, '遵守法律法规 、 6-15-1 无犯罪记录管理层声明书', 5, 0, '遵守法律法规 、 6-15-1 无犯罪记录管理层声明书', 3, '-', NOW(), NOW());
    UPDATE `folders` SET `description` = '请对照以下海关对于无犯罪记录的要求开展核查：
1. 公司法定代表人、负责海关事务的高级管理人员（小村博之、川锅和弘）以及财务负责人、贸易安全负责人、报关业务负责人、AEO联络员是否在认证有效期内（近2年）存在刑事犯罪记录。
2. 企业是否曾发生由于走私犯罪受过刑事处罚的情形。
3. 请上传管理层对应的无犯罪记录声明书，需由相关负责人签署。' WHERE `id` = @f_b9b4cbf71ca8195b46466e25753384cd;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_57fbedef7123c7affcce97e6f1dbbb5e, '6-16&17&18 报关单行政处罚合规', 5, 0, '6-16&17&18 报关单行政处罚合规', 3, '-', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件（对应原 6-16、6-17、6-18 审核项）：
1. 企业行政处罚记录说明或各年度无行政处罚证明材料
2. 被处罚报关单明细及对应的行政处罚决定书（如有）
3. 法律法规遵守相关证明材料（如行政许可证、相关资质证书等）
注：审核标准为行政处罚金额累计≤5万元，且被处罚报关单比例＜1‰' WHERE `id` = @f_57fbedef7123c7affcce97e6f1dbbb5e;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_6a38321a2ecc77750f61bfda7655343d, '进出口记录 、 1年内进出口活动证明', 4, 0, '进出口记录 、 1年内进出口活动证明', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 1年内进出口活动证明（如海关进出口统计报表、报关记录汇总，或海关签发的证明文件）
2. 如有不同年度版本，请按年份分别上传' WHERE `id` = @f_6a38321a2ecc77750f61bfda7655343d;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_801364dcc88d163958839256923d2bef, '财务状况 、 审计报告', 1, 0, '财务状况 、 审计报告', 3, '-', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 各年度财务审计报告（涵盖公司存续年份，每年一份，由第三方会计师事务所出具）' WHERE `id` = @f_801364dcc88d163958839256923d2bef;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_ff9a7159e3ba11c0fa95b0e2a1a55fe6, '财务状况 、 资产负债率情况', 1, 0, '财务状况 、 资产负债率情况', 3, '-', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 各年度资产负债率数据说明文件（含资产负债表或财务分析报告，涵盖公司存续年份）
2. 如有专项资产负债率计算说明，请一并上传' WHERE `id` = @f_ff9a7159e3ba11c0fa95b0e2a1a55fe6;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_042b6cbb9446ebba368ce95e3c23315a, '经营场所安全 、 经营场所安全管理制度', 3, 0, '经营场所安全 、 经营场所安全管理制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 经营场所安全管理制度文件（含办公区、仓库、园区等区域的安全管理规范）
2. 如有年度更新版本，请按年份分别上传' WHERE `id` = @f_042b6cbb9446ebba368ce95e3c23315a;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_0c9ff66910da2dee807c0684ab58f905, '经营场所安全 、 经营场所建筑物', 3, 0, '经营场所安全 、 经营场所建筑物', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 经营场所建筑物照片或说明（含外观、围墙、门禁等设施的现场图片）
2. 建筑物平面图或场所示意图
3. 如有多个经营场所或多年度更新记录，请按场所/年份分别上传' WHERE `id` = @f_0c9ff66910da2dee807c0684ab58f905;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_547c416fed64c50933099467393a19a3, '经营场所安全 、 锁闭装置及钥匙保管', 3, 0, '经营场所安全 、 锁闭装置及钥匙保管', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 锁闭装置及钥匙保管制度文件
2. 锁闭装置实物照片（含门锁、密码锁、电子门禁等设施）
3. 钥匙/门禁卡领用登记记录（按年度上传，涵盖公司存续年份）' WHERE `id` = @f_547c416fed64c50933099467393a19a3;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_fcbc1f3ff29760bd4ef2499bc83f225c, '经营场所安全 、 照明', 3, 0, '经营场所安全 、 照明', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 经营场所照明设施照片（含仓库内外、停车区域、门禁区域等）
2. 照明检查记录或维护记录（按年度上传）' WHERE `id` = @f_fcbc1f3ff29760bd4ef2499bc83f225c;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_67103813373213261524ae32b60ce307, '经营场所安全 、 车辆和人员进出管理', 3, 0, '经营场所安全 、 车辆和人员进出管理', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 车辆与人员进出管理制度文件
2. 进出登记记录（如门卫签到表、车辆出入台账、门禁系统记录截图等，按年度上传，涵盖公司存续年份）
3. 现场照片（如门卫亭、道闸、人行通道等设施）' WHERE `id` = @f_67103813373213261524ae32b60ce307;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_890b61f1e759722bad0cf01883a86261, '经营场所安全 、 单证存放和仓储区域受控管理', 3, 0, '经营场所安全 、 单证存放和仓储区域受控管理', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 单证存放管理制度及仓储区域受控管理制度
2. 单证存放区域实物照片（如文件柜、档案室等）
3. 仓储区域管控措施说明或现场图片' WHERE `id` = @f_890b61f1e759722bad0cf01883a86261;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_9ad4323b6dab7dda37ed98ca9f5c805e, '经营场所安全 、 重要敏感区域视频监控', 3, 0, '经营场所安全 、 重要敏感区域视频监控', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 视频监控系统说明（含监控点位分布图或照片）
2. 监控录像保存制度及保存时长说明
3. 监控系统运行状态截图或巡检记录（按年度上传）' WHERE `id` = @f_9ad4323b6dab7dda37ed98ca9f5c805e;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_6078290632f9303a52f12637ba85850a, '人员安全 、 员工入职离职管理', 2, 0, '人员安全 、 员工入职离职管理', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 员工入职管理制度文件（含入职前背景核查流程）
2. 员工离职管理制度文件（含权限注销、资产归还等流程）
3. 如有年度版本更新，请按年份分别上传' WHERE `id` = @f_6078290632f9303a52f12637ba85850a;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_edd5592fb69f45a88387009709b5806f, '人员安全 、 新员工&安全敏感岗位背调', 2, 0, '人员安全 、 新员工&安全敏感岗位背调', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 新员工及安全敏感岗位背景调查制度文件
2. 背调记录样本（如背调报告、员工授权书等，按年份归纳，涵盖公司存续年份）
3. 安全敏感岗位名单或说明' WHERE `id` = @f_edd5592fb69f45a88387009709b5806f;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_df175e41d64c8b84d3269643ec7cb61d, '人员安全 、 员工身份识别和离职员工取消授权', 2, 0, '人员安全 、 员工身份识别和离职员工取消授权', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 员工身份识别管理制度（含工牌、门禁卡发放及管理规范）
2. 离职员工权限注销记录（按年度上传，涵盖公司存续年份）
3. 员工工牌或身份识别系统说明截图' WHERE `id` = @f_df175e41d64c8b84d3269643ec7cb61d;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_76f8856967987010c5a93b15de09a349, '人员安全 、 访客进出登记管理', 2, 0, '人员安全 、 访客进出登记管理', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 访客进出登记管理制度文件
2. 访客登记记录表样本（按年度上传，涵盖公司存续年份）
3. 访客接待区域或门卫处现场照片' WHERE `id` = @f_76f8856967987010c5a93b15de09a349;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_f15775b01b1ca88312c2dec4c7883711, '货物、物品安全 、 货物、物品安全管理制度', 5, 0, '货物、物品安全 、 货物、物品安全管理制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 货物与物品安全管理制度文件（含收货、发货、仓储全流程的安全管控规范）
2. 如有年度版本更新，请按年份分别上传' WHERE `id` = @f_f15775b01b1ca88312c2dec4c7883711;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_03dc14bf9c5569a90a4bd7f860330148, '货物、物品安全 、 集装箱七点检查法', 5, 0, '货物、物品安全 、 集装箱七点检查法', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 集装箱七点检查法操作规范文件
2. 各年度集装箱七点检查记录（按年份上传，涵盖公司存续年份，建议每年至少2个时间节点）' WHERE `id` = @f_03dc14bf9c5569a90a4bd7f860330148;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_e1c98e14cd2212b8255c14e500e126e4, '货物、物品安全 、 集装箱封条', 5, 0, '货物、物品安全 、 集装箱封条', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 集装箱封条管理制度文件
2. 集装箱封条实物照片或使用记录（按年份上传，涵盖公司存续年份）' WHERE `id` = @f_e1c98e14cd2212b8255c14e500e126e4;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_ac4b52f6beb709efa97f1f15b1995855, '货物、物品安全 、 集装箱存储制度', 5, 0, '货物、物品安全 、 集装箱存储制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 集装箱存储管理制度文件
2. 相关年度集装箱存放区域照片或管理记录' WHERE `id` = @f_ac4b52f6beb709efa97f1f15b1995855;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_5cd83d128c86e5f9fe3876853396bf28, '货物、物品安全 、 司机身份核实', 5, 0, '货物、物品安全 、 司机身份核实', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 司机身份核实管理制度文件
2. 各年度司机身份核实记录（如核实登记表、驾照复印件存档等，按年份上传，涵盖公司存续年份）' WHERE `id` = @f_5cd83d128c86e5f9fe3876853396bf28;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_1a1254f028892c5c60e376b6987b474d, '货物、物品安全 、 装运和接收货物物品', 4, 0, '货物、物品安全 、 装运和接收货物物品', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 货物装运与接收操作规范文件
2. 各年度货物收发记录样本（如入库单、出库单、验货记录等，按年份上传，涵盖公司存续年份）' WHERE `id` = @f_1a1254f028892c5c60e376b6987b474d;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_352ea919a809c04568e2ef2d4ae052c5, '货物、物品安全 、 货物、物品差异及报告程序', 5, 0, '货物、物品安全 、 货物、物品差异及报告程序', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 货物差异处理及报告程序文件（含差异发现、上报、处置全流程说明）
2. 差异报告记录样本（如有）' WHERE `id` = @f_352ea919a809c04568e2ef2d4ae052c5;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_e1dac6385749fd1bd4caa7cdfb2b6717, '货物、物品安全 、 出口安全制度', 5, 0, '货物、物品安全 、 出口安全制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 出口安全管理制度文件（含出口货物安全控制的规范与流程）' WHERE `id` = @f_e1dac6385749fd1bd4caa7cdfb2b6717;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_92603d42a5c33fdbcd6a9e31e8ead4a7, '运输工具安全 、 运输工具安全管理制度', 3, 0, '运输工具安全 、 运输工具安全管理制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 运输工具安全管理制度文件（含车辆检查、维护、安全标准等管理规范）' WHERE `id` = @f_92603d42a5c33fdbcd6a9e31e8ead4a7;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_09ff27bfd98cfc67ea24af378128d717, '运输工具安全 、 运输工具检查', 3, 0, '运输工具安全 、 运输工具检查', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 运输工具检查标准或操作规范文件
2. 各年度车辆出车前安全检查记录（按年份上传，涵盖公司存续年份）
3. 各年度车辆定期检查记录（如季度/年度车辆检查报告，按年份上传）' WHERE `id` = @f_09ff27bfd98cfc67ea24af378128d717;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_b7ad7b5ba6c1baafaa1062c7d4594590, '运输工具安全 、 运输工具存储制度', 3, 0, '运输工具安全 、 运输工具存储制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 运输工具存储管理制度文件（如运输部操作规范中的车辆停放与保管规定）' WHERE `id` = @f_b7ad7b5ba6c1baafaa1062c7d4594590;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_ba8388249bd8b98c90ed5f51d35de950, '运输工具安全 、 安全培训', 3, 0, '运输工具安全 、 安全培训', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 运输安全相关制度文件（如运输部操作规范）
2. 各年度运输安全培训记录（按月份/年份上传，涵盖公司存续年份）
   注：培训记录请按年份归纳，每年按月度培训记录分别上传' WHERE `id` = @f_ba8388249bd8b98c90ed5f51d35de950;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_9990d29f82c43e97a2c83ecc22ced356, '商业伙伴安全 、 商业伙伴安全管理制度', 5, 0, '商业伙伴安全 、 商业伙伴安全管理制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 商业伙伴安全管理制度文件（含对客户、供应商等合作伙伴的安全管控规范）' WHERE `id` = @f_9990d29f82c43e97a2c83ecc22ced356;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_7d914029799fb2732603050bb90e52fe, '商业伙伴安全 、 全面评估', 5, 0, '商业伙伴安全 、 全面评估', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件（分客户和供应商两类分别准备）：
【客户类】
1. 与客户有关的评估与监测程序说明文件
2. 商业合作伙伴清单（按年份上传，涵盖公司存续年份）
3. 客户调查表（按年份上传，涵盖公司存续年份）
4. 客户评价表（按年份分别上传，按公司存续年份各一份）
5. 贸易安全考评表
【供应商类】
6. 供应商（运输、报关等类别）调查表、评价表及考评表（按年份分别上传）' WHERE `id` = @f_7d914029799fb2732603050bb90e52fe;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_5d24657dcddf514da24e2617a34d3af2, '商业伙伴安全 、 优化贸易安全管理书面文件', 5, 0, '商业伙伴安全 、 优化贸易安全管理书面文件', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 与运输供应商签订的贸易安全补充协议
2. 与报关供应商签订的贸易安全补充协议
3. 向客户发送的贸易安全告知书（按客户分别上传，涵盖全部主要客户）' WHERE `id` = @f_5d24657dcddf514da24e2617a34d3af2;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_5da59f1a402ec3c339c1670fbd166ef1, '商业伙伴安全 、 监控检查', 5, 0, '商业伙伴安全 、 监控检查', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件（分客户和供应商两类分别准备）：
【客户类】
1. 与客户监控检查相关的评估与监测程序说明
2. 客户贸易安全考评表
3. 客户评价表（按年份分别上传，涵盖公司存续年份）
【供应商类】
4. 运输供应商贸易安全考评表（按年份分别上传，涵盖公司存续年份）
5. 报关供应商贸易安全考评表（按年份分别上传）
6. 仓库供应商贸易安全考评表（按年份分别上传）' WHERE `id` = @f_5da59f1a402ec3c339c1670fbd166ef1;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_d32daf863a47dded9a628d23840d8370, '海关业务和贸易安全培训 、 法律法规和贸易安全内部培训制度', 4, 0, '海关业务和贸易安全培训 、 法律法规和贸易安全内部培训制度', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 人力资源管理程序（含员工培训相关规定，按版本年份上传，请上传当前有效版本）
2. 各年度内部培训计划（按年份分别上传，按公司存续年份各一份）' WHERE `id` = @f_d32daf863a47dded9a628d23840d8370;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_26d3ec10693826d19e062f201ffa4c30, '海关业务和贸易安全培训 、 海关法律法规培训', 4, 0, '海关业务和贸易安全培训 、 海关法律法规培训', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 人力资源管理程序（按版本年份上传）
2. 各次培训记录表（区分员工培训和内审员培训，按培训日期分别上传，涵盖公司存续年份）' WHERE `id` = @f_26d3ec10693826d19e062f201ffa4c30;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_0dfd8c7dbbace22af75b81323a3f37a9, '海关业务和贸易安全培训 、 货物安全培训', 4, 0, '海关业务和贸易安全培训 、 货物安全培训', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 仓库安全管理手册 / 运输部操作规范（按版本年份上传）
2. 运输安全培训记录（按月份上传，涵盖公司存续年份）
3. 仓库安全培训记录（按年度上传，涵盖公司存续年份）
   注：培训记录请按年份分别整理归纳后上传' WHERE `id` = @f_0dfd8c7dbbace22af75b81323a3f37a9;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_3a6881be96d9c5989574ad2affaa658c, '海关业务和贸易安全培训 、 危机管理培训', 4, 0, '海关业务和贸易安全培训 、 危机管理培训', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 危机管理相关制度文件（含应急预案，如火灾、台风、地震、车辆故障等应急预案，以及自然灾害应急手册）
2. 各年度危机管理培训记录（按年份分别上传，涵盖公司存续年份）' WHERE `id` = @f_3a6881be96d9c5989574ad2affaa658c;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_278beadba9cc8a616d125cd1b972e763, '海关业务和贸易安全培训 、 信息安全培训', 4, 0, '海关业务和贸易安全培训 、 信息安全培训', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. IT信息安全管理手册（按版本年份上传）
2. 各次信息安全培训记录（按培训日期分别上传，涵盖公司存续年份，含员工信息安全培训及网络安全培训）' WHERE `id` = @f_278beadba9cc8a616d125cd1b972e763;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_75db620cc01a0de68c2101516e72d208, '三、1 商品检查与进出口法检制度', 6, 0, '三、1 商品检查与进出口法检制度', 1, '“商检”、“法检”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：1. 仓库操作部木质包装管理制度
2. 客户服务部进出境商检与进出口法检制度' WHERE `id` = @f_75db620cc01a0de68c2101516e72d208;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_78e502dfaa31e9656eadf162fd69b318, '三、3 抽查单证文件', 6, 0, '三、3 抽查单证文件', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：历年抽查单证相关文件。' WHERE `id` = @f_78e502dfaa31e9656eadf162fd69b318;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_8f03a3809245319695cdb3d10eb2714c, '三、4 熏蒸板记录', 6, 0, '三、4 熏蒸板记录', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：1. 空置熏蒸板存放区文件
2. 整进整出熏蒸板记录文件' WHERE `id` = @f_8f03a3809245319695cdb3d10eb2714c;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_b10ee10c417fecf06b113580f651f1e6, '二、2 特殊物品单证', 6, 0, '二、2 特殊物品单证', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：历年特殊物品单证文件夹' WHERE `id` = @f_b10ee10c417fecf06b113580f651f1e6;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_4d26e6c91a5b734547908f9305ea2a5f, '二、3 特殊物品安全管理制度', 6, 0, '二、3 特殊物品安全管理制度', 1, '“单证管理”、“复核”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：1. 特殊物品-温控货物操作指导手册
2. 单证归档管理制度（电子）
3. 单证归档管理制度（纸质）' WHERE `id` = @f_4d26e6c91a5b734547908f9305ea2a5f;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_bc8ec9e78d821e895a63093869421c47, '一、1 进出口单证复核&保管制度', 6, 0, '一、1 进出口单证复核&保管制度', 1, '“单证管理”、“复核”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：1. 客户服务部单证复核流程
2. 单证归档管理制度（电子）
3. 单证归档管理制度（纸质）' WHERE `id` = @f_bc8ec9e78d821e895a63093869421c47;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_dd6c90bb716fed24dbd0389e2604eb19, '三、2 进境商检查验管理台账历年纪录', 6, 0, '三、2 进境商检查验管理台账历年纪录', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：历年进境商检查验管理台账记录。' WHERE `id` = @f_dd6c90bb716fed24dbd0389e2604eb19;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_780dbca59d8bc74473fb0d5b6f71282c, '进出口商品检验 、 法检制度', 6, 0, '进出口商品检验 、 法检制度', 1, '“商检”、“法检”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传进出境商检与进出口法检管理制度文件。' WHERE `id` = @f_780dbca59d8bc74473fb0d5b6f71282c;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_2648ecdb4284cb709576ed37051af3df, '八、物流运输业务 - 20 运输工具管理制度', 6, 0, '八、物流运输业务 - 20 运输工具管理制度', 1, '“车辆管理”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传运输工具管理相关的操作规范或制度文件（如运输部操作规范）。' WHERE `id` = @f_2648ecdb4284cb709576ed37051af3df;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_e3568d067d64a020afd3bfd90787756d, '八、物流运输业务 - 21-1 运输工具轨迹管理制度', 6, 0, '八、物流运输业务 - 21-1 运输工具轨迹管理制度', 1, '“定位监控”、“轨迹系统”、“车载终端”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传定位系统车载终端管理制度文件。' WHERE `id` = @f_e3568d067d64a020afd3bfd90787756d;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_9f0e7cea82de96cb4db5c6fa63070f26, '八、物流运输业务 - 21-2 车辆行驶轨迹记录', 6, 0, '八、物流运输业务 - 21-2 车辆行驶轨迹记录', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传各年度车辆行驶轨迹监控数据及汇总台账。' WHERE `id` = @f_9f0e7cea82de96cb4db5c6fa63070f26;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_df8cffbee2ff15c98cb8247f3f3a6f10, '八、物流运输业务 - 22-1 驾驶员安全与匹配制度', 6, 0, '八、物流运输业务 - 22-1 驾驶员安全与匹配制度', 1, '“驾驶员审核”、“身份检查”、“人员匹配”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传驾驶员安全管理制度、司机提货流程及身份检查规范。' WHERE `id` = @f_df8cffbee2ff15c98cb8247f3f3a6f10;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_246460b03ce03dc9028df14f9b70e6a5, '八、物流运输业务 - 22-2 车辆与司机登记台账', 6, 0, '八、物流运输业务 - 22-2 车辆与司机登记台账', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传车辆信息表、各年度提送货车辆进出登记台账。' WHERE `id` = @f_246460b03ce03dc9028df14f9b70e6a5;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_e56b9c928628984a8e2776d1385d5d21, '六、代理报关业务 - 1 进出口单证及复核制度文件', 6, 0, '六、代理报关业务 - 1 进出口单证及复核制度文件', 1, '“进出口单证”', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 进出口单证及复核制度文件' WHERE `id` = @f_e56b9c928628984a8e2776d1385d5d21;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_33a23502eacd7c57698a6fc37eed6745, '六、代理报关业务 - 2 系统复审界面截屏', 6, 0, '六、代理报关业务 - 2 系统复审界面截屏', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 系统复审界面截屏' WHERE `id` = @f_33a23502eacd7c57698a6fc37eed6745;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_854ae3707b7af1653c362b7d3f4b0fc9, '六、代理报关业务 - 3 历年退改单率统计', 6, 0, '六、代理报关业务 - 3 历年退改单率统计', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 历年退改单率统计' WHERE `id` = @f_854ae3707b7af1653c362b7d3f4b0fc9;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_26361bcc28dfcbb4fb4339ee671939b6, '六、代理报关业务 - 4 历年单一窗口数据取值截屏', 6, 0, '六、代理报关业务 - 4 历年单一窗口数据取值截屏', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 历年单一窗口数据取值截屏' WHERE `id` = @f_26361bcc28dfcbb4fb4339ee671939b6;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_6fff0ae37a844f02f381404447a4f5af, '六、代理报关业务 - 5 系统逻辑检验截屏', 6, 0, '六、代理报关业务 - 5 系统逻辑检验截屏', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 系统逻辑检验截屏' WHERE `id` = @f_6fff0ae37a844f02f381404447a4f5af;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_4199d99723e0742ebe0c174bdcf6b776, '六、代理报关业务 - 6 历年单证抽取记录', 6, 0, '六、代理报关业务 - 6 历年单证抽取记录', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 历年单证抽取记录，包括出口、出境、进口、进境' WHERE `id` = @f_4199d99723e0742ebe0c174bdcf6b776;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_9b620604a3bca5eada3cdb63ab76aa38, '六、代理报关业务 - 7 海关法律法规培训管理办法', 6, 0, '六、代理报关业务 - 7 海关法律法规培训管理办法', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 海关法律法规培训管理办法' WHERE `id` = @f_9b620604a3bca5eada3cdb63ab76aa38;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_94a2b03a73e1e50c1cd1ddaaa5504c02, '六、代理报关业务 - 8 客户海关法律法规培训签到记录和培训课件', 6, 0, '六、代理报关业务 - 8 客户海关法律法规培训签到记录和培训课件', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 客户海关法律法规培训签到记录和培训课件' WHERE `id` = @f_94a2b03a73e1e50c1cd1ddaaa5504c02;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_55078a21ee27bc3fc67ea395d92e90da, '六、代理报关业务 - 9 延伸认证情况说明文件', 6, 0, '六、代理报关业务 - 9 延伸认证情况说明文件', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传以下文件：
1. 延伸认证情况说明文件' WHERE `id` = @f_55078a21ee27bc3fc67ea395d92e90da;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_8405c1fa7f0174ef71edcf6fc9f3b83a, '五、2 历年法检查验管理台账', 6, 0, '五、2 历年法检查验管理台账', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：历年法检查验管理台账。' WHERE `id` = @f_8405c1fa7f0174ef71edcf6fc9f3b83a;
    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES (@f_b2ff7a72d8a3099912b6e22134456600, '五、3 历年抽查单证文件', 6, 0, '五、3 历年抽查单证文件', 2, '', NOW(), NOW());
    UPDATE `folders` SET `description` = '请上传：历年抽查单证文件。' WHERE `id` = @f_b2ff7a72d8a3099912b6e22134456600;

END //
DELIMITER ;
CALL SyncUniversal();
DROP PROCEDURE SyncUniversal;
SET FOREIGN_KEY_CHECKS = 1;
