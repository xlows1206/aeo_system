# AEO System Agent Collaboration & Implementation Details

本文档记录了参与 AEO 审核系统开发的各 Agent 职责、核心技术决策及近期关键实现的详细说明。

---

## 1. Agent 角色与职责

### Antigravity (Antigravity Agent)
- **职责**：核心逻辑开发、前后端集成、复杂故障排查。
- **当前重点**：
    - **AEO 镜像层级架构**：自 2026-04-21 起，系统全面升级为“全准则 Universal Sync”模式。`folders_inserts.sql` 必须与 `audit_list_3.csv` 的 `脱敏文件路径` 严格 1:1 对齐。
    - **V3 符号标准化规范**：
        - **顶级根目录**：使用 `一、` 或 `六、` 汉字顿号风格。
        - **子目录与项目**：使用 `16-60-名称` 连字符风格，彻底移除序号与名称间的空格。
        - **全链路物理同步**：运行 `normalize_disk_folders.py` 对磁盘上的物理目录进行了批量 Bottom-Up 重命名。
    - **四位一体同步**：确保磁盘、CSV、数据库、SQL 种子四端符号逻辑绝对统一。

---

## 2. 核心实现细节

### 2.1 数据同步流 (全准则通用同步)
- **工具**：`sync_audit_csv_universal.py`
- **逻辑**：
    - 解析 `audit_list_3.csv` 全量 71 个项目。
    - 根据 `对应部门` 自动映射 `standard_id` (1:财务, 2:人事, 3:行政, 4:关务, 5:审计, 6:单项标准)。
    - 自动识别根路径并根据“根目录顿号、子项连字符”规则生成 SQL。

### 1. 结构与符号规范化 (V3 标准 - 2026-04-21)
- [x] **连字符去空格化**：将所有子级文件夹的 `、` 和 `.` 替换为 `-`，并移除了序号后的空格（如 `16-60-名称`）。
- [x] **根目录顿号保留**：顶级分类保持 `六、` 这种稳重的汉字顿号风格。
- [x] **Universal 引擎重构**：打破了只能处理 Standard 6 的限制，现在支持 1-6 全准则载入。

### 2. 核心处理流程
- [x] 物理磁盘格式化 -> CSV 路径对齐 -> SQL 种子规范化 -> Universal 脚本生成 SQL -> 闭包表重建 -> 账号绑定刷新。
映射 (以 folders_inserts.sql 为准)**：
    ```
    { '财务': 1, '人事': 2, '行政': 3, '关务': 4, '审计/审计部': 5, '单项标准': 6 }
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

### 🔴 问题：由于 500 报错导致“审计开始年份”为空且页面初始化中断

**发现时间**：2026-04-20
**现象**：公司设置页面年份下拉框显示“请选择”但点击无任何选项，同时项目列表大类显示正常但子项可能缺失。

**根本原因**：
1. **API 崩溃**：`/api/v1/file/projects/all` 接口在处理 `folder_check_files` 中的孤儿记录时，将 `null` 传给了 `FolderDisplayName::format`（该函数之前带有严格的 `string` 类型声明），导致 PHP 报出 Fatal Error 并返回 500。
2. **JS 执行链截断**：前端 `index.vue` 的 `onMounted` 钩子函数中，获取项目列表的请求排在生成年份选项 (`generateYearOptions`) 之前。由于 API 请求抛出异常且未被局部捕捉，导致 `onMounted` 的后续代码（包括生成年份选项和回显已有配置）全部停止运行。

**修复步骤**：
1. **代码容错**：修改 `FolderDisplayName::format` 和 `normalizeParentName`，允许接收 `null` 参数并返回空字符串。
2. **查询优化**：在 `FileController` 中将 `leftJoin('folders as f')` 改为 `join('folders as f')`（即 `INNER JOIN`），确保不返回没有对应实际文件夹的无效项目。
3. **数据补全**：根据备份手动补全了 `folders` 表中缺失的 ID（如 387, 372 等），恢复了 22 个核心审核项目。

### 2.4 公司设置 API 整合 (原子化保存)
为了彻底解决并发保存导致的竞态冲突（不同请求互相覆盖），系统采用了**单一口径保存**架构：
- **接口**：`POST /api/v1/company` (对应 `CompanyController@store`)。
- **改动**：将原本分散在多个接口的 `start_year`, `end_year`, `not_self_total` 等字段收缩到 `store` 方法中。
- **前端封装**：`index.vue` 在提交前自动计算 `duration_year` 并构造完整的参数对象进行一次性提交。

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

> [!IMPORTANT]
> **重建闭包表 (folder_closure)**：由于我们的 SQL 种子目前不包含闭包数据，每次 `TRUNCATE folders` 后，**必须**手动执行闭包表重建 SQL（插入 distance 0, 1, 2...），否则前端导航路径（Breadcrumb）会因溯源失败而锁死在“全部”。

### Step 3：运行同步脚本

```bash
cd /Users/aaron.w/Desktop/aeo_system
python3 sync_audit_csv_universal.py
# 生成 sync_universal.sql
```

### Step 4：执行生成的 SQL

```bash
docker exec -i mysql-aeo mysql --default-character-set=utf8mb4 -u root -proot aeo_ai < sync_universal.sql
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

### Step 6：刷新环境与清理缓存 (必做)

> ⚠️ **仅重启后端容器通常不足以使变更立刻生效！**

```bash
# 1. 重启后端容器使代码变更生效 (若涉及 SCAN_CACHEABLE)
docker restart hyperf-skeleton

# 2. 强制清理 Redis 缓存 (核心：必须清理才能刷新分类名称和项目列表)
docker exec -i redis-aeo redis-cli flushall

# 3. 浏览器端处理
# 按 Ctrl + F5 强制刷新页面，避免 API 响应被浏览器本地缓存。
```

### Step 7：更新文档
修改 `data_pipeline.md` 和 `project_todo_list.md`，记录本次变更内容。

---

- **详情页头部**：进入任何审核项目后，顶部标题必须**仅显示当前文件夹名称**（排除所有父级前缀）。
- **示例**：路径为 `财务状态 -> 审计报告` 时，标题仅显示 `5-13-审计报告`。
- **名称来源**：由 `FileController@index` 的 `paths` 数组末项提供，由前端绑定至 `h2` 标签。
- **视觉要求**：标题使用 `text-xl` 字号，加粗显式，并占据头部操作栏的剩余宽度。

### ⚡ 教训 1：分类名称与项目数据的二元性
**描述**：左侧菜单显示的“部门分类名称”来源于 `standards` 表，而右侧显示的“审核项目列表”来源于 `folders` 与 `folder_check_files`。
**对策**：如果需要修改一级分类的文字（如“财务”、“关务”），必须同步 `UPDATE standards SET name = 'xxx' WHERE id = n;`。

### ⚡ 教训 2：Redis 缓存持久性
**描述**：Hyperf 在数据管理上使用了深度缓存。重启 `hyperf-skeleton` 只会重启 PHP 进程，而 Redis 中的 JSON 缓存块会跨容器重启持续存在。
**对策**：涉及数据库映射（Mapping）或元数据（Metadata）的修改，必须执行 `redis-cli flushall`。

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

### ⚡ 教训 6：后端接口崩溃会导致前端生命周期函数 (Cycle Hooks) 截断

**描述**：在 Vue 的 `onMounted` 或其他 async 函数中，如果前面的 `await` 请求发生了 500 错误且没有被 `try-catch` 包裹，后续的所有初始化逻辑（哪怕完全不依赖这个请求）都会停止执行。
**对策**：
- 重要的初始化 logic（如生成本地下拉框选项）应放在 async 请求之前，或者确保请求被 `try-catch` 包裹。
- 保证每个环境都能稳定生成基础字典数据。

### ⚡ 教训 7：严格类型声明 (Strict Types) 在处理数据库 JOIN 结果时需谨慎

**描述**：PHP 的 `string` 类型声明在接收到 `null` 时会直接导致致命错误。在执行 `LEFT JOIN` 后，右表字段极可能为 `null`。
**对策**：
- 在数据展示层（Support / Transformer）的函数参数中，优先使用 `?string` 而非 `string`。
- 函数内部应显式处理 `null` 情况。

## 6. 维护规范

### 标准同步链条
```
修改 audit_list_3.csv
  → 确认 folders 层级已存在（必要时先建文件夹）
  → 重建闭包表 (关键：INSERT INTO folder_closure SELECT ... ORDER BY distance)
  → python3 sync_audit_csv_universal.py（生成 sync_universal.sql）
  → 执行 sync_universal.sql
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
| 500 | 一、内部控制标准 | 0 |
| 527 | 二、财务状况标准 | 0 |
| 520 | 三、守法规范标准 | 0 |
| 531 | 四、贸易安全标准 | 0 |
| 902 | 1-单证复核及系统逻辑检验 | 300 |
| 903 | 1-1-进出口单证及复核制度文件 | 902 |
| 571 | 16-60-货物安全培训 | 568 |

---

---

## 7. 企业业务主体性质与检测项目绑定 (2026-04-24 架构升级)

### 7.1 核心逻辑 (多租户动态映射)
- **多租户隔离**：自 2026-04-24 起，所有租户数据通过 `master_id` 物理隔离。
- **动态展示白名单**：前端“评估/评估详情”与“资料管理”中的“单项标准 (standard_id=6)”部分，会根据该公司 `bind_projects` 字段中存储的项目 ID 列表进行实时过滤。
- **云端/本地对齐策略**：由于不同环境的数据库自增 ID（Auto-Increment IDs）不一致，系统放弃了硬编码 ID 绑定，升级为**基于名称的动态映射**。

### 7.2 动态映射流程
1. **模板定义**：在 `company_types.note` 中存储 `master_id=0`（系统模板）下的项目 ID。
2. **实时转换**：`CompanyController@types` 接口被调用时：
   - 提取 `note` 里的模板 ID 集合。
   - 查询这些 ID 在 `master_id=0` 对应的 `文件夹名称` + `项目名称`。
   - 在当前登录用户的 `master_id` 下，通过 `名称` 反查对应的本地 ID。
   - 返回给前端当前租户可用的真实 ID。

### 7.3 数据库实现详情
- **`company_info` 表**：
  - `types` (varchar)：存储业务主体 ID 集合（逗号分隔，如 `1,3`）。
  - `bind_projects` (text)：存储最终生效的 `folder_check_files.id` 集合（租户本地 ID）。
- **`company_types` 表**：
  - `note` (TEXT)：存储该类型建议绑定的**模板项目 ID**。已从 `varchar(255)` 扩容为 `TEXT` 以支持“报关”等包含大量项目的类别。
- **`folders` & `folder_check_files`**：新增 `master_id` 字段（默认 0），所有租户数据必须带有正确的 `master_id`。

### 7.4 关键维护命令
- **租户初始化/同步**：
  ```bash
  # 将 master_id=0 的结构克隆给指定的租户 (如 id=2)
  # --force 会删除该租户旧数据并重新克隆
  php bin/hyperf.php folder:init -m 2 --force
  ```
- **云端 ID 校准 (数据迁移时使用)**：
  通过 SQL 子查询基于 `f.name` 动态更新 `company_types.note`，避免 ID 错位。

---

## 8. AI 检测与审计逻辑升级 (2026-04-21)

### 8.1 PDF 提取策略
- **规则**：针对 `检测方式 = 关键词检测` 的项目，后端 `GetAiResult` Job 会将 PDF 解析范围强制限制在 **前 2 页**。
- **目的**：提高处理效率，降低 Token 成本，平衡审核关键信息获取效率。

### 8.2 核心关键词规则表 (V3)

| 文件夹/项目名称 | 关键词 (check_text) | 逻辑说明 |
|---|---|---|
| 一-1 进出口单证复核&保管制度 | “单证管理”、“复核” | 满足其一即可 |
| 二-3 特殊物品安全管理制度 | “单证管理”、“复核” | 满足其一即可 |
| 五、进出口商品检测法检制度 | “商检”、“法检” | 满足其一即可 |
| 八、物流运输相关制度 | “车辆管理” | 包含该描述 |

### 8.3 物理磁盘变动
- **Category 五**：新增物理目录 `10-历年法检查验管理台账` 及 `11-历年抽查单证文件` 以支持台账类文件的上传。

---

## 9. 生产环境同步总结 (2026-04-24)

### 9.1 核心修复记录
- **500 错误消除**：通过 `INNER JOIN` 和 `null` 容错处理，解决了因 `folder_id` 孤儿记录导致的 API 崩溃。
- **字段类型扩容**：`ALTER TABLE company_types MODIFY COLUMN note TEXT;` 解决了报关项目过多导致的 Data Too Long 报错。
- **多租户数据对齐**：通过 `folder:init` 确保了租户层级与模板层级 100% 同步。

### 9.2 缓存刷新协议
每次涉及“业务主体映射”或“目录结构”修改后，**必须**执行：
1. `docker restart hyperf-skeleton` (或对应 php 进程重启)
2. `redis-cli flushall` (强制清理元数据缓存)
3. 浏览器 `Ctrl + F5` (清理前端 Axios 缓存)

---

### 🔴 问题：由于 SQL 字段数量不匹配导致审核结果写入失败 (1136 Error)

**发现时间**：2026-04-24
**现象**：云端提交审核后状态显示“失败”，且前端不显示任何结果。日志报错：`SQLSTATE[21S01]: Insert value list does not match column list: 1136 Column count doesn't match value count at row 4`。

**根本原因**：
1.  **数组结构不统一**：在 `GetAiResult.php` 中，混合了 AI 审核项（7个字段，含 `result_str`）和非 AI 审核项（6个字段）。
2.  **批量插入特性**：Hyperf 的 `insert()` 方法会以数组第一个元素为准生成列名列表。如果首个元素是 6 列，后续遇到 7 列的元素就会因字段溢出而导致整个事务回滚并报错。

**修复步骤**：
1.  **统一字段 Schema**：在 `GetAiResult.php` 中强制所有审核分支输出包含 `result_str` 在内的完整 7 字段结构。
2.  **显式类型转换**：对插入的数据执行 `(int)` 和 `(string)` 强制转换，增强数据入库的安全性。
3.  **重启队列**：由于常驻进程缓存，修改后必须执行 `kill` 并重启 `php bin/hyperf.php queue:work` 才能生效。

### 🔴 问题：本地 Docker 环境无法处理 PDF 审核

**发现时间**：2026-04-24
**现象**：本地测试 PDF 审核时直接崩溃或无响应。

**原因**：
1.  **工具缺失**：本地 Alpine 镜像未安装 `ghostscript`。
2.  **配置缺失**：`.env` 文件中缺少 OSS 相关的 KEY 与 Endpoint 定义。

**修复步骤**：
1.  **安装依赖**：运行 `apk add ghostscript imagemagick`。
2.  **补全配置**：在本地 `.env` 补齐 OSS 模板并重启容器。

---

## 10. AI 审核展示与结论透传逻辑升级 (2026-04-24)

### 10.1 核心展示范式转移
- **从“文件”到“项目”**：系统现已废弃“每个文件显示一行结论”的模式，升级为**按审核项 (Check Project) 聚合**。同一项目下的多个关联文件会合并处理，输出唯一的结构化结论，彻底解决了历史记录重复的问题。
- **UI 纯净匹配**：前端 `Info.vue` 引入了 `normalize` 算法，忽略 `、` 和 `-` 的符号差异，确保物理路径与审核规则 100% 匹配。

### 10.2 结论分层透传体系 (Conclusion Layering)
为了平衡“审核透明度”与“话术标准化”，系统建立了三级结论反馈机制：

1. **AI 深度结论 (High Transparency)**：
   - **适用项**：资产负债率、审计报告、无犯罪证明等。
   - **实现**：通过 `AbstractHandler::getSuccessMessages` 钩子，将 AI 提取的原始数据（如：负债率 65.4%、无保留审计意见）直接透传至前端。
2. **标准合格话术 (Standardized)**：
   - **适用项**：关键字检测、上传即通过项目。
   - **文案**：`上传的文档文件符合审核项目标准。`
3. **AI 提取异常提醒 (Defensive)**：
   - **适用项**：AI 无法从模糊或不匹配的文档中识别关键字段时。
   - **文案**：`未能从文档中提取到有效的审核结论，请检查文件内容。`

### 10.3 数据库与工程变更
- **字段迁移**：`pre_audit_results` 表字段由 `failed_str` 统一更名为 `result_str` (TEXT)，存储结构化 JSON。
- **状态判定逻辑**：
  - 列表左侧状态：仅在“历史记录”中存在“全项合格”时标记为完成。
  - 历史记录颜色：`status: 1` (绿色/合格)，`status: 0` (红色/不合格)。

---

## 11. 审核流水线标准化 (2026-04-25 V4 标准)

### 11.1 Unified `check_type` 映射
为了消除端到端识别歧义，系统统一了 `check_type` 的字段含义：

| 数据库值 | 定义 | 业务描述 | 处理逻辑 |
|---|---|---|---|
| **1** | **AI内容理解** | AI Semantic/Numerical | 调用具体 Handler (如 FinancialRatio) |
| **2** | **关键词检测** | Keyword Match | 调用 KeywordMatchHandler (正则/关键词) |
| **3** | **上传即为通过** | Simple Check | 不经过 AI，直接标记合格 |

### 11.2 同步与执行流
- **权威源**：`audit_list_3.csv` 中的“检测方式”列。
- **转换器**：`sync_audit_csv_universal.py` 负责将文字转换为上述数字编码。
- **执行引擎**：`GetAiResult.php` 依据编码分配并行队列：
  - `in_array(type, [1, 2])` -> 加入 AI 任务。
  - `type == 3` -> 构造静态合格记录。

---

## 12. 权威数据源切换：云端至本地反向同步 (2026-04-25)

### 12.1 痛点解决
为了解决“本地脚本/CSV 与云端手动优化数据冲突”的问题，系统正式切换为 **“云端管理，本地备份”** 的反向驱动模式。云端数据库现在是审核项配置的唯一权威源。

### 12.2 反向同步流 (Cloud-to-Local)
1. **云端导出**：在服务器执行 `mysqldump ... --no-tablespaces ... > cloud_audit_structure.sql`。
2. **反向同步**：运行本地脚本 `python3 sync_db_to_csv.py`。
   - **逻辑**：解析 SQL 里的 `INSERT` 语句，自动将最新的 `check_type`、`check_text` 和 `folder_name` 写回本地 `audit_list_3.csv`。
3. **代码持久化**：提交更新后的 CSV 到 Git，确保全队共享最新的审核逻辑。

### 12.3 维护守则
- **禁止**：禁止直接手动修改本地 `audit_list_3.csv` 而不同步云端。
- **强制**：所有关于 `check_type`（1/2/3）或 `check_text`（关键词）的线上调整，必须在调整后执行一次反向同步，以保持代码库与生产环境 100% 对齐。

---

*Updated by Antigravity - 2026-04-25 (Cloud-to-Local Reverse Sync Workflow)*
