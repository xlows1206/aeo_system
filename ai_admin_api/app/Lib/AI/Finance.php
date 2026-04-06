<?php

namespace App\Lib\AI;

use App\Lib\Log;
use Exception;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;
use GuzzleHttp\Psr7\Utils;

class Finance
{
//     curl --location 'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions' \
// --header "Authorization: Bearer sk-75575fff703045d7ac9f7e0e1b99de02" \
// --header 'Content-Type: application/json' \
// --data '{
//   "model": "qwen-vl-ocr-2025-11-20",
//   "messages": [
//     {
//       "role": "user",
//       "content": [
//         {
//           "type": "image_url",
//           "image_url": {
//             "url": "https://i.postimg.cc/xdsVRgH0/2020nian-shen-ji-yi-jian.png"
//           }
//         },
//         {
//           "type": "text",
//           "text": "# 角色\\n你是一个专业且谨慎仔细的文员，非常擅长于从文档资料中抽取相关信息并且判断是否符合业务规定。\\n# 任务\\n你需要仔细从提供的资料中提取会计事务所的审计意见并存入{scratch_pad}，\\\"无法表示意见\\\"、\\\"有保留意见\\\"、\\\"无法出具\\\"等意见为不通过，\\\"无保留意见\\\"为通过，请你根据内容输出{review}\\n# 输出格式\\n{\\n  \\\"year\\\": \\\"{year}\\\",\\n  \\\"review\\\": \\\"{scratch_pad}\\\",\\n  \\\"result\\\": \\\"{review}\\\"\\n}"
//         }
//       ]
//     }
//   ],
//   "response_format": {
//     "type": "json_object"
//   }
// }'
    protected string $apiKey = 'sk-b6b9a007a87748bcb7c61f17a1c63574';

    function getModes($base_url)
    {
        $url = $base_url . '/models';
        $client = new Client();
        $res = $client->get($url, [
            'headers' => [
                'Authorization' => 'Bearer ' . $this->apiKey,
                'Content-Type' => 'application/json',
                'Connection' => 'Keep-alive',
                'Accept' => '*/*'
            ],
        ]);
        return json_decode((string)$res->getBody(), true);
    }

    function getAiResponse($message, $model_name, $fileUrl = '')
    {
        $messages = [
            [
                'role' => 'user',
                'content' => [
                    [
                        'type' => 'text',
                        'text' => $message
                    ],
                    [
                        'type' => 'image_url',
                        "image_url" => [
                            "url" => $fileUrl
                        ]
                    ]
                ]
            ]
        ];

        $url = 'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions';
        $data = [
            'model' => $model_name,
            'messages' => $messages,
            'vl_high_resolution_images' => true,
            'temperature' => 0.1,
            'top_p' => 0.8,
            'max_tokens' => 2021
        ];

        try {
            $client = new Client();
            $res = $client->post($url, [
                'headers' => [
                    'Authorization' => 'Bearer ' . $this->apiKey,
                    'Content-Type' => 'application/json',
                    'Connection' => 'Keep-alive',
                    'Accept' => '*/*'
                ],
                'body' => Utils::streamFor(json_encode($data, 320))
            ]);
            $response = json_decode((string)$res->getBody(), true);
            $choices = $response['choices'] ?? [];
            $choices = $choices[0] ?? [];
            $message = $choices['message'] ?? [];
            return $message['content'] ?? '';
        } catch (Exception $e) {
            Log::get()->error('AI Finance Error: ', [
                'params' => $e->getMessage(),
                'code' => $e->getCode(),
                'aiStr' => $messages,
                'fileUrl' => $fileUrl
            ]);
            return '';
        }
    }

    function getResult($base_url, $data, $model_name)
    {
        $data = json_encode($data, 320);
        $url = $base_url . '/chat/completions';

        $messages = [
            [
                'role' => 'system',
                'content' => 'You are a helpful assistant'
            ],
            [
                'role' => 'user',
                'content' => '
        # 任务
请你一步步仔细思考，根据<数据>中每一年的负债率 liability_ratio，然后按<规则>判断输出，不要输出其他任何内容。
# 规则
如果至少有1年"liability_ratio"不超过95.00%，请按下面格式输出"true"，如果均超过95.00%，输出"false"。
参考格式：{"result":true}
# 数据
' . $data
            ]
        ];
        // 构建数据
        $data = [
            'model' => $model_name,
            'messages' => $messages,
            'stream' => false
        ];

        $client = new Client();
        $res = $client->post($url, [
            'headers' => [
                'Authorization' => 'Bearer ' . $this->apiKey,
                'Content-Type' => 'application/json',
                'Connection' => 'Keep-alive',
                'Accept' => '*/*'
            ],
            'body' => json_encode($data, JSON_UNESCAPED_UNICODE)
        ]);
        return json_decode((string)$res->getBody(), true);
    }
}