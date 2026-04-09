<?php

declare(strict_types=1);

namespace App\Controller\System;

use App\Controller\BaseController;
use App\Model\Article;
use App\Model\ArticleCategory;
use App\Model\Role;
use App\Model\User;
use App\Request\Role\StoreRequest;
use App\Request\Role\UpdateRequest;
use Hyperf\DbConnection\Db;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Request;

#[Controller(prefix: 'api/v1/admin/administrator'), Middleware('App\Middleware\UserAuthMiddleware')]
class AdministratorController extends BaseController
{
    #[RequestMapping(path: 'updatePassword', methods: 'put')]
    public function updatePassword(Request $request)
    {
        $username = trim($request->input('username'));
        $password = $request->input('password');
        $auth = $request->input('Auth');
        $master_id = $auth->master_id;
        $standing = $auth->standing;

        if ($standing === 1) {
            $user = User::where('username', $username)->first();
        } else {
            $user = User::where('username', $username)->where('master_id', $master_id)->first();
        }
        if ($user) {
            $user->password = password_hash($password, PASSWORD_BCRYPT);
            $user->save();
            return $this->responseService->success();
        }
        return $this->responseService->error("用户不存在");
    }
}
