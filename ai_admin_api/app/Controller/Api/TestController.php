<?php

declare(strict_types=1);

namespace App\Controller\Api;

use App\Lib\AI\CheckHandlers\CheckHandlerFactory;
use App\Lib\AI\Finance;
use Hyperf\HttpServer\Annotation\Controller;
use Hyperf\HttpServer\Annotation\GetMapping;
use Hyperf\HttpServer\Contract\ResponseInterface;

#[Controller(prefix: "api/test")]
class TestController
{
    #[GetMapping(path: "prompt")]
    public function prompt(ResponseInterface $response)
    {
        $imageUrl = 'https://img1.baidu.com/it/u=3049187376,464878235&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=667';
        
        $handler = CheckHandlerFactory::make('资产负债率情况');
        $prompt = $handler->getPrompt();

        $finance = new Finance();
        $model = 'qwen-vl-max'; 
        
        $rawResponse = $finance->getAiResponse($prompt, $model, $imageUrl);
        
        // 解析与标准化
        $jsonCleaned = preg_replace('/```(?:json)?\n|\n```/', '', $rawResponse);
        $parsedData = json_decode($jsonCleaned, true);
        
        $standardized = null;
        $auditResult = null;
        if ($parsedData) {
            $standardized = $handler->parseResult($parsedData);
            $auditResult = $handler->performAudit([$standardized], ['duration_years' => [$standardized['year'] ?? date('Y')]]);
        }

        return $response->json([
            'status' => 'success',
            'prompt_sample' => substr($prompt, 0, 100) . '...',
            'ai_raw' => $rawResponse,
            'parsed' => $standardized,
            'audit_result' => $auditResult ?? 'Passed',
        ]);
    }
}
