<?php

declare(strict_types=1);

namespace App\Request\Company;

use Hyperf\Validation\Request\FormRequest;

class StoreRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        return [
            'company_name' => 'required',
            'enterprise_person_name' => 'required',
            'principal_person_name' => 'required',
            'financial_person_name' => 'required',
            'customs_person_name' => 'required',
        ];
    }
}
