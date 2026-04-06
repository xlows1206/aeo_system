<?php

use Hyperf\Database\Schema\Schema;
use Hyperf\Database\Schema\Blueprint;
use Hyperf\Database\Migrations\Migration;

class CreateCompanyInfoTable extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('company_info', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->bigInteger('master_id')->index();
            $table->string('company_name')->nullable()->comment('公司名称');
            $table->string('enterprise_person_name')->nullable()->comment('企业法定代表人');
            $table->string('principal_person_name')->nullable()->comment('主要负责人');
            $table->string('financial_person_name')->nullable()->comment('财务负责人');
            $table->string('customs_person_name')->nullable()->comment('关务负责人');
            $table->datetimes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('company_info');
    }
}