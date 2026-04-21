<?php
use Hyperf\DbConnection\Db;

require_once __DIR__ . '/vendor/autoload.php';

// Mock DB settings
$standardId = 6;
$masterId = 2; // Assuming this is the test user

$query = Db::table('folder_check_files as fcf')
    ->join('folders as f', 'f.id', '=', 'fcf.folder_id')
    ->leftJoin('folders as p', 'p.id', '=', 'f.parent_id')
    ->leftJoin('folders as gp', 'gp.id', '=', 'p.parent_id')
    ->where('fcf.standard_id', $standardId);

// Check company binds
$company = Db::table('company_info')->where('master_id', $masterId)->first();
if ($company && !empty($company->bind_projects)) {
    $bindIds = explode(',', (string)$company->bind_projects);
    echo "Binding IDs: " . implode(',', $bindIds) . "\n";
    $query->whereIn('fcf.id', $bindIds);
} else {
    echo "No bindings found or empty.\n";
    $query->whereRaw('1 = 0');
}

$projects = $query->select('f.name as folder_name', 'fcf.id as fcf_id', 'fcf.folder_name as fcf_label')
    ->get();

echo "Total Projects Found: " . count($projects) . "\n";
foreach ($projects as $idx => $p) {
    echo "[$idx] ID: {$p->fcf_id} | Label: {$p->fcf_label} | Folder: {$p->folder_name}\n";
}
