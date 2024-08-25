<?php

namespace App\Http\Controllers\Auth;

use App\Events\EmailVerified;
use App\Models\PaymentGateway;
use App\Models\PaymentProvider;
use App\Models\User;
use App\Http\Controllers\Controller;
use Illuminate\Auth\Events\Registered;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Foundation\Auth\RegistersUsers;
use Jrean\UserVerification\Traits\VerifiesUsers;
use Jrean\UserVerification\Facades\UserVerification;
use Illuminate\Http\Request;
use MetaTag;
use App\Models\Role;
use Setting;
use App\Models\Bit_Message;
use App\Models\BitDeals;
use Igoshev\Captcha\Facades\Captcha;

class RegisterController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Register Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles the registration of new users as well as their
    | validation and creation. By default this controller uses a trait to
    | provide this functionality without requiring any additional code.
    |
    */

    use RegistersUsers;
    use VerifiesUsers;

    /**
     * Where to redirect users after registration.
     *
     * @var string
     */
    protected $redirectTo = '/';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest');
    }

    /**
     * Get a validator for an incoming registration request.
     *
     * @param  array  $data
     * @return \Illuminate\Contracts\Validation\Validator
     */
    protected function validator(array $data)
    {
        $messages = [
            'indisposable' => __('Disposable email addresses are not allowed.'),
        ];

        $vdata = [
            'name' => 'required|string|max:255',
            'password' => 'required|string|min:6|confirmed',
            'bitcoin' => 'required|string|min:32|unique:users',
            'captcha' => 'required|captcha',
            //'terms' => 'required',
        ];

        if (!empty($data['email']) && filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            $vdata['email'] = 'required|string|email|max:255|unique:users'; #indisposable
        } else {
            $vdata['email'] = 'required|string|min:35|unique:users,bitmessage';
        }

        return Validator::make($data, $vdata, $messages);
    }

    /**
     * Create a new user instance after a valid registration.
     *
     * @param  array  $data
     * @return \App\Models\User
     */
    protected function create(array $data)
    {
        if (!empty($data['email']) && !filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            $data['bitmessage'] = $data['email'];
        }
        if (empty($data['email']) || !filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            $data['email'] = $data['name'].time().'@localhost.loc';
        }

        return User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'bitcoin' => $data['bitcoin'],
            'currency' => $data['currency'],
            'bitmessage' => $data['bitmessage'],
            'password' => Hash::make($data['password']),
        ]);
    }

    protected function redirectTo() {
        return '/path';
    }

    public function showRegistrationForm()
    {
        MetaTag::set('title', __("Register"));
        session()->put('from', request('redirect')?:url()->previous());

        $currencies = ["AFA","ALL","DZD","USD","EUR","AOA","XCD","NOK","XCD","ARA","AMD","AWG","AUD","EUR","AZM","BSD","BHD","BDT","BBD","BYR","EUR","BZD","XAF","BMD","BTN","BOB","BAM","BWP","NOK","BRL","GBP","BND","BGN","XAF","BIF","KHR","XAF","CAD","CVE","KYD","XAF","XAF","CLF","CNY","AUD","AUD","COP","KMF","CDZ","XAF","NZD","CRC","HRK","CUP","EUR","CZK","DKK","DJF","XCD","DOP","TPE","USD","EGP","USD","XAF","ERN","EEK","ETB","FKP","DKK","FJD","EUR","EUR","EUR","EUR","XPF","EUR","XAF","GMD","GEL","EUR","GHC","GIP","EUR","DKK","XCD","EUR","USD","GTQ","GNS","GWP","GYD","HTG","AUD","EUR","HNL","HKD","HUF","ISK","INR","IDR","IRR","IQD","EUR","ILS","EUR","XAF","JMD","JPY","JOD","KZT","KES","AUD","KPW","KRW","KWD","KGS","LAK","LVL","LBP","LSL","LRD","LYD","CHF","LTL","EUR","MOP","MKD","MGF","MWK","MYR","MVR","XAF","EUR","USD","EUR","MRO","MUR","EUR","MXN","USD","MDL","EUR","MNT","XCD","MAD","MZM","MMK","NAD","AUD","NPR","EUR","ANG","XPF","NZD","NIC","XOF","NGN","NZD","AUD","USD","NOK","OMR","PKR","USD","PAB","PGK","PYG","PEI","PHP","NZD","PLN","EUR","USD","QAR","EUR","ROL","RUB","RWF","XCD","XCD","XCD","WST","EUR","STD","SAR","XOF","EUR","SCR","SLL","SGD","EUR","EUR","SBD","SOS","ZAR","GBP","EUR","LKR","SHP","EUR","SDG","SRG","NOK","SZL","SEK","CHF","SYP","TWD","TJR","TZS","THB","XAF","NZD","TOP","TTD","TND","TRY","TMM","USD","AUD","UGS","UAH","SUR","AED","GBP","USD","USD","UYU","UZS","VUV","VEF","VND","USD","USD","XPF","XOF","MAD","ZMK","USD"];
        $currencies = array_combine($currencies, $currencies);
        $currency = Setting::get('currency', config('marketplace.currency'));

        $roles = Role::get();
        $selectable_roles = [];
        foreach($roles as $role) {
            if($role->getMeta('selectable'))
                $selectable_roles[$role->id] = $role;
        }

        $captcha = Captcha::getView();

        return view('auth.register', compact('selectable_roles', 'currencies', 'currency', 'captcha'));
    }

    /**
     * Handle a registration request for the application.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function register(Request $request)
    {
        $this->validator($request->all())->validate();

        $data = $request->all();

        if (!empty($data['email']) && !filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            $data['bitmessage'] = $data['email'];
        } else {
            $data['bitmessage'] = "";
        }

        if (empty($data['email']) || !filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            $data['email'] = $data['name'].time().'@localhost.loc';
        }

        $bs_data = array('address' => $data['bitcoin']);

        if (!empty($data['bitmessage'])) {
            $bs_data['bitmessage'] = $data['bitmessage'];
        }

        if (!empty($data['sign'])) {
            $bs_data['sign'] = $data['sign'];
        }

        $bs_stat = BitDeals::add_user($bs_data);

        //var_dump($bs_stat);
        //exit;

        if(!empty($bs_stat->result) && !$bs_stat->result->success && !empty($bs_stat->result->message)) {
            alert()->error($bs_stat->result->message);

            //var_dump($bs_data);
            //var_dump($bs_stat);
            //exit;

            return redirect(url()->previous())->withInput($request->all());;
        }

        //var_dump($bs_stat);
        //exit;

        $user = $this->create($data);

        event(new Registered($user));

        $this->guard()->login($user);

        $user->username = $data['bitcoin'];
        $user->bitmessage = $data['bitmessage'];
        $user->email = $data['email'];
      
        if(!empty($data['country'])) {
          $user->country = $data['country'];
        }
      
        $user->save();

        UserVerification::generate($user);

        if ($data['bitmessage']) {
            Bit_Message::send($data['bitmessage'], __('Welcome and Verification'), __("Hello $user->username, you have been registered at " . config('app.name') . ".\n\rPlease confirm you e-mail address by follow the link: " . route('email-verification.check', $user->verification_token) . '?email=' . urlencode($user->email)));
        } else {
            UserVerification::send($user, __('Welcome and Verification'));
        }

        $user->assignRole('member'); //make a member
        if($request->has('role')) {
            $role = Role::find($request->input('role'));
            if($role->getMeta('selectable')) {
                $user->assignRole($role);
                $user->save();
            }
        }

        $provider = PaymentProvider::where('key', 'offline')->where('is_offline', 1)->first();
        $identifier = $provider->key . '_' . $user->id; //any random
        $payment_gateway = PaymentGateway::firstOrCreate([
            'name' => $provider->key,
            'gateway_id' => $identifier,
            'user_id' => $user->id
        ]);


        $user->can_accept_payments = true;
        $user->save();

        //var_dump($a);  exit;

        return $this->registered($request, $user)
            ?: redirect(route("email-verification.index"));
    }

    public function check_bs_user(Request $request) {
        $data = $request->all();

        if(!empty($data['bitcoin'])) {
            $bs_data = array('address' => $data['bitcoin']);

            $bs_stat = BitDeals::get_user_status($bs_data);

            $data['url'] = [];

            if (!empty($bs_stat->result) && empty($bs_stat->result->success)) {
                $data['user_status'] = 0;
            } else {
                $info = BitDeals::user_profile($bs_data);
                if(!empty($info['urltrusted'])) {
                    $data['url'] = $info['urltrusted'];
                }
                if(!in_array(url('/'), $data['url'])) {
                    $data['url'][] = url('/');
                }

                $data['sign_html'] = date('Y-m-d') . "<br>\n" . $data['bitcoin'] . "<br>\n" . implode("<br>\n", $data['url']);

                $data['user_status'] = 1;
            }
        } else {
            $data['user_status'] = 0;
        }


        return response()->json($data);
    }
}
