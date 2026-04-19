<?php

declare(strict_types=1);

namespace App\Lib\AI\CheckHandlers;

/**
 * AEO 检测项处理接口
 */
interface CheckHandlerInterface
{
    /**
     * 获取检测项专用的 Prompt
     * @param array $context 动态上下文（如 check_text）
     * @return string
     */
    public function getPrompt(array $context = []): string;

    /**
     * 解析并标准化 AI 返回的 JSON 数据
     * @param array $rawResult AI 返回的原始数组
     * @return array 标准化后的数据
     */
    public function parseResult(array $rawResult): array;

    /**
     * 执行业务审计逻辑
     * @param array $data 聚合后的 AI 结果数据
     * @param array $context 包含公司信息、存续年份等业务上下文
     * @return string|null 展示用的结果字符串（始终返回所有年份），无数据时返回 null
     */
    public function performAudit(array $data, array $context): ?string;

    /**
     * 判断该检测项是否通过（与 performAudit 显示内容解耦）
     * @param array $data 聚合后的 AI 结果数据
     * @param array $context 包含公司信息、存续年份等业务上下文
     * @return bool true 为通过，false 为不通过
     */
    public function isAccessible(array $data, array $context): bool;
}
