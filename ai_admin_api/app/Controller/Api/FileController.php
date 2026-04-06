<?php

declare(strict_types=1);

namespace App\Controller\Api;

use App\Controller\BaseController;
use App\Lib\Log;
use App\Model\File;
use App\Model\Folder;
use Hyperf\DbConnection\Db;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use function Hyperf\Support\env;

#[Controller(prefix: 'api/v1/file'), Middleware('App\Middleware\UserAuthMiddleware')]
class FileController extends BaseController
{
    #[RequestMapping(path: "", methods: "get")]
    public function index(RequestInterface $request)
    {
        $auth = $request->input('Auth');
        $userId = $auth->id;
        $masterId = $auth->master_id;

        $page = $request->input('page', 1);
        $size = $request->input('pageSize', 20);

        $folderId = $request->input('folder_id', 0);
        $folder = Folder::find($folderId);

        $standardId = $request->input('standard_id', 0);

        $paths = [['id' => 0, 'name' => '全部']];
        if ($folder) {
            $paths = array_merge($paths, $folder->getAncestorsAndSelf()->toArray());
        }

        $folders = Db::table('folders')
//            ->when($auth->parent_id == 0, function ($q) use ($masterId) {
//                // 主账号
//                $q->where('master_id', $masterId);
//            }, function ($q) use ($userId) {
//                $q->where('user_id', $userId);
//            })
//            ->where('master_id', $masterId)
            ->where('parent_id', $folderId)
            ->where('standard_id', $standardId)
            ->select('id', 'name', Db::raw('1 as type'), Db::raw("'' as size"), Db::raw("'' as url"), Db::raw("'' as suffix"), 'updated_at');
        $files = Db::table('files')
            ->when($auth->parent_id == 0, function ($q) use ($masterId) {
                // 主账号
                $q->where('master_id', $masterId);
            }, function ($q) use ($userId) {
                $q->where('user_id', $userId);
            })
            ->where('folder_id', $folderId)
            ->where('standard_id', $standardId)
            ->select('id', 'name', Db::raw('2 as type'), 'size', 'url', 'suffix', 'updated_at')
            ->unionAll($folders);

        $total = $files->count();
        $lists = $files->forPage($page, $size)->oldest('type')->latest('updated_at')->get();

        return $this->responseService->success([
            'list' => $lists,
            'page' => intval($page),
            'itemCount' => $total,
            'paths' => $paths
        ]);
    }

    #[RequestMapping(path: "lists", methods: "get")]
    public function lists(RequestInterface $request)
    {
        $auth = $request->input('Auth');
        $userId = $auth->id;
        $standardId = $request->input('standard_id', 0);
        $masterId = $auth->master_id;

        $folders = Db::table('folders as f')
//            ->when($auth->parent_id == 0, function ($q) use ($masterId) {
//                // 主账号
//                $q->where('master_id', $masterId);
//            }, function ($q) use ($userId) {
//                $q->where('user_id', $userId);
//            })
//            ->where('master_id', $masterId)
            ->where('f.standard_id', $standardId)
            ->select('f.*')
            ->get()
            ->map(function ($i) {
                return [
                    'id' => 'f' . $i->id,
                    'type' => 'folder',
                    'parent_id' => 'f' . $i->parent_id,
                    'name' => $i->name,
                ];
            })
            ->toArray();

        $files = Db::table('files')
            ->when($auth->parent_id == 0, function ($q) use ($masterId) {
                // 主账号
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

        return $this->responseService->success(buildTree(array_merge($folders, $files, [['id' => 'f0', 'name' => '根目录', 'type' => 'folder', 'parent_id' => 'x']])));

    }

    #[RequestMapping(path: "standard", methods: "get")]
    public function standard(RequestInterface $request)
    {
        $auth = $request->input('Auth');
        $standing = $auth->standing;
        $roleId = $auth->role_id;
        $parentId = $auth->parent_id;
        $enterprise = $auth->enterprise;
        $permissionPaths = Db::table('role_permission as rp')
            ->leftJoin('permissions as p', 'p.id', '=', 'rp.permission_id')
            ->where('rp.role_id', $roleId)
            ->pluck('p.path')
            ->toArray();
        $lists = Db::table('standards')
            ->when(filled($standing), function ($q) use ($permissionPaths, $standing, $parentId, $enterprise) {
                if ($standing > 1) {
                    if ($parentId == 0) {
                        // 主账号
                        if ($enterprise == 1) {
                            $where = [1];
                        } else {
                            $where = [1, 2];
                        }
                        $q->whereIn('type', $where);
                    } else {
                        $q->whereIn('permission_path', $permissionPaths)->orWhere('name', '全部');
                    }
                }
            })
            ->get();

        return $this->responseService->success([
            'lists' => $lists
        ]);
    }

    #[RequestMapping(path: "allStandard", methods: "get")]
    public function allStandard(RequestInterface $request)
    {
        $auth = $request->input('Auth');

        if ($auth->enterprise == 1) {
            $where = [1];
        } else {
            $where = [1, 2];
        }
        $lists = Db::table('standards')
            ->whereIn('type', $where)
            ->get()
            ->map(function ($i) {
                $i->parent_id = $i->type == 1 ? 't1' : 't2';
                return $i;
            });

        if ($auth->enterprise == 1) {
            $lists = $lists->prepend(collect(
                ['id' => 't1', 'name' => '通用', 'parent_id' => 'x']
            ))->toArray();
        } else {
            $lists = $lists->prepend(collect(
                ['id' => 't2', 'name' => '单项', 'parent_id' => 'x']
            ))->prepend(collect(
                ['id' => 't1', 'name' => '通用', 'parent_id' => 'x']
            ))->toArray();
        }

        return $this->responseService->success(buildTree($lists));
    }

    #[RequestMapping(path: "", methods: "post")]
    public function store(RequestInterface $request)
    {
        $auth = $request->input('Auth');
        $userId = $auth->id;
        $masterId = $auth->master_id;

        $name = $request->input('name');
        $folderId = $request->input('folder_id');
        $standardId = $request->input('standard_id');

        $count = Db::table('files')
            ->where('user_id', $userId)
            ->where('folder_id', $folderId)
            ->where('standard_id', $standardId)
            ->where('name', 'like', "$name%")
            ->count();

        $suffix = explode('.', $name);
        $suffix = end($suffix);

        if ($count > 0) {
            $name = $name . '_' . "($count)";
        }

        $file = new File();
        $file->name = $name;
        $file->url = $request->input('url');
        $file->size = transmit_file_size($request->input('size', 0));
        $file->suffix = $suffix;
        $file->folder_id = $folderId;
        $file->standard_id = $standardId;
        $file->user_id = $userId;
        $file->master_id = $masterId;
        $file->save();

        return $this->responseService->success();
    }

    #[RequestMapping(path: "{id}/copy", methods: "post")]
    public function copy(RequestInterface $request, $id)
    {
        $auth = $request->input('Auth');
        $userId = $auth->id;
        $masterId = $auth->master_id;

        $oldFile = File::find($id);

        $file = new File();
        $file->name = $oldFile->name . '_副本';
        $file->url = $oldFile->url;
        $file->suffix = $oldFile->suffix;
        $file->size = $oldFile->size;
        $file->folder_id = $oldFile->folder_id;
        $file->standard_id = $oldFile->standard_id;
        $file->user_id = $userId;
        $file->master_id = $masterId;
        $file->save();

        return $this->responseService->success();
    }

    #[RequestMapping(path: "{id}/rename", methods: "patch")]
    public function rename(RequestInterface $request, $id)
    {
        $file = File::find($id);
        $file->name = $request->input('name');
        $file->save();
        return $this->responseService->success();
    }

    #[RequestMapping(path: "{id}", methods: "delete")]
    public function destroy($id)
    {
        File::destroy($id);
        return $this->responseService->success();
    }

    #[RequestMapping(path: "{id}/move", methods: "patch")]
    public function move(RequestInterface $request, $id)
    {
        $file = File::find($id);
        $file->folder_id = $request->input('folder_id');
        $file->save();
        return $this->responseService->success();
    }

    #[RequestMapping(path: "getFileById", methods: "post")]
    public function getFileById(RequestInterface $request)
    {
        $ids = $request->input('ids');
        $files = Db::table('files')->whereIn('id', $ids)->get();
        return $this->responseService->success([
            'lists' => $files
        ]);
    }
}
