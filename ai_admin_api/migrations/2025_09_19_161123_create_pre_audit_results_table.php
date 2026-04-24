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
        Schema::create('pre_audit_results', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedInteger('folder_id')->comment('文件夹id');
            $table->unsignedInteger('standard_id')->comment('所属部门');
            $table->string('folder_name')->comment('文件夹名称');
            $table->unsignedInteger('master_id')->comment('主账号id');
            $table->boolean('is_access')->default(0)->comment('是否通过检测');
            $table->string('result_str')->nullable()->default('')->comment('审核结果');
            $table->datetimes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pre_audit_results');
    }
};
