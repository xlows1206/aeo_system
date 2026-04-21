<?php

declare(strict_types=1);

namespace App\Support;

class FolderDisplayName
{
    public static function format(?string $name, ?string $parentName, ?string $rootName = null): string
    {
        $parts = [];
        if ($rootName !== null && trim($rootName) !== '') {
            $parts[] = trim($rootName);
        }
        if ($parentName !== null && trim($parentName) !== '') {
            $parts[] = trim($parentName);
        }
        if ($name !== null && trim($name) !== '') {
            $parts[] = trim($name);
        }

        return implode(' - ', $parts);
    }

    public static function normalizeParentName(?string $name): string
    {
        return $name !== null ? trim($name) : '';
    }
}
