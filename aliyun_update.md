# AEO 系统阿里云服务器同步指引 (2026-04-20)

本文档记录了将本地修复（500 报错修复与数据恢复）同步至阿里云服务器的操作步骤。

## 1. 代码同步 (Backend Codes)

需要同步的文件涉及后端逻辑整合与前端交互重构：
- `ai_admin_api/app/Support/FolderDisplayName.php` (防止 NULL 崩溃)
- `ai_admin_api/app/Controller/Api/FileController.php` (INNER JOIN 查询优化)
- `ai_admin_api/app/Controller/System/CompanyController.php` (API 整合)
- `ai_admin_web/src/views/system/company/index.vue` (前端调用整合)

### 同步命令示例 (在本地宿主机执行)
```bash
# 1. 后端逻辑
scp ai_admin_api/app/Support/FolderDisplayName.php root@<ip>:<path>/ai_admin_api/app/Support/
scp ai_admin_api/app/Controller/Api/FileController.php root@<ip>:<path>/ai_admin_api/app/Controller/Api/
scp ai_admin_api/app/Controller/System/CompanyController.php root@<ip>:<path>/ai_admin_api/app/Controller/System/

# 2. 前端源文件
scp ai_admin_web/src/views/system/company/index.vue root@<ip>:<path>/ai_admin_web/src/views/system/company/
```

## 2. 数据库同步 (Critical - Data Recovery)

服务器端也需要补全文件夹层级以确保项目列表正常显示。

### 操作步骤
1. 将 `ai_admin_api/restore_folders_and_uniqueness.sql` 上传至服务器。
2. 在服务器执行 SQL 导入：
```bash
# 进入服务器目录后执行
docker exec -i mysql-aeo mysql -u root -proot --default-character-set=utf8mb4 aeo_ai < restore_folders_and_uniqueness.sql
```

## 3. 服务器端生效

代码和数据库更新后，必须重启 Hyperf 容器以加载新代码并刷新模型缓存：

```bash
docker restart hyperf-skeleton
```

---

## 4. 验证清单
- [ ] 检查服务器版“公司设置”页面，年份下拉框是否显示。
- [ ] 检查“资料管理”中的单项标准列表，确认 22 个项目均已出现。
- [ ] 确认没有 500 报错日志。
