# 项目目标陈述
修复 aeo_system 后端 API 错误，并优化前端管理界面功能。

# 关键模块描述
- **ai_admin_api**: 基于 Hyperf 的后端服务。
- **ai_admin_web**: 前端管理界面。

# 处理流程描述
1. 接收前端请求。
2. 路由分发。
3. Controller 处理逻辑（涉及数据库查询、缓存等）。
4. 返回响应。

# 任务列表
- [x] 排查 `/api/v1/index/access_rate` 接口 500 错误
- [x] 排查 `/api/v1/index/article` 接口 500 错误
- [x] 排查 `/api/v1/company/types` 接口 500 错误
- [x] 资料管理页面数据修改与持久化优化 [已完成]
- [x] 首页 UI 优化：缩小标题字号
- [x] 梳理文件审核逻辑与 Prompt/API 处理流程 [已完成]
- [x] 确保所有已知数据流节点通畅
- [x] 修复 Hyperf `migrate` 命令缺失问题 (确保多环境自动同步) [已完成]
    - [x] 手动注册迁移命令至 `config/autoload/commands.php`
    - [x] 手动补全 `migrations` 迁移记录 [Batch 3]
    - [x] 验证 `php bin/hyperf.php migrate:status` 状态
- [x] **[架构重构] 检测逻辑与提示词抽象化抽离** [已完成]
    - [x] 创建 `CheckHandlers` 策略接口与基类
    - [x] 实现各业务线（财务、审计、法律等）独立 Handler
    - [x] 建立 `storage/prompts` 外部提示词存储体系
    - [x] 重构 `GetAiResult` 核心 Job 执行流程
    - [x] 更新 `.memory/backend_memory.md` 架构文档
