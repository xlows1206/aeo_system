<?php
declare(strict_types=1);
namespace App\Command;
use Hyperf\Command\Command as HyperfCommand;
use Hyperf\Command\Annotation\Command;
use Hyperf\DbConnection\Db;
use Psr\Container\ContainerInterface;

#[Command]
class TestCheck extends HyperfCommand
{
    public function __construct(protected ContainerInterface $container)
    {
        parent::__construct('test:check');
    }
    public function handle()
    {
        $projects = Db::table('folder_check_files as fcf')
            ->leftJoin('folders as f', 'f.id', '=', 'fcf.folder_id')
            ->leftJoin('folders as p', 'p.id', '=', 'f.parent_id')
            ->where('fcf.standard_id', 6)
            ->select('f.*', 'p.name as parent_name')
            ->get();
        foreach ($projects as $f) {
            echo "ID: f{$f->id}, Name: {$f->name}, ParentName: {$f->parent_name}\n";
        }
    }
}
