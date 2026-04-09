<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class AddStartEndYearToCompanyInfo extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('company_info', function (Blueprint $table) {
            $table->integer('start_year')->after('duration_year')->nullable()->comment('开始年份');
            $table->integer('end_year')->after('start_year')->nullable()->comment('结束年份');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('company_info', function (Blueprint $table) {
            $table->dropColumn(['start_year', 'end_year']);
        });
    }
}
