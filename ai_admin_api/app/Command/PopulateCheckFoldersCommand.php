<?php

declare(strict_types=1);

namespace App\Command;

use Hyperf\Command\Command as HyperfCommand;
use Hyperf\Command\Annotation\Command;
use Hyperf\DbConnection\Db;
use Psr\Container\ContainerInterface;

#[Command]
class PopulateCheckFoldersCommand extends HyperfCommand
{
    public function __construct(protected ContainerInterface $container)
    {
        parent::__construct('populate:check-folders');
    }

    public function configure()
    {
        parent::configure();
        $this->setDescription('Identify leaf folders as audit projects and populate folder_check_files table.');
    }

    public function handle()
    {
        $this->line('Starting refined population of folder_check_files...', 'info');

        // 1. Fetch all folders and build necessary maps
        $allFolders = Db::table('folders')->get();
        $folderMap = [];
        $childrenMap = []; // parent_id => [childId1, childId2, ...]
        
        foreach ($allFolders as $folder) {
            $folderMap[$folder->id] = $folder;
            $childrenMap[$folder->parent_id][] = $folder->id;
        }

        // 2. Clear existing data
        Db::table('folder_check_files')->truncate();
        $this->line('Table folder_check_files truncated.', 'comment');

        // 3. Define Business Logic Helper
        $isYear = function (string $name) {
            return (bool) preg_match('/\d{4}/', $name);
        };

        $getStandardId = function ($folder) use ($folderMap) {
            $current = $folder;
            while ($current) {
                if ($current->standard_id > 0) {
                    return $current->standard_id;
                }
                $current = isset($folderMap[$current->parent_id]) ? $folderMap[$current->parent_id] : null;
            }
            return 0;
        };

        // 4. Identify Projects
        $projects = [];
        foreach ($allFolders as $folder) {
            $subFolderIds = isset($childrenMap[$folder->id]) ? $childrenMap[$folder->id] : [];
            
            $hasSubFolders = count($subFolderIds) > 0;
            $isYearNode = $isYear($folder->name);
            
            $isProject = false;

            // Rule 1: Root folders (parent_id = 0) are NEVER projects (they are top-level categories)
            if ($folder->parent_id > 0) {
                // Rule 2: Exclude specific redundant header folders (IDs 85:进入安全, 89:10.数据管理)
                if (in_array($folder->id, [85, 89])) {
                    continue;
                }
                
                // Fallback name-based blacklist
                if (preg_match('/进入安全|数据管理/ui', $folder->name)) {
                    continue;
                }

                if (!$hasSubFolders) {
                    // Case 1: Leaf node. Must not be a year folder.
                    if (!$isYearNode) {
                        $isProject = true;
                    }
                } else {
                    // Case 2: Has sub-folders. Only a project if ALL sub-folders are years.
                    $hasNonYearChild = false;
                    foreach ($subFolderIds as $childId) {
                        if (!$isYear($folderMap[$childId]->name)) {
                            $hasNonYearChild = true;
                            break;
                        }
                    }
                    
                    if (!$hasNonYearChild) {
                        $isProject = true;
                    }
                }
            }

            if ($isProject) {
                $projects[] = [
                    'folder_name' => $folder->name,
                    'folder_id'   => $folder->id,
                    'standard_id' => $getStandardId($folder),
                    'check_name'  => $folder->name,
                    'check_type'  => 2,
                    'check_text'  => null,
                    'created_at'  => date('Y-m-d H:i:s'),
                    'updated_at'  => date('Y-m-d H:i:s'),
                ];
            }
        }

        // 5. Bulk insert
        if (count($projects) > 0) {
            // Using chunks for large data if necessary
            foreach (array_chunk($projects, 100) as $chunk) {
                Db::table('folder_check_files')->insert($chunk);
            }
        }

        $this->line("Successfully populated " . count($projects) . " refined audit projects.", 'info');
    }
}
