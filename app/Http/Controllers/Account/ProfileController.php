<?php

namespace App\Http\Controllers\Account;

use App\Models\PaymentGateway;
use App\Models\PaymentProvider;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\User;
use App\Http\Requests\UpdateUserProfile;
use Image;
use Storage;
use GeoIP;
use App\Models\BitDeals;
use Hash;
use Setting;

class ProfileController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
		$user = auth()->user();

		//var_dump(BitDeals::get_user_status(array('address'=>$user->bitcoin)));

        $currencies = ["AFA","ALL","DZD","USD","EUR","AOA","XCD","NOK","XCD","ARA","AMD","AWG","AUD","EUR","AZM","BSD","BHD","BDT","BBD","BYR","EUR","BZD","XAF","BMD","BTN","BOB","BAM","BWP","NOK","BRL","GBP","BND","BGN","XAF","BIF","KHR","XAF","CAD","CVE","KYD","XAF","XAF","CLF","CNY","AUD","AUD","COP","KMF","CDZ","XAF","NZD","CRC","HRK","CUP","EUR","CZK","DKK","DJF","XCD","DOP","TPE","USD","EGP","USD","XAF","ERN","EEK","ETB","FKP","DKK","FJD","EUR","EUR","EUR","EUR","XPF","EUR","XAF","GMD","GEL","EUR","GHC","GIP","EUR","DKK","XCD","EUR","USD","GTQ","GNS","GWP","GYD","HTG","AUD","EUR","HNL","HKD","HUF","ISK","INR","IDR","IRR","IQD","EUR","ILS","EUR","XAF","JMD","JPY","JOD","KZT","KES","AUD","KPW","KRW","KWD","KGS","LAK","LVL","LBP","LSL","LRD","LYD","CHF","LTL","EUR","MOP","MKD","MGF","MWK","MYR","MVR","XAF","EUR","USD","EUR","MRO","MUR","EUR","MXN","USD","MDL","EUR","MNT","XCD","MAD","MZM","MMK","NAD","AUD","NPR","EUR","ANG","XPF","NZD","NIC","XOF","NGN","NZD","AUD","USD","NOK","OMR","PKR","USD","PAB","PGK","PYG","PEI","PHP","NZD","PLN","EUR","USD","QAR","EUR","ROL","RUB","RWF","XCD","XCD","XCD","WST","EUR","STD","SAR","XOF","EUR","SCR","SLL","SGD","EUR","EUR","SBD","SOS","ZAR","GBP","EUR","LKR","SHP","EUR","SDG","SRG","NOK","SZL","SEK","CHF","SYP","TWD","TJR","TZS","THB","XAF","NZD","TOP","TTD","TND","TRY","TMM","USD","AUD","UGS","UAH","SUR","AED","GBP","USD","USD","UYU","UZS","VUV","VEF","VND","USD","USD","XPF","XOF","MAD","ZMK","USD"];
        $currencies = array_combine($currencies, $currencies);



        $currency = !empty($user->currency) ? $user->cu0rrency : Setting::get('currency', config('marketplace.currency'));

		$countries = [null=> 'Country...'] ;

		foreach (supported_locales() as $code => $country) {
            $countries[$code] = $country['name'];
        }

		$lat = GeoIP::getLatitude();
		$lng = GeoIP::getLongitude();

        if (strpos(auth()->user()->email, '@localhost.loc') === false) {
            $email = auth()->user()->email;
        } else {
            $email = auth()->user()->bitmessage;
        }


        $now_date = date('Y-m-d');

		return view('account.profile', compact('user', 'currencies', 'currency', 'countries', 'lat', 'lng', 'email', 'now_date'));
    }

    public function store(UpdateUserProfile $request)
    {
        $user = auth()->user();
        $old_country = $user->country;
        if($request->file('image')) {
            $image = Image::make($request->file('image'))
                    ->fit(300, 300, function ($constraint) {
                        $constraint->aspectRatio();
                        $constraint->upsize();
                    })
                    ->resizeCanvas(300, 300);
            Storage::cloud()->put('avatars/'.$user->path, (string) $image->encode());
            $user->avatar = Storage::cloud()->url("avatars/".$user->path);
            $user->save();
        }

        $user_data = $request->except(['email','password','password_confirmation']);

        if (!empty($request->input('email')) && !filter_var($request->input('email'), FILTER_VALIDATE_EMAIL)) {
            $user_data['bitmessage'] = $request->input('email');
        } else {
            $user_data['bitmessage'] = "";
        }

        if (!empty($request->input('email')) && filter_var($request->input('email'), FILTER_VALIDATE_EMAIL)) {
            $user_data['email'] = $request->input('email');
        } else {
            $user_data['email'] = $data['name'].time().'@localhost.loc';
        }

        $user->fill($user_data)->save();

        if($request->input('location') && $request->input('country')) {
            if($request->input('location')) {
                $user->address = $request->input('location');
            }

            if($request->input('country')) {
                $user->country = $request->input('country');
            }
            $user->save();
        }

		/*if($request->input('lat') && $request->input('lng')) {
            $lat = $request->input('lat');
            $lng = $request->input('lng');
            $user->location = \DB::raw("(ST_GeomFromText('POINT($lat $lng)'))");
        }*/

		if($request->input('currency')) {
            $user->currency = $request->input('currency');
            $user->save();
        }

		/*if($request->input('bitcoin_public_key')) {
            $user->bitcoin_public_key = $request->input('bitcoin_public_key');
            $user->save();
        }*/
		
		if($request->has('filters')) {
			foreach($request->input('filters') as $k => $v) {
				$user->filters[$k] = $v;
			}
			$user->save();
		}

        $bitcoin_address = $user->bitcoin;
        $bitmessage_address = $user->bitmessage;
        $sign = $user->sign;

        /*$bs_stat = false;
        if ($bitcoin_address) {
            $bs_stat = BitDeals::update_user(array('address' => $bitcoin_address, 'bitmessage' => $bitmessage_address, 'sign' => $sign));//, 'pgp' => $request->input('bitcoin_public_key', false)

            if(!empty($bs_stat->result) && !$bs_stat->result->success && !empty($bs_stat->result->message)) {
                alert()->error($bs_stat->result->message);

                return redirect(url()->previous());
            }
        }*/

        if (!empty($request->input('password')) && !empty($request->input('password_confirmation'))) {
            //$user = User::find(auth()->user()->id);
            $user->password = Hash::make($request->input('password'));
            $user->save();
        }

        if (empty($user->can_accept_payments)) {
            $provider = PaymentProvider::where('key', 'offline')->where('is_offline', 1)->first();
            $identifier = $provider->key . '_' . $user->id; //any random
            $payment_gateway = PaymentGateway::firstOrCreate([
                'name' => $provider->key,
                'gateway_id' => $identifier,
                'user_id' => $user->id
            ]);


            $user->can_accept_payments = true;
            $user->save();
        }

        $redirect = route('account.edit_profile.index');
        if ($old_country != $user->country) {

            $redirect = get_low_localized_url($user->country);

        }

        /*if(!empty($bs_stat->result) && !$bs_stat->result->success && !empty($bs_stat->result->message)) {
            alert()->error($bs_stat->result->message);
        } else {*/

            alert()->success(__('Successfully saved!'));
        //}
        return redirect($redirect);
    }

}
