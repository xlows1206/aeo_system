import pandas as pd
import re
import os

# 1. 配置
CSV_PATH = '/Users/aaron.w/Desktop/aeo_system/audit_list_3.csv'
OUTPUT_SQL = '/Users/aaron.w/Desktop/aeo_system/sync_universal.sql'

print("Initializing Universal Authoritative Sync (Standard 1-6)...")

# 2. 核心映射表 (以 CSV 中的顿号标点为准)
ROOT_CONFIG = {
    # 单项标准 (Standard 6)
    ('一、加工贸易以及保税进出口业务', '单项标准'): {'id': 264, 'std_id': 6},
    ('二、卫生检疫业务', '单项标准'): {'id': 265, 'std_id': 6},
    ('三、动植物检疫业务', '单项标准'): {'id': 266, 'std_id': 6},
    ('五、进出口商品检验业务', '单项标准'): {'id': 267, 'std_id': 6},
    ('六、代理报关业务', '单项标准'): {'id': 300, 'std_id': 6},
    ('八、物流运输业务', '单项标准'): {'id': 268, 'std_id': 6},
    
    # 通用标准 (Standard 1-5)
    ('一、内部控制标准', '人事'): {'id': 500, 'std_id': 2},
    ('一、内部控制标准', '关务'): {'id': 504, 'std_id': 4},
    ('一、内部控制标准', '行政'): {'id': 510, 'std_id': 3},
    ('一、内部控制标准', '审计'): {'id': 515, 'std_id': 5},
    ('一、内部控制标准', '审计部'): {'id': 515, 'std_id': 5},
    
    ('二、财务状况标准', '财务'): {'id': 527, 'std_id': 1},
    
    ('三、守法规范标准', '审计'): {'id': 520, 'std_id': 5},
    ('三、守法规范标准', '审计部'): {'id': 520, 'std_id': 5},
    ('三、守法规范标准', '关务'): {'id': 524, 'std_id': 4},
    
    ('四、贸易安全标准', '行政'): {'id': 531, 'std_id': 3},
    ('四、贸易安全标准', '人事'): {'id': 540, 'std_id': 2},
    ('四、贸易安全标准', '审计'): {'id': 546, 'std_id': 5},
    ('四、贸易安全标准', '审计部'): {'id': 546, 'std_id': 5},
    ('四、贸易安全标准', '关务'): {'id': 553, 'std_id': 4},
}

# 加载 CSV
df = pd.read_csv(CSV_PATH)
# 预处理：过滤掉空路径
df = df.dropna(subset=['脱敏文件路径'])
unique_paths_with_depts = df[['脱敏文件路径', '对应部门']].drop_duplicates().values.tolist()

full_sql = ["""
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
"""]

def generate_path_sql(path_str, dept_name):
    parts = [p.strip() for p in path_str.split('/')]
    if len(parts) < 2:
        return "", None, None
    
    root_category_name = parts[1]
    hierarchy = parts[2:]
    
    config = ROOT_CONFIG.get((root_category_name, dept_name))
    if not config:
        # 降级尝试：如果部门带'部'字
        if dept_name.endswith('部'):
            config = ROOT_CONFIG.get((root_category_name, dept_name[:-1]))
        elif not dept_name.endswith('部'):
            config = ROOT_CONFIG.get((root_category_name, dept_name + '部'))
            
    if not config:
        return f"    -- [WARNING] No root mapped for {root_category_name} + {dept_name}", None, None

    std_id = config['std_id']
    root_id = config['id']
    
    local_sql = []
    prev_var = str(root_id)
    current_full_path = parts[0] + "/" + parts[1]
    
    for name in hierarchy:
        current_full_path += "/" + name
        import hashlib
        path_hash = hashlib.md5(current_full_path.encode('utf-8')).hexdigest()
        var_name = "@f_" + path_hash
        
        # SQL logic to find or create
        local_sql.append(f"""
    SET {var_name} = (SELECT id FROM folders WHERE name = '{name}' AND parent_id = {prev_var} AND standard_id = {std_id} LIMIT 1);
    IF {var_name} IS NULL THEN
        INSERT INTO folders (name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
        VALUES ('{name}', {std_id}, 1, 2, {prev_var}, NOW(), NOW(), '{dept_name}');
        SET {var_name} = LAST_INSERT_ID();
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES ({var_name}, {var_name}, 0);
        INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
        SELECT ancestor, {var_name}, distance + 1 FROM folder_closure WHERE descendant = {prev_var};
    END IF;""")
        prev_var = var_name
        
    return "\n".join(local_sql), prev_var, std_id

# 处理路径
path_mapping = {} # (path, dept) -> (var_name, std_id)
for path, dept in unique_paths_with_depts:
    sql_block, final_var, std_id = generate_path_sql(path, dept)
    if final_var:
        full_sql.append(sql_block)
        path_mapping[(path, dept)] = (final_var, std_id)

full_sql.append("\n    -- 3. 开始同步审核项目 (以 CSV 为准)")
for _, row in df.iterrows():
    raw_name = str(row['审核项目名称']).strip().replace("'", "\\'")
    instruction = str(row['需要上传文件说明']).strip().replace("'", "\\'")
    target_path = str(row['脱敏文件路径']).strip()
    dept = str(row['对应部门']).strip()
    
    if (target_path, dept) in path_mapping:
        fid_var, s_id = path_mapping[(target_path, dept)]
        
        # 映射检测方式
        check_type_str = str(row.get('检测方式', '上传即为通过')).strip()
        check_text = str(row.get('检测关键字', '')).strip().replace("'", "\\'")
        if check_text == 'nan': check_text = ''
        
        type_map = {
            "关键词检测": 1,
            "上传即为通过": 2,
            "AI内容理解": 3
        }
        check_type_code = type_map.get(check_type_str, 2)

        full_sql.append(f"    INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `check_text`, `created_at`, `updated_at`) VALUES ({fid_var}, '{raw_name}', {s_id}, 0, '{raw_name}', {check_type_code}, '{check_text}', NOW(), NOW());")
        full_sql.append(f"    UPDATE `folders` SET `description` = '{instruction}' WHERE `id` = {fid_var};")

full_sql.append("""
END //
DELIMITER ;
CALL SyncUniversal();
DROP PROCEDURE SyncUniversal;
SET FOREIGN_KEY_CHECKS = 1;
""")

with open(OUTPUT_SQL, 'w', encoding='utf-8') as f:
    f.write("\n".join(full_sql))

print(f"Authoritative Sync SQL generated at {OUTPUT_SQL} with {len(path_mapping)} paths mapped.")
