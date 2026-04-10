<?php

declare(strict_types=1);

namespace App\Command;

use App\Service\LogService;
use App\Service\RedisService;
use Hyperf\Collection\Arr;
use Hyperf\Command\Command as HyperfCommand;
use Hyperf\Command\Annotation\Command;
use Hyperf\DbConnection\Db;
use Hyperf\Di\Annotation\Inject;
use League\Flysystem\Filesystem;
use Psr\Container\ContainerInterface;
use function Symfony\Component\String\b;

#[Command]
class TestCheck extends HyperfCommand
{
    #[Inject]
    protected RedisService $redisService;

    #[Inject]
    protected LogService $logService;

    protected int $pre_audit_id = 5;
    protected int $number = 1;

    public function __construct(protected ContainerInterface $container)
    {
        parent::__construct('test:check');
    }

    public function configure()
    {
        parent::configure();
    }

    public function handle()
    {
        // 5-13 审计报告: result 为true
        // 5-14 资产负债率情况: liability / liability_equity > 0.95 则不通过
        // 3-7-1 系统操作手册: result 为true
        // 3-8-1 制度: result 为true
        // 3-9-1 制度: result 为true
        // 1-2 岗位职责 ： result 为true
        // 1-1 关企联系合作机制 ： result 为true
        // 2-3-1 制度 ： result 为true
        // 2-4-1 单位归档制度 ： result 为true
        // 2-5-1 禁止类产品合规审查制度 ： result 为true
        // 6-16&17&18 ： penalty_amount > 5.0 则不通过
        // 6-15-2 无犯罪记录证明。需要检查企业人员是否全部无犯罪证明

        $keys = $this->redisService->make()->lRange('ai_result:' . $this->pre_audit_id . ':keys', 0, -1);

        $labels = [];
        foreach ($keys as $key) {
            $keyItem = explode(':', $key);
            $label = $keyItem[2];
            $labels[$label][] = $key;
        }


        $masterId = Db::table('pre_audits')
            ->where('id', $this->pre_audit_id)
            ->value('master_id');

        $companyInfo = Db::table('company_info')->where('master_id', $masterId)->first();

        $companyPersonName = [$companyInfo?->enterprise_person_name, $companyInfo?->principal_person_name, $companyInfo?->financial_person_name, $companyInfo?->customs_person_name];
        $companyPersonName = array_values(array_filter($companyPersonName));
        // 根据设置的起止年份算出年份
        $start_year = $companyInfo?->start_year ?? 0;
        $end_year = $companyInfo?->end_year ?? 0;
        $duration_years = [];
        if ($start_year > 0 && $end_year > 0 && $start_year <= $end_year) {
            for ($y = $start_year; $y <= $end_year; $y++) {
                $duration_years[] = (string) $y;
            }
        }


        $res5_13 = [];
        $res5_14 = [];
        $res3_7_1 = [];
        $res3_8_1 = [];
        $res3_9_1 = [];
        $res1_2 = [];
        $res1_1 = [];
        $res2_3_1 = [];
        $res2_4_1 = [];
        $res2_5_1 = [];
        $res6_161718 = [];
        $res6_15_2 = [];

        foreach ($labels as $label => $keys) {
            switch ($label) {
                case '5-13 审计报告':
                    // 判断是否存在有true的，存在则通过
                    $results = $this->redisService->make()->pipeline(function ($pipe) use ($keys) {
                        foreach ($keys as $key) {
                            $pipe->get($key);
                        }
                    });

                    $years = [];
                    foreach ($results as $result) {
                        $result = json_decode($result, true);
                        if (isset($result['year'])) {
                            $years[$result['year']][] = $result['result'];
                        }
                    }

                    if (count($duration_years) == 0) {
                        $res5_13 = [
                            'result' => false,
                            'data' => ['未设置公司存续年份, 无法进行审计报告检查.'],
                        ];
                        break;
                    }

                    foreach ($duration_years as $duration_year) {
                        if (isset($years[$duration_year])) {
                            if (in_array(true, $years[$duration_year])) {
                                continue;
                            } else {
                                $res5_13[] = $duration_year . '年度审计报告未通过, 不存在相关信息';
                            }
                        } else {
                            $res5_13[] = $duration_year . '年度审计报告未通过, 未找到对应文件';
                        }
                    }

                    if (count($res5_13) > 0) {
                        //结果为不合格
                        $res5_13 = [
                            'result' => false,
                            'data' => $res5_13,
                        ];
                    } else {
                        //结果为合格
                        $res5_13 = [
                            'result' => true,
                            'data' => []
                        ];
                    }
                    break;
                case '5-14 资产负债率情况':
                    $results = $this->redisService->make()->pipeline(function ($pipe) use ($keys) {
                        foreach ($keys as $key) {
                            $pipe->get($key);
                        }
                    });

                    $years = [];
                    foreach ($results as $result) {
                        $result = json_decode($result, true);
                        if (isset($result['year'])) {
                            $years[$result['year']][] = $result;
                        }
                    }

                    if (count($duration_years) == 0) {
                        $res5_14 = [
                            'result' => false,
                            'data' => ['未设置公司存续年份, 无法进行审计报告检查.'],
                        ];
                        break;
                    }

                    foreach ($duration_years as $duration_year) {
                        if (isset($years[$duration_year])) {
                            $results = $years[$duration_year];
                            // 如果 liability 和 liability_equity 都存在，则认为有效
                            $liability_equity = 0;
                            $liability = 0;
                            foreach ($results as $result) {
                                $liabilityItem = $result['liability'];
                                $liability_equityItem = $result['liability_equity'];
                                if ($liabilityItem > 0 && $liability_equityItem > 0) {
                                    $liability = str_replace(',', '', $liabilityItem);
                                    $liability_equity = str_replace(',', '', $liability_equityItem);
                                }
                            }

                            if ($liability == 0 && $liability_equity == 0) {
                                // 未读取有效信息
                                $res5_14[] = $duration_year . '年度资产负债率未读取有效信息';
                            } else {
                                $ratio = bcdiv($liability, $liability_equity, 2);
                                if ($ratio > 0.95) {
                                    // 不合格
                                    $res5_14[] = $duration_year . '年度资产负债率不合格, 负债率为' . $ratio * 100 . '%';
                                }
                            }
                        } else {
                            $res5_14[] = $duration_year . '年度资产负债率未读取有效信息';
                        }
                    }

                    if (count($res5_14) > 0) {
                        //结果为不合格
                        $res5_14 = [
                            'result' => false,
                            'data' => $res5_14,
                        ];
                    } else {
                        //结果为合格
                        $res5_14 = [
                            'result' => true,
                            'data' => []
                        ];
                    }
                    break;
                case '3-7-1 系统操作手册' :
                    $results = $this->redisService->make()->pipeline(function ($pipe) use ($keys) {
                        foreach ($keys as $key) {
                            $pipe->get($key);
                        }
                    });

                    foreach ($results as $result) {
                        $result = json_decode($result, true);
                        if (!$result['result']) {
                            $res3_7_1[] = '《' . $result['file_name'] . '》系统操作手册未通过, 请检查.';
                        }
                    }

                    if (count($res3_7_1) > 0) {
                        //结果为不合格
                        $res3_7_1 = [
                            'result' => false,
                            'data' => $res3_7_1
                        ];
                    } else {
                        //结果为合格
                        $res3_7_1 = [
                            'result' => true,
                            'data' => []
                        ];
                    }
                    break;
                case '3-8-1 制度' :
                    $results = $this->redisService->make()->pipeline(function ($pipe) use ($keys) {
                        foreach ($keys as $key) {
                            $pipe->get($key);
                        }
                    });

                    foreach ($results as $result) {
                        $result = json_decode($result, true);
                        if (!$result['result']) {
                            $res3_8_1[] = '《' . $result['file_name'] . '》制度未通过, 请检查.';
                        }
                    }

                    if (count($res3_8_1) > 0) {
                        //结果为不合格
                        $res3_8_1 = [
                            'result' => false,
                            'data' => $res3_8_1
                        ];
                    } else {
                        //结果为合格
                        $res3_8_1 = [
                            'result' => true,
                            'data' => []
                        ];
                    }
                    break;
                case '3-9-1 制度' :
                    $results = $this->redisService->make()->pipeline(function ($pipe) use ($keys) {
                        foreach ($keys as $key) {
                            $pipe->get($key);
                        }
                    });

                    foreach ($results as $result) {
                        $result = json_decode($result, true);
                        if (!$result['result']) {
                            $res3_9_1[] = '《' . $result['file_name'] . '》制度未通过, 请检查.';
                        }
                    }

                    if (count($res3_9_1) > 0) {
                        //结果为不合格
                        $res3_9_1 = [
                            'result' => false,
                            'data' => $res3_9_1
                        ];
                    } else {
                        //结果为合格
                        $res3_9_1 = [
                            'result' => true,
                            'data' => []
                        ];
                    }
                    break;
                case '1-2 岗位职责' :
                    $results = $this->redisService->make()->pipeline(function ($pipe) use ($keys) {
                        foreach ($keys as $key) {
                            $pipe->get($key);
                        }
                    });

                    foreach ($results as $result) {
                        $result = json_decode($result, true);
                        if (!$result['result']) {
                            $res1_2[] = '《' . $result['file_name'] . '》岗位职责未通过, 请检查.';
                        }
                    }

                    if (count($res1_2) > 0) {
                        //结果为不合格
                        $res1_2 = [
                            'result' => false,
                            'data' => $res1_2
                        ];
                    } else {
                        //结果为合格
                        $res1_2 = [
                            'result' => true,
                            'data' => []
                        ];
                    }
                    break;
                case '1-1 关企联系合作机制' :
                    $results = $this->redisService->make()->pipeline(function ($pipe) use ($keys) {
                        foreach ($keys as $key) {
                            $pipe->get($key);
                        }
                    });

                    foreach ($results as $result) {
                        $result = json_decode($result, true);
                        if (!$result['result']) {
                            $res1_1[] = '《' . $result['file_name'] . '》关企联系合作机制未通过, 请检查.';
                        }
                    }

                    if (count($res1_1) > 0) {
                        //结果为不合格
                        $res1_1 = [
                            'result' => false,
                            'data' => $res1_1
                        ];
                    } else {
                        //结果为合格
                        $res1_1 = [
                            'result' => true,
                            'data' => []
                        ];
                    }
                    break;
                case '2-3-1 制度' :
                    $results = $this->redisService->make()->pipeline(function ($pipe) use ($keys) {
                        foreach ($keys as $key) {
                            $pipe->get($key);
                        }
                    });

                    foreach ($results as $result) {
                        $result = json_decode($result, true);
                        if (!$result['result']) {
                            $res2_3_1[] = '《' . $result['file_name'] . '》制度未通过, 请检查.';
                        }
                    }

                    if (count($res2_3_1) > 0) {
                        //结果为不合格
                        $res2_3_1 = [
                            'result' => false,
                            'data' => $res2_3_1
                        ];
                    } else {
                        //结果为合格
                        $res2_3_1 = [
                            'result' => true,
                            'data' => []
                        ];
                    }
                    break;
                case '2-4-1 单位归档制度' :
                    $results = $this->redisService->make()->pipeline(function ($pipe) use ($keys) {
                        foreach ($keys as $key) {
                            $pipe->get($key);
                        }
                    });
                    foreach ($results as $result) {
                        $result = json_decode($result, true);
                        if (!$result['result']) {
                            $res2_4_1[] = '《' . $result['file_name'] . '》单位归档制度未通过, 请检查.';
                        }
                    }

                    if (count($res2_4_1) > 0) {
                        //结果为不合格
                        $res2_4_1 = [
                            'result' => false,
                            'data' => $res2_4_1
                        ];
                    } else {
                        //结果为合格
                        $res2_4_1 = [
                            'result' => true,
                            'data' => []
                        ];
                    }
                    break;
                case '2-5-1 禁止类产品合规审查制度' :
                    $results = $this->redisService->make()->pipeline(function ($pipe) use ($keys) {
                        foreach ($keys as $key) {
                            $pipe->get($key);
                        }
                    });

                    foreach ($results as $result) {
                        $result = json_decode($result, true);
                        if (!$result['result']) {
                            $res2_5_1[] = '《' . $result['file_name'] . '》禁止类产品合规审查制度未通过, 请检查.';
                        }
                    }

                    if (count($res2_5_1) > 0) {
                        //结果为不合格
                        $res2_5_1 = [
                            'result' => false,
                            'data' => $res2_5_1
                        ];
                    } else {
                        //结果为合格
                        $res2_5_1 = [
                            'result' => true,
                            'data' => []
                        ];
                    }
                    break;
                case '6-16&17&18' :
                    $results = $this->redisService->make()->pipeline(function ($pipe) use ($keys) {
                        foreach ($keys as $key) {
                            $pipe->get($key);
                        }
                    });

                    $penalty_amount = '0';
                    foreach ($results as $result) {
                        $result = json_decode($result, true);
                        $penalty_amount = bcadd($penalty_amount, $result['penalty_amount'], 2);
                    }

                    if ($penalty_amount > '5.0') {
                        $res6_161718 = [
                            'result' => false,
                            'data' => '6-16&17&18 存在违规记录, 处罚金额为' . $penalty_amount . '元, 超过5.0元, 请检查.'
                        ];
                    } else {
                        $res6_161718 = [
                            'result' => true,
                            'data' => []
                        ];
                    }
                    break;
                case '6-15-2 无犯罪记录证明' :
                    $results = $this->redisService->make()->pipeline(function ($pipe) use ($keys) {
                        foreach ($keys as $key) {
                            $pipe->get($key);
                        }
                    });

                    $allPersons = [];
                    foreach ($results as $result) {
                        $result = json_decode($result, true);
                        foreach ($result as $value) {
                            $allPersons[] = $value['name'];
                        }

                    }

                    if (count($companyPersonName) < 4) {
                        $res6_15_2 = [
                            'result' => false,
                            'data' => [
                                '无犯罪记录证明验证失败，未设置公司主要负责人信息'
                            ],
                        ];
                        break;
                    }

                    // 跟公司主要人取差，如果存在差集，则不合格
                    $diffPersons = array_diff($companyPersonName, $allPersons);
                    if (count($diffPersons) > 0) {
                        $res6_15_2 = [
                            'result' => false,
                            'data' => implode('、', $diffPersons) . ' 未提供无犯罪记录证明, 请检查.'
                        ];
                    } else {
                        $res6_15_2 = [
                            'result' => true,
                            'data' => []
                        ];
                    }
                    break;
                default:
                    break;
            }
        }


        // 检查结果
        $aiResult = [];
        // 5-13 审计报告
        $result_5_13 = $res5_13['result'] ?? false;
        if (!$result_5_13) {
            $aiResult[] = $res5_13['data'] ?? ['未提交5-13 审计报告相关资料，审核失败'];
        }
        //5-14 资产负债率情况
        $result_5_14 = $res5_14['result'] ?? false;
        if (!$result_5_14) {
            $aiResult[] = $res5_14['data'] ?? ['未提交5-14 资产负债率情况相关资料，审核失败'];
        }
        //3-7-1 系统操作手册
        $result_3_7_1 = $res3_7_1['result'] ?? false;
        if (!$result_3_7_1) {
            $aiResult[] = $res3_7_1['data'] ?? ['未提交3-7-1 系统操作手册相关资料，审核失败'];
        }
        //3-8-1 制度
        $result_3_8_1 = $res3_8_1['result'] ?? false;
        if (!$result_3_8_1) {
            $aiResult[] = $res3_8_1['data'] ?? ['未提交3-8-1 制度相关资料，审核失败'];
        }
        //3-9-1 制度
        $result_3_9_1 = $res3_9_1['result'] ?? false;
        if (!$result_3_9_1) {
            $aiResult[] = $res3_9_1['data'] ?? ['未提交3-9-1 制度相关资料，审核失败'];
        }
        //1-2 岗位职责
        $result_1_2 = $res1_2['result'] ?? false;
        if (!$result_1_2) {
            $aiResult[] = $res1_2['data'] ?? ['未提交1-2 岗位职责相关资料，审核失败'];
        }
        //1-1 关企联系合作机制
        $result_1_1 = $res1_1['result'] ?? false;
        if (!$result_1_1) {
            $aiResult[] = $res1_1['data'] ?? ['未提交1-1 关企联系合作机制相关资料，审核失败'];
        }
        //2-3-1 制度
        $result_2_3_1 = $res2_3_1['result'] ?? false;
        if (!$result_2_3_1) {
            $aiResult[] = $res2_3_1['data'] ?? ['未提交2-3-1 制度相关资料，审核失败'];
        }
        //2-4-1 单位归档制度
        $result_2_4_1 = $res2_4_1['result'] ?? false;
        if (!$result_2_4_1) {
            $aiResult[] = $res2_4_1['data'] ?? ['未提交2-4-1 单位归档制度相关资料，审核失败'];
        }
        //2-5-1 禁止类产品合规审查制度
        $result_2_5_1 = $res2_5_1['result'] ?? false;
        if (!$result_2_5_1) {
            $aiResult[] = $res2_5_1['data'] ?? ['未提交2-5-1 禁止类产品合规审查制度相关资料，审核失败'];
        }
        //6-16&17&18
        $result_6_161718 = $res6_161718['result'] ?? false;
        if (!$result_6_161718) {
            $aiResult[] = $res6_161718['data'] ?? ['未提交6-16&17&18 相关资料，审核失败'];
        }
        //6-15-2 无犯罪记录证明
        $result_6_15_2 = $res6_15_2['result'] ?? false;
        if (!$result_6_15_2) {
            $aiResult[] = $res6_15_2['data'] ?? ['未提交6-15-2 相关资料，审核失败'];
        }


        $aiResult = Arr::collapse($aiResult);


        $status = 0;
        if (count($aiResult) > 0) {
            $status = 1;
        }
        if (count($aiResult) == 1) {
            $status = 2;
        }
        if (count($aiResult) == 0) {
            $status = 3;
        }

        Db::table('pre_audit_json')
            ->where('pre_audit_id', $this->pre_audit_id)
            ->where('number', $this->number)
            ->update([
                'ai_result' => json_encode($aiResult),
                'status' => $status,
            ]);
        Db::table('pre_audits')
            ->where('id', $this->pre_audit_id)
            ->update([
                'status' => $status,
            ]);

        var_dump($aiResult);

    }
}
