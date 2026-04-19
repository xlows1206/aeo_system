<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class CreateFolderPassedFiles extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('folder_passed_files', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('master_id')->index();
            $table->unsignedBigInteger('folder_id')->index();
            $table->unsignedBigInteger('file_id')->index();
            $table->string('file_name');
            $table->string('file_url');
            $table->string('archive_path')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('folder_passed_files');
    }
}
