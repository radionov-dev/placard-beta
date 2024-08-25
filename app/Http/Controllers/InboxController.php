<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreDirectMessage;
use App\Mail\ReceiveMessage;
use App\Models\Bit_Message;
use App\Models\Listing;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Routing\Controller;
use Illuminate\Support\Carbon;
use Kris\LaravelFormBuilder\FormBuilder;
use App\Models\User;
use App\Models\Message;
//use Nahid\Talk\Messages\Message;
use Nahid\Talk\Conversations\Conversation;
use Talk;
use Validator;
use Mail;
use DB;
use App\Support\AdminNotification;
use Igoshev\Captcha\Facades\Captcha;

class InboxController extends Controller
{
    /**
     * Display a listing of the resource.
     * @return Response
     */
    public function index()
    {
        DB::table('messages')->where('updated_at', '<=', Carbon::today()->subDays(30)->endOfDay())->where('is_seen', '1')->whereIn('conversation_id', DB::table('conversations')->where(function($query) {
            $query->where('conversations.user_one', auth()->user()->id)->orWhere('conversations.user_two', auth()->user()->id);
        })->whereNotIn('id', DB::table('orders')->where('orders.seller_id', auth()->user()->id)->orWhere('orders.user_id', auth()->user()->id)->pluck('conversation_id'))->pluck('id'))->delete();

        Talk::setAuthUserId(auth()->user()->id);
        $inboxes = Talk::getInbox();

        $conversation_data = array();

        $orders = Order::with('listing')->join('conversations', 'conversations.id', '=', 'orders.conversation_id')->where(function($query) {
            $query->where('orders.seller_id', auth()->user()->id)
                ->orWhere('orders.user_id', auth()->user()->id);
        })->where('conversations.status', 2)->get();

        foreach ($orders as $order) {
            $conversation_data[(int)$order->conversation_id] = $order;
        }


        foreach ($inboxes as $key => &$inbox) {
            if (empty($inbox->thread->conversation_id)) {
                unset($inboxes[$key]);
            }
            if (!empty($conversation_data[(int)$inbox->thread->conversation_id])) {
                $inbox->order = $conversation_data[(int)$inbox->thread->conversation_id];
            }
        }

        return view('inbox.index', compact('inboxes'));
    }

    /**
     * Show the form for creating a new resource.
     * @return Response
     */
    public function create(Request $request, FormBuilder $formBuilder)
    {
        //alert()->danger('You cannot send a message to yourself.');
        Talk::setAuthUserId(auth()->user()->id);
        $inboxes = Talk::getInbox();

        $conversation_data = array();

        $orders = Order::with('listing')->join('conversations', 'conversations.id', '=', 'orders.conversation_id')->where(function($query) {
            $query->where('orders.seller_id', auth()->user()->id)
                ->orWhere('orders.user_id', auth()->user()->id);
        })->where('conversations.status', 2)->get();

        foreach ($orders as $order) {
            $conversation_data[(int)$order->conversation_id] = $order;
        }


        foreach ($inboxes as $key => &$inbox) {
            if (empty($inbox->thread->conversation_id)) {
                unset($inboxes[$key]);
            }
            if (!empty($conversation_data[(int)$inbox->thread->conversation_id])) {
                $inbox->order = $conversation_data[(int)$inbox->thread->conversation_id];
            }
        }

        $user_id = $request->input('user_id');
        $listing_id = $request->input('listing_id');
        $message = $request->input('message', "");

        $conversationId = Talk::isConversationExists($user_id);

        if (!$conversationId) {
            Talk::setAuthUserId($user_id);
            $conversationId = Talk::isConversationExists(auth()->user()->id);
            Talk::setAuthUserId(auth()->user()->id);
        }

        $conversation = Talk::getConversationsAllById($conversationId, 0, 1);

        if (isset($conversation->id)) {
            $conversationId = Talk::isConversationExists($conversation->id);
            return redirect(route('inbox.show', $conversationId));
        } else {
            $conversation = Conversation::create([
                'user_one' => auth()->user()->id,
                'user_two' => $user_id,
                'status' => 1,
            ]);
        }

        $recipient = $conversation;

        if($listing_id && !$message) {
            $listing = Listing::find($listing_id);
            if($listing) {
                $message = __("I'm interested in :title", ['title' => $listing->title]);
            }
        }

        $captcha = Captcha::getView();

        return view('inbox.index', compact('recipient', 'message', 'inboxes', 'captcha'));
    }

    /**
     * Store a newly created resource in storage.
     * @param  Request $request
     * @return Response
     */
    public function store(Request $request)
    {
        $params = $request->all();
        #return response('OK', 200)->header('X-IC-Redirect', '/create/r4W0J7ObQJ/edit#images_section');
        $validator = Validator::make($request->all(), [
            'message' => 'required',
            'captcha' => 'required|captcha',
        ]);

        if ($validator->fails()) {
            return redirect(route('inbox.show', $request->get('recipient_id')))
                ->withErrors($validator);
                //->withInput();
        }

        /*if($request->get('recipient_id') == auth()->user()->id) {
            alert()->danger(__('Alert - You cannot send a message to yourself.'));
            return redirect(route('inbox.create', ['user_id' => $request->get('recipient_id')]))
                ->withErrors($validator)
                ->withInput();
        }*/

        Talk::sendMessage($request->get('recipient_id'), $request->get('message'));

        $users = array();

        $conversation = Conversation::find($request->get('recipient_id'));

        $conversation_data = array();

        if ($conversation->status == '2') {
            $orders = Order::with('listing')->join('conversations', 'conversations.id', '=', 'orders.conversation_id')->where(function ($query) {
                $query->where('orders.seller_id', auth()->user()->id)->orWhere('orders.user_id', auth()->user()->id);
            })->where('conversations.status', 2)->get();

            foreach ($orders as $order) {
                $conversation_data[(int)$order->conversation_id] = $order;
            }
        }

        if ($conversation->user_one && $conversation->user_one != auth()->user()->id) {
            $users[$conversation->user_one] = $conversation->user_one;
        } elseif ($conversation->user_two) {
            $users[$conversation->user_two] = $conversation->user_two;
        }


        $m_users = Message::select('user_id')->distinct()->where('conversation_id', $request->get('recipient_id'))->where('user_id', '<>', auth()->user()->id)->where('user_id', '<>', 0)->get();
        foreach ($m_users as $user) {
            $users[$user->user_id] = $user->user_id;
        }

        foreach ($users as $user) {
            $user = User::find($user);

            if ($user) {
                $user->increment('unread_messages');

                Mail::to($user->email)->send(new ReceiveMessage($user, auth()->user(), $request->get('recipient_id')));

                if ($user->bitmessage) {
                    if (isset($conversation_data[(int)$request->get('recipient_id')])) {
                        Bit_Message::send($user->bitmessage, __('New message in deal'), __("You have a new message in deal.\n\rThe deal: " . route('account.orders.show', $conversation_data[(int)$request->get('recipient_id')])));
                    } else {
                        Bit_Message::send($user->bitmessage, __('New message'), __("You have a new message.\n\rThe message: " . route('inbox.show', $request->get('recipient_id'))));
                    }
                }
            }
        }

		#Does message contain contact info?
        if(setting('messaging_monitor_contact_sharing')) {

            $message = $request->input('message');
            $message = preg_replace('/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i','(phone hidden)', $message); // extract email
            $message = preg_replace('/(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?/','(email hidden)', $message);

            if($message != $request->input('message')) {
                AdminNotification::notify(
                    "Contact Sharing",
                    "The user $user->email has shared his contact details using direct message."
                );
            }
        }

        return redirect(route('inbox.show', $request->get('recipient_id')));
    }

    /**
     * Show the specified resource.
     * @return Response
     */
    public function show($id)
    {

        session(['conversation_id' => $id]);
        $inboxes = Talk::getInbox();

        $conversation_data = array();

        $orders = Order::with('listing')->join('conversations', 'conversations.id', '=', 'orders.conversation_id')->where(function($query) {
            $query->where('orders.seller_id', auth()->user()->id)
                ->orWhere('orders.user_id', auth()->user()->id);
        })->where('conversations.status', 2)->get();

        foreach ($orders as $order) {
            $conversation_data[(int)$order->conversation_id] = $order;
        }


        foreach ($inboxes as $key => &$inbox) {
            if (empty($inbox->thread->conversation_id)) {
                unset($inboxes[$key]);
            }
            if (!empty($conversation_data[(int)$inbox->thread->conversation_id])) {
                $inbox->order = $conversation_data[(int)$inbox->thread->conversation_id];
            }
        }

        $message_count = Message::where('conversation_id', $id)->count();
        $limit = 2000;
        $offset = max($message_count-$limit,0);
        $conversations = Talk::getConversationsAllById($id, $offset, $limit);

        $messages = $conversations->messages;
        $recipient = $conversations->withUser;
        $recipient->id = $id;
        $is_order = null;

        if (!empty($conversation_data[(int)$id])) {
            $recipient->id = $id;
            $recipient->display_name = 'Deal #' . $conversation_data[(int)$id]->id;

            $is_order = true;
        }

        #mark as seen
        if ($messages) {
            foreach ($messages as $message) {
                if (!$message->is_seen && auth()->user()->id != $message->sender->id) {
                    Talk::makeSeen($message->id);
                    auth()->user()->update(['unread_messages' => \DB::raw('GREATEST(unread_messages-1, 0)')]);
                }
            }
        }

        $captcha = Captcha::getView();

        return view('inbox.index', compact('messages', 'recipient', 'inboxes', 'conversation_data', 'is_order', 'captcha'));
    }

    /**
     * Show the form for editing the specified resource.
     * @return Response
     */
    public function edit()
    {
        $inboxes = Talk::getInbox();

        return view('inbox.edit');
    }

    /**
     * Update the specified resource in storage.
     * @param  Request $request
     * @return Response
     */
    public function update(Request $request)
    {
    }

    /**
     * Remove the specified resource from storage.
     * @return Response
     */
    public function destroy()
    {
    }
}
