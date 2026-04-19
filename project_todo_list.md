# 项目进度管理 (project_todo_list.md)

## 项目目标陈述
解决 AEO 审核系统中“公司设置”保存失败的问题，并确保数据流各环节通畅且逻辑符合业务需求。

## 关键模块描述
1. **Frontend (View)**: `ai_admin_web/src/views/system/company/index.vue` - 公司信息设置页面。
2. **Frontend (API)**: 调用接口保存公司信息。
3. **Database (Table)**: `company_info` 表及相关关联表。

## 环境与系统配置修复
### MCP 配置文件修复
- **文件**: `mcp_config.json`
- **问题**: 属性 `$typeName` 不被 MCP 规范允许，导致架构校验失败。
- **解决状态**: 已修复 (移除所有 `$typeName` 字段)。
- **日期**: 2026-04-19

## 处理流程描述
1. 用户在“公司设置”页面填写表单。
2. 点击“确认”按钮触发 `save` 方法。
3. 前端发送请求到后端 API。
4. 后端验证数据并更新数据库。
5. 后端返回结果给前端，前端提示成功或失败。

## 各环节主任务与子任务
- [x] **问题排查 (已完成)**
    - [x] 配置 `apiStoreCompany` 支持 POST 传参
- [ ] 验证后端 `notSelfTotal` 和 `durationYear` 的接口权限与容错 (进行中)
- [x] 后端全局异常捕获与日志增强
- [ ] 再次验证保存流程
- [x] **修复与验证 (已完成)**
    - [x] 修复代码中的 Bug (Axios params -> data)。
    - [x] 验证数据保存是否成功。
    - [x] 更新 `data_pipeline.md` 记录。

- [x] **基础设施与环境 (已完成)**
    - [x] 修复 `mcp_config.json` 架构校验错误 (移除 `$typeName`)

## AEO “单项标准 - 六、代理报关业务”集成
- **目标**: 将 9 项新增代理报关业务标准集成到审核系统。
- **任务状态**:
    - [x] 更新 `audit_list_3.csv` 基础数据。
    - [x] 在 `folders_inserts.sql` 中新增分类及子项文件夹 (ID: 300-309)。
    - [x] 优化 `sync_audit_csv_final.py` 同步脚本（支持“单项标准”部门映射）。
    - [x] 执行脚本生成 `sync_final.sql`。
    - [ ] **问题排查**：修复 `allProjects` 404 错误 (修正 `pan.ts` 中的路由)。
    - [ ] 将 `sync_final.sql` 部署至数据库并验证界面展示。
- [x] 修复 AEO 单项标准（二、三、五、八）以及通用标准 7. 进出口记录的乱码重复项，彻底规范并同步数据库树形层级
