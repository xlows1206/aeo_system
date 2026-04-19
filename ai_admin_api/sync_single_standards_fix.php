<?php

declare(strict_types=1);

define('BASE_PATH', __DIR__);

include __DIR__ . '/vendor/autoload.php';

use Hyperf\Context\ApplicationContext;
use Hyperf\DbConnection\Db;

// Initialize container
$container = require __DIR__ . '/config/container.php';
if (! ApplicationContext::hasContainer()) {
    ApplicationContext::setContainer($container);
}

$now = date('Y-m-d H:i:s');
$standardId = (int) (Db::table('standards')->where('name', '单项标准')->orWhere('name', 'LIKE', '%单项标准%')->value('id') ?? 6);

echo "Syncing projects for standard_id: {$standardId}\n";

$projects = [
    [
        'name' => '进出口单证复核&保管制度',
        'description' => "请上传：1. 客户服务部单证复核流程\n2. 单证归档管理制度（电子）\n3. 单证归档管理制度（纸质）",
        'path' => ['一、加工贸易以及保税进出口业务', '一-1 进出口单证复核&保管制度'],
        'check_type' => 2,
        'check_text' => null,
    ],
    [
        'name' => '特殊物品单证',
        'description' => "请上传：历年特殊物品单证文件夹",
        'path' => ['二、卫生检疫业务', '二-2 特殊物品单证'],
        'check_type' => 2,
        'check_text' => null,
    ],
    [
        'name' => '特殊物品安全管理制度',
        'description' => "请上传：1. 特殊物品-温控货物操作指导手册\n2. 单证归档管理制度（电子）\n3. 单证归档管理制度（纸质）",
        'path' => ['二、卫生检疫业务', '二-3 特殊物品安全管理制度'],
        'check_type' => 2,
        'check_text' => null,
    ],
    [
        'name' => '动植物商检管理制度',
        'description' => "请上传：1. 仓库操作部木质包装管理制度\n2. 客户服务部进出境商检与进出口法检制度",
        'path' => ['三、动植物检疫业务', '三-4 商检制度&台账', '三-4-1 制度'],
        'check_type' => 2,
        'check_text' => null,
    ],
    [
        'name' => '进境商检查验管理台账',
        'description' => "请上传：历年进境商检查验管理台账",
        'path' => ['三、动植物检疫业务', '三-4 商检制度&台账', '三-4-2 进境商检查验管理台账'],
        'check_type' => 2,
        'check_text' => null,
    ],
    [
        'name' => '抽查单证',
        'description' => "请上传：历年抽查单证文件夹",
        'path' => ['三、动植物检疫业务', '三-4 商检制度&台账', '三-4-3 抽查单证'],
        'check_type' => 2,
        'check_text' => null,
    ],
    [
        'name' => '熏蒸板记录',
        'description' => "请上传：1. 空置熏蒸板存放区文件\n2. 整进整出熏蒸板记录文件",
        'path' => ['三、动植物检疫业务', '三-4 商检制度&台账', '三-4-4 熏蒸板记录'],
        'check_type' => 2,
        'check_text' => null,
    ],
    [
        'name' => '进出口商品检验 - 法检制度',
        'description' => "请上传进出境商检与进出口法检管理制度文件。",
        'path' => ['五、进出口商品检验业务', '五-9 法检制度'],
        'check_type' => 1,
        'check_text' => '“进出口法检”、“商检管理”',
    ],
    [
        'name' => '物流运输业务 - 运输工具管理制度',
        'description' => "请上传运输工具管理相关的操作规范或制度文件（如运输部操作规范）。",
        'path' => ['八、物流运输业务', '八-20 运输工具管理制度'],
        'check_type' => 2,
        'check_text' => null,
    ],
    [
        'name' => '物流运输业务 - 车辆轨迹管理制度',
        'description' => "请上传定位系统车载终端管理制度文件。",
        'path' => ['八、物流运输业务', '八-21 运输工具行驶轨迹', '八-21-1 制度'],
        'check_type' => 1,
        'check_text' => '“定位监控”、“轨迹系统”、“车载终端”',
    ],
    [
        'name' => '物流运输业务 - 车辆行驶轨迹记录',
        'description' => "请上传各年度车辆行驶轨迹监控数据及汇总台账。",
        'path' => ['八、物流运输业务', '八-21 运输工具行驶轨迹', '八-21-2 轨迹记录'],
        'check_type' => 2,
        'check_text' => null,
    ],
    [
        'name' => '物流运输业务 - 驾驶员安全匹配制度',
        'description' => "请上传驾驶员安全管理制度、司机提货流程及身份检查规范。",
        'path' => ['八、物流运输业务', '八-22 运输工具与驾驶人员匹配制度', '八-22-1 制度'],
        'check_type' => 1,
        'check_text' => '“驾驶员审核”、“身份检查”、“人员匹配”',
    ],
    [
        'name' => '物流运输业务 - 车辆与司机登记台账',
        'description' => "请上传车辆信息表、各年度提送货车辆进出登记台账。",
        'path' => ['八、物流运输业务', '八-22 运输工具与驾驶人员匹配制度', '八-22-2 记录'],
        'check_type' => 2,
        'check_text' => null,
    ],
    [
        'name' => '遵守法律法规 - 6-15-1 管理层声明书',
        'description' => "请上传：管理层声明书",
        'path' => ['遵守法律法规', '6-15-1 管理层声明书'],
        'check_type' => 2,
        'check_text' => null,
    ]
];

Db::table('folder_check_files')->where('standard_id', $standardId)->delete();
echo "Cleaned up old records for standard_id: {$standardId}\n";

foreach ($projects as $project) {
    echo "Processing: {$project['name']}\n";
    $parentId = 0;

    foreach ($project['path'] as $segment) {
        $folder = Db::table('folders')
            ->where('standard_id', $standardId)
            ->where('parent_id', $parentId)
            ->where('name', $segment)
            ->first();

        if (! $folder) {
            $folderId = Db::table('folders')->insertGetId([
                'name' => $segment,
                'standard_id' => $standardId,
                'user_id' => 0,
                'master_id' => 0,
                'parent_id' => $parentId,
                'department' => '单项标准',
                'created_at' => $now,
                'updated_at' => $now,
            ]);
            echo "  Created folder: {$segment} (ID: {$folderId})\n";
            $folder = (object) ['id' => $folderId];
        } else {
            // Update department just in case
            Db::table('folders')->where('id', $folder->id)->update(['department' => '单项标准']);
        }

        $parentId = (int) $folder->id;
    }

    Db::table('folders')->where('id', $parentId)->update([
        'department' => '单项标准',
        'description' => $project['description'],
        'standard_id' => $standardId,
        'updated_at' => $now,
    ]);

    Db::table('folder_check_files')->insert([
        'folder_name' => $project['name'],
        'folder_id' => $parentId,
        'standard_id' => $standardId,
        'check_name' => $project['name'],
        'check_type' => $project['check_type'],
        'check_text' => $project['check_text'],
        'created_at' => $now,
        'updated_at' => $now,
    ]);
}

echo "Sync completed. Total items: " . count($projects) . "\n";
