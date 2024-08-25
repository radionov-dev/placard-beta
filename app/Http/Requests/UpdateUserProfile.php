<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateUserProfile extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return auth()->check();
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        $data = [
            'username' => 'required|unique:users,username,'.auth()->user()->id.'|max:255',
            'bitcoin'  => 'required|string|min:32|unique:users,bitcoin,'.auth()->user()->id,
            //'bitmessage'  => 'required|string|min:35|unique:users,bitmessage,'.auth()->user()->id,
        ];

        if (!empty($this->post('email')) && filter_var($this->post('email'), FILTER_VALIDATE_EMAIL)) {
            $data['email']  = 'required|string|email|max:255|unique:users,email,'.auth()->user()->id;
        } else {
            $data['email']  = 'required|string|min:35|unique:users,bitmessage,'.auth()->user()->id;
        }

        if (!empty($this->post('password')) || !empty($this->post('password_confirmation'))) {
            $data['password']  = 'required|confirmed|min:6';
        }

         return $data;
    }
}
