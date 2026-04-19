<?php
require 'vendor/autoload.php';
Hyperf\Di\ClassLoader::init();
$container = require 'config/container.php';
$projects = Hyperf\DbConnection\Db::table('folder_check_files as fcf')
    ->leftJoin('folders as f', 'f.id', '=', 'fcf.folder_id')
    ->leftJoin('folders as p', 'p.id', '=', 'f.parent_id')
    ->where('fcf.standard_id', 6)
    ->select('f.*', 'p.name as parent_name')
    ->get();
foreach ($projects as $f) {
    echo "ID: f{$f->id}, Name: {$f->name}, ParentName: {$f->parent_name}\n";
}
