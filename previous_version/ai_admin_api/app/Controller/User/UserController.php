<?php

declare(strict_types=1);

namespace App\Controller\User;

use App\Controller\BaseController;
use App\Job\ProcessUserBaseData;
use App\Model\User;
use App\Request\User\StoreRequest;
use App\Request\User\UpdateRequest;
use App\Resource\UserResource;
use App\Service\QueueService;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Request;

#[Controller(prefix: 'api/v1/user'), Middleware('App\Middleware\UserAuthMiddleware')]
class UserController extends BaseController
{
    #[Inject]
    protected QueueService $service;

    #[RequestMapping(path: "info", methods: "get")]
    public function info(Request $request)
    {
        $user = $request->input('Auth');
        if (!$user) {
            return $this->responseService->success([], '用户未登录', 10042);
        }
        $permissions = $user->getUserPermissionPath();
        $userData = [
            'userId' => $user->id,
            'username' => $user->username,
            'standing' => $user->standing,
            'permissions' => count($permissions) === 0 ? ['_'] : $permissions,
        ];
        return $this->responseService->success($userData);
    }

    #[RequestMapping(path: "", methods: "get")]
    public function index(Request $request)
    {
        $auth = $request->input('Auth');
        $standing = $auth->standing;
        $masterId = $auth->master_id;

        $username = $request->input('username');
        $page = $request->input('page', 1);
        $pageSize = $request->input('pageSize', 10);
        $query = User::when(filled($username), function ($q) use ($username) {
            $q->where('username', 'like', '%' . $username . '%');
        })->where('standing', '>', 1)->when(filled($standing), function ($q) use ($standing, $masterId) {
            if ($standing > 1) {
                // 非管理员
                $q->where('master_id', $masterId);
                $q->where('parent_id', '>', 0);
            }
        });
        $total = $query->count();
        $lists = $query->with(['role', 'master'])->forPage($page, $pageSize)->oldest()->get();
        return $this->responseService->success([
            'list' => UserResource::collection($lists),
            'page' => intval($page),
            'itemCount' => $total,
        ]);
    }

    #[RequestMapping(path: "", methods: "post")]
    public function store(StoreRequest $request)
    {
        $user = new User();

        $standing = $request->input('standing');
        if ($standing == 2) {
            // 主账号, 验证公司名称是否存在
            $company = $request->input('company');
            if (Db::table('users')
                ->where('company', $company)
                ->exists()) {
                return $this->responseService->error('公司名称已经存在');
            }

            $user->company = $request->input('company');
            $user->enterprise = $request->input('enterprise', 1);
        }

        if ($standing == 3) {
            // 子账号，验证主账号是否存在
            $parentId = $request->input('parentId');
            $parentInfo = Db::table('users')
                ->where('id', $parentId)
                ->first();
            if (!$parentInfo) {
                return $this->responseService->error('主账号不存在');
            }
            $user->company = $parentInfo->company;
            $user->parent_id = $parentId;
            $user->master_id = $parentId;
            $user->enterprise = $parentInfo->enterprise;
        }

        $user->username = $request->input('username');
        $user->note = $request->input('note');
        $user->role_id = $request->input('roleId');
        $user->password = password_hash($request->input('password'), PASSWORD_BCRYPT);
        $user->standing = $standing == 3 ? 3 : 2;
        $user->save();

        if ($standing == 2) {
            // 更新主账号
            Db::table('users')->where('id', $user->id)->update(['master_id' => $user->id]);

            // 处理新账号的文件夹范围
//            $this->service->getDrive()->push(new ProcessUserBaseData($user->id));
        }
        return $this->responseService->success();
    }

    #[RequestMapping(path: "{id}", methods: "put")]
    public function update(UpdateRequest $request, $id)
    {
        $user = User::find($id);

        $standing = $request->input('standing');
        $enterprise = $request->input('enterprise', 1);
        if ($standing == 2) {
            // 主账号, 验证公司名称是否存在
            $company = $request->input('company');
            if (Db::table('users')
                ->where('company', $company)
                ->where('id', '<>', $id)
                ->where('master_id', '<>', $user->master_id)
                ->exists()) {
                return $this->responseService->error('公司名称已经存在');
            }

            $user->company = $request->input('company');
            $user->enterprise = $enterprise;
        }

        if ($standing == 3) {
            // 子账号，验证主账号是否存在
            $parentId = $request->input('parentId');
            $parentInfo = Db::table('users')
                ->where('id', $parentId)
                ->first();
            if (!$parentInfo) {
                return $this->responseService->error('主账号不存在');
            }

            $user->company = $parentInfo->company;
            $user->parent_id = $parentId;
            $user->master_id = $parentId;
        }

        $user->username = $request->input('username');
        $user->note = $request->input('note');
        $user->role_id = $request->input('roleId');
        $user->standing = $standing == 3 ? 3 : 2;
        $user->save();
        if ($standing == 2) {
            // 更新子账号的类型
            Db::table('users')->where('master_id', $user->id)->update(['enterprise' => $enterprise]);
        }
        return $this->responseService->success();
    }


    #[RequestMapping(path: "{id}", methods: 'delete')]
    public function destroy($id)
    {
        User::destroy($id);
        return $this->responseService->success();
    }

    #[RequestMapping(path: "{id}/resetPassword", methods: 'patch')]
    public function resetPassword($id)
    {
        $user = User::find($id);
        $user->password = password_hash('a12345678', PASSWORD_BCRYPT);
        $user->save();
        return $this->responseService->success();
    }

    #[RequestMapping(path: "allMaster", methods: 'get')]
    public function allMaster()
    {
        $lists = Db::table('users')
            ->where('parent_id', 0)
            ->where('standing', 2)
            ->get()
            ->map(function ($i) {
                return [
                    'label' => $i->username,
                    'value' => $i->id
                ];
            });
        return $this->responseService->success([
            'lists' => $lists
        ]);
    }
}
