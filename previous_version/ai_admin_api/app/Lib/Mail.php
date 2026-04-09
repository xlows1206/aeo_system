<?php
declare(strict_types=1);

namespace App\Lib;

use App\Exception\HslException;

class Mail
{
    function smtp_mail($to, $subject, $message, $smtp_host, $smtp_port, $smtp_user, $smtp_pass, $headers = '')
    {
// 连接到 SMTP 服务器
        $smtp_conn = fsockopen($smtp_host, $smtp_port, $errno, $errstr, 30);
        var_dump($errstr);
        var_dump($errno);
        var_dump(!$smtp_conn);
        if (!$smtp_conn) {
            throw new HslException("连接到 SMTP 服务器失败: $errstr ($errno)");
        }

        var_dump("连接成功，资源类型: " . get_resource_type($smtp_conn));
// 读取服务器响应
        $response = fgets($smtp_conn, 515);
        var_dump($response);
        if (substr($response, 0, 3) != '220') {
            throw new HslException("服务器响应错误: $response");
        }

// 发送 HELO 命令
        fwrite($smtp_conn, "HELO " . gethostname() . "\r\n");
        $response = fgets($smtp_conn, 515);
        if (substr($response, 0, 3) != '250') {
            throw new HslException("HELO 命令发送失败: $response");
        }

// 启用身份验证
        fwrite($smtp_conn, "AUTH LOGIN\r\n");
        $response = fgets($smtp_conn, 515);
        if (substr($response, 0, 3) != '334') {
            throw new HslException("AUTH LOGIN 命令发送失败: $response");
        }

// 发送用户名
        fwrite($smtp_conn, base64_encode($smtp_user) . "\r\n");
        $response = fgets($smtp_conn, 515);
        if (substr($response, 0, 3) != '334') {
            throw new HslException("用户名发送失败: $response");
        }

// 发送密码
        fwrite($smtp_conn, base64_encode($smtp_pass) . "\r\n");
        $response = fgets($smtp_conn, 515);
        if (substr($response, 0, 3) != '235') {
            throw new HslException("密码发送失败: $response");
        }

// 发送 MAIL FROM 命令
        fwrite($smtp_conn, "MAIL FROM: <$smtp_user>\r\n");
        $response = fgets($smtp_conn, 515);
        if (substr($response, 0, 3) != '250') {
            throw new HslException("MAIL FROM 命令发送失败: $response");
        }

// 发送 RCPT TO 命令
        fwrite($smtp_conn, "RCPT TO: <$to>\r\n");
        $response = fgets($smtp_conn, 515);
        if (substr($response, 0, 3) != '250') {
            throw new HslException("RCPT TO 命令发送失败: $response");
        }

// 发送 DATA 命令
        fwrite($smtp_conn, "DATA\r\n");
        $response = fgets($smtp_conn, 515);
        if (substr($response, 0, 3) != '354') {
            throw new HslException("DATA 命令发送失败: $response");
        }

// 发送邮件内容
        $headers .= "To: <$to>\r\n";
        $headers .= "Subject: $subject\r\n";
        fwrite($smtp_conn, "$headers\r\n$message\r\n.\r\n");
        var_dump($smtp_conn, "$headers\r\n$message\r\n.\r\n");
        $response = fgets($smtp_conn, 515);
        if (substr($response, 0, 3) != '250') {
            throw new HslException("邮件发送失败: $response");
        }

// 发送 QUIT 命令
        fwrite($smtp_conn, "QUIT\r\n");
        fclose($smtp_conn);
        return true;
    }

}