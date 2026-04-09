<?php

declare(strict_types=1);

namespace App\Controller\Tool;

use App\Controller\BaseController;
use Hyperf\Context\ApplicationContext;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use PHPMailer\PHPMailer\PHPMailer;

#[Controller(prefix: 'api/v1/tool')]
class ToolController extends BaseController
{
    #[RequestMapping(path: "sendMail", methods: "post")]
    public function sendMail(RequestInterface $request)
    {
        $code = rand(0000, 9999);
        $email = $request->input('email');
        $container = ApplicationContext::getContainer();
        $redis = $container->get(\Hyperf\Redis\Redis::class);
        $redis->setex('forgot_code:' . $email, 300, $code);

        // 实例化 PHPMailer 类
        try {
            $mail = new PHPMailer(true);
            $mail->SMTPDebug = 0;                      // 开启调试输出（0 关闭调试输出）
            $mail->isSMTP();                           // 使用 SMTP 发送邮件
            $mail->Host       = getenv('MAIL_HOST');  // 设置 SMTP 服务器地址
            $mail->SMTPAuth   = true;                  // 启用 SMTP 认证
            $mail->Username   = getenv('MAIL_USERNAME'); // SMTP 用户名（你的邮箱地址）
            $mail->Password   = getenv('MAIL_PASSWORD');   // SMTP 密码（你的邮箱密码）
            $mail->SMTPSecure = 'ssl';                 // 启用 TLS 加密（或 'ssl'）
            $mail->Port       = (int) getenv('MAIL_PORT');                  // SMTP 端口（tls 通常为 587，ssl 通常为 465）
            // 收件人设置
            $mail->setFrom(getenv('MAIL_FROM_ADDRESS'), getenv('MAIL_FROM_NAME')); // 发件人地址和名称
            $mail->addAddress($email); // 添加收件人地址和名称
            // 内容
            $mail->isHTML(true);                        // 将邮件设置为 HTML 格式
            $mail->Subject = '验证码';     // 邮件主题
            $mail->Body    = "您的验证码为 <strong>$code</strong>, 5分钟内有效"; // 邮件正文（HTML 格式）
            $mail->send();
        } catch (\Exception $exception) {
//            var_dump($exception->getMessage());
            return $this->responseService->error('邮件发送失败');
        }

        return $this->responseService->success();
    }
}
