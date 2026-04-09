<?php

declare(strict_types=1);


if (!function_exists('blank')) {
    /**
     * Determine if the given value is "blank".
     *
     * @param mixed $value
     */
    function blank($value): bool
    {
        if (is_null($value)) {
            return true;
        }

        if (is_string($value)) {
            return trim($value) === '';
        }

        if (is_numeric($value) || is_bool($value)) {
            return false;
        }

        if ($value instanceof Countable) {
            return count($value) === 0;
        }

        return empty($value);
    }
}

if (!function_exists('filled')) {
    /**
     * Determine if a value is "filled".
     *
     * @param mixed $value
     */
    function filled($value): bool
    {
        return !blank($value);
    }
}

if (!function_exists('camelize')) {
    /**
     * @param $words
     * @return string
     *                下划线转驼峰
     */
    function camelize($words, string $separator = '_'): string
    {
        $words = $separator . str_replace($separator, ' ', strtolower($words));
        return ltrim(str_replace(' ', '', ucwords($words)), $separator);
    }
}

if (!function_exists('unCamelize')) {
    /**
     * @param $camelCaps
     * @return string
     *                驼峰命名转下划线命名
     */
    function unCamelize($camelCaps, string $separator = '_'): string
    {
        return strtolower(preg_replace('/([a-z])([A-Z])/', '$1' . $separator . '$2', $camelCaps));
    }
}

if (!function_exists('collect_to_array')) {
    function collect_to_array($obj): array
    {
        if (is_array($obj)) {
            return $obj;
        }

        $temp = [];
        foreach ($obj as $k => $v) {
            $temp[$k] = $v;
        }

        return $temp;
    }
}

if (!function_exists('array_pluck')) {
    /**
     * Pluck an array of values from an array.
     *
     * @param array $array
     * @param array|string $value
     * @param null|array|string $key
     *
     * @deprecated Arr::pluck() should be used directly instead. Will be removed in Laravel 6.0.
     */
    function array_pluck($array, $value, $key = null): array
    {
        $data = [];
        foreach ($array as $item) {
            $data[] = $item[$value];
        }
        return $data;
    }
}

if (!function_exists('getParam')) {
    /**
     * @param $value
     * @param $default
     * @return mixed
     */
    function getParam($value, $default = null)
    {
        return filled($value) ? $value : $default;
    }
}

if (!function_exists('url_safe_b64encode')) {
    function url_safe_b64encode($string)
    {
        $data = base64_encode($string);
        return str_replace(['+', '/'], ['-', '_'], $data);
    }
}

if (!function_exists('str_random')) {
    function str_random($length = 16): string
    {
        $string = '';

        while (($len = strlen($string)) < $length) {
            $size = $length - $len;

            $bytes = random_bytes($size);

            $string .= substr(str_replace(['/', '+', '='], '', base64_encode($bytes)), 0, $size);
        }

        return $string;
    }
}

if (!function_exists('getManyZero')) {
    function getManyZero($str, $len): string
    {
        $z = '0';

        for ($i = 1; $i < $len - strlen($str); ++$i) {
            $z .= '0';
        }

        return $z;
    }
}

if (!function_exists('buildTree')) {

    function buildTree(array $elements, $parentId = 'x'): array
    {
        $branch = [];

        foreach ($elements as &$element) {
            $element = collect_to_array($element);
            if ($element['parent_id'] == $parentId) {
                $children = buildTree($elements, $element['id']);
                if ($children) {
                    $element['children'] = $children;
                }
                $branch[] = $element;
                unset($element);
            }
        }
        return $branch;
    }

}

if (!function_exists('collect')) {
    function collect($value = null): \Hyperf\Collection\Collection
    {
        return new \Hyperf\Collection\Collection($value);
    }
}


if (!function_exists('transmit_file_size')) {
    function transmit_file_size($bytes, $decimals = 2): string
    {
        $bytes = (string) $bytes;
        $size = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
        if ($bytes == 0) return '0 B';
        $factor = floor((strlen($bytes) - 1) / 3);
        return sprintf("%.{$decimals}f", $bytes / pow(1024, $factor)) . ' ' . $size[$factor];
    }
}
