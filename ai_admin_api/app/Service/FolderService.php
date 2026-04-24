<?php

declare(strict_types=1);

namespace App\Service;

use App\Model\Folder;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;

class FolderService
{
    /**
     * 从模板 (master_id=0) 初始化公司的文件夹结构和审核项
     */
    public function initFromTemplate(int $masterId, bool $force = false)
    {
        $oldFolders = [];
        if ($force) {
            // 0. 记录旧文件夹 ID 与名称的映射 (用于迁移文件关联)
            $oldFolders = Folder::where('master_id', $masterId)->pluck('name', 'id')->toArray();
        }

        // 1. 获取所有模板文件夹 (master_id = 0)
        $templates = Folder::where('master_id', 0)->orderBy('id')->get();
        if ($templates->isEmpty()) {
            return false;
        }

        $idMap = []; // old_template_id => new_id

        // 第一遍：创建文件夹记录
        foreach ($templates as $tpl) {
            $newFolder = $tpl->replicate();
            $newFolder->master_id = $masterId;
            $newFolder->user_id = $masterId;
            $newFolder->save();
            $idMap[$tpl->id] = $newFolder->id;
        }

        // 第二遍：修正 parent_id
        foreach ($templates as $tpl) {
            if ($tpl->parent_id > 0 && isset($idMap[$tpl->parent_id])) {
                $newId = $idMap[$tpl->id];
                $newFolder = Folder::find($newId);
                $newFolder->parent_id = $idMap[$tpl->parent_id];
                $newFolder->save();
            }
        }

        // 第三遍：克隆审核项目 (folder_check_files)
        $checkTemplates = Db::table('folder_check_files')->where('master_id', 0)->get();
        foreach ($checkTemplates as $fcf) {
            $data = (array)$fcf;
            unset($data['id']);
            $data['master_id'] = $masterId;
            $data['folder_id'] = $idMap[$fcf->folder_id] ?? 0;
            if ($data['folder_id'] > 0) {
                Db::table('folder_check_files')->insert($data);
            }
        }

        // 第四遍：迁移文件关联 (基于名称匹配) 并清理旧数据
        if ($force && !empty($oldFolders)) {
            $newNameMap = Folder::where('master_id', $masterId)->where('id', '>', 0)->pluck('id', 'name')->toArray();
            foreach ($oldFolders as $oldId => $name) {
                if (isset($newNameMap[$name])) {
                    $newId = $newNameMap[$name];
                    if ($newId != $oldId) {
                        Db::table('files')->where('master_id', $masterId)
                            ->where('folder_id', $oldId)
                            ->update(['folder_id' => $newId]);
                    }
                }
            }
            // 清理旧文件夹 (排除刚刚创建的新文件夹)
            $newIds = array_values($idMap);
            Folder::where('master_id', $masterId)->whereNotIn('id', $newIds)->delete();
            Db::table('folder_check_files')->where('master_id', $masterId)->whereNotIn('folder_id', $newIds)->delete();
        }

        // 第五遍：重建闭包表 (folder_closure)
        $this->rebuildClosure($masterId);

        return true;
    }

    /**
     * 重建指定 Master ID 的闭包表
     */
    public function rebuildClosure(int $masterId)
    {
        // 删除该 master_id 下的闭包记录
        Db::table('folder_closure')
            ->whereIn('descendant', function($query) use ($masterId) {
                $query->select('id')->from('folders')->where('master_id', $masterId);
            })->delete();

        // 插入距离为 0 的记录 (自身到自身)
        Db::insert("INSERT INTO folder_closure (ancestor, descendant, distance) 
                    SELECT id, id, 0 FROM folders WHERE master_id = ?", [$masterId]);

        // 递归插入上级记录
        $distance = 1;
        while (true) {
            $count = Db::insert("
                INSERT INTO folder_closure (ancestor, descendant, distance)
                SELECT f.parent_id, fc.descendant, ?
                FROM folders f
                JOIN folder_closure fc ON f.id = fc.ancestor
                WHERE f.master_id = ? AND f.parent_id != 0 AND fc.distance = ? - 1
            ", [$distance, $masterId, $distance]);

            if ($count === 0 || $distance > 15) break;
            $distance++;
        }
    }
}
