<?php

declare(strict_types=1);
/**
 * This file is part of Hyperf.
 *
 * @link     https://www.hyperf.io
 * @document https://hyperf.wiki
 * @contact  group@hyperf.io
 * @license  https://github.com/hyperf/hyperf/blob/master/LICENSE
 */

namespace App\Model;

use Carbon\Carbon;
use Hyperf\Database\Model\Relations\HasMany;
use Hyperf\DbConnection\Model\Model;

/**
 * @property int $id
 * @property string $name
 * @property string $path
 * @property int $rank
 * @property int $parent_id
 * @property Carbon $created_at
 * @property Carbon $updated_at
 */
class Permission extends Model
{
    /**
     * The table associated with the model.
     */
    protected ?string $table = 'permissions';

    /**
     * The attributes that are mass assignable.
     */
    protected array $guarded = [];

    /**
     * The attributes that should be cast to native types.
     */
    protected array $casts = ['id' => 'integer', 'rank' => 'integer', 'parent_id' => 'integer', 'created_at' => 'datetime', 'updated_at' => 'datetime'];

    public function children(): HasMany
    {
        return $this->hasMany(self::class, 'parent_id', 'id');
    }
}
