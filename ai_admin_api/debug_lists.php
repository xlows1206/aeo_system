<?php
// This is a mockup of the lists method to see what it would return
// I will run it via docker exec to get the actual data

require_once 'vendor/autoload.php';

// I'll just use the DB to simulate the logic
use Hyperf\DbConnection\Db;

// Simulate standard_id = 1
$standardId = 1;

$checkFolderIds = Db::table('folder_check_files')
    ->pluck('folder_id')
    ->toArray();

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

echo json_encode($folders, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
