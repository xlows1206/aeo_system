# AEO System Agent Collaboration & Implementation Details

本文档记录了参与 AEO 审核系统开发的各 Agent 职责、核心技术决策及近期关键实现的详细说明。

---

## 1. Agent 角色与职责

### Antigravity (Antigravity Agent)
- **职责**：核心逻辑开发、前后端集成、复杂故障排查。
- **当前重点**：
    - AEO 单项标准（一～八）全栈集成与数据一致性维护。
    - 数据库层级结构 (Folders / folder_closure) 与 CSV 审核标准的同步。
    - 后端接口性能优化与路由冲突解决。

---

## 2. 核心实现细节

### 2.1 数据同步流 (AEO 标准同步)
- **工具**：`sync_audit_csv_final.py`
- **逻辑**：
    - 解析 `audit_list_3.csv`，基于"对应部门"进行多维度映射。
    - 将"单项标准"映射至 standard_id = 6（关务部门）。
    - 自动生成 `sync_final.sql`，执行 `folders` 表的 `description` 更新
      及 `folder_check_files` 的关联关系插入。
- **部门 → standard_id 映射**：
    ```
    { '关务': 6, '人事': 3, '信息': 5, '物流': 4, '单项标准': 6 }
    ```

### 2.2 数据库三表关系（核心架构）

```
folders (文件夹树)
  ↓ id 被引用
folder_closure (树形路径缓存，每对 ancestor-descendant 保存一行)
  ↕
folder_check_files (审核项目与文件夹的绑定，folder_id → folders.id)
```

> **关键约束**：`folder_check_files.folder_id` 必须是 `folders.id` 的有效外键。
> 如果 folders 里的记录被删除，对应的 folder_check_files 行就成为"孤儿"，
> `allProjects` 接口的 LEFT JOIN 将返回 NULL，该审核项目在前端彻底消失。

### 2.3 后端接口

| 路径 | 控制器 | 作用 |
|------|--------|------|
| `GET /api/v1/file/projects/all?standard_id=6` | `FileController@allProjects` | 返回所有审核项目的扁平列表 + stats |
| `GET /api/v1/file/index` | `FileController@index` | 返回文件夹树 |

- **数据格式**：`{ "list": [...], "stats": { "total": N, "passed": M } }`
- **排序权重**：一→1, 二→2, 三→3 ... 按汉字权重对 list 排序后返回。

---

## 3. 已知问题根因与修复记录

### 🔴 问题：单项标准"一、二、三、五、六、八"在前端消失

**发现时间**：2026-04-20  
**现象**：`/api/v1/file/projects/all?standard_id=6` 只返回部分记录（六的9条），其余类别全部缺失。

**根本原因**：`folder_check_files` 表中存在**孤儿记录**——这些行的 `folder_id` 指向的 `folders` 记录已被清理操作意外删除。

具体孤儿情况（修复前）：

| fcf.folder_id | fcf.folder_name | 问题 |
|---|---|---|
| 269 | 一-1 进出口单证复核&保管制度 | folders 里 id=269 已不存在 |
| 276 | 三-1 商品检查与进出口法检制度 | folders 里 id=276 已不存在 |
| 279 | 三-4 熏蒸板记录 | folders 里 id=279 已不存在 |

**修复步骤**：
1. **重建 folders 记录**：
   ```sql
   INSERT IGNORE INTO `folders` (`id`, `name`, `standard_id`, `user_id`, `master_id`, `parent_id`, ...)
   VALUES (269, '一-1 进出口单证复核&保管制度', 6, 1, 2, 264, NOW(), NOW());
   -- id=276 parent=377（三-4 商检制度&台账）
   INSERT IGNORE INTO `folders` (...) VALUES (276, '三-4-1 制度', 6, 1, 2, 377, NOW(), NOW());
   -- id=279 parent=377
   INSERT IGNORE INTO `folders` (...) VALUES (279, '三-4-4 熏蒸板记录', 6, 1, 2, 377, NOW(), NOW());
   ```
2. **重建 folder_closure 闭包表**（只针对 standard_id=6 区域）：
   ```sql
   -- 删除旧记录
   DELETE FROM folder_closure
   WHERE ancestor IN (SELECT id FROM folders WHERE standard_id=6)
      OR descendant IN (SELECT id FROM folders WHERE standard_id=6);
   -- 重建 distance=0（自身）
   INSERT INTO folder_closure (ancestor, descendant, distance)
   SELECT id, id, 0 FROM folders WHERE standard_id=6;
   -- 重建 distance=1（直接父子）
   INSERT INTO folder_closure (ancestor, descendant, distance)
   SELECT f.parent_id, f.id, 1 FROM folders f WHERE f.standard_id=6 AND f.parent_id != 0;
   -- 重建 distance=2（跨两层）
   INSERT INTO folder_closure (ancestor, descendant, distance)
   SELECT fc1.ancestor, fc2.descendant, fc1.distance + fc2.distance
   FROM folder_closure fc1 JOIN folder_closure fc2 ON fc1.descendant = fc2.ancestor
   WHERE fc1.distance=1 AND fc2.distance=1
     AND fc1.ancestor IN (SELECT id FROM folders WHERE standard_id=6);
   ```
3. **同步持久化 SQL**：将新恢复的 id=276/279 追加到 `folders_inserts.sql`（位于文件末尾的 Recovery 区块）。

**验证命令**（修复后应返回 22 条）：
```sql
SELECT COUNT(*) FROM folder_check_files fcf
JOIN folders f ON fcf.folder_id = f.id
WHERE fcf.standard_id = 6;
-- 期望结果：22
```

---

## 4. 正确更新审核项目和文件夹的标准流程

> ⚠️ **每一步都是必须的，缺一步都可能导致数据损坏！**

### Step 1：修改 CSV（权威数据源）

编辑 `/Users/aaron.w/Desktop/aeo_system/audit_list_3.csv`，新增或修改审核项目行。
CSV 列格式：`check_name, description, full_path, relative_path, file_count, dept, check_type, check_text`

### Step 2：确认 folders 表层级结构存在

在运行同步脚本前，必须先确保 CSV 中路径对应的文件夹 ID 在 `folders` 表中已存在。

**检查脚本**：
```sql
-- 列出 standard_id=6 已存在的文件夹层级
SELECT id, name, parent_id FROM folders WHERE standard_id=6 ORDER BY id;
```

如果需要新增文件夹节点，必须同时：
1. `INSERT INTO folders (id, name, standard_id, parent_id, ...) VALUES (...)`
2. 手动重建 `folder_closure`（用上面第 3.1 节的 SQL 模板）
3. **将 INSERT 语句追加到 `folders_inserts.sql`** 持久化

### Step 3：运行同步脚本

```bash
cd /Users/aaron.w/Desktop/aeo_system
python3 sync_audit_csv_final.py
# 生成 sync_final.sql
```

### Step 4：执行生成的 SQL

```bash
docker exec -i mysql-aeo mysql --default-character-set=utf8mb4 -u root -proot aeo_ai < sync_final.sql
```

### Step 5：验证数据一致性（必做）

```sql
-- 检查是否存在孤儿 fcf 记录（folder_id 指向不存在的 folders）
SELECT fcf.folder_id, fcf.folder_name
FROM folder_check_files fcf
LEFT JOIN folders f ON fcf.folder_id = f.id
WHERE fcf.standard_id = 6 AND f.id IS NULL;
-- 期望：0 行。如果有行，说明 folders 里缺对应记录，需要补建。

-- 检查总数
SELECT COUNT(*) FROM folder_check_files WHERE standard_id = 6;
```

### Step 6：更新文档

修改 `data_pipeline.md` 和 `project_todo_list.md`，记录本次变更内容。

---

## 5. 经验教训（防止再次踩坑）

### ⚡ 教训 1：清理数据库前必须保留 fcf 引用关系

**踩坑**：为修复乱码和重复数据，对 `folders` 表执行了 `DELETE WHERE id >= 269` 的批量清理，
但没有检查 `folder_check_files` 中是否还在引用这些 id，导致 fcf 变成孤儿记录，
相关审核项目在前端彻底消失。

**正确做法**：清理 folders 前，先运行：
```sql
SELECT DISTINCT folder_id FROM folder_check_files WHERE folder_id IN (/* 将要删除的 id 列表 */);
-- 如果返回任何行，绝对不能直接删除，必须先迁移 fcf 的 folder_id 或同步创建新 folders 记录。
```

### ⚡ 教训 2：folder_closure 必须与 folders 同步维护

**踩坑**：手动插入或删除 `folders` 记录后，忘记同步更新 `folder_closure`，
导致前端树形结构查询（getAncestorsAndSelf）失败或路径不正确。

**正确做法**：每次增删 folders 记录后，立即检查并重建对应的 closure 行。
不要试图手动单条插入 closure，直接用批量重建脚本（见第 3 节）更安全。

### ⚡ 教训 3：folders_inserts.sql 是唯一的持久化依据

**踩坑**：直接在数据库里修改了 folders 数据，但没有同步更新 `folders_inserts.sql`，
导致下次重置 / 迁移时这些修改丢失，问题又复现。

**正确做法**：
- 所有 `folders` 的新增/修改，必须同步写入 `folders_inserts.sql`（使用 `INSERT IGNORE`）。
- 该文件末尾有 `-- Recovery & Cleanup` 区块，追加到那里。

### ⚡ 教训 4：孤儿记录诊断是排查入口

当发现某个审核类别（如"一"、"三"）在前端消失时，第一步不是检查前端代码，
而是运行孤儿诊断 SQL：
```sql
SELECT fcf.folder_id, fcf.folder_name, fcf.standard_id
FROM folder_check_files fcf
LEFT JOIN folders f ON fcf.folder_id = f.id
WHERE fcf.standard_id = <目标 standard_id> AND f.id IS NULL;
```
如果有返回行，说明是 folders 记录丢失，先修复数据层再看前端。

### ⚡ 教训 5：fcf 的 folder_name 与 folders 的 name 不需要严格一致

`folder_check_files.folder_name` 是显示用的标签文本（前端 allProjects 接口用 `FolderDisplayName::format` 格式化），
和 `folders.name` 是独立字段，两者可以不完全一样。
诊断时以 `fcf.folder_id → folders.id` 的关联是否存在为准，不要被名字是否一致迷惑。

---

## 6. 维护规范

### 标准同步链条
```
修改 audit_list_3.csv
  → 确认 folders 层级已存在（必要时先建文件夹 + 重建 closure）
  → python3 sync_audit_csv_final.py（生成 sync_final.sql）
  → 执行 sync_final.sql
  → 运行孤儿诊断 SQL 验证
  → 更新 folders_inserts.sql（追加新增的 folders 行）
  → 更新 data_pipeline.md + project_todo_list.md
```

### 数据层关键 ID 速查（standard_id=6 单项标准）

| folders.id | name | parent_id |
|---|---|---|
| 264 | 一、加工贸易以及保税进出口业务 | 0 |
| 265 | 二、卫生检疫业务 | 0 |
| 266 | 三、动植物检疫业务 | 0 |
| 267 | 五、进出口商品检验业务 | 0 |
| 268 | 八、物流运输业务 | 0 |
| 300 | 六、代理报关业务 | 0 |
| 269 | 一-1 进出口单证复核&保管制度 | 264 |
| 372 | 二-2 特殊物品单证 | 265 |
| 373 | 二-3 特殊物品安全管理制度 | 265 |
| 377 | 三-4 商检制度&台账 | 266 |
| 276 | 三-4-1 制度 | 377 |
| 388 | 三-4-2 进境商检查验管理台账 | 377 |
| 389 | 三-4-3 抽查单证 | 377 |
| 279 | 三-4-4 熏蒸板记录 | 377 |
| 378 | 五-9 法检制度 | 267 |
| 379 | 八-20 运输工具管理制度 | 268 |
| 380 | 八-21 运输工具行驶轨迹 | 268 |
| 381 | 八-21-1 制度 | 380 |
| 382 | 八-21-2 轨迹记录 | 380 |
| 383 | 八-22 运输工具与驾驶人员匹配制度 | 268 |
| 384 | 八-22-1 制度 | 383 |
| 385 | 八-22-2 记录 | 383 |
| 301-309 | 六-1 至 六-9（代理报关业务子项） | 300 |

---

---

## 7. 企业业务主体性质与检测项目绑定 (2026-04-20 新增)

### 7.1 核心逻辑
- **业务主体性质**：主账号在“系统设置”中可多选：物流、仓储、报关、外贸。
- **动态展示白名单**：前端“评估/评估详情”与“资料管理”中的“单项标准 (standard_id=6)”部分，会根据该公司 `bind_projects` 字段中存储的项目 ID 列表进行实时过滤。
- **自动进度重算**：过滤后的项目总数将作为进度计算的分母，仅对绑定的项目进行合规统计。

### 7.2 逻辑映射规则

| 业务主体性质 | 关联检测项目 (folder_check_files.id) | 对应大类 |
|---|---|---|
| 物流 | 58, 59, 60, 61, 62 | 八、物流运输业务 |
| 仓储 | 55, 54 | 一、加工贸易；二、卫生检疫 |
| 报关 | 55, 53, 50, 57, 63-71 | 一、二、三、五、六(全) |
| 外贸 | 55, 53, 54, 50, 57 | 一、二、三、五、单项标准通用 |

### 7.3 数据库实现详情
- **`company_info` 表**：
  - `types` (varchar)：存储业务主体 ID 集合（逗号分隔，如 `1,3`）。
  - `bind_projects` (text)：存储最终生效的 `folder_check_files.id` 集合（逗号分隔）。
- **`company_types` 表**：
  - `note` (varchar)：存储该类型默认绑定的项目清单建议。

### 7.4 开发变更点
- **后端**：`FileController@allProjects` 及 `FileController@lists` 增加了针对 `standard_id=6` 且 `bind_projects` 非空的 `WHERE IN` 过滤。
- **前端**：`company/index.vue` 增加了基于计算属性 `filteredProjectCategories` 的分块动态展示逻辑。

---

*Updated by Antigravity - 2026-04-20 (Added Business Nature Filtering)*
