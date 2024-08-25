<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\ResetsPasswords;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;

class ResetPasswordController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Password Reset Controller
    |--------------------------------------------------------------------------
    |
    | This controller is responsible for handling password reset requests
    | and uses a simple trait to include this behavior. You're free to
    | explore this trait and override any methods you wish to tweak.
    |
    */

    use ResetsPasswords;

    /**
     * Where to redirect users after resetting their password.
     *
     * @var string
     */
    protected $redirectTo = '/account';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest');
    }

    public function reset(Request $request)
    {
        $this->validate($request, $this->rules($request), $this->validationErrorMessages());

        $data = $request->only(
            'email', 'password', 'password_confirmation', 'token'
        );

        if (empty($data['email']) || !filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            $data['bitmessage'] = $data['email'];
            unset($data['email']);
        }

        // Here we will attempt to reset the user's password. If it is successful we
        // will update the password on an actual user model and persist it to the
        // database. Otherwise we will parse the error and return the response.
        $response = $this->broker()->reset(
            $data, function ($user, $password) {
            $this->resetPassword($user, $password);
        }
        );

        // If the password was successfully reset, we will redirect the user back to
        // the application's home authenticated view. If there is an error we can
        // redirect them back to where they came from with their error message.
        return $response == Password::PASSWORD_RESET
            ? $this->sendResetResponse($response)
            : $this->sendResetFailedResponse($request, $response);
    }

    /**
     * Get the password reset validation rules.
     *
     * @return array
     */
    protected function rules(Request $request = null)
    {
        if (!empty($request->input('email')) && filter_var($request->input('email'), FILTER_VALIDATE_EMAIL)) {
            return [
                'token' => 'required',
                'email' => 'required|email',
                'password' => 'required|confirmed|min:6',
            ];
        } else {
            return [
                'token' => 'required',
                'email' => 'required|string|min:35',
                'password' => 'required|confirmed|min:6',
            ];
        }
    }
}
