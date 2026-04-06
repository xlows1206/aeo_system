<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class CreateRoleStandard extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('role_standard', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->bigInteger('role_id')->index()->comment('角色 ID');
            $table->bigInteger('standard_id')->index()->comment('资料 ID');
            $table->datetimes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('role_standard');
    }
}
