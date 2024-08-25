<?php

namespace App\Http\Controllers\Payments;

use App\Models\BitDeals;
use App\Models\PaymentGateway;
use App\Models\PaymentProvider;
use Hashids;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\User;
use App\Http\Requests\UpdateUserProfile;
use Image;
use Jimmerioles\BitcoinCurrencyConverter\Converter;
use Storage;
use GeoIP;
use Date;
use App\Events\OrderPlaced;

/*
 * Methods
 *  index -> shows the payment page or redirects
 *  store -> processes the payment and redirects to the purchase history
 *
 */

class OfflineController extends BaseController
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index($session, Request $request)
    {
        $listing = $session->listing;
        #calculate the real price of the order
        $widget = '\App\Widgets\Order\\'.studly_case($listing->pricing_model->widget).'Widget';
        $widget = new $widget();
        $pricing = $widget->validate_payment($listing, $session->request);

        #if no identifier create one
        if(!$session->payment_provider->identifier) {
            //dd("Error");
        }
        #dd($session->payment_provider->identifier);

        #now we simply place the order
        $transaction_id = Hashids::encode($session->id);
        $order_params = [
            'buyer_id' => auth()->user()->id,
            'seller_id' => $listing->user->id,
            'authorization_id' => $transaction_id,
            'pricing' => $pricing,
            'request' => $session->request,
            'payment_provider' => $session->payment_provider,
            'payment_gateway_id' => $session->payment_provider->identifier->id,
            'shipping_address' => $session->extra_attributes['shipping_address'],
            'billing_address' => $session->extra_attributes['billing_address'],
            'listing' => $session->listing,
        ];
        #dd($order_params);
        $order = $this->create_order($order_params);

        if (auth()->check() && !empty(auth()->user()->bitcoin) && !empty($listing->user->bitcoin) && !empty($order->getAttribute('bd_type'))) {
            $status_buyer = BitDeals::get_user_status(array('address' => auth()->user()->bitcoin));
            $status_seller = BitDeals::get_user_status(array('address' => $listing->user->bitcoin));

            if (!empty($status_buyer->result) && empty($status_buyer->result->success)) {
                BitDeals::new_user(array('address' => auth()->user()->bitcoin));
            }

            if (!empty($status_seller->result) && empty($status_seller->result->success)) {
                BitDeals::new_user(array('address' => $listing->user->bitcoin));
            }

            $bd_type = $order->getAttribute('bd_type');

            if ($bd_type == 'mediation' || $bd_type == 'Mediation') {
                $bd_type = 'postpayment';
            }

            $deal = BitDeals::create_deal(array(
                'order' => 'Create',
                'type' => $bd_type,
                'at' => url('/'),
                'date' => date("Y-m-d H:i:s", $order->getAttribute('timestamp')). ' UTC',
                'seller_address' => $listing->user->bitcoin,
                'customer_address' => auth()->user()->bitcoin,
                'payment_sum' => $order->getAttribute('btc_payment_sum'),
                'payment_until' => date("Y-m-d H:i:s", strtotime($order->payment_until)). ' UTC',
                'feedback_leave_before' => date("Y-m-d H:i:s", $order->getAttribute('end_timestamp')). ' UTC',
            ));

            if(!empty($deal->result) && !$deal->result->success && !empty($deal->result->message)) {
                alert()->error($deal->result->message);
                //exit;

                return redirect(url()->previous());
            }

            $payload = nl2br(base64_decode($deal->payload));
            $payload_p = explode('payment:', $payload);
            if (isset($payload_p[1])) {
                $payload_pa = explode('address:', $payload_p[1]);
                if (isset($payload_pa[1])) {
                    $payload_pae = explode('<br />', $payload_pa[1]);
                    $payment_address = trim($payload_pae[0]);

                    $order->payment_address = $payment_address;
                    $order->save();

                    //var_dump($payment_address);
                }
            }
            //exit;

            /*var_dump(array(
                'order' => $order->hash,
                'type' => $bd_type,
                'at' => url('/'),
                'date' => date("Y-m-d H:i:s", $order->getAttribute('timestamp')). ' UTC',
                'seller_address' => $listing->user->bitcoin,
                'customer_address' => auth()->user()->bitcoin,
                'payment_sum' => $order->getAttribute('btc_payment_sum')
            ));
            var_dump($deal);*/

            /*if ($order->payment_address && $order->payment_until) {
                $seller_rating = $listing->user->totalCommentCount() . ", " . round(($listing->user->averageRate()/3)*100) . "%";
                $customer_rating = auth()->user()->totalCommentCount() . ", " . round((auth()->user()->averageRate()/3)*100) . "%";

                $d1 = $deal = BitDeals::pay_deal(array(
                    'order' => $order->hash,
                    'type' => $bd_type,
                    'at' => url('/'),
                    'date' => date("Y-m-d H:i:s", $order->getAttribute('timestamp')). ' UTC',
                    'seller_address' => $listing->user->bitcoin,
                    'seller_rating' => $seller_rating,
                    'customer_address' => auth()->user()->bitcoin,
                    'customer_rating' => $customer_rating,
                    'payment_sum' => $order->getAttribute('btc_payment_sum'),
                    'payment_address' => $order->payment_address,
                    'payment_until' => date("Y-m-d H:i:s", strtotime($order->payment_until)). ' UTC',
                    'feedback_leave_before' => date("Y-m-d H:i:s", $order->getAttribute('end_timestamp')). ' UTC'
                ));
                var_dump(array(
                    'order' => $order->hash,
                    'type' => $bd_type,
                    'at' => url('/'),
                    'date' => date("Y-m-d H:i:s", $order->getAttribute('timestamp')). ' UTC',
                    'seller_address' => $listing->user->bitcoin,
                    'seller_rating' => $seller_rating,
                    'customer_address' => auth()->user()->bitcoin,
                    'customer_rating' => $customer_rating,
                    'payment_sum' => $order->getAttribute('btc_payment_sum'),
                    'payment_address' => $order->payment_address,
                    'payment_until' => date("Y-m-d H:i:s", strtotime($order->payment_until)). ' UTC',
                    'feedback_leave_before' => date("Y-m-d H:i:s", $order->getAttribute('end_timestamp')). ' UTC'
                ));
                var_dump($d1);
            }*/
        }

        //exit;

        //now decrease listing quantity
        event(new OrderPlaced($order));

        #call widget and do processing there
        //$widget = '\App\Widgets\Order\\'.camel_case($listing->pricing_model->widget).'Widget';
        //$widget = new $widget();
        //$widget->decrease_stock($order, $listing);
        //alert()->success(__('Your reservation was placed successfully. Your order number is '.$order->hash));

        return redirect()->route('account.orders.show', $order);
    }

    public function connect($key, Request $request)
    {
        $provider = PaymentProvider::where('key', $key)->where('is_offline', 1)->first();
        $user = auth()->user();

        #$identifier = $request->input('identifier');
        #$provider = PaymentProvider::find($provider);
        $identifier = $provider->key .'_'.$user->id; //any random

        $user = auth()->user();
        $payment_gateway = PaymentGateway::firstOrCreate([
            'name' => $provider->key,
            'gateway_id' => $identifier,
            'user_id' => $user->id
        ]);


        $user->can_accept_payments = true;
        $user->save();

        alert()->success(__('You can now accept payments and start selling.'));

        return redirect()->route('account.bank-account.index');
    }

    public function store(Request $request)
    {
        dd($request->all());
        return view('checkout.cash_on_delivery');
    }

    public function accept($order) {

        return uniqid();
    }

    public function decline($order) {
        return uniqid();
    }

    //this is for a custom callback method
    /* public function unlink($provider, Request $request) {
         $provider = PaymentProvider::find($provider);
         $provider->identifier->delete();

         alert()->success(__('Unlinked account'));
         return redirect()->route('account.bank-account.index');
     }

     public function callback($provider, Request $request) {

         $identifier = $request->input('identifier');
         $provider = PaymentProvider::find($provider);

         $user = auth()->user();
         $payment_gateway = PaymentGateway::firstOrCreate([
             'name' => $provider->key,
             'gateway_id' => $identifier,
             'user_id' => $user->id
         ]);

         alert()->success(__('Awesome! You can now accept payments and start selling.'));

         return redirect()->route('account.bank-account.index');
     }*/

}
