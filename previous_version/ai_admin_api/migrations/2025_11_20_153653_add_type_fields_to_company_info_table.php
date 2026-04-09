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
            $table->string('types')->default(0)->comment("企业类型");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('company_info', function (Blueprint $table) {
            $table->dropColumn('types');
        });
    }
};
