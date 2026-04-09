<?php

declare(strict_types=1);

namespace App\Lib\AI\CheckHandlers;

use App\Lib\Log;

/**
 * 检测项处理抽象基类
 */
abstract class AbstractHandler implements CheckHandlerInterface
{
    /**
     * @var string 对应的 Prompt 文件名（不含后缀）
     */
    protected string $promptFile;

    /**
     * 默认实现：从 storage 目录读取 Markdown 提示词
     */
    public function getPrompt(array $context = []): string
    {
        $path = BASE_PATH . "/storage/prompts/{$this->promptFile}.md";
        if (!file_exists($path)) {
            Log::get()->error("Prompt file not found: {$path}");
            return "";
        }

        $content = file_get_contents($path);

        // 如果 context 中包含变量，执行简单的替换 (例如 {check_text})
        foreach ($context as $key => $value) {
            if (is_scalar($value)) {
                $content = str_replace('{' . $key . '}', (string)$value, $content);
            }
        }

        return $content;
    }

    /**
     * 默认的标准化处理：直接返回（子类可覆盖）
     */
    public function parseResult(array $rawResult): array
    {
        return $rawResult;
    }
}
