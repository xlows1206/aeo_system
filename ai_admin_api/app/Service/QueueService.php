<?php

declare(strict_types=1);

namespace App\Service;

use App\Job\GetAiResult;
use Hyperf\AsyncQueue\Driver\DriverFactory;
use Hyperf\AsyncQueue\Driver\DriverInterface;

class QueueService
{
    protected DriverInterface $driver;

    public function __construct(DriverFactory $driverFactory)
    {
        $this->driver = $driverFactory->get('default');
    }

    public function getDrive(): DriverInterface
    {
        return $this->driver;
    }
}
