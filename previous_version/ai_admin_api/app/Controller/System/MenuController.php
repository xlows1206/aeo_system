<?php

declare(strict_types=1);
/**
 * This file is part of Hyperf.
 *
 * @link     https://www.hyperf.io
 * @document https://hyperf.wiki
 * @contact  group@hyperf.io
 * @license  https://github.com/hyperf/hyperf/blob/master/LICENSE
 */

namespace App\Controller\System;

use App\Controller\BaseController;
use App\Model\Permission;
use App\Request\Menu\StoreRequest;
use App\Request\Menu\UpdateRequest;
use Hyperf\DbConnection\Db;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Request;

use function Hyperf\Collection\collect;

#[Controller(prefix: 'api/v1/menu'), Middleware('App\Middleware\UserAuthMiddleware')]
class MenuController extends BaseController
{
    #[RequestMapping(path: 'list', methods: 'get')]
    public function list(Request $request)
    {
        $auth = $request->input('Auth');
        $standing = $auth->standing;
        if ($standing === 1) {
            $lists = Db::table('permissions')
                ->oldest('rank')
                ->oldest('id')
                ->get();
        } else {
            $lists = $auth->getUserPermission();
        }

        $lists = $lists->prepend(collect(['id' => 0, 'name' => '全部', 'parent_id' => 'x']))->toArray();

        return $this->responseService->success(buildTree($lists));
    }

    #[RequestMapping(path: '', methods: 'post')]
    public function store(StoreRequest $request)
    {
        $permission = new Permission();
        $permission->name = $request->input('name');
        $permission->path = $request->input('path');
        $permission->rank = $request->input('rank');
        $permission->parent_id = $request->input('parent_id');
        $permission->save();
        return $this->responseService->success();
    }

    #[RequestMapping(path: '{id}', methods: 'put')]
    public function update(UpdateRequest $request, $id)
    {
        $permission = Permission::find($id);
        $permission->name = $request->input('name');
        $permission->path = $request->input('path');
        $permission->rank = $request->input('rank');
        $permission->save();
        return $this->responseService->success();
    }

    #[RequestMapping(path: '{id}', methods: 'delete')]
    public function destroy($id)
    {
        $permission = Permission::withCount('children')->find($id);
        if (!$permission) {
            return $this->responseService->success();
        }
        if ($permission->children_count > 0) {
            return $this->responseService->error('存在下级菜单，无法删除');
        }
        $permission->delete();
        return $this->responseService->success();
    }

}
