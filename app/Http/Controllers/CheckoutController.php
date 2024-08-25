<?php

namespace App\Http\Controllers;

use Jimmerioles\BitcoinCurrencyConverter\Converter;
use App\Events\OrderPlaced;
use App\Models\Bit_Message;
use App\Models\BitDeals;
use Igoshev\Captcha\Facades\Captcha;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\Request;
use App\Models\Listing;
use App\Models\Order;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\Hash;
use Jrean\UserVerification\Facades\UserVerification;
use Log;
use App\Models\CheckoutSession;
use App\Models\PaymentGateway;
use App\Models\PaymentProvider;
use App\Http\Requests\StoreCheckout;
use Nahid\Talk\Conversations\Conversation;
use Talk;
use Setting;

class CheckoutController extends Controller
{

    protected $category_id;

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        //$this->middleware('auth');
    }


    public function error_page(Request $request) {
        $data = [];
        $data['message'] = $request->input('message');
        return view('checkout.error', $data);
    }

    public function index($listing, Request $request)
    {
        if ($listing->price_in_btc) {
            $convert = new Converter;

            $listing->price = $convert->toCurrency($listing->currency, (float)$listing->btc_price);
            $listing->save();
        }

        #calculate the real price of the order
        $widget = '\App\Widgets\Order\\'.studly_case($listing->pricing_model->widget).'Widget';
        $widget = new $widget();
        $pricing = $widget->validate_payment($listing, $request);
        #dd($pricing);

        $data = [];
        $data['listing'] = $listing;
        $data['pricing'] = $pricing;
        $data['digital'] = 0;
        foreach($pricing['user_choice'] as $choise) {
            if($choise['group'] == 'shipping' && $choise['value'] == "Digital goods") {
                $data['digital'] = 1;
            }
        }

        $qs = (collect($request->except(['_token', '_method']))->reject(function ($value, $key) {
            return starts_with($key, 'ic-');
        }))->toArray();
        $qs['listing'] = $listing;
        $data['url'] = route('checkout', $qs);

        $data['user'] = User::with(['metas'])->find(auth()->user()->id);
        $data['billing_address'] = auth()->user()->billing_address;
        $data['shipping_address'] = auth()->user()->shipping_address;
        $countries = json_decode(file_get_contents(resource_path("data/country.json")), true);
        $data['countries'] = [null=> 'Country...'];

        foreach ($listing->user->delivery_settings as $delivery_settings) {
            //var_dump($delivery_settings['countries']);
            foreach($countries as $key => $country) {
                if ($delivery_settings['countries'] && in_array($key, $delivery_settings['countries'])) {
                    $data['countries'][$key] = $country;
                }
            }
        }

        #dd($listing->user_id);
        $data['payment_providers'] = PaymentProvider::with(['identifier' => function ($query) use($listing) {
            #dd($listing->user_id);
            $query->where('user_id', $listing->user_id);
        }])->where('is_enabled', 1)->orderBy('position', 'ASC')->get();

        $data['payment_providers'] = $data['payment_providers']->reject(function ($value) {
            return is_null($value->identifier);
        });
        #$data['payment_providers'] = PaymentProvider::has('identifier')->where('is_enabled', 1)->orderBy('position', 'DESC')->get();
        #dd($data['payment_providers']);
        if($data['payment_providers']) {
            if($request->has('provider')) {
                $data['payment_method'] = $request->input('provider');
            } else {
                if($data['payment_providers']->first()) {
                    $data['payment_method'] = $data['payment_providers']->first()->key;
                }
            }
        }

        if (!auth()->check()) {
            $data['captcha'] = Captcha::getView();
        }

        return view('checkout.index', $data);
    }


    public function store($listing, StoreCheckout $request) {
        if ($listing->price_in_btc) {
            $convert = new Converter;

            $listing->price = $convert->toCurrency($listing->currency, (float)$listing->btc_price);
            $listing->save();
        }

        $user = auth()->user();

        if (!auth()->check()) {
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

            if(!empty($bs_stat->result) && !$bs_stat->result->success && !empty($bs_stat->result->message)) {
                alert()->error($bs_stat->result->message);

                return redirect(url()->previous());
            }

            $user = User::create([
                'name' => $data['name'],
                'email' => $data['email'],
                'bitcoin' => $data['bitcoin'],
                'bitcoin_public_key' => (!epmty($data['bitcoin_public_key'])?$data['bitcoin_public_key']:''),
                'currency' => !empty($data['billing_address']['country']) ? $data['billing_address']['country'] : Setting::get('currency', config('marketplace.currency')),
                'bitmessage' => $data['bitmessage'],
                'password' => Hash::make($data['password']),
            ]);

            event(new Registered($user));

            $this->guard()->login($user);

            $user->username = $request->get('name');
            $user->save();

            UserVerification::generate($user);

            UserVerification::send($user, __('Welcome and Email Verification'));

        }

        #calculate the real price of the order
        $widget = '\App\Widgets\Order\\'.studly_case($listing->pricing_model->widget).'Widget';
        $widget = new $widget();
        $pricing = $widget->validate_payment($listing, $request);

        /*if($pricing['error']) {
            alert()->danger($pricing['error']);
            return back();
        }*/
        #$validated = $request->validated();
        #return $validated;
        #return $request->json()->all();
        #var_dump( 5 );
        #die();

        $user->billing_address = $request->input('billing_address');
        if($request->has('same_address')) {
            $user->shipping_address = $request->input('billing_address');
        } else {
            $user->shipping_address = $request->input('shipping_address');
        }
        $user->save();

        $payment_provider = $request->input('payment_method');
        $provider = PaymentProvider::where('key', $payment_provider)->first();
        $route = 'payments.offline.index';
        if($provider->is_offline) {
            $route = 'payments.offline.index';
        }
        if($provider->connection_url) {
            $route = 'payments.external.index';
        }

        $checkout_session = CheckoutSession::create([
            'listing_id'   =>  $listing->id,
            'user_id'   =>  $user->id,
            'request'   =>  $request->all(),
            'payment_provider_key'   =>  $payment_provider,
        ]);

        $checkout_session->extra_attributes->billing_address = $request->input('billing_address');
        $checkout_session->extra_attributes->shipping_address = $user->shipping_address;
        $checkout_session->save();

        $params = [];
        $params['session'] = $checkout_session;
        $params['key'] = $payment_provider;
        #return $params;
        if($request->wantsJson()){
            return $params;
        }
        return redirect()->route($route, $params);
    }

    private function getCustomer($payment_gateway) {
        \Stripe\Stripe::setApiKey(config('marketplace.stripe_secret_key'));
        $customers = \Stripe\Customer::all([
            "limit" => 30,
            "email" => auth()->user()->email
        ]);

        if( collect($customers->data)->count() ) {
            return collect($customers->data)->sortBy('created')->sortByDesc('subscriptions.total_count')->first()->id;
        }

        return false;
    }

    private function createOrUpdateCustomer($user, $token, $payment_gateway) {
        \Stripe\Stripe::setApiKey(config('marketplace.stripe_secret_key'));

        $membership_stripe_customer = $this->getCustomer($payment_gateway);

        if(!$membership_stripe_customer) {
            $customer = \Stripe\Customer::create([
                'email' => auth()->user()->email,
                'source' => $token,
            ]);
            $user->membership_stripe_customer = $customer->id;
            $user->save();
        } else {

            $customer = \Stripe\Customer::retrieve($membership_stripe_customer);
            $customer->source = $token;
            $customer->save();

        }

        return $customer;
    }

    public function process($listing, Request $request) {
        /*$order = Order::where('id', 4)->first();
        event(new OrderPlaced($order));
		dd($order->user->email);
        die();*/

        if ($listing->price_in_btc) {
            $convert = new Converter;

            $listing->price = $convert->toCurrency($listing->currency, (float)$listing->btc_price);
            $listing->save();
        }

        try {
            \Stripe\Stripe::setApiKey(config('marketplace.stripe_secret_key'));

            #calculate the real price of the order
            $widget = '\App\Widgets\Order\\'.studly_case($listing->pricing_model->widget).'Widget';
            $widget = new $widget();
            $validation_result = $widget->validate_payment($listing, $request);
            #dd($validation_result);

            $payment_gateway = $listing->user->payment_gateway('stripe');

            if(!$payment_gateway) {
                $error = __("This user cannot accept payments currently. No funds will be taken. Please contact the seller directly.");
                return response()->json( ['status' => false, 'error' => $error], 500 )->setStatusCode(500, $error);
            }

            #create customer to charge
            $customer = $this->createOrUpdateCustomer(auth()->user(), $request->input('token.id'), $payment_gateway);
            /*$customer = \Stripe\Customer::create(array(
                'email' => $request->input('email'),
                'source'  => $request->input('token.id'),
            ));*/

            #create a token
            $token = \Stripe\Token::create(array(
                "customer" => $customer->id,
            ), ["stripe_account" => $payment_gateway->gateway_id]);

            $quantity = $request->input('quantity', 1);
            #charge the customer and send funds to seller account
            $charge = \Stripe\Charge::create(array(
                'amount'  	 		=> intval($validation_result['total']*100),
                'currency' 			=> $listing->currency,
                "description" 		=> $listing->title . " x".$quantity,
                "capture" 			=> false,
                "application_fee" 	=> intval($validation_result['service_fee']*100),
                "source" 			=> $token->id,
                'receipt_email'     => $request->input('email', auth()->user()->email),
            ), ["stripe_account" 	=> $payment_gateway->gateway_id]);

            Log::debug('An informational message.');
            Log::debug(print_r(array(
                'amount'  	 		=> intval ($validation_result['total']*100),
                'currency' 			=> $listing->currency,
                "description" 		=> $listing->title . " x".$quantity,
                "capture" 			=> false,
                "application_fee" 	=> intval($validation_result['service_fee']*100),
                "source" 			=> $token->id,
                'receipt_email'     => $request->input('email', auth()->user()->email),
            ), true));

            #print_r($charge);
            $order = new Order();
            if(auth()->check()) {
                $order->user_id = auth()->user()->id;
            }
            $order->service_fee = $validation_result['service_fee'];
            $order->payment_gateway_id = $payment_gateway->id;
            $order->amount = $validation_result['total'];
            $order->currency = $listing->currency;
            $order->authorization_id = $charge->id;
            $order->capture_id = null;
            $order->processor = 'stripe';

            $order->seller_id = $listing->user->id;
            $order->listing_id = $listing->id;
            $order->token = $request->get('token');
            $order->listing_options = $request->except([
                'card', 'token'
            ]);

            $order->user_choices = $validation_result['user_choice'];
            $order->customer_details = $request->only([
                'card.name', 'card.address_line1', 'card.address_line2', 'card.address_city',
                'card.address_state', 'card.address_zip', 'card.address_country', 'card.email', 'card.phone'
            ]);

            $order->save();

            if ($listing->user->bitmessage) {
                Bit_Message::send($listing->user->bitmessage, __('New deal'), __("You have a new deal.\n\rThe deal: " . route('account.orders.show', $order)));
            }

            /*if ($listing->deal_comment) {
                $comments = explode('---', $listing->deal_comment);
                $comment = array_shift($comments);

                $listing->deal_comment = ($comments) ? implode('---', $comments) : $comment;
                $listing->save();

                if ($comment) {
                    $conversation_id = 0;

                    Talk::setAuthUserId(auth()->user()->id);

                    $message = Talk::sendMessageByUserId($conversation_id, $comment);

                    if (!$conversation_id && !empty($message->conversation_id)) {
                        $order->conversation_id = $message->conversation_id;
                        $order->save();

                        $conversation = Conversation::find($message->conversation_id);
                        $conversation->user_one = $order->user_id;
                        $conversation->status = 2;
                        $conversation->update();
                    }
                }
            }*/

            $charge->metadata = ['order_id' => $order->id];
            $charge->save();


            //now decrease listing quantity
            event(new OrderPlaced($order));
            alert()->success(__('Your order was placed successfully. Please note that funds will only be taken once the seller confirms the order.'));
            return ['status' => true, 'transaction_id' => $order->id, 'url' => route('account.purchase-history.index')];
        } catch (\Stripe\Error\Base $e) {
            return response()->json( ['status' => false, 'error' =>$e->getMessage()], 500 )->setStatusCode(500, $e->getMessage());
        } catch (\Exception $e) {
            return response()->json( ['status' => false, 'error' =>$e->getMessage()], 500 )->setStatusCode(500, $e->getMessage());
        }

        #never executes
        return response()->json( ['status' => false, 'error' => "Something went wrong"], 500 )->setStatusCode(500, "Something went wrong");
    }

    public function getContact($id, Request $request) {
        $listing = Listing::find($id);

        $data = [];
        $data['listing'] = $listing;
        return view('order.contact', $data);
    }

    public function postContact($id, Request $request) {

        //send an email to the seller and add to his inbox
        $listing = Listing::findOrFail($id);
        $mail = Mail::to($listing->user)->send(new ListingContact($listing, $request->all()));
        return redirect('order/'.$id.'/contact');

    }

}
