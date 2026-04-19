<?php

declare(strict_types=1);

namespace App\Command;

use Hyperf\Command\Annotation\Command;
use Hyperf\Command\Command as HyperfCommand;
use Hyperf\DbConnection\Db;
use Psr\Container\ContainerInterface;

#[Command]
class RepairFolderClosure extends HyperfCommand
{
    public function __construct(protected ContainerInterface $container)
    {
        parent::__construct('repair:folder-closure');
    }

    public function configure()
    {
        parent::configure();
        $this->setDescription('Repair folder_closure table for Standard 5 and 6');
    }

    public function handle()
    {
        $this->line('Starting closure table repair...', 'info');

        // Fetch folders to repair
        $folders = Db::table('folders')
            ->whereIn('standard_id', [5, 6])
            ->get();

        foreach ($folders as $folder) {
            $this->repair($folder);
        }

        $this->line('Repair completed!', 'success');
    }

    protected function repair($folder)
    {
        $id = $folder->id;
        $parentId = $folder->parent_id;

        $this->line("Processing Folder ID: {$id} - {$folder->name}");

        // 1. Delete all relationship where this folder is a descendant
        Db::table('folder_closure')->where('descendant', $id)->delete();

        // 2. Add self relationship
        Db::table('folder_closure')->insert([
            'ancestor' => $id,
            'descendant' => $id,
            'distance' => 0,
        ]);

        // 3. If has parent, copy parent's ancestors
        if ($parentId > 0) {
            $query = "
                INSERT INTO folder_closure (ancestor, descendant, distance)
                SELECT ancestor, {$id}, distance + 1
                FROM folder_closure
                WHERE descendant = {$parentId}
            ";
            Db::insert($query);
        }
    }
}
