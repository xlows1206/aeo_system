<?php
/**
 * 阿里云 OSS 纯 PHP 诊断脚本 (无 Composer 依赖)
 */

function oss_sign($method, $uri, $access_key_secret, $content_type = '', $date = '') {
    $string_to_sign = "$method\n\n$content_type\n$date\n$uri";
    return base64_encode(hash_hmac('sha1', $string_to_sign, $access_key_secret, true));
}

// 1. 加载配置
$envFile = file_exists('.env.production') ? '.env.production' : '.env';
echo "--- OSS Diagnostic (No Dependencies) ---\n";
echo "Loading config from {$envFile}...\n";

$accessKeyId = '';
$accessKeySecret = '';
$endpoint = '';
$bucket = '';

if (file_exists($envFile)) {
    $lines = file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos(trim($line), '#') === 0) continue;
        $parts = explode('=', $line, 2);
        if (count($parts) == 2) {
            $name = trim($parts[0]);
            $value = trim($parts[1]);
            if ($name == 'OSS_ACCESS_KEY') $accessKeyId = $value;
            if ($name == 'OSS_SECRET_KEY') $accessKeySecret = $value;
            if ($name == 'OSS_ENDPOINT') $endpoint = str_replace(['https://', 'http://'], '', $value);
            if ($name == 'OSS_BUCKET') $bucket = $value;
        }
    }
}

if (!$accessKeyId || !$accessKeySecret) {
    die("ERROR: OSS_ACCESS_KEY or OSS_SECRET_KEY not found in {$envFile}\n");
}

echo "Testing Key: " . substr($accessKeyId, 0, 5) . "...\n";
echo "Endpoint: {$endpoint}\n";
echo "Bucket: {$bucket}\n";

// 2. 构造测试请求 (List Objects)
$host = "{$bucket}.{$endpoint}";
$method = "GET";
$uri = "/{$bucket}/?max-keys=1"; // 注意：对于 OSS REST API，URI 通常包含 bucket 名
$date = gmdate('D, d M Y H:i:s T');
$signature = oss_sign($method, "/{$bucket}/", $accessKeySecret, '', $date);

$url = "https://{$host}/?max-keys=1";

echo "Sending request to {$url}...\n";

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HEADER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    "Date: {$date}",
    "Authorization: OSS {$accessKeyId}:{$signature}"
]);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$headerSize = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
$headers = substr($response, 0, $headerSize);
$body = substr($response, $headerSize);
curl_close($ch);

echo "HTTP Status: {$httpCode}\n";

if ($httpCode == 200) {
    echo "SUCCESS: Connection established! Your Key is valid and active.\n";
} else {
    echo "ERROR: OSS Request Failed!\n";
    echo "Headers:\n{$headers}\n";
    echo "Body:\n{$body}\n";
    
    if ($httpCode == 403) {
        if (strpos($body, 'AccessDenied') !== false) {
            echo "\nDiagnosis: [AccessDenied] 密钥已被阿里云禁用或该子账号没有 OSS 权限。\n";
        } elseif (strpos($body, 'SignatureDoesNotMatch') !== false) {
            echo "\nDiagnosis: [SignatureMismatch] 密钥不正确或复制时包含了空格。\n";
        }
    }
}
