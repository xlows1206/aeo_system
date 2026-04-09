<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class CreateMasterStandardTable extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('user_standard', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->bigInteger('user_id')->index()->comment('账号 ID');
            $table->bigInteger('standard_id')->index()->comment('主账号 ID');
            $table->datetimes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_standard');
    }
}
