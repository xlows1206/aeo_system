# AEO 系统修复记录: 审核项目加载与路由异常

## 1. 问题背景
在“数据管理”模块中，用户反馈在刷新页面后出现以下两个主要问题：
1. **数据丢失**：审核项目列表显示为“暂无审核项目”。
2. **控制台报错**：Vue Router 提示 `No match found for location with path "/pan/index"`。
3. **外部干扰**：控制台出现数个 403 权限错误（来自 Monica AI 等浏览器插件，非业务报错）。

## 2. 核心原因分析
### 2.1 数据映射偏移 (Backend)
- 原同步脚本 `sync_audit_projects.php` 使用了硬编码的 `standard_id` (如 财务=1, 人事=2)。
- 在不同环境下，`standards` 表的 ID 可能发生偏移（如财务 ID 变为 7），导致 `folder_check_files` 表中的映射关系无法与前端请求对齐。

### 2.2 路由初始化时序 (Frontend)
- `/pan/index` 路由属于动态注册路由。刷新页面时，Router 优先匹配静态路由，此时动态路由尚未从后端菜单接口加载完成，导致瞬间的匹配失效警告。

## 3. 修复细节

### 3.1 后端：动态数据同步
- **重构迁移脚本**：
    - 废弃硬编码 ID，改为根据标准名称（`财务`、`人事`、`行政`、`关务`、`审计部`）动态查询 `standards` 表获取真实 ID。
    - 增加了文件夹存在性校验 (`folders` 表是否存在该 ID)，防止由于环境差异导致的逻辑报错。
- **文件路径**：`ai_admin_api/migrations/2026_04_19_050000_repair_audit_projects.php`

### 3.2 前端：路由与逻辑优化
- **消除警告**：将 `ErrorPageRoute` (404/Catch-all) 从动态路由移入 `constantRouter`。确保 Router 在任何时候都能匹配到路径，避免 Match Warning。
- **优化初始化**：在 `pan/index.vue` 的 `apiGetStandard` 回调中，显式为 `searchParams.standard_id` 赋值，确保初次加载即触发项目列表查询。

## 4. Docker 容器内执行指南

由于后端运行在 Docker 中且 `docker-compose.yml` 未启用 `volumes` 实质性挂载，修复后的代码需要手动同步并执行。

### 4.1 容器识别
执行以下命令确认 Hyperf 容器名称（本例为 `hyperf-skeleton`）：
```bash
docker ps
```

### 4.2 迁移脚本同步
由于容器内代码通过镜像打包，宿主机的变更不会自动同步，需执行 `docker cp`：
```bash
# 将宿主机修改后的 migrations 目录同步到容器内
docker cp migrations/. hyperf-skeleton:/opt/www/migrations/
```

### 4.3 执行修复迁移
为了避免触发老旧迁移脚本的建表冲突，指定具体文件路径执行：
```bash
# 进入容器执行特定迁移脚本
docker exec -it hyperf-skeleton php /opt/www/bin/hyperf.php migrate --path=migrations/2026_04_19_050000_repair_audit_projects.php
```
*注：如果提示生产环境警告，请根据提示输入 `yes`。*

## 5. 验证结论
- 刷新页面后，控制台不再出现路由警告。
- “财务”、“人事”等分类下的审核项目列表已正确加载。
- `folder_check_files` 表已根据当前环境的 ID 映射完成重构。
