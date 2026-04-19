import pandas as pd
import re

# 1. 配置
CSV_PATH = '/Users/aaron.w/Desktop/aeo_system/audit_list_3.csv'
SQL_INSERTS_PATH = '/Users/aaron.w/Desktop/aeo_system/ai_admin_api/folders_inserts.sql'
OUTPUT_SQL = '/Users/aaron.w/Desktop/aeo_system/sync_final.sql'

# 部门映射表
DEPT_MAP = {
    '人员安全': {'name': '人事', 'id': 2},
    '信息系统': {'name': '行政', 'id': 3},
    '关企沟通联系合作': {'name': '关务', 'id': 4},
    '内部审计和改进': {'name': '审计部', 'id': 5},
    '商业伙伴安全': {'name': '关务', 'id': 4},
    '海关业务和贸易安全培训': {'name': '关务', 'id': 4},
    '经营场所安全': {'name': '行政', 'id': 3},
    '财务状况': {'name': '财务', 'id': 1},
    '货物、物品安全': {'name': '关务', 'id': 4},
    '运输工具安全': {'name': '关务', 'id': 4},
    '进出口单证': {'name': '关务', 'id': 4},
    '进出口记录': {'name': '关务', 'id': 4},
    '遵守法律法规': {'name': '审计部', 'id': 5},
    '单项标准': {'name': '关务', 'id': 6},
}

# 2. 解析 folders 结构
folders = {}
pattern = re.compile(r"INSERT INTO `folders` \(`id`, `name`, `standard_id`, `user_id`, `master_id`, `parent_id`, .*?\) VALUES \((\d+), '(.*?)', (\d+), (\d+), (\d+), (\d+),")

with open(SQL_INSERTS_PATH, 'r', encoding='utf-8') as f:
    for line in f:
        match = pattern.search(line)
        if match:
            fid, name, std_id, uid, mid, pid = match.groups()
            folders[int(fid)] = {
                'name': name,
                'parent_id': int(pid),
                'standard_id': int(std_id)
            }

def get_full_path(fid):
    path_parts = []
    curr = folders.get(fid)
    while curr:
        path_parts.insert(0, curr['name'])
        curr = folders.get(curr['parent_id'])
    return '/'.join(path_parts)

path_to_id = {}
for fid in folders:
    full_path = get_full_path(fid)
    if '通用标准' in full_path:
        full_path = full_path[full_path.index('通用标准'):]
    elif '单项标准' in full_path:
        full_path = full_path[full_path.index('单项标准'):]
    path_to_id[full_path] = fid

# 3. 解析 CSV 并生成 SQL
df = pd.read_csv(CSV_PATH)
sql_statements = []
sql_statements.append("SET FOREIGN_KEY_CHECKS = 0;")
sql_statements.append("TRUNCATE TABLE `folder_check_files`;")

matched_count = 0

for _, row in df.iterrows():
    raw_name = str(row['审核项目名称']).strip()
    instruction = str(row['需要上传文件说明']).strip().replace("'", "''")
    target_path = str(row['脱敏文件路径']).strip()
    
    category_from_name = raw_name.split(' - ')[0] if ' - ' in raw_name else raw_name
    category_from_col = str(row['对应部门']).strip()
    
    dept_info = DEPT_MAP.get(category_from_col, DEPT_MAP.get(category_from_name, {'name': '关务', 'id': 4}))
    
    fid = path_to_id.get(target_path)
    if not fid:
        # 弹性匹配逻辑
        last_segment = target_path.split('/')[-1]
        # 提取编号前缀，如 "6-15"
        prefix_match = re.search(r'([A-Za-z0-9\-]+)', last_segment)
        prefix = prefix_match.group(1) if prefix_match else None
        
        for p, i in path_to_id.items():
            db_segment = p.split('/')[-1]
            # 1. 包含匹配
            if last_segment in p:
                fid = i
                break
            # 2. 编号前缀匹配
            if prefix and db_segment.startswith(prefix):
                fid = i
                break
            # 3. 关键词匹配
            if "无犯罪记录" in last_segment and "无犯罪记录" in db_segment:
                fid = i
                break

    if fid:
        matched_count += 1
        sql_statements.append(f"UPDATE `folders` SET `department` = '{dept_info['name']}', `description` = '{instruction}', `standard_id` = {dept_info['id']} WHERE `id` = {fid};")
        sql_statements.append(f"INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES ({fid}, '{raw_name}', {dept_info['id']}, 0, '{raw_name}', 2, NOW(), NOW());")
    else:
        print(f"FAILED TO MATCH: {target_path}")

sql_statements.append("SET FOREIGN_KEY_CHECKS = 1;")

with open(OUTPUT_SQL, 'w', encoding='utf-8') as f:
    f.write('\n'.join(sql_statements))

print(f"Final Count: {matched_count}/{len(df)}")
