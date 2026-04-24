<?php

declare(strict_types=1);

namespace App\Command;

use App\Model\Folder;
use Hyperf\Command\Command as HyperfCommand;
use Hyperf\Command\Annotation\Command;
use Hyperf\DbConnection\Db;
use Psr\Container\ContainerInterface;
use Symfony\Component\Console\Input\InputOption;

#[Command]
class InitFoldersCommand extends HyperfCommand
{
    public function __construct(protected ContainerInterface $container)
    {
        parent::__construct('folder:init');
    }

    public function configure()
    {
        parent::configure();
        $this->setDescription('Initialize folder structure from templates (master_id=0) for all companies');
        $this->addOption('master_id', 'm', InputOption::VALUE_OPTIONAL, 'Specific master_id to initialize');
        $this->addOption('force', 'f', InputOption::VALUE_NONE, 'Force re-initialize even if folders exist');
    }

    public function handle()
    {
        $targetMasterId = $this->input->getOption('master_id');
        $force = $this->input->getOption('force');

        if ($targetMasterId) {
            $masterIds = [$targetMasterId];
        } else {
            // 获取所有主账号 ID
            $masterIds = Db::table('users')->where('parent_id', 0)->pluck('master_id')->toArray();
        }

        foreach ($masterIds as $masterId) {
            if ($masterId == 0) continue;

            $this->line("Initializing master_id: {$masterId}...");

            // 检查是否已有文件夹
            $exists = Folder::where('master_id', $masterId)->exists();
            if ($exists && !$force) {
                $this->warn("Master ID {$masterId} already has folders. Use --force to re-init.");
                continue;
            }

            $this->cloneFromTemplate((int)$masterId, (bool)$force);
            $this->info("Master ID {$masterId} initialized successfully.");
        }

        $this->info("All tasks completed. Please run 'redis-cli flushall' to refresh cache.");
    }

    private function cloneFromTemplate(int $masterId, bool $force = false)
    {
        /** @var \App\Service\FolderService $service */
        $service = $this->container->get(\App\Service\FolderService::class);
        $service->initFromTemplate($masterId, $force);
    }
}
