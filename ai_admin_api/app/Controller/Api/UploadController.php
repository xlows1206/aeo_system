<?php

declare(strict_types=1);

namespace App\Controller\Api;

use App\Controller\BaseController;
use Hyperf\Config\Annotation\Value;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\Middleware;
use Hyperf\HttpServer\Annotation\RequestMapping;
use Hyperf\HttpServer\Contract\RequestInterface;
use Hyperf\Stringable\Str;
use Iidestiny\Flysystem\Oss\OssAdapter;
use function Hyperf\Support\env;

#[Controller(prefix: 'api/v1/upload'), Middleware('App\Middleware\UserAuthMiddleware')]
class UploadController extends BaseController
{
    #[RequestMapping(path: "getUploadToken", methods: "post")]
    public function getUploadToken(RequestInterface $request, \Hyperf\Filesystem\FilesystemFactory $factory)
    {
        $prefix = date('Ymd') . '/images/';
        $accessKeyId = getenv('OSS_ACCESS_KEY');
        $accessKeySecret = getenv('OSS_SECRET_KEY');
        $endpoint = getenv('OSS_ENDPOINT');
        $bucket = getenv('OSS_BUCKET');
        $adapter = new OssAdapter($accessKeyId, $accessKeySecret, $endpoint, $bucket, false, $prefix);
        $config = $adapter->signatureConfig('/', '', [], 60 * 60 * 24 * 365);

        return $this->responseService->success([
            'config' => json_decode($config, true),
            'prefix' => $prefix,
            'host' => env('OSS_HOST'),
            'random' => time() . Str::random(),
        ]);
    }
}
