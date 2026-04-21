# AEO System Data Pipeline

## 1. 核心流程：路径即真理 (Path as Truth)

系统以 `/Users/aaron.w/Desktop/aeo_system/audit_list_3.csv` 为权威数据源。

### 数据同步链路
1. **物理层**：根据审计要求在 `单项标准/` 或 `通用标准/` 下维护物理文件夹。
2. **配置层**：在 `audit_list_3.csv` 中维护 `脱敏文件路径`，必须与物理路径 1:1 对应。
3. **逻辑层**：执行 `python3 sync_audit_csv_final.py`。
   - **自动化路径构建**：脚本会自动解析 CSV 路径。若数据库中不存在对应文件夹，脚本将自动在 `folders` 表中创建节点并修复 `folder_closure`。
   - **项目绑定**：脚本清除并重置 `folder_check_files`，将审计项与文件夹 ID 进行 100% 精准绑定。
4. **持久化层**：脚本生成的变更可反向导出至 `ai_admin_api/folders_inserts.sql`。
5. **缓存层**：必须执行 `redis-cli flushall` 以使变更在前端即刻生效。

## 2. 关键节点状态

| 环节节点 | 输入值 | 输出值 | 格式/示例 | 通畅状态 | 备注 |
|---|---|---|---|---|---|
| CSV 配置 | 原始 Prd 需求 | `audit_list_3.csv` | 包含 `检测方式`, `检测关键字` | ✅ | 已更新关键词规则表 |
| 物理目录 | 映射规则 | 磁盘实际文件夹 | `10-历年法检查验...` | ✅ | 已创建 Category 五新增目录 |
| SQL 生成 | `audit_list_3.csv` | `sync_universal.sql` | `TRUNCATE TABLE...` | ✅ | 生成成功 |
| 闭包表重建 | folders 表 | folder_closure 表 | `(ancestor, descendant)` | ✅ | 通过 SQL 存储过程自动维护 |
| AI 关键词检测 | PDF / Image | AI 判定结果 (前2页) | 文本关键词命中 | ✅ | 适用于制度/轨迹类 |
| AI 语义理解 | 图像 + 公司上下文 | 结构化判定 (Json) | 标题、意图、身份比对 | ✅ | 适用于无犯罪/财务类 |
| 上传拦截引导 | 公司设置状态 | 前端 UI 状态 | 置灰按钮 + 引导卡片 | ✅ | 解决数据缺失导致解析失败 |

## 3. 当前值示例 (Example)

- **物理路径**: `单项标准/八、物流运输业务/21-运输工具行驶轨迹/21-1-定位系统车载终端管理制度`
- **CSV 脱敏路径**: `单项标准/八、物流运输业务/21-运输工具行驶轨迹/21-1-定位系统车载终端管理制度`
- **数据库 ID**: `folders.id = 899` (示例)
- **匹配状态**: 100%

---
*Updated by Antigravity - 2026-04-20 (Implemented Auto-heal Path Construction)*
