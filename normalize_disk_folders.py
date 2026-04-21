import os
import re

# 1. 规则函数 (必须与 normalize_config.py 完全一致)
def normalize_name(name, is_root=False):
    if not name or not isinstance(name, str):
        return name
    
    # 规则 1: 根目录保留/变更为“汉字序号 + 顿号”格式
    if is_root:
        name = re.sub(r'^([一二三四五六七八九十]+)\s+', r'\1、', name)
        return name
    
    # 规则 2: 非根目录 - 符号转换
    name = name.replace('、', '-')
    name = re.sub(r'(\d+)\.\s*', r'\1-', name)
    name = re.sub(r'(\d+)\s+', r'\1-', name)
    name = re.sub(r'(\d+-\d+)\s+', r'\1-', name)
    
    # 规则 3: 极端清理
    name = re.sub(r'-+', '-', name)
    name = name.strip('-')
    
    return name

TARGET_ROOTS = [
    '/Users/aaron.w/Desktop/aeo_system/单项标准',
    '/Users/aaron.w/Desktop/AEO/通之意AEO认证提交版/通用'
]

print("Starting Physical Folder Normalization...")

for root_base in TARGET_ROOTS:
    if not os.path.exists(root_base):
        print(f"Skipping non-existent root: {root_base}")
        continue
    
    print(f"Processing Root: {root_base}")
    
    # 我们采用自底向上的方式重命名，以防父级名称改变导致找不到路径
    for dirpath, dirnames, filenames in os.walk(root_base, topdown=False):
        for dirname in dirnames:
            # 判断是否是 root 的直接子级 (即业务根目录，如 "一 内部控制")
            parent_dir = os.path.basename(dirpath)
            # 如果 dirpath 就是 root_base，那么 dirname 就是 Root 节点
            is_root = (dirpath.rstrip('/') == root_base.rstrip('/'))
            
            target_name = normalize_name(dirname, is_root)
            
            if target_name != dirname:
                old_path = os.path.join(dirpath, dirname)
                new_path = os.path.join(dirpath, target_name)
                
                try:
                    print(f"Renaming: {dirname} -> {target_name}")
                    os.rename(old_path, new_path)
                except Exception as e:
                    print(f"Error renaming {old_path}: {e}")

print("Physical Renaming Complete.")
