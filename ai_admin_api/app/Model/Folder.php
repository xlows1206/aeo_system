<?php

declare(strict_types=1);

namespace App\Model;

use App\Exception\HslException;
use Hyperf\Database\Model\Events\Created;
use Hyperf\Database\Model\Events\Deleted;
use Hyperf\Database\Model\Events\Updated;
use Hyperf\DbConnection\Db;
use Hyperf\DbConnection\Model\Model;

/**
 * @property int $id 
 * @property string $name 
 * @property int $standard_id 
 * @property int $user_id 
 * @property int $master_id 
 * @property int $parent_id 
 * @property \Carbon\Carbon $created_at 
 * @property \Carbon\Carbon $updated_at 
 */
class Folder extends Model
{
    protected ?string $closureTable = 'folder_closure';
    protected ?string $ancestorColumn = 'ancestor';
    protected ?string $descendantColumn = 'descendant';
    protected ?string $distance = 'distance';
    /**
     * The table associated with the model.
     */
    protected ?string $table = 'folders';

    /**
     * The attributes that are mass assignable.
     */
    protected array $guarded = [];

    /**
     * The attributes that should be cast to native types.
     */
    protected array $casts = ['id' => 'integer', 'standard_id' => 'integer', 'user_id' => 'integer', 'master_id' => 'integer', 'parent_id' => 'integer', 'created_at' => 'datetime', 'updated_at' => 'datetime'];


    public function created(Created $event): void
    {
        $descendantId = $event->getModel()->id;
        $ancestorId = $event->getModel()->parent_id;
        $table = $this->closureTable;
        $ancestorColumn = $this->ancestorColumn;
        $descendantColumn = $this->descendantColumn;
        $distance = $this->distance;

        $query = "
            INSERT INTO {$table} ({$ancestorColumn}, {$descendantColumn}, {$distance})
            SELECT tbl.{$ancestorColumn}, {$descendantId}, tbl.{$distance}+1
            FROM {$table} AS tbl
            WHERE tbl.{$descendantColumn} = {$ancestorId}
            UNION ALL
            SELECT {$descendantId}, {$descendantId}, 0
            ON DUPLICATE KEY UPDATE {$distance} = VALUES ({$distance})
        ";

        Db::connection($this->connection)->insert($query);
    }

    public function updated(Updated $event): void
    {

        $parentKey = $event->getModel()->parent_id;

        $ids = $this->getDescendantsAndSelf([$this->getKeyName()])->pluck($this->getKeyName())->toArray();

        if (in_array($parentKey, $ids)) {
            throw new HslException('Can\'t move to descendant');
        }
        Db::connection($this->connection)->transaction(function () use ($parentKey) {
            if (!$this->detachRelationships()) {
                throw new HslException('Unbind relationships failed');
            }
            if (!$this->attachTreeTo($parentKey)) {
                throw new HslException('Associate tree failed');
            }
        });
    }

    public function deleted(Deleted $event): void
    {
        $children = $this->getChildren();

        Db::table('files')->where('folder_id', $event->getModel()->id)->delete();
        foreach ($children as $child) {
            $child->delete();
        }
        $this->detachRelationships();
        $this->detachSelfRelation();
    }

    protected function getDescendantsAndSelf(): \Hyperf\Collection\Collection
    {
        $tableName = $this->getTable();

        $temp = Db::select("select
          *
        from
          `{$tableName}`
          inner join `{$this->closureTable}` on `{$this->closureTable}`.`{$this->descendantColumn}` = `{$tableName}`.`id`
        where
          `{$this->closureTable}`.`{$this->ancestorColumn}` = {$this->id}
          and `{$this->closureTable}`.`{$this->distance}` >= 0");

        return collect($temp);
    }

    protected function detachRelationships(): bool
    {
        $key = $this->getKey();
        $table = $this->closureTable;
        $ancestorColumn = $this->ancestorColumn;
        $descendantColumn = $this->descendantColumn;

        $query = "
            DELETE FROM {$table}
            WHERE {$descendantColumn} IN (
              SELECT d FROM (
                SELECT {$descendantColumn} as d FROM {$table}
                WHERE {$ancestorColumn} = {$key}
              ) as dct
            )
            AND {$ancestorColumn} IN (
              SELECT a FROM (
                SELECT {$ancestorColumn} AS a FROM {$table}
                WHERE {$descendantColumn} = {$key}
                AND {$ancestorColumn} <> {$key}
              ) as ct
            )
        ";

        Db::connection($this->connection)->delete($query);
        return true;
    }

    protected function attachTreeTo($parentKey = 0): bool
    {
        if (is_null($parentKey)) {
            $parentKey = 0;
        }

        $key = $this->getKey();
        $table = $this->closureTable;
        $ancestor =  $this->ancestorColumn;
        $descendant = $this->descendantColumn;
        $distance = $this->distance;
        $query = "
            INSERT INTO {$table} ({$ancestor}, {$descendant}, {$distance})
            SELECT supertbl.{$ancestor}, subtbl.{$descendant}, supertbl.{$distance}+subtbl.{$distance}+1
            FROM {$table} as supertbl
            CROSS JOIN {$table} as subtbl
            WHERE supertbl.{$descendant} = {$parentKey}
            AND subtbl.{$ancestor} = {$key}
            ON DUPLICATE KEY UPDATE {$distance} = VALUES ({$distance})
        ";

        Db::connection($this->connection)->insert($query);
        return true;
    }

    protected function getChildren(array $columns = ['*']): \Hyperf\Database\Model\Collection|array
    {
        return $this->queryChildren()->get($columns);
    }

    protected function queryChildren(): \Hyperf\Database\Model\Builder
    {
        $key = $this->getKey();
        return $this->where('parent_id', $key);
    }

    protected function detachSelfRelation(): bool
    {
        $key = $this->getKey();
        $table = $this->closureTable;
        $ancestorColumn = $this->ancestorColumn;
        $descendantColumn = $this->descendantColumn;
        $query = "
            DELETE FROM {$table}
            WHERE {$descendantColumn} = {$key}
            OR {$ancestorColumn} = {$key}
        ";

        Db::connection($this->connection)->delete($query);
        return true;
    }


    public function getAncestorsAndSelf(): \Hyperf\Collection\Collection
    {
        $tableName = $this->getTable();
        $temp = Db::select("select
              *
            from
              `{$tableName}`
              inner join `{$this->closureTable}` on `{$this->closureTable}`.`{$this->ancestorColumn}` = `{$tableName}`.`id`
            where
              `{$this->closureTable}`.`{$this->descendantColumn}` = {$this->id}
              and `{$this->closureTable}`.`{$this->distance}` >= 0
            order by
              `{$this->distance}` desc");

        return collect($temp);

    }
}
