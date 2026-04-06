<?php

declare(strict_types=1);

namespace App\Controller\User;

use App\Controller\BaseController;
use App\Job\ProcessUserBaseData;
use App\Lib\Jwt\Jwt;
use App\Lib\Log;
use App\Model\User;
use App\Request\User\LoginRequest;
use App\Request\User\RegisterRequest;
use App\Service\QueueService;
use Carbon\Carbon;
use Hyperf\Context\ApplicationContext;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Request;

#[Controller(prefix: 'api/v1/user/auth')]
class AuthController extends BaseController
{
    #[Inject]
    private Jwt $jwt;
    protected QueueService $service;


    #[RequestMapping(path: "login", methods: "post")]
    public function login(LoginRequest $request)
    {
        $username = $request->input('username');
        $password = $request->input('password');
        $user = User::where('username', $username)->first();
        if (!password_verify($password, $user->password)) {
            return $this->responseService->error('密码错误');
        }

        $token = $this->jwt->make($user->id);
        $user->login_at = Carbon::now()->toDateTimeString();
        $user->save();

        return $this->responseService->success([
            'token' => $token
        ]);
    }


    #[RequestMapping(path: "register", methods: "post")]
    public function register(RegisterRequest $request)
    {
        $user = new User();
        $user->username = $request->input('username');
        $user->company = $request->input('company');
        $user->password = password_hash($request->input('password'), PASSWORD_BCRYPT);
        $user->standing = 2;
        $user->parent_id = 0;
        $user->master_id = 0;
        $user->save();

        $user->master_id = $user->id;
        $user->save();

        $token = $this->jwt->make($user->id);

//        $this->service->getDrive()->push(new ProcessUserBaseData($user->id));

        return $this->responseService->success([
            'token' => $token
        ]);
    }

    #[RequestMapping(path: "forgotPassword", methods: "post")]
    public function forgotPassword(Request $request)
    {
        $email = $request->input('username');
        $code = $request->input('code');

        $container = ApplicationContext::getContainer();
        $redis = $container->get(\Hyperf\Redis\Redis::class);
        $forgotCode = $redis->get('forgot_code:' . $email);

        if ($code != $forgotCode) {
            return $this->responseService->error('验证码错误');
        }

        $user = User::where('username', $email)->first();
        $user->password = password_hash($request->input('password'), PASSWORD_BCRYPT);
        $user->save();

        return $this->responseService->success();
    }
}
