import mysql.connector

# 配置数据库连接
config = {
    'user': 'root',
    'password': 'root',
    'host': '127.0.0.1',
    'port': 3306,
    'database': 'aeo_ai'
}

def rebuild_closure():
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    
    # 1. 获取所有需要修复的文件夹 (ID >= 300)
    cursor.execute("SELECT id, name, parent_id FROM folders")
    all_folders = {f['id']: f for f in cursor.fetchall()}
    
    # 我们只关心 ID >= 300 且 ID < 400 的（我们刚才操作的范围）以及 六、五、八 等
    target_ids = [fid for fid in all_folders if fid >= 264] 
    
    sql_inserts = []
    
    # 清理旧的（针对我们刚才操作的 ID）
    delete_ids = ",".join([str(tid) for tid in target_ids])
    sql_inserts.append(f"DELETE FROM folder_closure WHERE descendant IN ({delete_ids}) OR ancestor IN ({delete_ids});")

    for fid in target_ids:
        # Distance 0: Self
        sql_inserts.append(f"INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES ({fid}, {fid}, 0);")
        
        # Ancestors
        curr_id = fid
        dist = 1
        while True:
            parent_id = all_folders[curr_id]['parent_id']
            if parent_id == 0:
                break
            if parent_id not in all_folders:
                # 如果父级不在当前表（比如根目录），则只记到此
                break
                
            sql_inserts.append(f"INSERT IGNORE INTO folder_closure (ancestor, descendant, distance) VALUES ({parent_id}, {fid}, {dist});")
            curr_id = parent_id
            dist += 1
            
            if dist > 10: # 防止死循环
                break
                
    with open('rebuild_closure.sql', 'w', encoding='utf-8') as f:
        f.write("SET FOREIGN_KEY_CHECKS = 0;\n")
        f.write("\n".join(sql_inserts))
        f.write("\nSET FOREIGN_KEY_CHECKS = 1;")
    
    print(f"Generated {len(sql_inserts)} closure entries.")
    conn.close()

if __name__ == "__main__":
    rebuild_closure()
