<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class CreatePreAuditsJson extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('pre_audit_json', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->bigInteger('pre_audit_id')->index()->comment('预审核 ID');
            $table->json('info')->comment('审核资料');
            $table->tinyInteger('number')->default(1)->comment(' 审核次数');
            $table->tinyInteger('status')->default(0)->index()->comment(' 状态 0 未审核 1不达标 2基本达标 3达标');
            $table->string('result')->nullable()->comment(' 审核详情');
            $table->datetimes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pre_audit_json');
    }
}
