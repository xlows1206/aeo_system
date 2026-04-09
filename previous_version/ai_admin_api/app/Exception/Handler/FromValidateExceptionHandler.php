<?php

declare(strict_types=1);

namespace App\Exception\Handler;

use Hyperf\ExceptionHandler\ExceptionHandler;
use Hyperf\HttpMessage\Stream\SwooleStream;
use Hyperf\Validation\ValidationException;
use Psr\Http\Message\ResponseInterface;
use Throwable;

/**
 * 自定义表单验证异常处理器.
 *
 * Class FromValidateExceptionHandler
 */
class FromValidateExceptionHandler extends ExceptionHandler
{

    public function handle(Throwable $throwable, ResponseInterface $response)
    {
        if ($throwable instanceof ValidationException) {
            $error = $throwable->validator->errors()->first();
            $errorArr = explode('|', $error);
            if (count($errorArr) > 1) {
                $data = json_encode([
                    'code' => 400,
                    'message' => $errorArr[0],
                    'appCode' => $errorArr[1],
                ]);
            } else {
                // 格式化异常数据格式
                $data = json_encode([
                    'code' => 400,
                    'message' => $error,
                ]);
            }

            if (! $response->hasHeader('content-type')) {
                $response = $response
                    ->withAddedHeader('content-type', 'application/json; charset=utf-8');
            }
            $this->stopPropagation();
            return $response->withStatus(200)->withBody(new SwooleStream($data));
        }

        return $response;
    }

    // 异常处理器处理该异常
    public function isValid(Throwable $throwable): bool
    {
        return true;
    }
}
