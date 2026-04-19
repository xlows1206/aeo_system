<?php

declare(strict_types=1);

namespace App\Service;

use Hyperf\DbConnection\Db;
use Hyperf\Contract\ConfigInterface;
use Hyperf\Filesystem\FilesystemFactory;
use Psr\Container\ContainerInterface;
use League\Flysystem\Filesystem;

class ArchiveService
{
    protected string $archiveRoot;
    protected ContainerInterface $container;

    public function __construct(ContainerInterface $container)
    {
        $this->container = $container;
        // 定义归档根目录
        $this->archiveRoot = BASE_PATH . '/runtime/aeo_archive';
        if (!is_dir($this->archiveRoot)) {
            mkdir($this->archiveRoot, 0777, true);
        }
    }

    /**
     * 归档通过审核的项目文件
     * @param int $masterId 主账号ID
     * @param int $folderId 文件夹ID
     * @param array $fileIds 文件ID列表
     * @return bool
     */
    public function archiveProjectFiles(int $masterId, int $folderId, array $fileIds): bool
    {
        // 1. 先清理旧的归档（确保即时清理）
        $this->purgeProjectArchive($masterId, $folderId);

        if (empty($fileIds)) {
            return true;
        }

        // 2. 获取文件详情
        $files = Db::table('files')
            ->whereIn('id', $fileIds)
            ->get();

        $targetDir = "{$this->archiveRoot}/{$masterId}/{$folderId}";
        if (!is_dir($targetDir)) {
            mkdir($targetDir, 0777, true);
        }

        $records = [];
        foreach ($files as $file) {
            $fileName = $file->name . '.' . $file->suffix;
            $targetPath = "{$targetDir}/{$fileName}";

            // 物理拷贝 (支持 URL 下载或本地拷贝)
            if (str_starts_with($file->url, 'http')) {
                @file_put_contents($targetPath, @file_get_contents($file->url));
            } else {
                $sourcePath = BASE_PATH . '/runtime/' . $file->url;
                if (file_exists($sourcePath)) {
                    copy($sourcePath, $targetPath);
                }
            }

            if (file_exists($targetPath)) {
                $records[] = [
                    'master_id' => $masterId,
                    'folder_id' => $folderId,
                    'file_id' => $file->id,
                    'file_name' => $file->name,
                    'suffix' => $file->suffix,
                    'file_url' => $file->url,
                    'archive_path' => "{$masterId}/{$folderId}/{$fileName}",
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ];
            }
        }

        // 3. 记录映射关系
        if (!empty($records)) {
            Db::table('folder_passed_files')->insert($records);
        }

        return true;
    }

    /**
     * 清理归档快照 (立即删除)
     * @param int $masterId
     * @param int $folderId
     * @return bool
     */
    public function purgeProjectArchive(int $masterId, int $folderId): bool
    {
        // 1. 删除数据库记录
        Db::table('folder_passed_files')
            ->where('master_id', $masterId)
            ->where('folder_id', $folderId)
            ->delete();

        // 2. 物理删除目录
        $targetDir = "{$this->archiveRoot}/{$masterId}/{$folderId}";
        if (is_dir($targetDir)) {
            $this->delDir($targetDir);
        }

        return true;
    }

    /**
     * 递归删除目录
     */
    protected function delDir(string $dir): bool
    {
        $files = array_diff(scandir($dir), ['.', '..']);
        foreach ($files as $file) {
            (is_dir("{$dir}/{$file}")) ? $this->delDir("{$dir}/{$file}") : unlink("{$dir}/{$file}");
        }
        return rmdir($dir);
    }
}
