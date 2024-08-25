<?php

namespace App\Http\Controllers;

use App\Models\Bit_Message;
use App\Models\Order;
use Illuminate\Http\Request;
use App\Models\Listing;
use App\Models\Widget;
use Location;
use Setting;
use MetaTag;
use LaravelLocalization;
use Theme;
use App\Models\bElectrum;

class HomeController extends Controller
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

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Http\Response
     */
    public function postIndex(Request $request) {
        $url = http_build_query($request->except('_token'));
        return redirect('/home?'.$url);
    }

    public function redirect(Request $request)
    {
        return redirect('/');
    }

    public function index(Request $request)
    {

        $current_locale = LaravelLocalization::getCurrentLocale();
        $data['widgets'] = Widget::where('locale', $current_locale)->orWhere('locale', NULL)->orderBy('position', 'ASC')->get();
        $data['show_search'] = false;

        foreach ($data['widgets'] as $key => $widget) {
            $data['widgets'][$key] = view('home.widgets.' . $widget['type'], array('widget' => $widget));
        }

        MetaTag::set('title', Setting::get('home_title'));
        MetaTag::set('description', Setting::get('home_description'));
        MetaTag::set('keywords', Setting::get('site_keywords'));

        //var_dump(Bit_Message::send('BM-GuHwT6VFQGtrmRpJFRnammABFPK1Th8u', __('New test'), __("You have a new test.")));

        /*$client = new Electrum\Client('65.21.101.151', 7778, 0, 'user', 'yXQBZZrMF7VspZvBLueZcw==');
        $method = new Electrum\Request\Method\Version($client);

        try {
            $response = $method->execute();
        } catch (\Exception $exception) {
            die($exception->getMessage());
        }

        var_dump($response->getVersion());*/

        //var_dump(bElectrum::new_address());

        MetaTag::set('rss', url('/feed'));

        return view('home.index', $data);

    }

    public function BitDealsResponse(Request $request) {
        return response()->json($_REQUEST);
    }
}
