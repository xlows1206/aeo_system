# AEO System API 接口文档

## 基础信息
- **Base URL**: `http://localhost:9501`
- **认证方式**: Bearer Token (Authorization Header)

---

## 1. 首页与公共接口 (Index)
- `GET /api/v1/index/article`: 获取文章列表 (分页、名称查询)
- `GET /api/v1/index/article_detail/{id}`: 获取文章详情
- `GET /api/v1/index/access_rate`: 获取标准达成率 (各部门及总计)

---

## 2. 企业管理 (Company)
- `GET /api/v1/company/checkCompany`: 检查企业是否存在
- `GET /api/v1/company/info`: 获取企业信息
- `POST /api/v1/company`: 保存/更新企业基础信息
- `PUT /api/v1/company/durationYear`: 更新企业存续年份
- `PUT /api/v1/company/notSelfTotal`: 更新报关总数
- `GET /api/v1/company/types`: 获取公司类型列表

---

## 3. 预审管理 (Pre-Audit)
- `GET /api/v1/pre_audit`: 获取预审列表
- `POST /api/v1/pre_audit`: 提交新的预审任务
- `PUT /api/v1/pre_audit/{id}`: 更新预审记录并触发 AI 识别
- `GET /api/v1/pre_audit/{id}/log`: 获取预审识别详情及相关文件
- `POST /api/v1/pre_audit/{id}/submitAudit`: 提交预审结果进行正式审核

---

## 4. 审核管理 (Audit)
- `GET /api/v1/audit`: 获取审核列表
- `GET /api/v1/audit/{id}/log`: 获取审核详情记录
- `PUT /api/v1/audit/{id}`: 更新审核状态/结果
- `PATCH /api/v1/audit/{id}/revocation`: 撤回审核

---

## 5. 系统设置 (System)
- **管理员管理**:
  - `GET /api/v1/system/administrator`: 列表
  - `POST /api/v1/system/administrator`: 新增
  - `PUT /api/v1/system/administrator/{id}`: 修改
  - `DELETE /api/v1/system/administrator/{id}`: 删除
- **文章管理**:
  - `GET /api/v1/system/article`: 列表
  - `POST /api/v1/system/article`: 新增
- **菜单/权限**:
  - `GET /api/v1/system/menu`: 获取菜单树
- **角色管理**:
  - `GET /api/v1/system/role`: 列表

---

## 6. 工具接口 (Tool)
- `POST /api/v1/tool/sendMail`: 发送邮件通知
- `POST /api/v1/upload`: 文件上传
