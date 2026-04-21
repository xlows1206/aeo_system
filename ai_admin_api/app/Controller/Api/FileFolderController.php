<?php

declare(strict_types=1);

namespace App\Controller\Api;

use App\Support\FolderDisplayName;
use App\Controller\BaseController;
use Hyperf\DbConnection\Db;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;

#[Controller(prefix: 'api/v1/folder'), Middleware('App\Middleware\UserAuthMiddleware')]
class FileFolderController extends BaseController
{
    #[RequestMapping(path: "lists", methods: "get")]
    public function lists(RequestInterface $request)
    {
        $auth = $request->input('Auth');
        $userId = $auth->id;
        $standardId = $request->input('standard_id', 0);
        $masterId = $auth->master_id;

        // 查询所有审核项目文件夹的 ID（以 folder_check_files 为权威来源）
        $checkFolderIds = Db::table('folder_check_files')
            ->pluck('folder_id')
            ->map(fn ($id) => (int)$id)
            ->toArray();
        $checkFolderIdMap = array_flip($checkFolderIds);

        $folders = Db::table('folders as f')
            ->where('f.standard_id', $standardId)
            ->select('f.*')
            ->get();

        $folderNameMap = $folders->pluck('name', 'id')->toArray();

        $folders = $folders
            ->map(function ($i) use ($checkFolderIds, $checkFolderIdMap, $folderNameMap) {
                $name = $i->name;
                if (isset($checkFolderIdMap[(int)$i->id])) {
                    $name = FolderDisplayName::format($i->name, $folderNameMap[$i->parent_id] ?? null);
                }

                return [
                    'id'              => 'f' . $i->id,
                    'type'            => 'folder',
                    'parent_id'       => 'f' . $i->parent_id,
                    'name'            => $name,
                    'is_check_folder' => isset($checkFolderIdMap[(int)$i->id]),
                    'audit_status'    => $i->audit_status,
                ];
            })
            ->toArray();

        $files = Db::table('files')
            ->when($auth->parent_id == 0, function ($q) use ($masterId) {
                $q->where('master_id', $masterId);
            }, function ($q) use ($userId) {
                $q->where('user_id', $userId);
            })
            ->where('standard_id', $standardId)
            ->get()
            ->map(function ($i) {
                return [
                    'id' => $i->id,
                    'type' => 'file',
                    'parent_id' => 'f' . $i->folder_id,
                    'name' => $i->name,
                ];
            })
            ->toArray();

        $totalCount = count($folders);
        $passedCount = collect($folders)->where('audit_status', 1)->count();

        return $this->responseService->success([
            'tree' => buildTree(array_merge($folders, $files, [['id' => 'f0', 'name' => '根目录', 'type' => 'folder', 'parent_id' => 'x']])),
            'stats' => [
                'total' => $totalCount,
                'passed' => $passedCount,
            ],
        ]);
    }
}
