<?php

namespace App\Http\Controllers\Payments;

use App\Models\bElectrum;
use App\Models\Order;
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
use Nahid\Talk\Conversations\Conversation;
use Talk;

/*
 * Methods
 *  index -> shows the payment page or redirects
 *  store -> processes the payment and redirects to the purchase history
 *
 */

class BaseController extends Controller
{

    public function error_page(Request $request) {
        dd(5);
    }

    protected function create_order($params) {
        #dd($params);
        $buyer_id = $params['buyer_id'];
        $seller_id = $params['seller_id'];
        $listing = $params['listing'];
        $pricing = $params['pricing'];
        $listing_options = collect($params['request']);
        $payment_provider = $params['payment_provider'];
        $payment_gateway_id = $params['payment_gateway_id'];
        $authorization_id = $params['authorization_id'];

        $order = new Order();
        $order->user_id = $buyer_id;
        $order->service_fee = $pricing['service_fee'];
        $order->payment_gateway_id = $payment_gateway_id;
        $order->amount = $pricing['total'];
        $order->currency = $listing->currency;
        $order->authorization_id = $authorization_id;
        $order->capture_id = null;
        $order->processor = $payment_provider->key;

        $order->seller_id = $seller_id;
        $order->listing_id = $listing->id;
        #$order->token = $request->get('token');
        $order->listing_options = $listing_options->except([
            'card', 'token'
        ]);

        $order->user_choices = $pricing['user_choice'];
        $order->shipping_address = $params['shipping_address'];
        $order->billing_address = $params['billing_address'];

        $order->setAttribute('listing_data', $listing);
      
        $order->save();

        if ($listing->pricing_model->meta->bd_type) {
            $until = "+1 day";
            if ($listing->pricing_model->meta->bd_type == 'mediation') {
                $listing_shipping = $order->listing->shipping_options->firstWhere('id', $order->listing_options['shipping_option']);

                if ((int)$listing_shipping->delivery_days) {
                    $until = "+".((int)$listing_shipping->delivery_days*2.5)." days";
                }
            }

            $convert = new Converter;
            $order->payment_address = '';//bElectrum::generateAddress();
            $order->payment_until = date('Y-m-d H:i:s', strtotime('+5 hours'));

            if(!empty($pricing['total_btc'])) {
                $btc_payment_sum = $pricing['total_btc'];
            } else {
                $btc_payment_sum = $convert->toBtc($pricing['total'], $listing->currency);
            }

            $order->setAttribute('bd_type', $listing->pricing_model->meta->bd_type);
            $order->setAttribute('is_return', $listing->is_return);
            $order->setAttribute('btc_payment_sum', $btc_payment_sum);
            $order->setAttribute('timestamp', time());
            $order->setAttribute('end_timestamp', strtotime($until));

            $order->save();
        }

        if ($listing->deal_comment) {
            $comments = explode('---', $listing->deal_comment);
            $comment = array_shift($comments);

            $listing->deal_comment = ($comments) ? implode('---', $comments) : $comment;
            $listing->save();

            if ($comment) {
                $conversation_id = 0;

                Talk::setAuthUserId($order->seller_id);

                $message = Talk::sendMessageByUserId($conversation_id, $comment);

                if (!$conversation_id && !empty($message->conversation_id)) {
                    $order->conversation_id = $message->conversation_id;
                    $order->save();

                    $conversation = Conversation::find($message->conversation_id);
                    $conversation->user_one = $order->seller_id;
                    $conversation->user_two = $order->user_id;
                    $conversation->status = 2;
                    $conversation->update();
                }
            }
        }

        return $order;
    }

}
