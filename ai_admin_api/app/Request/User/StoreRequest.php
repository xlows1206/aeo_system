<?php

declare(strict_types=1);

namespace App\Request\User;

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
            'username' => 'required|unique:users',
            'password' => 'required',
            'roleId' => 'required',
        ];
    }

    public function messages(): array
    {
        return [
            'username.required'=> '账号不能为空',
            'username.unique'=> '账号已存在',
            'password.required'=> '密码不能为空',
        ];
    }
}
