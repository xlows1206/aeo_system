<?php
require 'vendor/autoload.php';

use App\Model\Folder;
use Hyperf\DbConnection\Db;

// Simulate Hyperf environment
$container = \Hyperf\Context\ApplicationContext::getContainer();
$service = $container->get(\App\Service\FolderService::class);

$masterId = 2;

// 1. Create a dummy folder and a file for master_id 2
echo "--- Step 1: Creating test data ---\n";
$oldFolder = new Folder();
$oldFolder->name = "TEST_FOLDER_" . time();
$oldFolder->master_id = $masterId;
$oldFolder->save();
$oldFolderId = $oldFolder->id;

$fileId = Db::table('files')->insertGetId([
    'name' => 'test_file.pdf',
    'folder_id' => $oldFolderId,
    'master_id' => $masterId,
    'standard_id' => 1,
    'url' => 'http://test.com',
    'created_at' => date('Y-m-d H:i:s'),
    'updated_at' => date('Y-m-d H:i:s'),
]);

echo "Created test folder: {$oldFolder->name} (ID: {$oldFolderId})\n";
echo "Created test file: test_file.pdf (Linked to folder ID: {$oldFolderId})\n";

// 2. Add this folder name to Template (master_id 0) to ensure initFromTemplate creates it
echo "--- Step 2: Adding folder to Template ---\n";
$tplFolder = new Folder();
$tplFolder->name = $oldFolder->name;
$tplFolder->master_id = 0;
$tplFolder->save();
$tplId = $tplFolder->id;
echo "Template folder created (ID: {$tplId})\n";

// 3. Run initFromTemplate with force
echo "--- Step 3: Running initFromTemplate(force=true) ---\n";
$service->initFromTemplate($masterId, true);

// 4. Verify results
echo "--- Step 4: Verification ---\n";

// Check if old folder is gone
$checkOld = Folder::find($oldFolderId);
if (!$checkOld) {
    echo "SUCCESS: Old folder {$oldFolderId} deleted.\n";
} else {
    echo "FAIL: Old folder {$oldFolderId} still exists.\n";
}

// Find new folder
$newFolder = Folder::where('master_id', $masterId)->where('name', $oldFolder->name)->first();
if ($newFolder) {
    echo "SUCCESS: New folder created (ID: {$newFolder->id}).\n";
    
    // Check file link
    $file = Db::table('files')->where('id', $fileId)->first();
    if ($file->folder_id == $newFolder->id) {
        echo "SUCCESS: File association MIGRATED from {$oldFolderId} to {$newFolder->id}!\n";
    } else {
        echo "FAIL: File association is {$file->folder_id}, expected {$newFolder->id}.\n";
    }
} else {
    echo "FAIL: New folder not found.\n";
}

// Cleanup template folder
$tplFolder->delete();
echo "Cleanup completed.\n";
