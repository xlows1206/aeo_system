<?php

declare(strict_types=1);

namespace App\Request\Menu;

use Hyperf\Validation\Request\FormRequest;
use Hyperf\Validation\Rule;

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
        $parent_id = $this->getParsedBody()['parent_id'];
        return [
            'name' => [
                'required',
                Rule::unique('permissions')->where('parent_id', $parent_id),
            ],
            'path' => 'required|unique:permissions',
            'rank' => 'required',
            'parent_id' => 'required',
        ];
    }
}
