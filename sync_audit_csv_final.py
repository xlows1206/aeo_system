import pandas as pd
import re

# 1. 配置
CSV_PATH = '/Users/aaron.w/Desktop/aeo_system/audit_list_3.csv'
SQL_INSERTS_PATH = '/Users/aaron.w/Desktop/aeo_system/ai_admin_api/folders_inserts.sql'
OUTPUT_SQL = '/Users/aaron.w/Desktop/aeo_system/sync_final.sql'

# 部门映射表 (以 folders_inserts.sql 的 standard_id 为准)
DEPT_MAP = {
    '人事': {'name': '人事', 'id': 2},
    '行政': {'name': '行政', 'id': 3},
    '关务': {'name': '关务', 'id': 4},
    '审计': {'name': '审计', 'id': 5},
    '财务': {'name': '财务', 'id': 1},
    '单项标准': {'name': '关务', 'id': 6},
}

# 由于 Docker 环境复杂，我们改为生成 SQL 文件的模式，但在关键步骤辅助确认
print("Initializing Enhanced Sync...")

df = pd.read_csv(CSV_PATH)
sql_statements = []
sql_statements.append("SET FOREIGN_KEY_CHECKS = 0;")
sql_statements.append("TRUNCATE TABLE `folder_check_files`;")

# 我们不在 Python 里直接操作 DB 以防连不上，而是生成逻辑严密的 SQL 块
# 每个项目的 SQL 块：
# 1. 尝试找到路径对应的 ID (使用临时变量)
# 2. 如果没有，插入
# 3. 关联 fcf

# 我们需要先构建一个完整的 'folders' 插入清单
print("Stage 1: Building Folder Tree SQL...")
unique_paths = sorted(df[df['对应部门'] == '单项标准']['脱敏文件路径'].unique())
folder_structure = {} # path -> id_var

# 为每个路径生成自愈创建 SQL
def generate_folder_sql(path_str):
    parts = path_str.split('/')
    base = parts[0] # 单项标准
    hierarchy = parts[1:]
    
    current_path = base
    prev_var = "0"
    
    # Root Category ID Map
    ROOT_ID_MAP = {
        '一、加工贸易以及保税进出口业务': 264,
        '二、卫生检疫业务': 265,
        '三、动植物检疫业务': 266,
        '五、进出口商品检验业务': 267,
        '六、代理报关业务': 300,
        '八、物流运输业务': 268
    }

    local_sql = []
    for i, name in enumerate(hierarchy):
        current_path += "/" + name
        var_name = "@f_" + re.sub(r'[^a-zA-Z0-9]', '_', current_path)
        
        forced_id = ROOT_ID_MAP.get(name) if i == 0 else None
        
        # SQL logic to find or create
        local_sql.append(f"""
-- Path: {current_path}
SET {var_name} = (SELECT id FROM folders WHERE name = '{name}' AND parent_id = {prev_var} AND standard_id = 6 LIMIT 1);
IF {var_name} IS NULL THEN
    INSERT INTO folders ({'id, ' if forced_id else ''}name, standard_id, user_id, master_id, parent_id, created_at, updated_at, department)
    VALUES ({str(forced_id) + ', ' if forced_id else ''}'{name}', 6, 1, 2, {prev_var}, NOW(), NOW(), '关务');
    SET {var_name} = {'LAST_INSERT_ID()' if not forced_id else forced_id};
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES ({var_name}, {var_name}, 0);
    INSERT IGNORE INTO folder_closure (ancestor, descendant, distance)
    SELECT ancestor, {var_name}, distance + 1 FROM folder_closure WHERE descendant = {prev_var};
END IF;
""")
        prev_var = var_name
    return "\n".join(local_sql), prev_var

# 生成存储过程形式，因为 MySQL 不支持脚本内 IF
full_sql = ["""
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
"""]

path_vars = {}
for path in unique_paths:
    sql_block, final_var = generate_folder_sql(path)
    full_sql.append(sql_block)
    path_vars[path] = final_var

full_sql.append("\n-- Start Inserting Audit Items")
for _, row in df.iterrows():
    raw_name = str(row['审核项目名称']).strip().replace("'", "\\'")
    instruction = str(row['需要上传文件说明']).strip().replace("'", "\\'")
    target_path = str(row['脱敏文件路径']).strip()
    
    if target_path in path_vars:
        fid_var = path_vars[target_path]
        full_sql.append(f"INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES ({fid_var}, '{raw_name}', 6, 0, '{raw_name}', 2, NOW(), NOW());")
        full_sql.append(f"UPDATE `folders` SET `description` = '{instruction}' WHERE `id` = {fid_var};")

full_sql.append("""
END //
DELIMITER ;
CALL SyncStandard6();
DROP PROCEDURE SyncStandard6;
SET FOREIGN_KEY_CHECKS = 1;
""")

with open(OUTPUT_SQL, 'w', encoding='utf-8') as f:
    f.write("\n".join(full_sql))

print(f"Enhanced Sync SQL generated at {OUTPUT_SQL} with {len(path_vars)} paths.")
