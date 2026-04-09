<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\DbConnection\Model\Model;

/**
 */
class PreAuditJson extends Model
{
    /**
     * The table associated with the model.
     */
    protected ?string $table = 'pre_audit_json';

    /**
     * The attributes that are mass assignable.
     */
    protected array $guarded = [];

    /**
     * The attributes that should be cast to native types.
     */
    protected array $casts = [];
}
