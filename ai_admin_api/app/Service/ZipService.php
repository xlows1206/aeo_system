<?php

declare(strict_types=1);

namespace App\Service;

use Hyperf\DbConnection\Db;
use ZipArchive;
use Hyperf\Lib\Log;

class ZipService
{
    protected string $archiveRoot;

    public function __construct()
    {
        $this->archiveRoot = BASE_PATH . '/runtime/aeo_archive';
    }

    /**
     * 为某个标准打包所有通过的项目
     */
    public function packagePassedFiles(int $masterId, int $standardId): string
    {
        // 1. 获取所有通过的项目文件夹
        $passedFolders = Db::table('folders')
            ->when($standardId > 0, function($q) use ($standardId){
                $q->where('standard_id', $standardId);
            })
            ->where('audit_status', 1)
            ->get();

        if ($passedFolders->isEmpty()) {
            throw new \Exception('当前部门尚无已通过审核的项目，无法打包。');
        }

        $runtimePath = BASE_PATH . '/runtime/zip_temp';
        if (!is_dir($runtimePath)) {
            mkdir($runtimePath, 0777, true);
        }

        $zipFileName = "AEO_Audit_Passed_Files_{$masterId}_{$standardId}_" . date('YmdHis') . ".zip";
        $zipPath = "{$runtimePath}/{$zipFileName}";
        
        $zip = new ZipArchive();
        
        if ($zip->open($zipPath, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== true) {
            throw new \Exception('服务器压缩引擎启动失败，请联系管理员。');
        }

        foreach ($passedFolders as $folder) {
            $folderName = $folder->name;
            // 获取归档映射关系
            $archiveFiles = Db::table('folder_passed_files')
                ->where('master_id', $masterId)
                ->where('folder_id', $folder->id)
                ->get();

            if ($archiveFiles->isEmpty()) {
                // 如果没有物理文件，至少保留个空文件夹结构
                $zip->addEmptyDir($folderName);
                continue;
            }

            foreach ($archiveFiles as $file) {
                $sourceFile = "{$this->archiveRoot}/{$file->archive_path}";
                if (file_exists($sourceFile)) {
                    // 打包路径：审核项目名/文件名.后缀
                    $localName = "{$folderName}/{$file->file_name}.{$file->suffix}";
                    $zip->addFile($sourceFile, $localName);
                }
            }
        }

        $zip->close();

        if (!file_exists($zipPath)) {
            throw new \Exception('压缩文件生成失败。');
        }

        return $zipPath;
    }
}
