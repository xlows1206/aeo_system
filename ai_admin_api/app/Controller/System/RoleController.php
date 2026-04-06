<?php

declare(strict_types=1);

namespace App\Controller\System;

use App\Controller\BaseController;
use App\Model\Role;
use App\Request\Role\StoreRequest;
use App\Request\Role\UpdateRequest;
use Hyperf\DbConnection\Db;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Request;

#[Controller(prefix: 'api/v1/role'), Middleware('App\Middleware\UserAuthMiddleware')]
class RoleController extends BaseController
{
    #[RequestMapping(path: '', methods: 'get')]
    public function index(Request $request)
    {
        $auth = $request->input('Auth');
        $standing = $auth->standing;
        $masterId = $auth->master_id;

        $page = $request->input('page', 1);
        $size = $request->input('pageSize', 10);
        $name = $request->input('name');
        $query = Role::when(filled($name), function ($q) use ($name) {
            $q->where('name', 'like', "%$name%");
        })->when(filled($standing), function ($q) use ($standing, $masterId) {
            if ($standing > 1) {
                $q->where('master_id', $masterId);
            } else {
                $q->where('master_id', 0);
            }
        });

        $total = $query->count();
        $lists = $query->with('permissions')->with('standards')->forPage($page, $size)->get()->map(function ($i) {
            return [
                'id' => $i->id,
                'name' => $i->name,
                'note' => $i->note,
                'permissionsIds' => $i->permissions->pluck('id')->toArray(),
                'standardsIds' => $i->standards->pluck('id')->toArray(),
                'updated_at' => $i->updated_at->toDateTimeString()
            ];
        });
        return $this->responseService->success([
            'list' => $lists,
            'page' => intval($page),
            'itemCount' => $total,
        ]);
    }

    #[RequestMapping(path: '', methods: 'post')]
    public function store(StoreRequest $request)
    {
        $user = $request->getParsedBody()['Auth'];

        $name = $request->input('name');
        if ($user->standing === 1) {
            // 管理员
            $masterId = 0;
        } else {
            $masterId = $user->master_id;
        }

        if (Db::table('roles')
            ->where('master_id', $masterId)
            ->where('name', $name)
            ->exists()) {
            return $this->responseService->error('名称已存在');
        }

        $role = new Role();
        $role->user_id = $user->standing == 1 ? 0 : $user->id;
        $role->master_id = $user->standing == 1 ? 0 : $user->master_id;
        $role->name = $name;
        $role->note = $request->input('note');
        $role->save();

        $role->permissions()->attach($request->input('permissions'));

//        $standards = $request->input('standards');
//        foreach ($standards as $index => $standard) {
//            if (is_string($standard)) {
//                unset($standards[$index]);
//            }
//        }
//        $role->standards()->attach(array_values($standards));

        return $this->responseService->success();
    }

    #[RequestMapping(path: '{id}', methods: 'put')]
    public function update(UpdateRequest $request, $id)
    {
        $user = $request->getParsedBody()['Auth'];
        $name = $request->input('name');
        if ($user->standing === 1) {
            // 管理员
            $masterId = 0;
        } else {
            $masterId = $user->master_id;
        }

        if (Db::table('roles')
            ->where('master_id', $masterId)
            ->where('name', $name)
            ->where('id', '<>', $id)
            ->exists()) {
            return $this->responseService->error('名称已存在');
        }

        $role = Role::find($id);
        $role->name = $request->input('name');
        $role->note = $request->input('note');
        $role->save();

        $role->permissions()->sync($request->input('permissions'));

//        $standards = $request->input('standards');
//        foreach ($standards as $index => $standard) {
//            if (is_string($standard)) {
//                unset($standards[$index]);
//            }
//        }
//        $role->standards()->sync(array_values($standards));

        return $this->responseService->success();
    }

    #[RequestMapping(path: '{id}', methods: 'delete')]
    public function destroy($id)
    {
        Role::destroy($id);
        return $this->responseService->success();
    }

    #[RequestMapping(path: 'all', methods: 'get')]
    public function all(Request $request)
    {
        $auth = $request->input('Auth');
        $standing = $auth->standing;
        $masterId = $auth->master_id;

        $lists = Db::table('roles')
            ->when(filled($standing), function ($q) use ($standing, $masterId) {
                if ($standing > 1) {
                    $q->where('master_id', $masterId);
                } else {
                    $q->where('master_id', 0);
                }
            })
            ->get()
            ->map(function ($i) {
                return [
                    'label' => $i->name,
                    'value' => $i->id,
                ];
            });
        return $this->responseService->success([
            'lists' => $lists
        ]);
    }
}
