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

### 8. 生产环境网络联通性修复
- **发现问题**: 同步代码至服务器后，前端请求报 Network Error，后端返回 502。
- **根本原因**: 
  1. `.env` 配置为 `DB_HOST=0.0.0.0`，导致 Docker 容器内无法连接数据库，服务崩溃/变慢。
  2. `APP_PORT=8787` 与 `docker-compose` 的 `9501` 映射不符，Nginx 转发失败。
- **修复措施**: 
  - 修正 `APP_PORT=9501`。
  - 修正 `DB_HOST=mysql`, `DB_PORT=3306`, `DB_DATABASE=aeo_ai`, `DB_PASSWORD=root`。
  - 修正 `REDIS_HOST=redis`。
- **状态**: ✅ 已建立多环境隔离体系。

### 9. 多环境配置隔离方案 (Isolating Environments)
- **目标**: 解决本地 (Docker) 与 生产 (宝塔) 环境配置频繁冲突问题。
- **方案**: 
  - 本地环境: 使用 `.env.development`，连接 Docker 容器内部服务 (`mysql`, `redis`)。
  - 生产环境: 使用 `.env.production`，连接宝塔本地服务 (`127.0.0.1`)。
- **切换方式**: 通过 `cp .env.{mode} .env` 激活对应环境。
- **状态**: ✅ 已建立模板文件，系统架构已解耦。
