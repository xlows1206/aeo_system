<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class CreateFilesTable extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('files', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name')->comment('名称');
            $table->string('url')->comment('链接');
            $table->string('size', 30)->comment('大小');
            $table->string('suffix', 10)->comment('大小');
            $table->bigInteger('folder_id')->default(0)->index()->comment('文件夹 ID');
            $table->bigInteger('standard_id')->index()->comment('标准 Id');
            $table->bigInteger('user_id')->index()->comment('用户 ID');
            $table->bigInteger('master_id')->index()->comment('主账号 ID');
            $table->tinyInteger('status')->default(0)->index()->comment('状态 0未审核 1不适用 2不达标 3基本达标 4达标');
            $table->datetimes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('files');
    }
}
