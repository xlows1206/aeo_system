<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class CreateUsersTables extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('username', 120)->comment('账号 手机号');
            $table->string('password')->comment('密码');
            $table->string('company', 120)->nullable()->comment('公司名称');
            $table->bigInteger('parent_id')->default(0)->index()->comment('上级 ID');
            $table->bigInteger('master_id')->default(0)->index()->comment('品牌 ID');
            $table->tinyInteger('standing')->index()->default(1)->comment('身份 1系统管理员 2企业主账号 3企业子账号 4海关');
            $table->tinyInteger('enterprise')->index()->default(1)->comment('审核标准1通用 2通用 + 单项');
            $table->dateTime('login_at')->nullable()->comment('最近登录时间');
            $table->string('note')->nullable()->comment('备注');
            $table->datetimes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
}
