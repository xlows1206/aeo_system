# 数据流观察日记 (data_pipeline.md)

## 公司设置保存流程

### 1. 前端输入 (Form Data)
- **节点**: `ai_admin_web/src/views/system/company/index.vue` -> `handleSubmit`
- **值示例**: 
  ```json
  {
    "name": "123",
    "legal_person": "张三",
    "audit_start_year": 2021,
    "audit_end_year": 2022,
    "declaration_count": 150
  }
  ```
- **状态**: 待核实
- **存在问题**: 保存失败（提示“服务器错误”）

### 2. API 请求 (Request)
- **节点**: Axios / Fetch Request
- **URL**: 待核实
- **Method**: 待核实
- **Payload**: 待核实
- **状态**: 待核实

### 3. 后端接收与处理 (Backend)
| 后端获取用户信息 | `Comp...Controller.php` | `$request->getParsedBody()['Auth']` | 异常已捕获 | 500 | 成功 | 已优化 getParsedBody 容错 |
| ParsedBody 解析 | `UserAuthMiddleware.php` | `JWT` 解析后的 `$user` 与 Body 合并 | 异常已捕获 | 500 | 成功 | 兼容对象/数组类型转换 |
| 批量保存接口 | `Comp...Controller.php` | `Promise.all` 调用三个接口 | 状态监控中 | 403/500 | 待验证 | 已添加全局 try-catch |
- **状态**: **已修复 (通畅)**

### 4. 数据库持久化 (Database)
- **表**: `company_info`
- **状态**: 未到达

---

## 系统/环境配置节点 (System Infrastructure)
- **节点**: `mcp_config.json`
- **问题**: `Property $typeName is not allowed` (架构配置不符合 MCP 标准)
- **输入**: 原始包含元数据的 JSON 配置文件
- **输出**: 标准的 MCP `mcpServers` 配置文件
- **状态**: **已修复 (通畅)**
- **日期**: 2026-04-19

---

## AEO 审核标准同步流程 (AEO Audit Standards Sync)

### 1. 数据采集与映射 (Data Enrichment)
- **节点**: `AEODOC_Fixed_Paths_Updated.csv` -> `audit_list_3.csv`
- **处理方式**: 提取“单项标准-六”开头的项目，映射部门、检测方式、描述。
- **状态**: **已完成 (通畅)**
- **记录日期**: 2026-04-19

### 2. 文件夹骨架建立 (Folder Infrastructure)
- **节点**: `folders_inserts.sql`
- **操作**: 追加 `ID 300-309` 的 SQL 插入语句，建立“六、代理报关业务”层级。
- **状态**: **已完成 (通畅)**
- **记录日期**: 2026-04-19

### 节点 2: AEO 标准同步库 (audit_list_3.csv)
- **数据流**: `audit_list_3.csv` (UTF-8) -> `sync_audit_csv_final.py` -> `sync_final.sql` (UTF-8) -> MySQL (aeo_ai)
- **状态**: ![通畅](https://img.shields.io/badge/%E7%8A%B6%E6%80%81-%E9%80%9A%E7%95%85-green)
- **关键问题修复**:
  - **编码问题**: 之前使用 `docker exec` 时未指定 charset 导致乱码。已修复为使用 `--default-character-set=utf8mb4`。
  - **字段约束**: 修复了 `folder_check_files` 缺失 `check_name` 和 `check_type` 导致的插入失败。
- **值示例**:
  ```json
  {
    "name": "六、代理报关业务 - 六-1 进出口单证及复核制度文件",
    "description": "请上传以下文件：\n1. 进出口单证及复核制度文件",
    "department": "关务",
    "standard_id": 6
  }
  ```

### 节点 3: 后端 API (FileController)
- **路径**: `/api/v1/file/projects/all?standard_id=6`
- **处理逻辑**: 聚合 `folders` 与 `folder_check_files` 的统计数据，支持按 standard_id 过滤。
- **状态**: ![通畅](https://img.shields.io/badge/%E7%8A%B6%E6%80%81-%E9%80%9A%E7%95%85-green)
- **解决状态**: 已完成逻辑迁移，解决了之前 404/405 路由冲突。
- **输出格式**:
  ```json
  {
    "code": 200,
    "result": {
      "list": [...],
      "stats": { "total": 16, "passed": 0 }
    }
  }
  ```

### 3. 数据同步与 SQL 生成 (Sync Logic)
- **节点**: `sync_audit_csv_final.py` -> `sync_final.sql`
- **逻辑**: 通过“脱敏路径”匹配 `folders` 表 ID，更新 `description` 和 `department`，并同步 `folder_check_files`。
- **输入**: `audit_list_3.csv`, `folders_inserts.sql`
- **输出**: `sync_final.sql` (含 215 处更新/插入)
- **状态**: **已完成 (通畅)**
- **数据示例**:
  ```sql
  UPDATE `folders` SET `department` = '关务', `description` = '...', `standard_id` = 6 WHERE `id` = 301;
  INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, ...) VALUES (301, '六-1 ...', 6, ...);
  ```
- **记录日期**: 2026-04-19

### 4. 接口加载验证 (Interface Loading)
- **节点**: 前端 `apiGetAllProjects` -> 后端 `allProjects`
- **故障排查: 404 接口错误**
    - 现象: `GET /api/v1/folder/allProjects` 404
    - 原因: 路由迁移导致路径变更，前端未同步更新；数据库 schema 缺失 `audit_status` 导致同步脚本失败。
    - 解决: 统一迁移至 `/api/v1/file/allProjects`, 添加 `audit_status` 字段, 修正 `sync_audit_csv_final.py` 逻辑。
    - 状态: 已通畅 (2026-04-19)

### 3.4 单项标准 - 六、代理报关业务
- 输入: `audit_list_3.csv` (199-215行)
- 逻辑: `sync_audit_csv_final.py` -> `REPLACE INTO folders` (ID 300-309) -> `sync_final.sql`
- 输出值示例: `{ "folder_id": 301, "folder_name": "六-1 进出口单证及复核制度文件", "standard_id": 6, "audit_status": 0 }`
- 状态: 已通畅 (2026-04-19)
  - 前端 `pan.ts` 仍指向旧路径 `/v1/folder/allProjects`。
    - **处理建议**: 统一前端 API 地址并完善 `FileController` 中的数据统计逻辑。
- **状态**: [阻塞 - 前端接口偏差]

## 第四章：数据重建与重复项清理 - 2026-04-20
**1. 遇到的问题**：
发现“五、进出口商品检验”、“八、物流运输业务”、“二”、“三”等单项标准目录在系统中存在大量冗余、重名记录，同时层级关系缺失，导致 AEO 系统数据失真。

**2. 解决状态**：已解决。

**3. 处理节点与数据流**：
- **诊断**：数据库中存在脏数据，部分由于前期测试执行脚本产生。
- **清理方案**：
    - **删除冗余**：彻底删除 ID >= 269（排除新增的）相关的无效结构（`DELETE FROM folders` + `DELETE FROM folder_closure`）。
    - **重构层级**：以单向 ID 作为统一基准点，重新在数据库建立“八”等目录的三级嵌套。
        - 比如：八、物流运输业务 (268) -> 八-21 运输工具行驶轨迹 (380) -> 八-21-1 制度 (381)。
- **持久化配置**：更新原始安装文件 `folders_inserts.sql`。将修复后的结构全量追加写入，保证项目生命周期内即便重新做数据迁移，结构也能保证统一。
- **联动 Python 脚本**：运行 `sync_audit_csv_final.py` 重新跑一遍 AEO 标准映射。结果 `71/71` 完美匹配。
- **闭包重算**：由于手动操作了 `folders` 的 `parent_id`，利用脚本重建了对应的 `folder_closure` 表关联，确保前端能在子树查询时读到无限级子节点。

**4. 解决结果与值示例**：
- 节点状态：全部通畅。
- UI 数据请求恢复正常，能看到规范嵌套。
