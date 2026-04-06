<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class CreateFolderClosureTable extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('folder_closure', function (Blueprint $table) {
            $table->bigInteger('ancestor')->index()->comment('父级ID');
            $table->bigInteger('descendant')->index()->comment('子集 ID');
            $table->tinyInteger('distance')->index()->comment('层级');
            $table->primary(['ancestor', 'descendant']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('folder_closure');
    }
}
