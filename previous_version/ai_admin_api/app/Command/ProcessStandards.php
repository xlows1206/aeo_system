<?php

declare(strict_types=1);

namespace App\Command;

use App\Model\Folder;
use App\Model\Standard;
use Hyperf\Command\Command as HyperfCommand;
use Hyperf\Command\Annotation\Command;
use Hyperf\DbConnection\Db;
use Psr\Container\ContainerInterface;

#[Command]
class ProcessStandards extends HyperfCommand
{
    public function __construct(protected ContainerInterface $container)
    {
        parent::__construct('process:standards');
    }

    public function configure()
    {
        parent::configure();
        $this->setDescription('Hyperf Demo Command');
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

        Db::table('standards')->delete();
        Db::table('folders')->delete();
        Db::table('folder_closure')->delete();
        Db::table('files')->delete();
        Db::table('users')->delete();

        foreach ($standards as $temp) {
            $standard = new Standard();
            $standard->name = $temp['name'];
            $standard->type = 1;
            $standard->component = 'common';
            $standard->save();
        }
    }
}
