<?php

declare(strict_types=1);

namespace App\Service;

use Exception;
use Hyperf\Context\ApplicationContext;
use Hyperf\Redis\Redis;
use Psr\Container\ContainerExceptionInterface;
use Psr\Container\NotFoundExceptionInterface;

class RedisService
{
    /**
     * @throws Exception
     */
    public static function make()
    {
        $container = ApplicationContext::getContainer();
        try {
            return $container->get(Redis::class);
        } catch (ContainerExceptionInterface|NotFoundExceptionInterface $e) {
            throw new Exception('缓存模块加载失败', $e->getCode(), $e);
        }
    }
}
