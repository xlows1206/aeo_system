<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class AddSuffixToFolderPassedFiles extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('folder_passed_files', function (Blueprint $table) {
            $table->string('suffix', 20)->after('file_name')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('folder_passed_files', function (Blueprint $table) {
            $table->dropColumn('suffix');
        });
    }
}
