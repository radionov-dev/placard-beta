<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\SendsPasswordResetEmails;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;

class ForgotPasswordController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Password Reset Controller
    |--------------------------------------------------------------------------
    |
    | This controller is responsible for handling password reset emails and
    | includes a trait which assists in sending these notifications from
    | your application to your users. Feel free to explore this trait.
    |
    */

    use SendsPasswordResetEmails;

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest');
    }

    public function showLinkRequestForm()
    {
        return view('auth.passwords.email');
    }

    public function reset(Request $request){
        return $this->sendResetLinkEmail($request);
    }

    public function sendResetLinkEmail(Request $request)
    {
        $this->validateEmail($request);

        $data = [];

        if (!empty($request->input('email')) && filter_var($request->input('email'), FILTER_VALIDATE_EMAIL)) {
            $data['email'] = $request->input('email');
        } else {
            $data['bitmessage'] = $request->input('email');
        }

        // We will send the password reset link to this user. Once we have attempted
        // to send the link, we will examine the response then see the message we
        // need to show to the user. Finally, we'll send out a proper response.
        $response = $this->broker()->sendResetLink(
            $data
        );

        return $response == Password::RESET_LINK_SENT
            ? $this->sendResetLinkResponse($response)
            : $this->sendResetLinkFailedResponse($request, $response);
    }

    protected function validateEmail(Request $request)
    {
        $data = [];

        if (!empty($request->input('email')) && filter_var($request->input('email'), FILTER_VALIDATE_EMAIL)) {
            $data['email'] = 'required|email';
        } else {
            $data['email'] = 'required|string|min:35';
        }

        $this->validate($request, $data);
    }
}
