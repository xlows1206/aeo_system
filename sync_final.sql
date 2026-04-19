SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `folder_check_files`;
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 关企联系合作机制制度文件（涵盖公司与海关沟通合作的管理规范）
2. 关企联系合作机制的年度更新版本（如有分年度版本，请按年份分别上传）', `standard_id` = 4 WHERE `id` = 292;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (292, '关企沟通联系合作 - 关企联系合作机制', 4, 0, '关企沟通联系合作 - 关企联系合作机制', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 组织架构图
2. 岗位任职条件与职责说明文件（含贸易安全相关岗位的职责描述）
3. 关键岗位任命书（如贸易安全负责人、AEO联络员等任命文件）
4. 如有多年版本，请按年份（公司存续年份）分别上传', `standard_id` = 4 WHERE `id` = 293;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (293, '关企沟通联系合作 - 岗位职责', 4, 0, '关企沟通联系合作 - 岗位职责', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 进出口单证复核管理制度文件
2. 各年度进出口单证复核操作记录（按年份分别上传，涵盖公司存续年份）
3. 单证复核抽查记录（含报关单、装箱单、发票等原始单据抽查样本）', `standard_id` = 4 WHERE `id` = 118;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (118, '进出口单证 - 进出口单证复核制度', 4, 0, '进出口单证 - 进出口单证复核制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 进出口单证保管管理制度文件
2. 各年度单证保管抽查记录（含实际单证样本，按年度/期次上传，涵盖公司存续年份）
注：单证类型包括但不限于报关单、提单、发票等，建议每年至少上传2个检查时间节点的记录', `standard_id` = 4 WHERE `id` = 119;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (119, '进出口单证 - 进出口单证保管制度', 4, 0, '进出口单证 - 进出口单证保管制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 禁止类产品合规审查制度文件（如有年度更新，按年份上传，涵盖公司存续年份）
2. 禁限类产品公告及目录（国家主管部门发布的相关禁止进出口货物目录）
3. 合规审查记录或自查表（可按年度归纳上传）', `standard_id` = 4 WHERE `id` = 120;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (120, '进出口单证 - 禁止类产品合规审查制度', 4, 0, '进出口单证 - 禁止类产品合规审查制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 企业认证电子资料档案汇编（包含AEO认证相关的授权文件、证书等电子存档）', `standard_id` = 4 WHERE `id` = 121;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (121, '进出口单证 - 企业认证电子资料档案', 4, 0, '进出口单证 - 企业认证电子资料档案', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '行政', `description` = '请上传以下文件：
1. 各信息系统操作手册（如EIP系统、WMS仓储系统、JDY系统、金蝶K3等，按系统分别上传）
2. 信息系统抽查记录（包含系统截图、进出库查询记录、异常报错记录等，按年度上传，涵盖公司存续年份）', `standard_id` = 3 WHERE `id` = 95;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (95, '信息系统 - 信息系统说明', 3, 0, '信息系统 - 信息系统说明', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '行政', `description` = '请上传以下文件：
1. 信息安全管理手册 / IT数据保管制度（按版本年份上传，请上传当前有效版本）
2. 系统数据保留期限截图（证明数据保存周期不少于3年，按时间段分别上传）', `standard_id` = 3 WHERE `id` = 96;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (96, '信息系统 - 系统数据的保管', 3, 0, '信息系统 - 系统数据的保管', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '行政', `description` = '请上传以下文件：
1. IT信息安全管理手册 / 员工手册（按版本年份上传）
2. 密码管理策略记录（密码定期修改策略截图、密码到期修改记录）
3. 机房门禁记录（按年度节点上传，如每年2个时间点，涵盖公司存续年份）
4. 杀毒软件运行截图（按年度上传）', `standard_id` = 3 WHERE `id` = 97;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (97, '信息系统 - 信息安全管理制度', 3, 0, '信息系统 - 信息安全管理制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '审计部', `description` = '请上传以下文件：
1. 内部审核制度文件（按版本年份上传，请上传当前有效版本）', `standard_id` = 5 WHERE `id` = 92;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (92, '内部审计和改进 - 内部审计制度', 5, 0, '内部审计和改进 - 内部审计制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '审计部', `description` = '请上传以下文件：
1. 各年度AEO内部审核报告（涵盖公司存续年度，部分年份有上下半年两份，请按年份/期次分别上传）
   参考格式：yyyy AEO内审报告.pdf 或 yyyy-I / yyyy-II AEO内审报告.pdf', `standard_id` = 5 WHERE `id` = 93;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (93, '内部审计和改进 - 内审记录报告', 5, 0, '内部审计和改进 - 内审记录报告', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '审计部', `description` = '请上传以下文件：
1. 内审改进机制文件（包含改进机制说明、内部审核不合格报告、纠正措施记录等）
2. 责任追究制度文件（如员工手册实施细则中的责任追究部分）
3. 关企联系合作报告流程文件', `standard_id` = 5 WHERE `id` = 94;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (94, '内部审计和改进 - 改进和责任追究机制', 5, 0, '内部审计和改进 - 改进和责任追究机制', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '审计部', `description` = '请对照以下海关对于无犯罪记录的要求开展核查：
1. 公司法定代表人、负责海关事务的高级管理人员（小村博之、川锅和弘）以及财务负责人、贸易安全负责人、报关业务负责人、AEO联络员是否在认证有效期内（近2年）存在刑事犯罪记录。
2. 企业是否曾发生由于走私犯罪受过刑事处罚的情形。
3. 请上传管理层对应的无犯罪记录声明书，需由相关负责人签署。', `standard_id` = 5 WHERE `id` = 73;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (73, '遵守法律法规 - 6-15-1 无犯罪记录管理层声明书', 5, 0, '遵守法律法规 - 6-15-1 无犯罪记录管理层声明书', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '审计部', `description` = '请上传以下文件（对应原 6-16、6-17、6-18 审核项）：
1. 企业行政处罚记录说明或各年度无行政处罚证明材料
2. 被处罚报关单明细及对应的行政处罚决定书（如有）
3. 法律法规遵守相关证明材料（如行政许可证、相关资质证书等）
注：审核标准为行政处罚金额累计≤5万元，且被处罚报关单比例＜1‰', `standard_id` = 5 WHERE `id` = 129;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (129, '遵守法律法规 - 6-16&17&18 报关单行政处罚合规', 5, 0, '遵守法律法规 - 6-16&17&18 报关单行政处罚合规', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 1年内进出口活动证明（如海关进出口统计报表、报关记录汇总，或海关签发的证明文件）
2. 如有不同年度版本，请按年份分别上传', `standard_id` = 4 WHERE `id` = 387;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (387, '进出口记录 - 1年内进出口活动证明', 4, 0, '进出口记录 - 1年内进出口活动证明', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '财务', `description` = '请上传以下文件：
1. 各年度财务审计报告（涵盖公司存续年份，每年一份，由第三方会计师事务所出具）', `standard_id` = 1 WHERE `id` = 110;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (110, '财务状况 - 审计报告', 1, 0, '财务状况 - 审计报告', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '财务', `description` = '请上传以下文件：
1. 各年度资产负债率数据说明文件（含资产负债表或财务分析报告，涵盖公司存续年份）
2. 如有专项资产负债率计算说明，请一并上传', `standard_id` = 1 WHERE `id` = 111;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (111, '财务状况 - 资产负债率情况', 1, 0, '财务状况 - 资产负债率情况', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '行政', `description` = '请上传以下文件：
1. 经营场所安全管理制度文件（含办公区、仓库、园区等区域的安全管理规范）
2. 如有年度更新版本，请按年份分别上传', `standard_id` = 3 WHERE `id` = 142;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (142, '经营场所安全 - 经营场所安全管理制度', 3, 0, '经营场所安全 - 经营场所安全管理制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '行政', `description` = '请上传以下文件：
1. 经营场所建筑物照片或说明（含外观、围墙、门禁等设施的现场图片）
2. 建筑物平面图或场所示意图
3. 如有多个经营场所或多年度更新记录，请按场所/年份分别上传', `standard_id` = 3 WHERE `id` = 143;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (143, '经营场所安全 - 经营场所建筑物', 3, 0, '经营场所安全 - 经营场所建筑物', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '行政', `description` = '请上传以下文件：
1. 锁闭装置及钥匙保管制度文件
2. 锁闭装置实物照片（含门锁、密码锁、电子门禁等设施）
3. 钥匙/门禁卡领用登记记录（按年度上传，涵盖公司存续年份）', `standard_id` = 3 WHERE `id` = 144;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (144, '经营场所安全 - 锁闭装置及钥匙保管', 3, 0, '经营场所安全 - 锁闭装置及钥匙保管', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '行政', `description` = '请上传以下文件：
1. 经营场所照明设施照片（含仓库内外、停车区域、门禁区域等）
2. 照明检查记录或维护记录（按年度上传）', `standard_id` = 3 WHERE `id` = 145;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (145, '经营场所安全 - 照明', 3, 0, '经营场所安全 - 照明', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '行政', `description` = '请上传以下文件：
1. 车辆与人员进出管理制度文件
2. 进出登记记录（如门卫签到表、车辆出入台账、门禁系统记录截图等，按年度上传，涵盖公司存续年份）
3. 现场照片（如门卫亭、道闸、人行通道等设施）', `standard_id` = 3 WHERE `id` = 146;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (146, '经营场所安全 - 车辆和人员进出管理', 3, 0, '经营场所安全 - 车辆和人员进出管理', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '行政', `description` = '请上传以下文件：
1. 单证存放管理制度及仓储区域受控管理制度
2. 单证存放区域实物照片（如文件柜、档案室等）
3. 仓储区域管控措施说明或现场图片', `standard_id` = 3 WHERE `id` = 147;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (147, '经营场所安全 - 单证存放和仓储区域受控管理', 3, 0, '经营场所安全 - 单证存放和仓储区域受控管理', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '行政', `description` = '请上传以下文件：
1. 视频监控系统说明（含监控点位分布图或照片）
2. 监控录像保存制度及保存时长说明
3. 监控系统运行状态截图或巡检记录（按年度上传）', `standard_id` = 3 WHERE `id` = 148;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (148, '经营场所安全 - 重要敏感区域视频监控', 3, 0, '经营场所安全 - 重要敏感区域视频监控', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '人事', `description` = '请上传以下文件：
1. 员工入职管理制度文件（含入职前背景核查流程）
2. 员工离职管理制度文件（含权限注销、资产归还等流程）
3. 如有年度版本更新，请按年份分别上传', `standard_id` = 2 WHERE `id` = 131;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (131, '人员安全 - 员工入职离职管理', 2, 0, '人员安全 - 员工入职离职管理', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '人事', `description` = '请上传以下文件：
1. 新员工及安全敏感岗位背景调查制度文件
2. 背调记录样本（如背调报告、员工授权书等，按年份归纳，涵盖公司存续年份）
3. 安全敏感岗位名单或说明', `standard_id` = 2 WHERE `id` = 132;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (132, '人员安全 - 新员工&安全敏感岗位背调', 2, 0, '人员安全 - 新员工&安全敏感岗位背调', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '人事', `description` = '请上传以下文件：
1. 员工身份识别管理制度（含工牌、门禁卡发放及管理规范）
2. 离职员工权限注销记录（按年度上传，涵盖公司存续年份）
3. 员工工牌或身份识别系统说明截图', `standard_id` = 2 WHERE `id` = 133;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (133, '人员安全 - 员工身份识别和离职员工取消授权', 2, 0, '人员安全 - 员工身份识别和离职员工取消授权', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '人事', `description` = '请上传以下文件：
1. 访客进出登记管理制度文件
2. 访客登记记录表样本（按年度上传，涵盖公司存续年份）
3. 访客接待区域或门卫处现场照片', `standard_id` = 2 WHERE `id` = 134;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (134, '人员安全 - 访客进出登记管理', 2, 0, '人员安全 - 访客进出登记管理', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 货物与物品安全管理制度文件（含收货、发货、仓储全流程的安全管控规范）
2. 如有年度版本更新，请按年份分别上传', `standard_id` = 4 WHERE `id` = 166;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (166, '货物、物品安全 - 货物、物品安全管理制度', 4, 0, '货物、物品安全 - 货物、物品安全管理制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 集装箱七点检查法操作规范文件
2. 各年度集装箱七点检查记录（按年份上传，涵盖公司存续年份，建议每年至少2个时间节点）', `standard_id` = 4 WHERE `id` = 167;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (167, '货物、物品安全 - 集装箱七点检查法', 4, 0, '货物、物品安全 - 集装箱七点检查法', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 集装箱封条管理制度文件
2. 集装箱封条实物照片或使用记录（按年份上传，涵盖公司存续年份）', `standard_id` = 4 WHERE `id` = 168;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (168, '货物、物品安全 - 集装箱封条', 4, 0, '货物、物品安全 - 集装箱封条', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 集装箱存储管理制度文件
2. 相关年度集装箱存放区域照片或管理记录', `standard_id` = 4 WHERE `id` = 169;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (169, '货物、物品安全 - 集装箱存储制度', 4, 0, '货物、物品安全 - 集装箱存储制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 司机身份核实管理制度文件
2. 各年度司机身份核实记录（如核实登记表、驾照复印件存档等，按年份上传，涵盖公司存续年份）', `standard_id` = 4 WHERE `id` = 170;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (170, '货物、物品安全 - 司机身份核实', 4, 0, '货物、物品安全 - 司机身份核实', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 货物装运与接收操作规范文件
2. 各年度货物收发记录样本（如入库单、出库单、验货记录等，按年份上传，涵盖公司存续年份）', `standard_id` = 4 WHERE `id` = 171;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (171, '货物、物品安全 - 装运和接收货物物品', 4, 0, '货物、物品安全 - 装运和接收货物物品', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 货物差异处理及报告程序文件（含差异发现、上报、处置全流程说明）
2. 差异报告记录样本（如有）', `standard_id` = 4 WHERE `id` = 172;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (172, '货物、物品安全 - 货物、物品差异及报告程序', 4, 0, '货物、物品安全 - 货物、物品差异及报告程序', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 出口安全管理制度文件（含出口货物安全控制的规范与流程）', `standard_id` = 4 WHERE `id` = 173;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (173, '货物、物品安全 - 出口安全制度', 4, 0, '货物、物品安全 - 出口安全制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 运输工具安全管理制度文件（含车辆检查、维护、安全标准等管理规范）', `standard_id` = 4 WHERE `id` = 190;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (190, '运输工具安全 - 运输工具安全管理制度', 4, 0, '运输工具安全 - 运输工具安全管理制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 运输工具检查标准或操作规范文件
2. 各年度车辆出车前安全检查记录（按年份上传，涵盖公司存续年份）
3. 各年度车辆定期检查记录（如季度/年度车辆检查报告，按年份上传）', `standard_id` = 4 WHERE `id` = 191;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (191, '运输工具安全 - 运输工具检查', 4, 0, '运输工具安全 - 运输工具检查', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 运输工具存储管理制度文件（如运输部操作规范中的车辆停放与保管规定）', `standard_id` = 4 WHERE `id` = 192;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (192, '运输工具安全 - 运输工具存储制度', 4, 0, '运输工具安全 - 运输工具存储制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 运输安全相关制度文件（如运输部操作规范）
2. 各年度运输安全培训记录（按月份/年份上传，涵盖公司存续年份）
   注：培训记录请按年份归纳，每年按月度培训记录分别上传', `standard_id` = 4 WHERE `id` = 193;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (193, '运输工具安全 - 安全培训', 4, 0, '运输工具安全 - 安全培训', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 商业伙伴安全管理制度文件（含对客户、供应商等合作伙伴的安全管控规范）', `standard_id` = 4 WHERE `id` = 203;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (203, '商业伙伴安全 - 商业伙伴安全管理制度', 4, 0, '商业伙伴安全 - 商业伙伴安全管理制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件（分客户和供应商两类分别准备）：
【客户类】
1. 与客户有关的评估与监测程序说明文件
2. 商业合作伙伴清单（按年份上传，涵盖公司存续年份）
3. 客户调查表（按年份上传，涵盖公司存续年份）
4. 客户评价表（按年份分别上传，按公司存续年份各一份）
5. 贸易安全考评表
【供应商类】
6. 供应商（运输、报关等类别）调查表、评价表及考评表（按年份分别上传）', `standard_id` = 4 WHERE `id` = 204;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (204, '商业伙伴安全 - 全面评估', 4, 0, '商业伙伴安全 - 全面评估', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 与运输供应商签订的贸易安全补充协议
2. 与报关供应商签订的贸易安全补充协议
3. 向客户发送的贸易安全告知书（按客户分别上传，涵盖全部主要客户）', `standard_id` = 4 WHERE `id` = 205;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (205, '商业伙伴安全 - 优化贸易安全管理书面文件', 4, 0, '商业伙伴安全 - 优化贸易安全管理书面文件', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件（分客户和供应商两类分别准备）：
【客户类】
1. 与客户监控检查相关的评估与监测程序说明
2. 客户贸易安全考评表
3. 客户评价表（按年份分别上传，涵盖公司存续年份）
【供应商类】
4. 运输供应商贸易安全考评表（按年份分别上传，涵盖公司存续年份）
5. 报关供应商贸易安全考评表（按年份分别上传）
6. 仓库供应商贸易安全考评表（按年份分别上传）', `standard_id` = 4 WHERE `id` = 206;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (206, '商业伙伴安全 - 监控检查', 4, 0, '商业伙伴安全 - 监控检查', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 人力资源管理程序（含员工培训相关规定，按版本年份上传，请上传当前有效版本）
2. 各年度内部培训计划（按年份分别上传，按公司存续年份各一份）', `standard_id` = 4 WHERE `id` = 239;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (239, '海关业务和贸易安全培训 - 法律法规和贸易安全内部培训制度', 4, 0, '海关业务和贸易安全培训 - 法律法规和贸易安全内部培训制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 人力资源管理程序（按版本年份上传）
2. 各次培训记录表（区分员工培训和内审员培训，按培训日期分别上传，涵盖公司存续年份）', `standard_id` = 4 WHERE `id` = 240;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (240, '海关业务和贸易安全培训 - 海关法律法规培训', 4, 0, '海关业务和贸易安全培训 - 海关法律法规培训', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 仓库安全管理手册 / 运输部操作规范（按版本年份上传）
2. 运输安全培训记录（按月份上传，涵盖公司存续年份）
3. 仓库安全培训记录（按年度上传，涵盖公司存续年份）
   注：培训记录请按年份分别整理归纳后上传', `standard_id` = 4 WHERE `id` = 241;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (241, '海关业务和贸易安全培训 - 货物安全培训', 4, 0, '海关业务和贸易安全培训 - 货物安全培训', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 危机管理相关制度文件（含应急预案，如火灾、台风、地震、车辆故障等应急预案，以及自然灾害应急手册）
2. 各年度危机管理培训记录（按年份分别上传，涵盖公司存续年份）', `standard_id` = 4 WHERE `id` = 242;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (242, '海关业务和贸易安全培训 - 危机管理培训', 4, 0, '海关业务和贸易安全培训 - 危机管理培训', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. IT信息安全管理手册（按版本年份上传）
2. 各次信息安全培训记录（按培训日期分别上传，涵盖公司存续年份，含员工信息安全培训及网络安全培训）', `standard_id` = 4 WHERE `id` = 243;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (243, '海关业务和贸易安全培训 - 信息安全培训', 4, 0, '海关业务和贸易安全培训 - 信息安全培训', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传：1. 仓库操作部木质包装管理制度
2. 客户服务部进出境商检与进出口法检制度', `standard_id` = 6 WHERE `id` = 276;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (276, '三-1 商品检查与进出口法检制度', 6, 0, '三-1 商品检查与进出口法检制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传：历年抽查单证相关文件。', `standard_id` = 6 WHERE `id` = 389;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (389, '三-3 抽查单证文件', 6, 0, '三-3 抽查单证文件', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传：1. 空置熏蒸板存放区文件
2. 整进整出熏蒸板记录文件', `standard_id` = 6 WHERE `id` = 279;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (279, '三-4 熏蒸板记录', 6, 0, '三-4 熏蒸板记录', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传：历年特殊物品单证文件夹', `standard_id` = 6 WHERE `id` = 372;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (372, '二-2 特殊物品单证', 6, 0, '二-2 特殊物品单证', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传：1. 特殊物品-温控货物操作指导手册
2. 单证归档管理制度（电子）
3. 单证归档管理制度（纸质）', `standard_id` = 6 WHERE `id` = 373;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (373, '二-3 特殊物品安全管理制度', 6, 0, '二-3 特殊物品安全管理制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传：1. 客户服务部单证复核流程
2. 单证归档管理制度（电子）
3. 单证归档管理制度（纸质）', `standard_id` = 6 WHERE `id` = 269;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (269, '一-1 进出口单证复核&保管制度', 6, 0, '一-1 进出口单证复核&保管制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传：历年进境商检查验管理台账记录。', `standard_id` = 6 WHERE `id` = 388;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (388, '三-2 进境商检查验管理台账历年纪录', 6, 0, '三-2 进境商检查验管理台账历年纪录', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传进出境商检与进出口法检管理制度文件。', `standard_id` = 6 WHERE `id` = 378;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (378, '进出口商品检验 - 法检制度', 6, 0, '进出口商品检验 - 法检制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传运输工具管理相关的操作规范或制度文件（如运输部操作规范）。', `standard_id` = 6 WHERE `id` = 379;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (379, '八-20 运输工具管理制度', 6, 0, '八-20 运输工具管理制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传定位系统车载终端管理制度文件。', `standard_id` = 6 WHERE `id` = 381;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (381, '八-21-1 运输工具轨迹管理制度', 6, 0, '八-21-1 运输工具轨迹管理制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传各年度车辆行驶轨迹监控数据及汇总台账。', `standard_id` = 6 WHERE `id` = 382;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (382, '八-21-2 车辆行驶轨迹记录', 6, 0, '八-21-2 车辆行驶轨迹记录', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传驾驶员安全管理制度、司机提货流程及身份检查规范。', `standard_id` = 6 WHERE `id` = 384;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (384, '八-22-1 驾驶员安全与匹配制度', 6, 0, '八-22-1 驾驶员安全与匹配制度', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传车辆信息表、各年度提送货车辆进出登记台账。', `standard_id` = 6 WHERE `id` = 385;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (385, '八-22-2 车辆与司机登记台账', 6, 0, '八-22-2 车辆与司机登记台账', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 进出口单证及复核制度文件', `standard_id` = 6 WHERE `id` = 301;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (301, '六-1 进出口单证及复核制度文件', 6, 0, '六-1 进出口单证及复核制度文件', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 系统复审界面截屏', `standard_id` = 6 WHERE `id` = 302;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (302, '六-2 系统复审界面截屏', 6, 0, '六-2 系统复审界面截屏', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 历年退改单率统计', `standard_id` = 6 WHERE `id` = 303;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (303, '六-3 历年退改单率统计', 6, 0, '六-3 历年退改单率统计', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 历年单一窗口数据取值截屏', `standard_id` = 6 WHERE `id` = 304;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (304, '六-4 历年单一窗口数据取值截屏', 6, 0, '六-4 历年单一窗口数据取值截屏', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 系统逻辑检验截屏', `standard_id` = 6 WHERE `id` = 305;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (305, '六-5 系统逻辑检验截屏', 6, 0, '六-5 系统逻辑检验截屏', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 历年单证抽取记录，包括出口、出境、进口、进境', `standard_id` = 6 WHERE `id` = 306;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (306, '六-6 历年单证抽取记录', 6, 0, '六-6 历年单证抽取记录', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 海关法律法规培训管理办法', `standard_id` = 6 WHERE `id` = 307;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (307, '六-7 海关法律法规培训管理办法', 6, 0, '六-7 海关法律法规培训管理办法', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 客户海关法律法规培训签到记录和培训课件', `standard_id` = 6 WHERE `id` = 308;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (308, '六-8 客户海关法律法规培训签到记录和培训课件', 6, 0, '六-8 客户海关法律法规培训签到记录和培训课件', 2, NOW(), NOW());
UPDATE `folders` SET `department` = '关务', `description` = '请上传以下文件：
1. 延伸认证情况说明文件', `standard_id` = 6 WHERE `id` = 309;
INSERT INTO `folder_check_files` (`folder_id`, `folder_name`, `standard_id`, `audit_status`, `check_name`, `check_type`, `created_at`, `updated_at`) VALUES (309, '六-9 延伸认证情况说明文件', 6, 0, '六-9 延伸认证情况说明文件', 2, NOW(), NOW());
SET FOREIGN_KEY_CHECKS = 1;