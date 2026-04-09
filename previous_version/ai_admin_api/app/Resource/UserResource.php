<?php

namespace App\Resource;

use Hyperf\Resource\Json\JsonResource;

class UserResource extends JsonResource
{

    const STANDING = [
        '', '系统管理员', '企业主账号', '企业子账号', '海关'
    ];

    const ENTERPRISE = [
        '', '通用', '通用+单项'
    ];

    /**
     * Transform the resource into an array.
     *
     * @return array
     */
    public function toArray(): array
    {
        return [
            'id' => $this->id,
            'login_at' => $this->login_at,
            'master' => $this->master->username ?? '',
            'note' => $this->note,
            'parent_id' => $this->parent_id,
            'role_id' => $this->role_id ?? 0,
            'role_name' => $this->role->name ?? '',
            'standing' => $this->standing,
            'standingName' => self::STANDING[$this->standing],
            'enterprise' => $this->enterprise,
            'enterpriseName' => self::ENTERPRISE[$this->enterprise],
            'username' => $this->username,
            'company' => $this->company,
            'created_at' => $this->created_at->toDateTimeString(),
        ];
    }
}
