<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('folder_check_files', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('folder_name')->comment('项目名称');
            $table->unsignedInteger('folder_id')->comment('文件夹id');
            $table->integer('standard_id')->default(0)->comment('分类id');
            $table->string('check_name')->comment('检测项目');
            $table->tinyInteger('check_type')->default(2)->comment('1 需要检测  2 上传就通过');
            $table->string('check_text', 1000)->nullable()->comment('检测内容');
            $table->datetimes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('folder_check_files');
    }
};
