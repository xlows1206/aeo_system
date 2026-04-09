# AEO System Backend Memory (真理之源)

本文档旨在记录 `aeo_system` 后端的核心逻辑、数据结构、接口流程及 AI 处理机制，作为后续开发与迭代的精准参考。

---

## 1. 技术架构概览 (Architecture Stack)

*   **后端框架**: Hyperf 3.x (协程框架)
*   **语言**: PHP 8.1+
*   **数据库**: MySQL 5.7+ (存储业务数据)
*   **缓存/队列**: Redis (用于异步队列 `async-queue` 和结果暂存)
*   **文件存储**: 阿里云 OSS (存储原始资料及 AI 处理后的图片)
*   **AI 模型**: 阿里云通义千问 `qwen-vl-max` (多模态视觉识别)
*   **基础库**: 
    *   `Imagick`: 用于 PDF 分页转图片 (核心依赖)。在 Docker 中通过 `php83-pecl-imagick` 预编译包安装。
    *   `xlswriter`: 用于高性能 Excel 处理。主要用于 `import_dir_path` 脚本，实现 AEO 审核标准、目录结构及文件清单的**初始导入与批量同步**。在 Docker 中通过 `php83-pecl-xlswriter` 预编译包安装。
    *   `GuzzleHttp`: 用于 API 外部通信。

---

## 2. 核心数据结构 (Core Data Structures)

### 2.1 企业信息表 (`company_info`)
| 字段名 | 类型 | 含义 |
| :--- | :--- | :--- |
| `id` | `bigint(20) unsigned` | 自增 ID |
| `master_id` | `bigint(20)` | 主账号 ID (多租户隔离关键) |
| `company_name` | `string(255)` | 公司全称 |
| `enterprise_person_name` | `string(255)` | 企业法定代表人 |
| `principal_person_name` | `string(255)` | 主要负责人 |
| `financial_person_name` | `string(255)` | 财务负责人 |
| `customs_person_name` | `string(255)` | 关务负责人 |
| `duration_year` | `int(11)` | 公司存续年限 |
| `not_self_total` | `int(11)` | 报关单总数 (用于处罚比例计算) |
| `types` | `string(255)` | 企业类型 (默认 0) |
| `start_year` | `int(11)` | 数据统计起始年份 |
| `end_year` | `int(11)` | 数据统计结束年份 |

### 2.2 预审主表 (`pre_audits`)
| 字段名 | 类型 | 含义 |
| :--- | :--- | :--- |
| `id` | `bigint(20) unsigned` | 自增 ID |
| `user_id` | `bigint(20)` | 提交用户 ID |
| `master_id` | `bigint(20)` | 所属主账号 ID |
| `status` | `tinyint(4)` | 0:未审核, 1:不达标, 2:基本达标, 3:达标 |
| `number` | `tinyint(4)` | 审核版本/次数 |

### 2.3 预审详情表 (`pre_audit_json`)
| 字段名 | 类型 | 含义 |
| :--- | :--- | :--- |
| `id` | `bigint(20) unsigned` | 自增 ID |
| `pre_audit_id` | `bigint(20)` | 关联预审 ID |
| `info` | `json` | 原始提交的资料配置 |
| `number` | `tinyint(4)` | 版本号 |
| `status` | `tinyint(4)` | AI 处理状态总结 |
| `ai_result` | `json` | AI 提取的原始结果/失败原因汇总 |
| `result` | `string(255)` | 审核详情总结 |

### 2.4 资料检测结果表 (`pre_audit_results`)
| 字段名 | 类型 | 含义 |
| :--- | :--- | :--- |
| `id` | `bigint(20) unsigned` | 自增 ID |
| `folder_id` | `unsigned int` | 关联文件夹 ID |
| `check_id` | `bigint(20)` | 关联检测项配置 ID (`folder_check_files.id`) |
| `folder_name` | `string(255)` | 资料名称 |
| `is_access` | `tinyint(1)` | 是否通过 (1:通过, 0:不通过) |
| `failed_str` | `string(255)` | 失败/不通过的具体原因描述 |

### 2.5 资料配置表 (`folder_check_files`)
| 字段名 | 类型 | 含义 |
| :--- | :--- | :--- |
| `id` | `bigint(20) unsigned` | 自增 ID |
| `file_name` | `string(255)` | 期望文件名 |
| `check_name` | `string(255)` | 检测项目分类名称 |
| `check_type` | `tinyint(4)` | 1:需要 AI 检测, 2:上传即通过 |
| `check_text` | `string(1000)` | 关键字匹配模式内容 |

---

## 3. 接口流程映射 (API Flow)

### 3.1 鉴权机制 (`UserAuthMiddleware`)
*   **前端**: 在请求头 `Authorization` 中携带 Bearer Token。
*   **逻辑**: 中间件解密 JWT，提取 `sub` (userId)，从库中获取 `User` 模型。
*   **注入**: 将用户信息注入 `ParsedBody` 的 `Auth` 字段。后序 Controller 通过 `$request->input('Auth')` 获取用户信息。

### 3.2 预审提交流程 (`PreAuditController`)
1.  **入库**: 创建 `pre_audits` 记录，并将配置 `info` 存入 `pre_audit_json`。
2.  **异步**: 调用 `QueueService` 将 `GetAiResult` 任务压入队列。
3.  **响应**: 立即返回，前端通过轮询或状态变更获知结果。

---

## 4. AI 处理详细逻辑 (AI Processing)

1.  **文件下载与转换**: 
    *   根据 PDF URL 下载文件至 `runtime` 目录。
    *   使用 `Imagick` 以 150 DPI 分辨率将 PDF 分页转换为 PNG 图片。
2.  **图片托管**: 将 PNG 上传至 OSS，获取临时/公网可见链接。
3.  **多模态识别**: 
    *   并发调用 `qwen-vl-max` 接口。
    *   通过 `CheckHandlerFactory` 获取对应业务的提示词 (Prompt)。
4.  **业务逻辑执行**: 
    *   识别结果通过 `Redis` 哈希表暂存，防止重复识别。
    *   `GetAiResult@handle` 调用相应的 `Handler` 执行数据解析与业务审计。

---

## 5. 文件检测项目矩阵 (File Detection Matrix)

| 检测项目 | 判断标准 (Business Rules) | 技术实现细节 |
| :--- | :--- | :--- |
| **资产负债率情况** | 至少有一年负债率 `liability / liability_equity` <= 95%。 | `FinancialRatioHandler`: 自动处理千分位，执行 `bcdiv` 精确计算。 |
| **审计报告** | 必须涵盖所有存续年份，且 AI 判定 `result` 为 `true`。 | `AuditReportHandler`: 比对存续年份数组与 AI 返回年份的覆盖率。 |
| **遵守法律法规** | 必须包含公司所有关键人员的无犯罪证明。 | `LegalComplianceHandler`: 从 `company_info` 提取名单并在结果中执行 `array_diff`。 |
| **行政被处罚金额** | 累计罚款金额不高于 50,000 元。 | `FineAmountHandler`: 累加匹配公司名称的 `amount` 数值。 |
| **被处罚单比例** | 处罚单比例不超过总量的 1‰。 | `PunishmentRatioHandler`: 统计识别结果中不含“经自查”的数量。 |
| **关键字匹配** | 是否包含 `check_text` 中定义的关键字。 | `KeywordMatchHandler`: 通用关键字存在性判定。 |

---

## 6. 环境依赖与基础设施 (Infrastructure)

*   **Dockerfile 修复**: 针对 Alpine 3.19 环境下的 PHP 8.3，通过在 `Dockerfile` 中引入 `v3.19/community` 和 `edge/community` 仓库，解决了 `imagick` 和 `xlswriter` 扩展缺失的问题。
*   **构建策略**: 放弃了耗时的源码编译（PECL），改用 `apk` 直接安装预编译包，显著提升了构建速度和环境稳定性。
*   **API 密钥**: 目前硬编码在 `App\Lib\AI\Finance.php` 的 `$apiKey` 中，需确保环境安全。
*   **OSS 密钥**: 通过环境变量 `OSS_ACCESS_KEY`, `OSS_SECRET_KEY` 等获取。
*   **并发限制**: 并行协程数设为 5 (`Parallel(5)`)，以平衡识别速度与接口速率限制。

---

## 7. 提示词与检测逻辑重构 (Architecture v2)

为了实现逻辑的高内聚、低耦合以及提示词的可在线配置，系统引入了策略模式架构：

### 7.1 核心组件
- **Prompt 存储 (`storage/prompts/`)**: 所有 AI 指令以 `.md` 格式存储，支持 `{check_text}` 等变量动态注入。
- **检测工厂 (`CheckHandlerFactory`)**: 根据数据库中的 `check_name` 自动分发到对应的 Handler。
- **业务 Handler (`App\Lib\AI\CheckHandlers`)**:
    - 统一实现 `CheckHandlerInterface`。
    - `getPrompt()`: 获取并合成完整提示词。
    - `parseResult()`: 标准化 AI 返回的 JSON，处理数据清洗。
    - `performAudit()`: 执行纯粹的业务规则算法，返回审计状态。

### 7.2 优势
- **局部更新**: 修改特定检测项逻辑无需改动核心 Job 代码，只需修改对应的 Handler 类或 Markdown 提示词。
- **易于扩展**: 新增检测项仅需增加一个策略类，主流程逻辑恒定。
- **可测试性**: 业务规则代码从异步任务流程中抽离，支持单元测试模拟。

---

## 8. 多环境配置管理 (Multi-environment Configuration)

为了确保本地开发便利性与生产环境稳定性的完全隔离，系统采用了基于文件的配置管理策略。

### 8.1 配置隔离方案
- **`.env.development`**: 适配本地 **Docker 全家桶** 环境。
    - 数据库连接: `DB_HOST=mysql` (容器别名)
    - Redis 连接: `REDIS_HOST=redis`
    - 鉴权与密码: 采用开发默认值 (`root`/`root`)。
- **`.env.production`**: 适配服务器 **宝塔 (BT Panel)** 环境。
    - 数据库连接: `DB_HOST=127.0.0.1` (指向宝塔本地 MySQL)
    - 库名: `aeo_ai`
    - 密码: 需从宝塔面板获取并手动填入。
    - Redis 连接: `REDIS_HOST=127.0.0.1`

### 8.2 环境切换机制 (The Switch)
Hyperf 框架默认读取根目录下的 `.env` 文件。切换环境时，通过复制对应的模板文件激活配置：

- **激活开发环境**:
  ```bash
  cp .env.development .env
  ```
- **激活生产环境**:
  ```bash
  cp .env.production .env
  ```

### 8.3 部署注意事项
- **Git 忽略**: `.env` 文件已被列入 `.gitignore`，确保生产敏感信息不会流向版本库。
- **端口对齐**: 无论在本地还是生产，后端应用统一监听 `9501` 端口，以匹配前端 `dist` 的请求及 Docker/Nginx 的转发规则。
- **联通性校验**: 若生产环境报“网络错误 (502)”，应首先在宿主机执行 `timeout 2 bash -c "</dev/tcp/127.0.0.1/3306"` 以确认数据库联通性。
