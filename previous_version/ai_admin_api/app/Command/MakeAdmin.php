<?php

declare(strict_types=1);

namespace App\Command;

use App\Job\ProcessUserBaseData;
use App\Model\User;
use App\Service\QueueService;
use Hyperf\Command\Command as HyperfCommand;
use Hyperf\Command\Annotation\Command;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;
use Psr\Container\ContainerInterface;

#[Command]
class MakeAdmin extends HyperfCommand
{
    #[Inject]
    protected QueueService $service;

    public function __construct(protected ContainerInterface $container)
    {
        parent::__construct('make:admin');
    }

    public function configure()
    {
        parent::configure();
        $this->setDescription('make a admin account');
    }

    public function handle()
    {
        $user = new User();
        $user->username = '18171389893';
        $user->password = password_hash('123456', PASSWORD_BCRYPT);
        $user->standing = 1;
        $user->master_id = 0;
        $user->save();
        Db::table('users')->where('id', $user->id)->update(['master_id' => $user->id]);
        $this->service->getDrive()->push(new ProcessUserBaseData($user->id));
    }
}
