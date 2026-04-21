import pandas as pd
import re
import os

# 1. 配置
CSV_PATH = '/Users/aaron.w/Desktop/aeo_system/audit_list_3.csv'
SQL_INSERTS_PATH = '/Users/aaron.w/Desktop/aeo_system/ai_admin_api/folders_inserts.sql'

def normalize_name(name, is_root=False):
    if not name or not isinstance(name, str):
        return name
    
    # 规则 1: 根目录保留/变更为“汉字序号 + 顿号”格式
    if is_root:
        # 如果是“一 内部控制标准”格式，改为“一、内部控制标准”
        name = re.sub(r'^([一二三四五六七八九十]+)\s+', r'\1、', name)
        return name
    
    # 规则 2: 非根目录 - 符号转换
    # a. 顿号 -> 连字符
    name = name.replace('、', '-')
    # b. 点号 -> 连字符 (处理 "4. ", "4.", "2. " 等)
    name = re.sub(r'(\d+)\.\s*', r'\1-', name)
    
    # 规则 3: 处理空格
    # a. 将序号后的空格转为连字符 (例如 "16-60 货物" -> "16-60-货物")
    name = re.sub(r'(\d+)\s+', r'\1-', name)
    # b. 处理双序号后的空格 (例如 "16-60 货物")
    name = re.sub(r'(\d+-\d+)\s+', r'\1-', name)
    
    # 规则 4: 极端清理
    # 移除所有多余的 - 
    name = re.sub(r'-+', '-', name)
    # 移除开头结尾的 -
    name = name.strip('-')
    
    return name

# 处理 SQL 种子文件
print("Normalizing SQL Seeds...")
with open(SQL_INSERTS_PATH, 'r', encoding='utf-8') as f:
    lines = f.readlines()

new_lines = []
for line in lines:
    if "INSERT INTO `folders`" in line:
        # 兼容两种常用的 INSERT 格式
        pattern = r"VALUES\s*\((\d+)\s*,\s*'([^']+)'\s*,\s*\d+\s*,\s*(\d+|\d+\s*,\s*\d+)\s*,\s*(\d+)"
        match = re.search(r"VALUES\s*\((\d+)\s*,\s*'([^']+)'\s*,\s*\d+.*,\s*(\d+)\s*,", line)
        
        # 简单暴力的直接查找逻辑
        if "'" in line:
            parts = line.split("'")
            if len(parts) >= 3:
                original_name = parts[1]
                # 尝试判断是否是 root (parent_id 为 0)
                # 粗略判断：如果该行包含 ", 0," 且 original_name 是汉字开头
                is_root = (", 0," in line) and any('\u4e00' <= char <= '\u9fff' for char in original_name[:1])
                target_name = normalize_name(original_name, is_root)
                line = line.replace(f"'{original_name}'", f"'{target_name}'")
    new_lines.append(line)

with open(SQL_INSERTS_PATH, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)

# 处理 CSV 文件
print("Normalizing CSV Paths...")
df = pd.read_csv(CSV_PATH)

def normalize_path(path_str):
    if not path_str or not isinstance(path_str, str) or '/' not in path_str:
        return path_str
    parts = path_str.split('/')
    
    new_parts = []
    new_parts.append(parts[0]) # 通用标准 / 单项标准
    
    for i, part in enumerate(parts[1:]):
        # 第一级是 root
        new_parts.append(normalize_name(part, is_root=(i == 0)))
        
    return "/".join(new_parts)

# 修正字段名
PATH_COL = '脱敏文件路径'
df[PATH_COL] = df[PATH_COL].apply(normalize_path)
df.to_csv(CSV_PATH, index=False)

print("Normalization Complete.")
