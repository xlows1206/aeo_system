<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class CreatePreAudits extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('pre_audits', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->bigInteger('user_id')->index()->comment('用户 ID');
            $table->bigInteger('master_id')->index()->comment('主账号 ID');
            $table->tinyInteger('status')->default(0)->index()->comment(' 状态 0 未审核 1不达标 2基本达标 3达标');
            $table->tinyInteger('number')->default(1)->comment(' 审核次数');
            $table->datetimes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pre_audits');
    }
}
