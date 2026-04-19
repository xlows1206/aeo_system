<?php

declare(strict_types=1);

use Hyperf\Database\Migrations\Migration;
use Hyperf\DbConnection\Db;

return new class extends Migration
{
    public function up(): void
    {
        $now = date('Y-m-d H:i:s');

        Db::table('folders')
            ->where(function ($query) {
                $query->where('id', 129)
                    ->orWhere('name', '6-16&17&18')
                    ->orWhere('name', '报关单处罚合规');
            })
            ->update([
                'name' => '报关单行政处罚合规',
                'updated_at' => $now,
            ]);

        Db::table('folder_check_files')
            ->where(function ($query) {
                $query->where('folder_id', 129)
                    ->orWhere('folder_name', '遵守法律法规 - 报关单处罚合规')
                    ->orWhere('check_name', '遵守法律法规 - 报关单处罚合规')
                    ->orWhere('folder_name', '遵守法律法规 - 报关单行政处罚合规')
                    ->orWhere('check_name', '遵守法律法规 - 报关单行政处罚合规');
            })
            ->update([
                'folder_name' => '遵守法律法规 - 报关单行政处罚合规',
                'check_name' => '遵守法律法规 - 报关单行政处罚合规',
                'updated_at' => $now,
            ]);
    }

    public function down(): void
    {
        $now = date('Y-m-d H:i:s');

        Db::table('folders')
            ->where(function ($query) {
                $query->where('id', 129)
                    ->orWhere('name', '报关单行政处罚合规');
            })
            ->update([
                'name' => '6-16&17&18',
                'updated_at' => $now,
            ]);

        Db::table('folder_check_files')
            ->where(function ($query) {
                $query->where('folder_id', 129)
                    ->orWhere('folder_name', '遵守法律法规 - 报关单行政处罚合规')
                    ->orWhere('check_name', '遵守法律法规 - 报关单行政处罚合规');
            })
            ->update([
                'folder_name' => '遵守法律法规 - 报关单处罚合规',
                'check_name' => '遵守法律法规 - 报关单处罚合规',
                'updated_at' => $now,
            ]);
    }
};
