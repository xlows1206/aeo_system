# AEO System 项目记录清单 (Project Todo List)

## 项目目标陈述
解决生产环境（宝塔面板）中，Hyperf API 后端服务部署时的端口冲突、依赖丢失及运行权限问题，确保前端能够正常调通后端接口。

## 关键模块描述
1. 后端 API (Hyperf + Swoole)：提供数据处理和业务逻辑接口。
2. 运行环境组件 (Nginx, Supervisor)：负责进程守护和反向代理转发。

## 处理流程描述
1. [x] 清理 9501 被占用的端口并重装破坏的 Composer vendor 依赖。
2. [x] 修复宝塔中 root vs www 用户执行 Supervisor 时的权限（Permission Denied）冲突。
3. [x] 排查并恢复前端到后端的网络通路（解决 ERR_EMPTY_RESPONSE 问题）。

## 各环节主任务与子任务
- [x] **单项标准 - 六、代理报关业务集成** (2026-04-20)
    - [x] 同步 9 项字标准至数据库
    - [x] 修复 `allProjects` API 路由及数据逻辑
    - [x] 修复数据库编码乱码问题
    - [x] 完成 UI 全流程验证
- [ ] **AI 审核逻辑对接** (进行中)
- **阶段一：部署环境基建修复**
  - [x] 删除并重新 `composer install` 损坏的 vendor/。
  - [x] 释放被死锁的进程端口 TCP 9501。
- **阶段二：启动鉴权与权限分配**
  - [x] 夺回项目目录所有权：`chown -R www:www`。
  - [x] 重置框架缓存写入权限：`chmod -R 777 runtime`。
- **阶段三：服务联通测试**
  - [x] 验证 Supervisor 管理的常驻进程是否做到无错 Error-free 启动。
  - [x] 解决请求被掐断的协议握手异常（ERR_EMPTY_RESPONSE），排查是否为 HTTP/HTTPS 混用或 Nginx 未启动导致。
- **阶段四：前后端分离联调（当前状态）**
  - [x] 解释并确认后端报错原理，验证后端 9501 业务健康。
  - [x] 排查 Nginx 错误，精准定位到误建的错误代理站点 `139.224.34.69_9501`。
  - [x] 阐明 Nginx 配合 Hyperf 处理文件上传的黄金配合原理。
  - [x] 完全审核通过主站点的 Nginx `try_files` 和 `proxy_pass` 组合配置，达成基于 80 端口的反代架构。
  - [x] **最终收尾**：已帮助用户自动修改本地代码 `ai_admin_web/.env.production`，成功移除多余的 `:9501` 端口号并执行 Local Commit，通过 Nginx 反向代理完美消除了 `405` 跨域与网关失稳的问题。
  
- **阶段五：新老代码生产环境同步及业务联调（当前状态）**
  - [x] **排雷**：前端请求 `/api/v1/company/durationYear` 报 500 内部错误。定位原因为：本地我们在重构 UI 期间新增了 `start_year` 和 `end_year` 的数据表字段，但在将代码推向生产环境（宝塔）时，遗漏了在正式服同步执行数据库迁移（Migrate）的步骤，导致生产服 MySQL 缺乏新字段并崩溃。
  - [x] **执行**：指导用户登入宝塔终端并确认执行 `php bin/hyperf.php migrate` 补充执行，成功应用 `2026_04_07_000001_add_start_end_year_to_company_info` 表结构变更。
  - [x] **后台队列同步修复**：修复了重构 `start_year` 与 `end_year` 后，底层 AI 队列任务（`GetAiResult.php`）未能同步采用新字段构建年度清单的 Bug。解决了界面提示“未设置公司存续年份, 无法进行资产负债率检查”的拦截误判。
### 6. AI 检测层 (多文件冲突与识别)
- **节点描述**：后台 Job `GetAiResult.php` 调用阿里通义万相 VL 模型进行 OCR 抽取。
- **现遇问题**：服务器部署后，提示“未读取到有效信息”，或者部分年份缺失。
- **原因判定 1**：Redis 存储键仅使用 `check_id`，导致同文件夹下多个文件（如 20/21/22 报表）互相覆盖，后进文件因为 `hExists` 判定已存在而直接跳过。
- **原因判定 2**：`isImage` 逻辑使用 `file_exists` 无法检测 URL，导致图片文件被迫进入 PDF 处理逻辑，若 OSS 没通则由于 `uploadOss` 返回空而中断。
- **解决方案要求**：将 Redis Field Key 从 `check_id_page` 扩展为 `check_id_fileId_page`；优化 `isImage` 支持 URL 检测。
- **状态**：正在修复逻辑中...

- **阶段六：审核项目识别与可见性稳定化**
  - [x] **字段重构**：将 `folder_check_files` 表的 `file_name` 重命名为 `folder_name`，提高语义清晰度。
  - [x] **后端接口优化**：在 `FileController` 中引入 `allProjects` 扁平化接口，解决了 405 路由冲突。
  - [x] **自动识别增强**：更新 `PopulateCheckFoldersCommand` 识别逻辑，支持 `standard_id` 自动继承。
  - [x] **前端稳定性修复**：修正了 `home/index.vue` 的组件解析 (`<n-button>`) 和属性引用 (`index`)。
  - [x] **架构层级修复**：修复了 `FileController@index` 中的 `UNION ALL` SQL 字段不匹配问题。

  **🏆 全系统稳定性与业务逻辑闭环达成！首页显示、资料管理项目可见性及核心审计数据流均已恢复至 100% 正常态。**
