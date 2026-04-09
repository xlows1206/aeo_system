<?php

declare(strict_types=1);

namespace App\Service\Response;

interface ResponseServiceInterface
{
    public function success($data = [], $message = '操作成功', $code = 200);

    public function error(string $message);

    public function download(string $path, string $name);

}
