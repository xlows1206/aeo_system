<?php

declare(strict_types=1);

namespace App\Lib\Jwt;

use Hyperf\Stringable\Str;
use function Hyperf\Support\env;

class Jwt
{

    function make($userId, $type = 'user', $exp = 86400): string
    {
        $secret = env('JWT_SECRET');
        $payload = [
            'iss' => env('APP_NAME'),
            'sub' => $userId,
            'aud' => $type,
            'iat' => time(),
            'nbf' => time(),
            'exp' => time() + $exp,
            'data' => [
                'random' => Str::random()
            ]
        ];
        return $this->generateJWT($payload, $secret);
    }

    function generateJWT($payload, $secret): string
    {
        $header = ['alg' => 'HS256', 'typ' => 'JWT'];

        $headerEncoded = $this->base64UrlEncode(json_encode($header));
        $payloadEncoded = $this->base64UrlEncode(json_encode($payload));
        $signatureEncoded = $this->sign($header, $payload, $secret);

        return 'Bearer ' . $headerEncoded . '.' . $payloadEncoded . '.' . $signatureEncoded;
    }

    function base64UrlEncode($data): string
    {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    function base64UrlDecode($data): bool|string
    {
        return base64_decode(strtr($data, '-_', '+/'));
    }

    function createSignature($header, $payload, $secret): string
    {
        $headerEncoded = $this->base64UrlEncode(json_encode($header));
        $payloadEncoded = $this->base64UrlEncode(json_encode($payload));
        $data = $headerEncoded . '.' . $payloadEncoded;
        return hash_hmac('sha256', $data, $secret, true);
    }

    function sign($header, $payload, $secret): string
    {
        $signature = $this->createSignature($header, $payload, $secret);
        return $this->base64UrlEncode($signature);
    }

    /**
     * HMAC SHA256签名  https://jwt.io/ 中HMAC SHA256签名实现.
     * @param string $input 为base64UrlEncode(header).".".base64UrlEncode(payload)
     * @param string $alg 算法方式
     * @return string
     */
    function signature(string $input, string $alg = 'HS256'): string
    {
        $key = env('JWT_SECRET');
        $alg_config = [
            'HS256' => 'sha256',
        ];
        return $this->base64UrlEncode(hash_hmac($alg_config[$alg], $input, $key, true));
    }
}