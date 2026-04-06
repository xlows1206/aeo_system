<?php

declare(strict_types=1);

namespace App\Service;

use Exception;
use Hyperf\Context\ApplicationContext;
use Hyperf\Logger\LoggerFactory;
use Psr\Container\ContainerExceptionInterface;
use Psr\Container\NotFoundExceptionInterface;
use Psr\Log\LoggerInterface;

class LogService
{
    /**
     * @throws Exception
     */
    public static function make(string $name = 'app', string $group = 'common'): LoggerInterface
    {
        try {
            return ApplicationContext::getContainer()->get(LoggerFactory::class)->get($name, $group);
        } catch (ContainerExceptionInterface|NotFoundExceptionInterface $e) {
            throw new Exception('日志模块加载失败', $e->getCode(), $e);
        }
    }
}
