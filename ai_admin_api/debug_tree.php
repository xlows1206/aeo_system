<?php
require_once 'vendor/autoload.php';
use Hyperf\DbConnection\Db;

// Simulate standard_id = 1
$standardId = 1;

$checkFolderIds = Db::table('folder_check_files')
    ->pluck('folder_id')
    ->toArray();

echo "Check Folder IDs count: " . count($checkFolderIds) . "\n";

$folders = Db::table('folders as f')
    ->where('f.standard_id', $standardId)
    ->select('id', 'name', 'parent_id')
    ->get()
    ->map(function ($i) use ($checkFolderIds) {
        return [
            'id'              => 'f' . $i->id,
            'type'            => 'folder',
            'parent_id'       => 'f' . $i->parent_id,
            'name'            => $i->name,
            'is_check_folder' => in_array($i->id, $checkFolderIds),
        ];
    })
    ->toArray();

echo "Folders count for standard 1: " . count($folders) . "\n";

// Check if there are any folders with is_check_folder = true
$checked = array_filter($folders, fn($f) => $f['is_check_folder']);
echo "Folders marked as project for standard 1: " . count($checked) . "\n";
foreach($checked as $f) {
    echo "  - {$f['name']} (ID: {$f['id']}, Parent: {$f['parent_id']})\n";
}

// Check buildTree
function buildTree(array $elements, $parentId = 'x'): array
{
    $branch = [];
    foreach ($elements as &$element) {
        if ($element['parent_id'] == $parentId) {
            $children = buildTree($elements, $element['id']);
            if ($children) {
                $element['children'] = $children;
            }
            $branch[] = $element;
        }
    }
    return $branch;
}

$tree = buildTree(array_merge($folders, [['id' => 'f0', 'name' => '根目录', 'type' => 'folder', 'parent_id' => 'x']]));
echo "Tree nodes at root: " . count($tree) . "\n";

if (count($tree) > 0) {
    echo "Root node name: " . $tree[0]['name'] . "\n";
    echo "Root children count: " . (isset($tree[0]['children']) ? count($tree[0]['children']) : 0) . "\n";
}

// Recursively count projects in tree
function countChecked($items) {
    $count = 0;
    foreach($items as $i) {
        if ($i['is_check_folder'] ?? false) $count++;
        if (isset($i['children'])) $count += countChecked($i['children']);
    }
    return $count;
}

echo "Total projects found in tree: " . countChecked($tree) . "\n";
