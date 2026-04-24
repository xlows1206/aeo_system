# AEO 系统数据流逻辑 (Data Pipeline)

## 1. 登录与身份校验流
- **输入**: 用户名、密码
- **处理**: `AuthController@login` 验证，生成 JWT。
- **输出**: 包含 `access_token` 和 `user_id`, `master_id` 的 JSON。

## 2. 目录初始化流 (Tenant Onboarding)
- **输入**: `master_id` (新注册企业 ID)
- **处理**: `FolderService::initTenantFolders` 递归克隆 `master_id=0` 的目录结构。
- **状态**: 通畅。已解决克隆时父子关系混乱问题。

## 3. 业务主体项目绑定流
- **输入**: `types` (业务类型 ID 集合)
- **处理**: `CompanyController@store` 保存类型并基于名称映射 `master_id=0` 的模板项目到租户本地 ID。
- **输出**: `company_info.bind_projects` 存储本地项目 ID。

## 4. 资料管理 - 列表展示流
- **输入**: `standard_id`, `folder_id`
- **处理**: `FileController@lists` 获取树形结构；`FileController@getPan` 获取当前文件夹内容。
- **输出**: 扁平化的文件与文件夹列表，带面包屑路径。

## 5. 文件移动流 (File Move Logic) - 2026-04-25 更新
- **输入**: `file_id` 或 `folder_id`, `target_folder_id`
- **处理**: 
    - 前端 `Move.vue` 根据 `props.projectId`（来自面包屑 `paths[1]`）从全局树中提取该项目的子树。
    - **隔离策略**: 移动窗口仅展示当前审核项目内的子文件夹，禁止跨项目移动。
    - **符号处理**: 提交时剥离 `f` 前缀。
- **输出**: 更新数据库 `files.folder_id` 或 `folders.parent_id`。
- **状态**: 修复中。已纠正项目 ID 提取索引。

## 6. AI 审核任务流 (Aggregation Mode)
- **输入**: 文件夹下的文件集合
- **处理**: `GetAiResult` 异步任务，按审核项聚合结论，更新 `pre_audit_results`。
- **鲁棒性更新 (2026-04-25)**: 
    - 解决了 AI 返回非标准 JSON 时导致的 `TypeError` 崩溃。
    - 将捕获范围从 `\Exception` 扩大到 `\Throwable`，防止异常导致任务无限重试。
    - 增加了 `is_array` 校验及更详尽的错误日志记录。
- **check_type 标准 (V4)**:
    - `1`: AI内容理解 (Semantic)
    - `2`: 关键词检测 (Keyword Match)
    - `3`: 上传即为通过 (Simple Pass)
- **输出**: 结构化 JSON 结论 (`result_str`)。
- **匹配与映射优化 (V4.1)**:
    - **逻辑**: `CheckHandlerFactory` 增加"两步清洗法"，先剥离 `Category 、 ` 路径，再剥离 `序号-` 前缀，解决带装饰名称无法命中 AI 处理器的问题。
    - **资产负债率逻辑修正 (2026-04-25)**: 遵循 AEO 最新标准，资产负债率判定由"全部年份通过"调整为"**只要有任意一年不高于 95% 就算通过**"。
    - **错误反馈机制**: AI Prompt 强制输出 `result: error` 状态。后端识别此状态并添加 `[ERROR]` 前缀，以明确区分"解析失败"与"合规不通过"。
- **全模块分层反馈 (V4.2 - 2026-04-25)**:
    - **逻辑重构**：所有 AI Handler (AuditReport, LegalCompliance, PunishmentRatio, FineAmount 等) 均已升级为"全量透明输出"模式。
    - **二元架构**：`performAudit` 提供每个文件的详细结论（包括合格项），`isAccessible` 负责整体合规逻辑判定。
    - **UI 展示**：前端和历史记录实现了"总结果 + 文件结果"的双层嵌套显示。

## 7. 预审文件采集流
- **输入**: `api/v1/file/lists` 返回的树形 JSON。
- **处理**: `Tree.vue` 递归函数 `getAllFiles` 遍历子目录。
- **输出**: 平展化的文件列表，带路径前缀（如 `文件夹 / 文件.pdf`）。

## 8. 审核详情展示流 (2026-04-25 修复)
- **输入**: `pre_audit_id`
- **处理**: `PreAuditController@log`
    - 解析提交 JSON 中的文件 ID 列表。
    - 通过 `folder_closure + folder_check_files` JOIN 关联文件到审核项目（与 `GetAiResult.php` 一致）。
    - 返回 `all_files`（含 `check_id`, `project_name`）和 `audit_results`（按 `check_id` 分组）。
- **输出**: 前端 `Info.vue` 按 `check_id` 分组文件，显示 `project_name`（审核项目名称）。
- **修复记录**: `$info['id']` 实际是 `standard_id` 而非 `check_id`，旧逻辑用它查 `folder_check_files` 导致 `project_name` 为空，前端回退显示物理文件夹名（如"测试通过"）。
- **状态**: 通畅。
