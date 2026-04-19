<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\Database\Model\Events\Deleted;
use Hyperf\DbConnection\Db;
use Hyperf\DbConnection\Model\Model;

/**
 */
class User extends Model
{
    /**
     * The table associated with the model.
     */
    protected ?string $table = 'users';

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

    public function role(): \Hyperf\Database\Model\Relations\BelongsTo
    {
        return $this->belongsTo(Role::class);
    }

    public function master(): \Hyperf\Database\Model\Relations\BelongsTo
    {
        return $this->belongsTo(self::class);
    }

    public function getUserPermissionPath(): \Hyperf\Collection\Collection
    {
        $query = Db::table('permissions as p');
        
        if ($this->standing !== 1) {
            $query->leftJoin('role_permission as rp', 'rp.permission_id', '=', 'p.id')
                ->leftJoin('roles as r', 'r.id', '=', 'rp.role_id')
                ->where('r.id', $this->role_id);
        }
        
        return $query->select('p.path as value', 'p.name as label')
            ->get();
    }

    public function getUserPermission(): \Hyperf\Collection\Collection
    {
        $query = Db::table('permissions as p');
        
        if ($this->standing !== 1) {
            $query->leftJoin('role_permission as rp', 'rp.permission_id', '=', 'p.id')
                ->leftJoin('roles as r', 'r.id', '=', 'rp.role_id')
                ->where('r.id', $this->role_id);
        }

        $lists = $query->oldest('p.rank')
            ->oldest('p.id')
            ->select('p.*')
            ->get();

        // 还要找出上一级的权限
        $parentLists = Db::table('permissions')
            ->whereIn('id', $lists->pluck('parent_id')->toArray())
            ->get();

        return $lists->merge($parentLists)->unique('id');
    }

    public function deleted(Deleted $event): void
    {
        $model = $event->getModel();
        if ($model->parent_id === 0) {
            // 主账号，需要删除全部子账号
            Db::table('users')
                ->where('master_id', $model->master_id)
                ->delete();
        }
    }


    public function isCustoms(): bool
    {
        return Db::table('roles')->where('name', '海关')->where('id', $this->role_id)->exists();
    }
}
