<?php

declare(strict_types=1);

namespace App\Job;

use App\Model\Folder;
use App\Model\Standard;
use Hyperf\AsyncQueue\Job;
use Hyperf\DbConnection\Db;

class ProcessUserBaseData extends Job
{
    protected mixed $userId;

    public function __construct($userId)
    {
        $this->userId = $userId;
    }

    public function handle()
    {
        /** @var \App\Service\FolderService $service */
        $service = \Hyperf\Context\ApplicationContext::getContainer()->get(\App\Service\FolderService::class);
        
        $service->initFromTemplate((int)$this->userId);
    }
}
