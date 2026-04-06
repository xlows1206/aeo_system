<?php

declare(strict_types=1);

namespace App\Controller\Api;

use App\Controller\BaseController;
use App\Model\Folder;
use Hyperf\DbConnection\Db;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;

#[Controller(prefix: 'api/v1/folder'), Middleware('App\Middleware\UserAuthMiddleware')]
class FileFolderController extends BaseController
{
    #[RequestMapping(path: "lists", methods: "get")]
    public function index(RequestInterface $request)
    {
        $lists = Db::table('folders')
//            ->when($auth->parent_id == 0, function ($q) use ($masterId) {
//                $q->where('master_id', $masterId);
//            }, function ($q) use ($userId) {
//                $q->where('user_id', $userId);
//            })
//            ->where('master_id', $masterId)
            ->oldest('id')
            ->get()->prepend(collect(['id' => 0, 'name' => '根目录', 'parent_id' => 'x']))
            ->toArray();
        return $this->responseService->success(buildTree($lists));
    }

//    #[RequestMapping(path: "", methods: "post")]
//    public function store(RequestInterface $request)
//    {
//        $auth = $request->input('Auth');
//        $folder = new Folder();
//        $folder->name = $request->input('name');
//        $folder->standard_id = $request->input('standard_id');
//        $folder->user_id = $auth->id;
//        $folder->master_id = $auth->master_id;
//        $folder->parent_id = $request->input('parent_id');
//        $folder->save();
//        return $this->responseService->success();
//    }

//    #[RequestMapping(path: "{id}", methods: "put")]
//    public function update(RequestInterface $request, $id)
//    {
//        $folder = Folder::find($id);
//        $folder->name = $request->input('name');
//        $folder->standard_id = $request->input('standard_id');
//        $folder->parent_id = $request->input('parent_id');
//        $folder->save();
//        return $this->responseService->success();
//    }
//
//    #[RequestMapping(path: "{id}/rename", methods: "patch")]
//    public function rename(RequestInterface $request, $id)
//    {
//        $folder = Folder::find($id);
//        $folder->name = $request->input('name');
//        $folder->save();
//        return $this->responseService->success();
//    }
//
//    #[RequestMapping(path: "{id}", methods: "delete")]
//    public function destroy($id)
//    {
//        $childIds = Db::table('folder_closure')
//            ->where('ancestor', $id)
//            ->pluck('descendant')
//            ->toArray();
//
//        if (
//            Db::table('files')
//                ->whereIn('folder_id', $childIds)
//                ->count() > 0
//        ) {
//            return $this->responseService->error('请先清空该目录下的文件');
//        }
//
//        Folder::destroy($id);
//        return $this->responseService->success();
//    }
//
//    #[RequestMapping(path: "{id}/move", methods: "patch")]
//    public function move(RequestInterface $request, $id)
//    {
//        $folder = Folder::find($id);
//        $childIds = Db::table('folder_closure')
//            ->where('ancestor', $id)
//            ->pluck('descendant')
//            ->toArray();
//
//        $fileFolderId = $request->input('folder_id');
//        if (in_array($fileFolderId, $childIds)) {
//            return $this->responseService->error('不能移动到其子目录下');
//        }
//
//        $moveFolder = Folder::find($fileFolderId);
//
//        if ($folder->standard_id != $moveFolder->standard_id) {
//            return $this->responseService->error('不能移动到不同标准目录下');
//        }
//
//        $folder->parent_id = $fileFolderId;
//        $folder->save();
//        return $this->responseService->success();
//    }
}
