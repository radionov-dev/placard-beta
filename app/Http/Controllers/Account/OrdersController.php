<?php

namespace App\Http\Controllers\Account;

use App\Mail\AcceptPurchase;
use App\Mail\DeclinePurchase;
use App\Mail\ReceiveMessage;
use App\Models\Bit_Message;
use App\Models\BitDeals;
use App\Models\Comment;
use App\Models\Filter;
use App\Models\Message;
use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Order;
use Carbon\Carbon;
use Mail;
use Nahid\Talk\Conversations\Conversation;
use Talk;
use Image;
use Storage;
use App\Http\Controllers\BrowseController;
use App\Models\Category;
use App\Widgets\Order\BuyWidget as buyWidget;

class OrdersController extends Controller
{

    public function index(Request $request)
    {

        $filter_status = $request->input('status', false);

        $orders = Order::with('listing', 'user', 'comments');

        if (auth()->check() && auth()->user()->can('edit order') && !$filter_status) {
            $orders = $orders->where('status', 'dispute')->orWhere(function($query) {
                $query->where(function($query) {
                    $query->where('orders.seller_id', auth()->user()->id)
                      ->where('orders.status', '!=', 'open')
                      ->orWhere(function($query) {
                        $query->where('orders.seller_id', auth()->user()->id)
                          ->whereNotNull('orders.payment_address')
                          ->whereNotNull('orders.payment_until')
                          ->whereDate('orders.payment_until', '>=', time());
                        });
                    })
                   ->orWhere('orders.user_id', auth()->user()->id);
            });
        } else {
            $orders = $orders->where(function($query) {
                $query->where(function($query) {
                    $query->where('orders.seller_id', auth()->user()->id)
                      ->where('orders.status', '!=', 'open')
                      ->orWhere(function($query) {
                        $query->where('orders.seller_id', auth()->user()->id)
                          ->whereNotNull('orders.payment_address')
                          ->whereNotNull('orders.payment_until')
                          ->whereDate('orders.payment_until', '>=', time());
                        });
                    })
                   ->orWhere('orders.user_id', auth()->user()->id);
            });
        }

        if ($filter_status) {
            $orders = $orders->where('status', $filter_status);
        }

        $orders = $orders->orderBy('id', 'DESC')->paginate(10);

        $filters = Filter::orderBy('position', 'ASC')->where('is_hidden', 0)->where('is_default', 0)->get();
        $default_shipping = [];

        foreach($filters as $key => $element) {
            if($element->is_category_specific && $element->categories && is_array($element->categories)) {
                if(!in_array($order->listing->category_id, $element->categories)) {
                    continue;
                }
            }

            if($element->form_input_meta && $element->form_input_type != 'none') {
                $form_input_meta = $element->form_input_meta;
                $form_input_meta['name'] = 'filters['.$element->form_input_meta['name'].']';
                $form_input_meta['value'] = (@$order->listing->meta[$element->form_input_meta['name']]);

                if(isset($form_input_meta['selected']))
                    $form_input_meta['selected'] = false;

                if(isset($form_input_meta['values'])) {
                    foreach ($form_input_meta['values'] as $k => $v) {
                        $form_input_meta['values'][$k]['selected'] = false;
                    }
                }

                if(isset($form_input_meta['values']) && is_array($form_input_meta['value'])) {
                    foreach ($form_input_meta['values'] as $k => $v) {
                        $form_input_meta['values'][$k]['selected'] = in_array($v['value'], $form_input_meta['value']);
                    }
                }

                if($form_input_meta['value'] && isset($form_input_meta['multiple']) && $form_input_meta['placeholder']) {
                    #array_unshift($form_input_meta['values'] , ["label"=> $form_input_meta['placeholder'], "value"=> false]);
                    $form_input_meta['placeholder'] = null;
                    #unset($form_input_meta['value']);
                }

                if ($element->field == 'shipping') {
                    $default_shipping = $form_input_meta;
                    continue;
                }
            }
        }

        return view('account.orders.index', compact('orders', 'default_shipping', 'filter_status'));
    }
    public function snapshot($order) {
      if (!auth()->check() || ($order->seller_id != auth()->user()->id && $order->user_id != auth()->user()->id) && !auth()->user()->can('edit order')) {
          $this->authorize('update', $order);
      }
      
      $old_listing_data = $order->getAttribute('listing_data')?$order->getAttribute('listing_data'):false;
      $old_listing_data->stock = 0;
      
      $data['has_map'] = false;
      $data['breadcrumbs'] = $data['facets'] = $data['parent_categories'] = $data['level_categories'] = $data['category'] = $data['seller'] = $data['filters'] = [];
      $data['facets'] = BrowseController::getFacets();
        $category_id = $old_listing_data->category->id;
        $category = Category::find($category_id); //current category

        $level_categories = Category::where('parent_id', $category_id)->orderBy('order', 'ASC')->get(); //categories on this level
        $parent_categories = BrowseController::getParentCategories($category_id);

        if(count($level_categories) == 0 && $category) {
            $level_categories = Category::where('parent_id', $category->parent_id)->orderBy('order', 'ASC')->get();
            $parent_categories = Category::whereIn('id', $parent_categories)->get();
        } elseif ($category) {
            $parent_categories = Category::whereIn('id', array_merge([$category_id], $parent_categories))->get();
        } else {
            $parent_categories = Category::where('parent_id', 0)->orderBy('order', 'ASC')->get();
        }

        if(setting('categories_hide_empty')) {
            //check which categoreis we need to show
            $count_categories = $this->getCategoryCounts();
            $parent_categories = $this->removeEmptyCategories($parent_categories, $count_categories);
            $level_categories = $this->removeEmptyCategories($level_categories, $count_categories);
            #dev_dd($parent_categories, $level_categories);
        }

        $data['parent_categories'] = $parent_categories;
        $data['level_categories'] = $level_categories;
        $data['category'] = $category;
        $data['category_id'] = $category_id;
      $data['listing'] = $old_listing_data;
      $data['is_snapshot'] = true;
      
      return view('listing.show', $data);
    }

    public function show($order)
    {

        if (!auth()->check() || ($order->seller_id != auth()->user()->id && $order->user_id != auth()->user()->id) && !auth()->user()->can('edit order')) {
            $this->authorize('update', $order);
        }
      
		$bs_status = false;
      
      	$old_listing_data = $order->getAttribute('listing_data')?$order->getAttribute('listing_data'):false;

        if ($order->getAttribute('bd_type') && $order->payment_address) {
            $status_deal = BitDeals::status_deal(array('address' => $order->payment_address));

            //var_dump($status_deal);

            //if (!empty($status_deal->result->success)) {
          		$payload = base64_decode($status_deal->payload);
                $bs_status = "<pre>".$payload."</pre>";//str_replace(' ', ' &nbsp;', $payload); //
          		$payload = nl2br($payload);
            //}
          
          if ($order->status == 'open' || $order->status == 'paid' || $order->status == 'dispute') {
            $payload_p = explode('order:', $payload);
            if (isset($payload_p[1])) {
                $payload_pa = explode('<br />', $payload_p[1]);
                $order_status = trim($payload_pa[0]);
              
                if (!empty($order_status) && in_array($order_status, array('Completed'))) {
                    $order->status = 'completed';
                    $order->save();
                } elseif (!empty($order_status) && in_array($order_status, array('Executed'))) {
                    $order->status = 'accepted';
                    $order->save();
                } elseif (!empty($order_status) && $order->status != 'paid' && in_array($order_status, array('Paid'))) {
                    $order->setAttribute('btc_payment_is', 1);
                    $order->status = 'paid';
                    $order->save();

                    //$widget = '\App\Widgets\Order\\'.camel_case($order->listing->pricing_model->widget).'Widget';
                    $widget = new buyWidget();
                    $widget->decrease_stock($order, $order->listing);
                  
                    $user = User::find($order->seller_id);
                	if ($user->bitmessage) {
                  	  Bit_Message::send($user->bitmessage, __('New Paid deal'), __("You have a new paid deal.\n\rThe deal: " . route('account.orders.show', $order)));
                	}
                }
            }
          }
        }

        $filters = Filter::orderBy('position', 'ASC')->where('is_hidden', 0)->where('is_default', 0)->get();
        $default_shipping = [];

        foreach($filters as $key => $element) {
            if($element->is_category_specific && $element->categories && is_array($element->categories)) {
                if(!in_array($order->listing->category_id, $element->categories)) {
                    continue;
                }
            }

            if($element->form_input_meta && $element->form_input_type != 'none') {
                $form_input_meta = $element->form_input_meta;
                $form_input_meta['name'] = 'filters['.$element->form_input_meta['name'].']';
                $form_input_meta['value'] = (@$order->listing->meta[$element->form_input_meta['name']]);

                if(isset($form_input_meta['selected']))
                    $form_input_meta['selected'] = false;

                if(isset($form_input_meta['values'])) {
                    foreach ($form_input_meta['values'] as $k => $v) {
                        $form_input_meta['values'][$k]['selected'] = false;
                    }
                }

                if(isset($form_input_meta['values']) && is_array($form_input_meta['value'])) {
                    foreach ($form_input_meta['values'] as $k => $v) {
                        $form_input_meta['values'][$k]['selected'] = in_array($v['value'], $form_input_meta['value']);
                    }
                }

                if($form_input_meta['value'] && isset($form_input_meta['multiple']) && $form_input_meta['placeholder']) {
                    #array_unshift($form_input_meta['values'] , ["label"=> $form_input_meta['placeholder'], "value"=> false]);
                    $form_input_meta['placeholder'] = null;
                    #unset($form_input_meta['value']);
                }

                if ($element->field == 'shipping') {
                    $default_shipping = $form_input_meta;
                    continue;
                }
            }
        }

        $shipping = '';
        if (!empty($order->listing_options['shipping_option'])) {
            $listing_shipping = $order->listing->shipping_options->firstWhere('id', $order->listing_options['shipping_option']);

            if ($listing_shipping && !empty($default_shipping['values'][$listing_shipping->is_default-1])){
                if ($shipping->name != $default_shipping['values'][$listing_shipping->is_default-1]['label']) {
                    $shipping = $default_shipping['values'][$listing_shipping->is_default-1]['label'] . ' - ' . $listing_shipping->name;
                } else {
                    $shipping = $default_shipping['values'][$listing_shipping->is_default-1]['label'];
                }
            }
        }

        /*$user = auth()->user();
        dd($user->stripe_id);
        $user->stripe_id = 'hello world';
        $user->save();*/

        Talk::setAuthUserId(auth()->user()->id);
        $is_mediator = auth()->check() && auth()->user()->can('edit order');
        $message_count = Message::where('conversation_id', $order->conversation_id)->count();
        $limit = 2000;
        $offset = max($message_count-$limit,0);
        //$conversations = Talk::getConversationsAllById($order->conversation_id, $offset, $limit);
        $conversation = Conversation::with(['messages' => function ($q) use ($offset, $limit) {
            return $q->offset($offset)
                ->take($limit);
        }, 'userone', 'usertwo'])->find($order->conversation_id);

        $conversations = (object) null;
        //if ($conversation->user_one == auth()->user()->id || $conversation->user_two == auth()->user()->id || ) {
            $withUser = ($conversation->userone->id === auth()->user()->id) ? $conversation->usertwo : $conversation->userone;
            $conversations->withUser = $withUser;
            $conversations->messages = $conversation->messages;
        //}

        $messages = collect($conversations->messages)->sortByDesc('created_at');

        #mark as seen
        if ($messages) {
            foreach ($messages as $message) {
                if (!$message->is_seen && auth()->user()->id != $message->sender->id) {
                    Talk::makeSeen($message->id);
                    auth()->user()->update(['unread_messages' => \DB::raw('GREATEST(unread_messages-1, 0)')]);
                }
            }
        }

        $btc_payment_is = $order->getAttribute('btc_payment_is')?$order->getAttribute('btc_payment_is'):0;

        return view('account.orders.show', compact('order', 'messages', 'is_mediator', 'shipping', 'bs_status', 'bs_error', 'old_listing_data', 'btc_payment_is'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $order)
    {
        //
        if (!auth()->check() || ($order->seller_id != auth()->user()->id && $order->user_id != auth()->user()->id) && !auth()->user()->can('edit order')) {
            $this->authorize('update', $order);
        }

        $user = auth()->user();
        $bd_type = $order->getAttribute('bd_type');

            if ($bd_type == 'mediation') {
                $bd_type = 'postpayment';
            }

            $seller_rating = $order->listing->user->totalCommentCount() . ", " . round(($order->listing->user->averageRate()/3)*100) . "%";
            $customer_rating = $order->user->totalCommentCount() . ", " . round(($order->user->averageRate()/3)*100) . "%";

            $deal_data = array(
                'order' => $order->hash,
                'type' => $bd_type,
                'at' => url('/'),
                'date' => date("Y-m-d H:i:s", $order->getAttribute('timestamp')). ' UTC',
                'seller_address' => $order->listing->user->bitcoin,
                'seller_rating' => $seller_rating,
                'customer_address' => $order->user->bitcoin,
                'customer_rating' => $customer_rating,
                'payment_sum' => $order->getAttribute('btc_payment_sum'),
                'payment_address' => $order->payment_address,
                'payment_until' => date("Y-m-d H:i:s", strtotime($order->payment_until)). ' UTC',
                'feedback_leave_before' => date("Y-m-d H:i:s", $order->getAttribute('end_timestamp')). ' UTC',
                'feedback_status' => ($request->input('status') == 'complete_n') ? 'Neutral' : 'Positive',
                'feedback_comments' => $request->input('notes', '')
            );

        if($request->input('status') == 'accept') {

            if($order->payment_gateway->name == 'stripe') {
                \Stripe\Stripe::setApiKey(config('marketplace.stripe_secret_key'));
                $charge = \Stripe\Charge::retrieve($order->authorization_id, ["stripe_account" => $order->payment_gateway->gateway_id]);
                $result = $charge->capture();
                $order->capture_id = $charge->id;
            }

            $order->accepted_at = Carbon::now();
            $order->status = 'accepted';
            $order->save();

            Mail::to($order->user->email)->send(new AcceptPurchase($order));

        }
        if($request->input('status') == 'decline') {

            if($order->payment_gateway->name == 'stripe') {
                \Stripe\Stripe::setApiKey(config('marketplace.stripe_secret_key'));
                $charge = \Stripe\Charge::retrieve($order->authorization_id, ["stripe_account" => $order->payment_gateway->gateway_id]);

                $refund = \Stripe\Refund::create(array(
                    "charge" => $charge->id
                ), ["stripe_account" 	=> $order->payment_gateway->gateway_id]);

                $order->refund_id = $refund->id;
            }
          
            $deal_data['order'] = 'Cancel';
            $deal_data['seller_signature'] = $request->input('seller_signature');
            $deal = BitDeals::deal_cancel($deal_data);

            //var_dump($deal_data);
            //var_dump($deal); exit;

            if(!empty($deal->result) && !$deal->result->success && !empty($deal->result->message)) {
                alert()->error($deal->result->message);

                return redirect(url()->previous());
            }elseif(!empty($deal->error) && !empty($deal->error->message)) {
                alert()->error($deal->error->message);

                return redirect(url()->previous());
            }

            $order->declined_at = Carbon::now();
            $order->status = 'declined';
            $order->save();

            Mail::to($order->user->email)->send(new DeclinePurchase($order));
        }
        if($request->input('status') == 'shipped') {
            $order->setAttribute('shipped_note', $request->input('notes'));
            $order->status = 'shipped';
            $order->save();
        }

        if($request->input('status') == 'complete_p' || $request->input('status') == 'complete_n') {

            $deal_data['order'] = 'complete';

            if (!empty($request->input('refund'))) {
                $deal_data['feedback_refund'] = (int)$request->input('refund') . '%';
            }

            $deal = BitDeals::complete_deal($deal_data);

            //var_dump($deal); exit;

            if(!empty($deal->result) && !$deal->result->success && !empty($deal->result->message)) {
                alert()->error($deal->result->message);

                return redirect(url()->previous());
            }elseif(!empty($deal->error) && !empty($deal->error->message)) {
                alert()->error($deal->error->message);
                return redirect(url()->previous());
            }

            $request->session()->flash('refresh_cache', 'OK');
        }

        if($request->input('notes')) {

            $conversation_id = !empty($order->conversation_id) ? $order->conversation_id : 0;


            Talk::setAuthUserId(auth()->user()->id);


            if (!$conversation_id) {
                $message = Talk::sendMessageByUserId($conversation_id, $request->get('notes'));
            } else {
                $message = Talk::sendMessage($conversation_id, $request->get('notes'));
            }

            if (!empty($message->conversation_id)) {
                $users = array();

                $conversation = Conversation::find($message->conversation_id);

                if ($conversation->user_one && $conversation->user_one != auth()->user()->id) {
                    $users[$conversation->user_one] = $conversation->user_one;
                } elseif ($conversation->user_two) {
                    $users[$conversation->user_two] = $conversation->user_two;
                }


                $m_users = Message::select('user_id')->distinct()->where('conversation_id', $message->conversation_id)->where('user_id', '<>', auth()->user()->id)->where('user_id', '<>', 0)->get();
                foreach ($m_users as $user) {
                    $users[$user->user_id] = $user->user_id;
                }

                foreach ($users as $user) {
                    $user = User::find($user);
                    if ($user) {
                        $user->increment('unread_messages');

                        if ($user->bitmessage) {
                            Bit_Message::send($user->bitmessage, __('New message in deal'), __("You have a new message in deal.\n\rThe deal: " . route('account.orders.show', $order)));
                        } else {
                            Mail::to($user->email)->send(new ReceiveMessage($user, auth()->user(), $message->conversation_id));
                        }
                    }
                }
            }

            if (!$conversation_id && !empty($message->conversation_id)) {
                $order->conversation_id = $message->conversation_id;
                $order->save();

                $conversation = Conversation::find($message->conversation_id);
                $conversation->user_one = $order->user_id;
                $conversation->status = 2;
                $conversation->update();
            }
        }

        $request->session()->flash('refresh_cache', 'OK');

        return redirect(route('account.orders.show', $order));
    }

    public function feedback($order) {
        if (!in_array($order->status, array('paid', 'completed', 'shipped')) || !auth()->check() || $order->user_id != auth()->user()->id || $order->comments()->count()) {
            return redirect(route('account.orders.show', $order));
        }

        $user = auth()->user();

        $now_date = date('Y-m-d');

        return view('account.orders.feedback', compact('order', 'user', 'now_date'));
    }
    public function feedback_post(Request $request, $order) {
        if (!in_array($order->status, array('paid', 'completed', 'shipped')) || !auth()->check() || $order->user_id != auth()->user()->id || $order->comments()->count()) {
            return redirect(route('account.orders.show', $order));
        }

        $user = auth()->user();

        $bd_type = $order->getAttribute('bd_type');

        if ($bd_type == 'mediation') {
            $bd_type = 'postpayment';
        }

        $seller_rating = $order->listing->user->totalCommentCount() . ", " . round(($order->listing->user->averageRate()/3)*100) . "%";
        $customer_rating = $order->user->totalCommentCount() . ", " . round(($order->user->averageRate()/3)*100) . "%";

        $deal = BitDeals::complete_deal(array(
            'order' => 'Feedback',
            'type' => $bd_type,
            'at' => url('/'),
            'date' => date("Y-m-d H:i:s", $order->getAttribute('timestamp')). ' UTC',
            'seller_address' => $order->listing->user->bitcoin,
            'seller_rating' => $seller_rating,
            'customer_address' => $order->user->bitcoin,
            'customer_rating' => $customer_rating,
            'customer_signature' => $request->input('signature'),
            'payment_sum' => $order->getAttribute('btc_payment_sum'),
            'payment_address' => $order->payment_address,
            'payment_until' => date("Y-m-d H:i:s", strtotime($order->payment_until)). ' UTC',
            'feedback_leave_before' => date("Y-m-d H:i:s", $order->getAttribute('end_timestamp')). ' UTC',
            'feedback_status' => ($request->input('rate') != '3') ? 'Negative' : 'Positive',
            'feedback_comments' => $request->input('feedback')
        ));

        if(!empty($deal->result) && !$deal->result->success && !empty($deal->result->message)) {
            alert()->error($deal->result->message);

            return redirect(url()->previous());
        }elseif(!empty($deal->error) && !empty($deal->error->message)) {
            alert()->error($deal->error->message);
            return redirect(url()->previous());
        }

        $comment = new Comment([
            'comment'        => '',//$request->input('feedback_comment'),
            'feedback'       => $request->input('feedback'),
            'rate'           => ($order->listing->getCanBeRated()) ? $request->input('rate') : null,
            'approved'       => true,
            'commenter_id'   => $user->id,
            'seller_id'   	 => $order->listing->user_id,
            'order_id'   	 => $order->id,
        ]);

        $order->listing->comments()->save($comment);

        $order->status = 'completed';
        $order->save();

        $request->session()->flash('refresh_cache', 'OK');

        return redirect(route('account.orders.show', $order));
    }

    public function feedback_replay(Request $request) {
        $user = auth()->user();
        $comment = Comment::with('seller')->where('id', $request->input('comment_id'))->where('seller_id', $user->id)->get();
        $comment = Comment::findOrFail($request->input('comment_id'));

        if (!empty($comment->seller_id) && $comment->seller_id == $user->id && !empty($request->input('replay'))) {
            //$comment->replay = $request->input('replay');
            $comment->updateMeta('replay', $request->input('replay'));
            //$comment->save();
        }

        $request->session()->flash('refresh_cache', 'OK');

        return redirect(url()->previous());
    }

    public function dispute($order) {
        if (!(auth()->check() && ((in_array($order->status, array('paid', 'shipped')) && ($order->getAttribute('bd_type') == 'postpayment' or $order->getAttribute('bd_type') == 'mediation') && $order->user_id == auth()->user()->id) ||  (in_array($order->status, array('dispute')) && $order->seller_id == auth()->user()->id)))) {
            return redirect(route('account.orders.show', $order));
        }

        $user = auth()->user();


        $return = $order->getAttribute('is_return');
        $digital = false;

        return view('account.orders.dispute', compact('order', 'user', 'return'));
    }

    public function dispute_post(Request $request, $order) {
        if (!(auth()->check() && ((in_array($order->status, array('paid', 'shipped')) && ($order->getAttribute('bd_type') == 'postpayment' or $order->getAttribute('bd_type') == 'mediation') && $order->user_id == auth()->user()->id) ||  (in_array($order->status, array('dispute')) && $order->seller_id == auth()->user()->id)))) {
            return redirect(route('account.orders.show', $order));
        }

        $location = '';

        if ($request->file('image')) {
            $location = 'dispute/' . time() . $order->id .  '.jpg';

            $img = Image::make($request->file('image'));
                /*->fit(1280, 1280, function ($constraint) {
                    $constraint->aspectRatio();
                    $constraint->upsize();
                })
                ->resizeCanvas(1280, 1280);*/

            Storage::cloud()->put($location, (string)$img->encode('jpg', 75), 'public');

            $location = Storage::cloud()->url($location);
        }

        if ($order->user_id == auth()->user()->id && !in_array($order->status, array('dispute'))) {
            $dispute_user_info = array(
                'reason' => $request->input('reason'),
                'problem' => $request->input('problem'),
                'proposal' => $request->input('proposal'),
                'notes' => $request->input('notes'),
                'img_location' => $location,
            );

            $order->setAttribute('dispute_user_timestamp', time());
            $order->setAttribute('dispute_user_info', $dispute_user_info);
            $order->status = 'dispute';
            $order->save();
          
            $user = User::find($order->seller_id);
            if ($user->bitmessage) {
              Bit_Message::send($user->bitmessage, __('New dispute in deal'), __("You have a new dispute in deal.\n\rThe deal: " . route('account.orders.show', $order)));
            }
            $users = User::permission('edit order')->get();
            foreach($users as $user) {
              if ($user->bitmessage) {
              Bit_Message::send($user->bitmessage, __('New dispute in deal'), __("You have a new dispute in deal.\n\rThe deal: " . route('account.orders.show', $order)));
              }
            }
        }

        if ($order->seller_id == auth()->user()->id && in_array($order->status, array('dispute'))) {
            $dispute_seller_info = array(
                'proposal' => $request->input('proposal'),
                'notes' => $request->input('notes'),
                'img_location' => $location,
            );

            $order->setAttribute('dispute_seller_timestamp', time());
            $order->setAttribute('dispute_seller_info', $dispute_seller_info);
            $order->save();
            $user = User::find($order->user_id);
            if ($user->bitmessage) {
              Bit_Message::send($user->bitmessage, __('New dispute message in deal'), __("You have a new dispute message in deal.\n\rThe deal: " . route('account.orders.show', $order)));
            }
            $users = User::permission('edit order')->get();
            foreach($users as $user) {
              Bit_Message::send($user->bitmessage, __('New dispute message in deal'), __("You have a new dispute message in deal.\n\rThe deal: " . route('account.orders.show', $order)));
            }
        }

        /*if($request->input('notes')) {

            $conversation_id = !empty($order->conversation_id) ? $order->conversation_id : 0;


            Talk::setAuthUserId(auth()->user()->id);


            if (!$conversation_id) {
                $message = Talk::sendMessageByUserId($conversation_id, $request->get('notes'));
            } else {
                $message = Talk::sendMessage($conversation_id, $request->get('notes'));
            }

            if (!empty($message->conversation_id)) {
                $users = array();

                $conversation = Conversation::find($message->conversation_id);

                if ($conversation->user_one && $conversation->user_one != auth()->user()->id) {
                    $users[$conversation->user_one] = $conversation->user_one;
                } elseif ($conversation->user_two) {
                    $users[$conversation->user_two] = $conversation->user_two;
                }


                $m_users = Message::select('user_id')->distinct()->where('conversation_id', $message->conversation_id)->where('user_id', '<>', auth()->user()->id)->where('user_id', '<>', 0)->get();
                foreach ($m_users as $user) {
                    $users[$user->user_id] = $user->user_id;
                }

                foreach ($users as $user) {
                    $user = User::find($user);
                    if ($user) {
                        $user->increment('unread_messages');

                        Mail::to($user->email)->send(new ReceiveMessage($user, auth()->user(), $message->conversation_id));

                        if ($user->bitmessage) {
                            Bit_Message::send($user->bitmessage, __('New message in deal'), __("You have a new message in deal.\n\rThe deal: " . route('account.orders.show', $order)));
                        }
                    }
                }
            }

            if (!$conversation_id && !empty($message->conversation_id)) {
                $order->conversation_id = $message->conversation_id;
                $order->save();

                $conversation = Conversation::find($message->conversation_id);
                $conversation->user_one = $order->user_id;
                $conversation->status = 2;
                $conversation->update();
            }
        }*/

        $user = auth()->user();

        return redirect(route('account.orders.show', $order));
    }
}
