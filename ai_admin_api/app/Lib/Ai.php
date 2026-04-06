<?php

declare(strict_types=1);
/**
 * This file is part of Hyperf.
 *
 * @link     https://www.hyperf.io
 * @document https://hyperf.wiki
 * @contact  group@hyperf.io
 * @license  https://github.com/hyperf/hyperf/blob/master/LICENSE
 */

namespace App\Lib;

use App\Lib\AI\Finance;

class Ai
{
    public function getFinance($images): array
    {
        $computeData = [];
        try {
            $finance = new Finance();

            $base_url = 'https://dashscope.aliyuncs.com/compatible-mode/v1';
//            // 获取模型名称（假设已获取模型ID为$first_model）
//            $models = $finance->getModes($base_url);
//            // 获取第一个模型的 ID
//            $model_name = $models['data'][0]['id'];
            $model_name = 'qwen-vl-max'; // 如果需要使用特定模型名称
            // 构建消息内容，每次必须传入Prompt和单张图片

            foreach ($images as $image) {
                $messages = [
                    [
                        'role' => 'user',
                        'content' => [
                            [
                                'type' => 'text',
                                'text' => '
                                        # 角色
                      你是一个专业且谨慎仔细的文员，非常擅长于从PDF、DOCX、图片等文档资料中抽取相关信息。
                      # 任务
                      你需要从提供资料的"期末余额列"中提取分别叫做“负债合计”、“负债和所有者权益(或股东权益)合计”行的数据，并以<输出格式>的范式输出结果。请注意，你需要的值是“负债和所有者权益(或股东权益)合计，而不是“所有者权益合计”这一行数据。
                      # 输出格式(请严格按照下面的json格式输出，只要json部分，不需要增加其他内容)
                      请你以下面的JSON格式输出数据,"负债合计"命名为"liability","负债和所有者权益(或股东权益)合计”命名为"liability_equity",保留两位小数。
                      {
                      "year": "{year}",
                      "liability": "{liability_number}",
                      "liability_equity": "{liability_equity_number}"
                      }
                '
                            ],
                            [
                                'type' => 'image_url',
                                'image_url' => [
                                    'url' => $image->url,
                                ]
                            ]
                        ]
                    ]
                ];
                $response = $finance->getAiResponse($base_url, $messages, $model_name);
                $choices = $response['choices'] ?? [];
                $choices = $choices[0] ?? [];
                $message = $choices['message'] ?? [];
                $content = $message['content'] ?? '';

                $json_cleaned = preg_replace('/```(?:json)?\n|\n```/', '', $content);
                $data = json_decode($json_cleaned, true);

                // 将字符串转换为浮点数，并去除千位分隔符
                $liability = floatval(str_replace(",", "", $data["liability"]));
                $liability_equity = floatval(str_replace(",", "", $data["liability_equity"]));
                $liability_ratio = ($liability / $liability_equity) * 100;
                $data["liability_ratio"] = number_format($liability_ratio, 2) . "%";
                $computeData[] = $data;
            }

            $res = $finance->getResult($base_url, $computeData, $model_name);
            Log::get()->info('Ai result info: ', [
                $res
            ]);

            $choices = $res['choices'] ?? [];
            $choices = $choices[0] ?? [];
            $message = $choices['message'] ?? [];
            $content = $message['content'] ?? '';
            $content = trim($content, '"');
            $content = preg_replace('/^```json\s*|\s*```$/', '', $content);
            $content = stripslashes($content);
            $data = json_decode($content, true);
            $result = $data['result'] ?? 'none';
            Log::get()->info('Ai result: ', [
                'result' => $result
            ]);
        } catch (\Exception $e) {
            $result = 'none';
            Log::get()->info('Ai error: ' . $e->getMessage());
        }

        if ($result === 'none') {
            return [
                'msg' => '未能获取到结果，请重新提交审核',
                'result' => false,
            ];
        }

        $computeData = collect($computeData)->sortBy('year')->values()->all();

        $msg = '';
        foreach ($computeData as $item) {
            $msg .= "{$item['year']}: 负债率为 {$item['liability_ratio']} \n";
        }

        Log::get()->info('Ai return result: ', [
            'msg' => '财务状况审核结果为' . ($result ? '通过' : '不通过') . ";\n" . $msg,
            'result' => $result,
        ]);

        return [
            'msg' => '财务状况审核结果为' . ($result ? '通过' : '不通过') . ";\n" . $msg,
            'result' => $result,
        ];
    }
}
