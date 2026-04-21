<?php
require 'vendor/autoload.php';
$container = require './config/container.php';
$db = $container->get(\Hyperf\DbConnection\Db::class);

echo "=== AEO 数据库一致性校验报告 ===\n";

// 1. 孤儿记录检查 (fcf -> folders)
$orphans = $db::table('folder_check_files as fcf')
    ->leftJoin('folders as f', 'f.id', '=', 'fcf.folder_id')
    ->whereNull('f.id')
    ->select('fcf.id', 'fcf.folder_name as fcf_name', 'fcf.folder_id')
    ->get();

echo "\n[1] 孤儿记录检查 (待清理): " . count($orphans) . " 条\n";
foreach ($orphans as $o) {
    echo " - fcf.id: {$o->id}, 名称: {$o->fcf_name}, 缺失 folder_id: {$o->folder_id}\n";
}

// 2. 同名审核项目检查 (可能存在重复多套)
$duplicates = $db::table('folder_check_files')
    ->select('folder_name', $db::raw('COUNT(*) as count'), $db::raw('GROUP_CONCAT(id) as ids'))
    ->groupBy('folder_name')
    ->having('count', '>', 1)
    ->get();

echo "\n[2] 同名审核项目检查 (潜在重复): " . count($duplicates) . " 组\n";
foreach ($duplicates as $d) {
    echo " - 名称: {$d->folder_name}, 数量: {$d->count}, ID 集合: [{$d->ids}]\n";
}

// 3. 单项标准 (standard_id=6) 统计
$standard6Count = $db::table('folder_check_files')->where('standard_id', 6)->count();
echo "\n[3] 单项标准统计: 当前共有 {$standard6Count} 个审核节点\n";

// 4. 公司绑定状态概览
$companies = $db::table('company_info')->get();
echo "\n[4] 公司绑定状态:\n";
foreach ($companies as $c) {
    $bindCount = $c->bind_projects ? count(explode(',', $c->bind_projects)) : 0;
    echo " - 公司 master_id: {$c->master_id}, 业务类型: {$c->types}, 绑定项目数: {$bindCount}\n";
}

echo "\n=== 校验结束 ===\n";
