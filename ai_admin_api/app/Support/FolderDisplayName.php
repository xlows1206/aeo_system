<?php

declare(strict_types=1);

namespace App\Support;

class FolderDisplayName
{
    public static function format(string $name, ?string $parentName): string
    {
        $prefix = self::normalizeParentName($parentName);
        $name = trim($name);

        if ($name === '' || $prefix === '') {
            return $name;
        }

        $fullPrefix = $prefix . ' - ';
        if (str_starts_with($name, $fullPrefix)) {
            return $name;
        }

        return $fullPrefix . $name;
    }

    public static function normalizeParentName(?string $name): string
    {
        if ($name === null) {
            return '';
        }

        $name = trim($name);
        $name = preg_replace('/^\d+\./u', '', $name) ?? $name;

        return trim($name);
    }
}
