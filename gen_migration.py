import pandas as pd
import re

CSV_PATH = '/Users/aaron.w/Desktop/aeo_system/audit_list_3.csv'
SQL_INSERTS_PATH = '/Users/aaron.w/Desktop/aeo_system/ai_admin_api/folders_inserts.sql'

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
}

folders = {}
pattern = re.compile(r"INSERT INTO `folders` \(`id`, `name`, `standard_id`, `user_id`, `master_id`, `parent_id`, .*?\) VALUES \((\d+), '(.*?)', (\d+), (\d+), (\d+), (\d+),")

with open(SQL_INSERTS_PATH, 'r', encoding='utf-8') as f:
    for line in f:
        match = pattern.search(line)
        if match:
            fid, name, std_id, uid, mid, pid = match.groups()
            folders[int(fid)] = {'name': name, 'parent_id': int(pid), 'standard_id': int(std_id)}

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
    if '通用标准' in full_path: full_path = full_path[full_path.index('通用标准'):]
    elif '单项标准' in full_path: full_path = full_path[full_path.index('单项标准'):]
    path_to_id[full_path] = fid

df = pd.read_csv(CSV_PATH)
php_lines = []

for _, row in df.iterrows():
    raw_name = str(row['审核项目名称']).strip()
    instruction = str(row['需要上传文件说明']).strip().replace("'", "\\'").replace("\n", "\\n")
    target_path = str(row['脱敏文件路径']).strip()
    category = raw_name.split(' - ')[0] if ' - ' in raw_name else raw_name
    dept_info = DEPT_MAP.get(category, {'name': '关务', 'id': 4})
    
    fid = path_to_id.get(target_path)
    if not fid:
        last_segment = target_path.split('/')[-1]
        prefix_match = re.search(r'([A-Za-z0-9\-]+)', last_segment)
        prefix = prefix_match.group(1) if prefix_match else None
        for p, i in path_to_id.items():
            db_segment = p.split('/')[-1]
            if last_segment in p or (prefix and db_segment.startswith(prefix)) or ('无犯罪记录' in last_segment and '无犯罪记录' in db_segment):
                fid = i; break

    if fid:
        php_lines.append(f"        Db::table('folders')->where('id', {fid})->update(['department' => '{dept_info['name']}', 'description' => '{instruction}', 'standard_id' => {dept_info['id']}]);")
        php_lines.append(f"        Db::table('folder_check_files')->insert(['folder_id' => {fid}, 'folder_name' => '{raw_name}', 'standard_id' => {dept_info['id']}, 'audit_status' => 0, 'created_at' => $now, 'updated_at' => $now]);")

print("        $now = date('Y-m-d H:i:s');")
print("        Db::table('folder_check_files')->truncate();")
for line in php_lines:
    print(line)
