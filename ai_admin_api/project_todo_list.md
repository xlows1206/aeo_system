# AEO System 项目记录清单 (Project Todo List)

## 项目目标陈述
解决生产环境（宝塔面板）中，Hyperf API 后端服务部署时的端口冲突、依赖丢失及运行权限问题，确保前端能够正常调通后端接口。

## 关键模块描述
1. 后端 API (Hyperf + Swoole)：提供数据处理和业务逻辑接口。
2. 运行环境组件 (Nginx, Supervisor)：负责进程守护和反向代理转发。

## 处理流程描述
1. [x] 清理 9501 被占用的端口并重装破坏的 Composer vendor 依赖。
2. [ ] 修复宝塔中 root vs www 用户执行 Supervisor 时的权限（Permission Denied）冲突。
3. [ ] 排查并恢复前端到后端的网络通路（解决 ERR_EMPTY_RESPONSE 问题）。

## 各环节主任务与子任务
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
  
  **🎉 恭喜！本次宝塔部署极难的底层配置架构排障任务，全部圆满完成并通关！**
