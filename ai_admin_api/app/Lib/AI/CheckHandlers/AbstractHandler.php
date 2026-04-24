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
 
     /**
      * 默认合格判定：performAudit 返回 null 则视为通过，返回字符串则视为失败。
      */
     public function isAccessible(array $data, array $context): bool
     {
         return $this->performAudit($data, $context) === null;
     }
 
     /**
      * 年份标准化：提取字符串中的纯数字部分 (如 "2020年" -> "2020")
      */
     protected function normalizeYear($year): string
     {
         return preg_replace('/[^0-9]/', '', (string)$year);
     }
 
     /**
      * 数值鲁棒性解析：提取字符串中的数字、小数点和负号，忽略单位和特殊符号
      */
     protected function normalizeNumber($val): float
     {
         if ($val === null || $val === '') {
             return 0.0;
         }
         if (is_numeric($val)) {
             return (float)$val;
         }
         $val = (string)$val;
         // 移除逗号、单位(如万元)等，保留数字、小数点和负号
         $clean = preg_replace('/[^\d\.-]/', '', $val);
         return $clean === '' ? 0.0 : (float)$clean;
     }
 
     /**
      * 获取合格时的具体结论（子类可覆盖）
      */
     public function getSuccessMessages(array $data, array $context): array
     {
         return [];
     }
 }
