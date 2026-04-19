<?php

declare(strict_types=1);

namespace App\Middleware;

use App\Lib\Jwt\Jwt;
use App\Model\User;
use Hyperf\HttpServer\Contract\ResponseInterface as HttpResponse;
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

class UserAuthMiddleware implements MiddlewareInterface
{
    protected HttpResponse $response;
    protected ContainerInterface $container;

    public function __construct(ContainerInterface $container, HttpResponse $response)
    {
        $this->container = $container;
        $this->response = $response;
    }

    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        $request_uri = $request->getServerParams()['request_uri'];
        if (in_array($request_uri, ["/api/v1/file/projects/all"])) {
            return $handler->handle($request);
        }

        $authorization = $request->getHeader('authorization')[0] ?? '';
        $tokens = explode('.', $authorization);

        if (count($tokens) != 3) {
            return $this->err('验证失败，请重新登录');
        }

        [$base64header, $base64payload, $sign] = $tokens;

        $jwt = new Jwt();

        $base64header = substr($base64header, 7);
        $base64DecodeHeader = json_decode($jwt->base64UrlDecode($base64header), true);
        if (empty($base64DecodeHeader['alg'])) {
            return $this->err('验证失败，请重新登录');
        }

        if ($jwt->signature($base64header . '.' . $base64payload, $base64DecodeHeader['alg']) !== $sign) {
            return $this->err('验证失败，请重新登录');
        }
        $payload = json_decode($jwt->base64UrlDecode($base64payload), true);

        // 签发时间大于当前服务器时间验证失败
        if (isset($payload['iat']) && $payload['iat'] > time()) {
            return $this->err('验证失败，请重新登录');
        }

        $userId = $payload['sub'];

        $user = User::where('id', $userId)->first();

        $parsedBody = $request->getParsedBody();
        if (is_object($parsedBody)) {
            $parsedBody = (array) $parsedBody;
        } elseif (!is_array($parsedBody)) {
            $parsedBody = [];
        }

        return $handler->handle($request->withParsedBody(
            array_merge($parsedBody, ['Auth' => $user])
        ));
    }

    /**
     * @param $err
     * @return ResponseInterface
     */
    public function err($err): ResponseInterface
    {
        return $this->response->json([
            'code' => 10042,
            'message' => $err,
        ])->withStatus(200);
    }
}
