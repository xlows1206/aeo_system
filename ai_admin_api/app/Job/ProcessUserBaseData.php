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
        $standards = [
            [
                'name' => '财务',
                'folders' => [
                    '会计信息',
                    '综合财务状况',
                ]
            ],
            [
                'name' => '人事',
                'folders' => [
                    '内部组织结构',
                    '人员安全',
                ]
            ],
            [
                'name' => '行政',
                'folders' => [
                    '信息系统',
                    '数据管理',
                    '场所安全',
                    '进入安全',
                    '安全培训',
                ]
            ],
            [
                'name' => '关务',
                'folders' => [
                    '海关业务培训',
                    '单证控制',
                    '单证保管',
                    '进出口控制',
                    '质量管理',
                ]
            ],
            [
                'name' => '审计部',
                'folders' => [
                    '内审制度',
                    '改进机制',
                    '信息安全',
                    '守法规范',
                    '商业伙伴安全',
                    '货物、物品安全',
                    '集装箱安全',
                    '运输工具安全',
                    '危机管理',
                ]
            ]
        ];
        foreach ($standards as $temp) {
            $standard_id = Db::table('standards')
                ->where('name', $temp['name'])
                ->value('id');
            if (!$standard_id) {
                $standard = new Standard();
                $standard->name = $temp['name'];
                $standard->type = 1;
                $standard->component = 'common';
                $standard->save();
                $standard_id = $standard->id;
            }

            foreach ($temp['folders'] as $folderName) {
                $folder = new Folder();
                $folder->name = $folderName;
                $folder->standard_id = $standard_id;
                $folder->user_id = $this->userId;
                $folder->master_id = $this->userId;
                $folder->parent_id = 0;
                $folder->save();
            }
        }
    }
}
