<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\DbConnection\Model\Model;

/**
 */
class PreAudit extends Model
{
    /**
     * The table associated with the model.
     */
    protected ?string $table = 'pre_audits';

    /**
     * The attributes that are mass assignable.
     */
    protected array $guarded = [];

    /**
     * The attributes that should be cast to native types.
     */
    protected array $casts = [];

    public function info(): \Hyperf\Database\Model\Relations\hasMany
    {
        return $this->hasMany(PreAuditJson::class);
    }

    public function user(): \Hyperf\Database\Model\Relations\HasOne
    {
        return $this->hasOne(User::class, 'id', 'user_id');
    }
}
