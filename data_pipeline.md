# Data Pipeline 数据流记录

| `文件审核异步处理` | `pre_audit_id`, `number` | `pre_audit_results` 数据 | 数据库/Redis | ✅ 通畅 | 修复了 Docker 环境下 imagick & xlswriter 扩展缺失，PDF 转图功能已恢复可用。 |

## 环节详情记录

### 1-5. 已处理环节
(详见之前记录)

### 6. 文件审核 AI 逻辑梳理
- **请求入口**: `ai_admin_api/app/Controller/Api/PreAuditController.php`
- **核心 Job**: `ai_admin_api/app/Job/GetAiResult.php` (处理 PDF 模型并发调用 & 结果聚合)
- **AI 抽象层**: `ai_admin_api/app/Lib/AI/Finance.php` (封装 DashScope API 请求)
- **Prompt 存储**: 硬编码于 `GetAiResult.php` (不同 check_name 对应不同 Prompt)
- **API 通信**: 阿里云通义千问 `qwen-vl-max` 模型，通过 `GuzzleHttp` 发送。
- **数据流转**: 
  1. Frontend (JSON Info) -> 
  2. MySQL (pre_audits) -> 
  3. Redis Queue (Job) -> 
  4. OSS (PDF images) -> 
  5. AI API -> 
  6. Redis (Temporary results) -> 
  7. MySQL (pre_audit_results)

### 7. [已重构] 检测业务 Handler 抽象模式
- **核心组件**: `CheckHandlerFactory` (路由) + `CheckHandlers/*` (具体实现)
- **Prompt 路径**: `storage/prompts/{name}.md`
- **逻辑流**: 
  1. Job 调用 Factory 获取对应 Handler。
  2. Handler 从外部文档读取 Prompt。
  3. AI 返回原始 JSON。
  4. Handler 执行 `parse` (格式化) 与 `performAudit` (业务判定)。
- **优点**: 核心 Job 逻辑恒定，各业务检测项可独立增加/删除/修改，互不干扰。 ✅ 通畅
