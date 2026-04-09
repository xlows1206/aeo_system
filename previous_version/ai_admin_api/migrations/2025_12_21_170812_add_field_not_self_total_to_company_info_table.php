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
        Schema::table('company_info', function (Blueprint $table) {
            $table->integer('not_self_total')->default(2000)->comment('报关单总数');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('company_info', function (Blueprint $table) {
            $table->dropColumn('not_self_total');
        });
    }
};
