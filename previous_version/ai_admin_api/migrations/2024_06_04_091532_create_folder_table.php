<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class CreateFolderTable extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('folders', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name')->comment('名称');
            $table->bigInteger('standard_id')->index()->comment('标准 Id');
            $table->bigInteger('user_id')->index()->comment('用户 ID');
            $table->bigInteger('master_id')->index()->comment('主账号 ID');
            $table->bigInteger('parent_id')->index()->comment('上级 ID');
            $table->datetimes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('folders');
    }
}
