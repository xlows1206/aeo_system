<?php

declare(strict_types=1);

namespace App\Service\Response;

use Hyperf\Di\Annotation\Inject;
use Hyperf\HttpServer\Contract\ResponseInterface;
use Psr\Http\Message\ResponseInterface as Psr7ResponseInterface;

class ResponseService implements ResponseServiceInterface
{
    #[Inject]
    protected ResponseInterface $response;

    public function success($data = [], $message = '操作成功', $code = 200): Psr7ResponseInterface
    {
        return $this->response->json([
            'code' => $code,
            'message' => $message,
            'result' => $data,
        ]);
    }

    public function error(string $message): Psr7ResponseInterface
    {
        return $this->response->json([
            'code' => 400,
            'message' => $message,
        ]);
    }

    public function download(string $path, string $name): Psr7ResponseInterface
    {
        return $this->response->download($path, $name);
    }
}
