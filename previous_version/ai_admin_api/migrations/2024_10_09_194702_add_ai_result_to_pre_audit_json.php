<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class AddAiResultToPreAuditJson extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('pre_audit_json', function (Blueprint $table) {
            $table->json('ai_result')->after('result')->nullable()->comment('AI识别结果');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('pre_audit_json', function (Blueprint $table) {
            $table->dropColumn('ai_result');
        });
    }
}
