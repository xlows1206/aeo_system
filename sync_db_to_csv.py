import re
import csv
import os
import shutil

# 配置路径
SQL_FILE = 'cloud_audit_structure.sql'
CSV_FILE = 'audit_list_3.csv'
BACKUP_CSV = 'audit_list_3.csv.bak_before_reverse_sync'

def parse_sql_inserts(sql_content):
    # 提取 folder_check_files 的插入语句
    # 格式: (id, file_name, folder_id, check_name, check_type, check_text, created_at, updated_at, folder_name, standard_id, master_id, audit_status)
    pattern = re.compile(r"INSERT INTO `folder_check_files` VALUES (.*?);", re.S)
    matches = pattern.findall(sql_content)
    
    records = []
    for match in matches:
        # 处理多行插入的情况
        rows = re.findall(r"\((.*?)\)(?:,|$)", match, re.S)
        for row in rows:
            try:
                items = []
                current_item = ""
                in_string = False
                escape = False
                for char in row:
                    if char == "\\" and not escape:
                        escape = True
                        current_item += char
                        continue
                    
                    if char == "'" and not escape:
                        in_string = not in_string
                        current_item += char
                    elif char == "," and not in_string:
                        items.append(current_item.strip())
                        current_item = ""
                    else:
                        current_item += char
                    escape = False
                items.append(current_item.strip())
                
                # 清洗单引号和 NULL
                items = [i.strip("'").replace("\\'", "'").replace("\\\\", "\\") if i.startswith("'") else (None if i == "NULL" else i) for i in items]
                records.append(items)
            except Exception as e:
                print(f"Error parsing row: {row[:50]}... Error: {e}")
    return records

def update_csv(records):
    # 备份旧 CSV
    if os.path.exists(CSV_FILE):
        shutil.copy(CSV_FILE, BACKUP_CSV)
        print(f"Backed up {CSV_FILE} to {BACKUP_CSV}")

    # 转换 check_type 数字回文字
    # V4 标准: 1: AI, 2: Keyword, 3: Simple
    type_rev_map = {'1': 'AI内容理解', '2': '关键词检测', '3': '上传即为通过'}
    
    # 过滤掉 master_id != 0 的租户数据，只保留模板数据 (master_id 是第 11 个字段，索引 10)
    template_records = [r for r in records if len(r) > 10 and r[10] == '0']
    
    with open(CSV_FILE, 'w', newline='', encoding='utf8') as f:
        writer = csv.writer(f)
        # 写入表头
        writer.writerow(['check_name', 'description', 'full_path', 'relative_path', 'file_count', 'dept', 'check_type', 'check_text'])
        
        for r in template_records:
            check_name = r[3]
            check_type_num = r[4]
            check_type_str = type_rev_map.get(check_type_num, '上传即为通过')
            check_text = r[5] if r[5] else ""
            folder_name = r[8] if r[8] else ""
            
            # 从 folder_name 猜测部门
            dept = "单项标准"
            if "人事" in folder_name: dept = "人事"
            elif "关务" in folder_name: dept = "关务"
            elif "财务" in folder_name: dept = "财务"
            elif "行政" in folder_name: dept = "行政"
            elif "审计" in folder_name: dept = "审计部"

            writer.writerow([
                check_name,
                "", # description
                folder_name, # full_path
                "", # relative_path
                0, # file_count
                dept,
                check_type_str,
                check_text
            ])

if __name__ == "__main__":
    if not os.path.exists(SQL_FILE):
        print(f"Error: {SQL_FILE} not found.")
    else:
        with open(SQL_FILE, 'r', encoding='utf8') as f:
            content = f.read()
        records = parse_sql_inserts(content)
        if records:
            update_csv(records)
            print(f"Successfully updated {CSV_FILE} with {len([r for r in records if len(r)>10 and r[10]=='0'])} template records from Cloud DB.")
        else:
            print("No records found in SQL.")
