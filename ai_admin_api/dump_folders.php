<?php
declare(strict_types=1);
require_once 'vendor/autoload.php';
$app = require_once 'config/container.php';
use Hyperf\DbConnection\Db;

$folders = Db::table('folders')->get();
$output = "";
foreach ($folders as $f) {
    $output .= "ID: {$f->id} | Name: '" . $f->name . "'\n";
}
file_put_contents('storage/logs/folders_dump.txt', $output);
echo "Dumped " . count($folders) . " folders to storage/logs/folders_dump.txt\n";
