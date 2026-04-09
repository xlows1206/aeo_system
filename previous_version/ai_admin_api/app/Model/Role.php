<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\DbConnection\Model\Model;

/**
 */
class Role extends Model
{
    /**
     * The table associated with the model.
     */
    protected ?string $table = 'roles';

    /**
     * The attributes that are mass assignable.
     */
    protected array $guarded = [];

    /**
     * The attributes that should be cast to native types.
     */
    protected array $casts = [
        'created_at' => 'datetime:Y-m-d H:i:s',
        'updated_at' => 'datetime:Y-m-d H:i:s'
    ];

    public function permissions(): \Hyperf\Database\Model\Relations\BelongsToMany
    {
        return $this->belongsToMany(Permission::class, 'role_permission')->withTimestamps();
    }

    public function standards(): \Hyperf\Database\Model\Relations\BelongsToMany
    {
        return $this->belongsToMany(Standard::class, 'role_standard')->withTimestamps();
    }
}
