import pandas as pd

# 读取CSV
df = pd.read_csv('/Users/aaron.w/Desktop/aeo_system/AEODOC_Fixed_Paths.csv', dtype=str)

print(f"总行数: {len(df)}")
print(f"列名: {list(df.columns)}")

# 按C列（文件路径）分组，收集所有B列文件清单
path_to_files = {}
for idx, row in df.iterrows():
    path = str(row['文件路径']).strip() if pd.notna(row['文件路径']) else ''
    file_name = str(row['文件清单']).strip() if pd.notna(row['文件清单']) else ''
    
    if path and path != 'nan':
        if path not in path_to_files:
            path_to_files[path] = []
        if file_name and file_name != 'nan' and file_name not in path_to_files[path]:
            path_to_files[path].append(file_name)

# 打印共享同一路径的分组（有多个文件的）
print("\n===== 共享同一路径的审核项目（多文件）=====")
for path, files in path_to_files.items():
    if len(files) > 1:
        print(f"\n路径: {path}")
        for f in files:
            print(f"  - {f}")

# 生成"需上传文件说明"列内容
def make_description(files):
    if not files:
        return ''
    if len(files) == 1:
        return f"请上传：{files[0]}"
    else:
        items = '\n'.join([f"{i+1}. {f}" for i, f in enumerate(files)])
        return f"请上传以下文件：\n{items}"

path_to_description = {
    path: make_description(files)
    for path, files in path_to_files.items()
}

# 新增列
df['需上传文件说明'] = df['文件路径'].apply(
    lambda p: path_to_description.get(str(p).strip(), '') if pd.notna(p) else ''
)

# 输出到新CSV
output_path = '/Users/aaron.w/Desktop/aeo_system/AEODOC_Fixed_Paths_Updated.csv'
df.to_csv(output_path, index=False, encoding='utf-8-sig')
print(f"\n✅ 已输出到: {output_path}")

# 统计
single_count = sum(1 for files in path_to_files.values() if len(files) == 1)
multi_count = sum(1 for files in path_to_files.values() if len(files) > 1)
print(f"\n统计结果：")
print(f"  - 唯一路径总数: {len(path_to_files)}")
print(f"  - 单文件路径（独立项目）: {single_count}")
print(f"  - 多文件路径（需合并说明）: {multi_count}")
