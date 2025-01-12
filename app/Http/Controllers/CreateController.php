<?php

namespace App\Http\Controllers;

use Jimmerioles\BitcoinCurrencyConverter\Converter;
use App\Http\Requests\StoreListing;
use App\Mail\NewListing;
use App\Models\ListingAdditionalOption;
use App\Models\ListingBookedDate;
use App\Models\ListingPlan;
use App\Models\ListingService;
use App\Models\ListingShippingOption;
use App\Models\ListingVariant;
use App\Models\PricingModel;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

use App\Models\Filter;
use App\Models\Listing;
use App\Models\Category;
use Grimzy\LaravelMysqlSpatial\Types\Point;
use Location;
use Setting;
use Storage;
use Image;
use GeoIP;
use DB;
use Validator;
use Mail;
use File;
use function BenTools\CartesianProduct\cartesian_product;

use Gerardojbaez\Laraplans\Models\Plan;
use Gerardojbaez\Laraplans\Models\PlanFeature;
use Igoshev\Captcha\Facades\Captcha;

class CreateController extends Controller
{
    /**
     * Display a listing of the resource.
     * @return Response
     */
    public function index()
    {

        if(auth()->check() && setting('single_listing_per_user')) {
            //let's see if we have a listing
            $user = auth()->user();
            if($user->listings->count()) {
                $listing = $user->listings->first();
                return redirect( $listing->edit_url );
            }
        }

        $data = [];
        $data['listings_form'] = Setting::get('listings_form', []);

        $listing = new Listing();
        $data['listing'] = $listing;
        $categories = Category::nested()->get();
        $categories = flatten($categories, 0);
        $list = [];
        foreach($categories as $category) {
            $list[''] = '';
            $list[$category['id']] = str_repeat("&mdash;", $category['depth']+1) . " " .$category['name'];
        }
        $data['categories'] = $list;
        $data['pricing_models'] = PricingModel::pluck('seller_label', 'id');

        $selected_category = null;
        if(request('category')) {
            $selected_category = Category::find(request('category'));
            $pricing_models = $selected_category->pricing_models->pluck('seller_label', 'id');
            if(count($pricing_models)) {
                $data['pricing_models'] = $pricing_models;
            }
        } else {
            if( count($data['categories']) == 1 ) {
                $category = Category::first();
                return redirect(route('create.index', ['category' => $category->id]));
            }
        }

        $selected_pricing_model = null;
        if(request('pricing_model')) {
            #dd($selected_category->pricing_models);
            $selected_pricing_model = $data['pricing_models'][request('pricing_model')];
        } else {
            if(request('category')) {
                if( $data['pricing_models']->count() == 1 ) {
                    $first_key = $data['pricing_models']->keys()->first();
                    return redirect(route('create.index', ['category' => request('category'), 'pricing_model' => $first_key]));
                }
            }
        }

        $data['selected_category'] = $selected_category;
        $data['selected_pricing_model'] = $selected_pricing_model;
        $data['form'] = 'create';

        $view = 'listing.create.pricing_model';

        return view($view, $data);
    }

    /**
     * Store a newly created resource in storage.
     * @param  Request $request
     * @return Response
     */
    #public function store(StoreListing $request)
    public function store(Request $request)
    {

        $params = $request->all();
        #return response('OK', 200)->header('X-IC-Redirect', '/create/r4W0J7ObQJ/edit#images_section');
        $validator = Validator::make($request->all(), [
            'title' => 'required|min:5|max:255',
            'description_new' => 'required|min:5',
        ]);

        if ($validator->fails()) {
            #dd($validator);
            if(\Request::wantsJson()) {
                return response()->json(['errors'=>$validator->errors()], 500);
            } else {
                return redirect(route('create.index', ['category' => $request->get('category'), 'pricing_model' => $request->get('pricing_model') ]))
                    ->withErrors($validator)
                    ->withInput();
            }
        }

        $params['category_id'] = $request->get('category');
        $params['pricing_model_id'] = $request->get('pricing_model');
        $params['user_id'] = auth()->user()->id;
        $params['title'] = $request->get('title');
        $params['description'] = $request->get('description_new');

        //set a default city - let user fine tune later

        //$city = GeoIP::getCity();
        $params['lat'] = auth()->user()->lat;
        $params['lng'] = auth()->user()->lng;
        $params['location'] = auth()->user()->location;
        $params['city'] = auth()->user()->city;
        $params['country'] = auth()->user()->country;

        $params['currency'] = !empty(auth()->user()->currency) ? auth()->user()->currency : Setting::get('currency', config('marketplace.currency'));
        $params['is_published'] = false;

        $listing = new \App\Models\Listing();
        $listing->title = $params['title'];
        $listing->category_id = $params['category_id'];
        $listing->pricing_model_id = $params['pricing_model_id'];
        $listing->user_id = $params['user_id'];
        $listing->description = $params['description'];
        $listing->lat = $params['lat'];
        $listing->lng = $params['lng'];
        //$listing->location = $params['location'];
        $listing->city = $params['city'];
        $listing->country = $params['country'];
        $listing->currency = $params['currency'];
        $listing->is_published = $params['is_published'];
        #dd($listing);
        $listing->save();

        #if it's a service - set to 9-5
        if($listing->pricing_model->widget == 'book_time') {
            $slots = [];
            $start_hour = (int) setting('timeslot.start_hour', 9);
            $end_hour = (int) setting('timeslot.end_hour', 17);
            foreach(range(1,5) as $day)
                for($hour = $start_hour; $hour <= $end_hour; $hour++)
                    $slots[] = ['day' => $day, 'start_time' => $hour.':00', 'end_time' => ($hour+1).':00'];
            $listing->timeslots = $slots;
            $listing->save();
        }

        //redirect to success page
        return redirect(route('create.edit', ['listing' => $listing ]))->withInput();
        #return response()->json(['listing'=>$listing], 200, ['X-IC-Redirect' => route('create.edit', $listing).'#images_section']);

        #return response('OK', 200)->header('X-IC-Redirect', $listing->edit_url.'#images_section')->json(['listing'=>$listing]);
    }

    /**
     * Show the specified resource.
     * @return Response
     */
    public function show()
    {
        return view('create::show');
    }

    /**
     * Show the form for editing the specified resource.
     * @return Response
     */
    public function edit($listing)
    {
        $this->authorize('update', $listing);

        $data = [];

        $data['pricing_models'] = array();
        $pricing_models = PricingModel::get();//pluck('seller_label', 'id');

        foreach ($pricing_models as $pricing_model) {
            if(!empty($pricing_model->meta['bd_type'])){
                $data['pricing_models'][$pricing_model->id] = $pricing_model->seller_label;
            }
        }

        $data['price_in_btc'] = array('0' => 'USD', '1' => 'BTC');

        if (auth()->user()->currency != 'USD') {
            $data['price_in_btc'][3] = auth()->user()->currency;
        }

        if (!in_array($listing->currency, array('USD', auth()->user()->currency))) {
            $data['price_in_btc'][4] = $listing->currency;
        }

        $data['price_in_btc_val'] = $listing->price_in_btc;

        if ($listing->currency == auth()->user()->currency && auth()->user()->currency != 'USD') {
            $data['price_in_btc_val'] = 3;
        } elseif(!in_array($listing->currency, array('USD', auth()->user()->currency, 'BTC'))) {
            $data['price_in_btc_val'] = 4;
        }

        $data['listing'] = $listing;
        #dev_dd($listing->category_id);
        #$filters = Filter::get();
        $filters = Filter::orderBy('position', 'ASC')->where('is_hidden', 0)->where('is_default', 0)->get();
        #dd($filters);
        $default_shipping = [];
        $listings_form = [];

        foreach($filters as $key => $element) {
            if($element->is_category_specific && $element->categories && is_array($element->categories)) {
                if(!in_array($listing->category_id, $element->categories)) {
                    continue;
                }
            }

            if($element->form_input_meta && $element->form_input_type != 'none') {
                $form_input_meta = $element->form_input_meta;
                $form_input_meta['name'] = 'filters['.$element->form_input_meta['name'].']';
                $form_input_meta['value'] = (@$listing->meta[$element->form_input_meta['name']]);

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

                $listings_form[] = $form_input_meta;
            }
        }

        $data['default_shipping'] = $default_shipping;
        $data['listings_form'] = $listings_form;
        $data['captcha'] = Captcha::getView();

        return view('create.edit', $data);
    }

    public function images($listing)
    {
        return view('create.images', compact('listing'));
    }

    public function additional($listing)
    {
        $data = [];
        $data['listing'] = $listing;
        $listings_form = json_decode(Setting::get('listings_form', []));
        foreach($listings_form as $k => $element) {
            $listings_form[$k]->value = (@$listing->meta[$element->name]);
        }
        $data['listings_form'] = $listings_form;
        return view('create.additional', $data);
    }

    public function pricing($listing)
    {
        return view('create.pricing', compact('listing'));
    }

    /**
     * Update the specified resource in storage.
     * @param  Request $request
     * @return Response
     */
    public function update($listing, Request $request)
    {
        $this->authorize('update', $listing);

        $params = $request->all();

        if ($listing->is_draft or !$listing->is_published) {
            $validator = Validator::make($params, [
                'title' => 'required|min:5|max:255',
                'description' => 'required|min:5',
                'captcha' => 'required|captcha',
            ]);
        } else {
            $validator = Validator::make($params, [
                'title' => 'required|min:5|max:255',
                'description' => 'required|min:5',
            ]);
        }

        if ($validator->fails()) {
            #dd($validator);
            if(\Request::wantsJson()) {
                return response()->json(['errors'=>$validator->errors()], 500);
            } else {
                return redirect(route('create.edit', $listing))
                    ->withErrors($validator)
                    ->withInput();
            }
        }

        if($request->has('ends_at') && strtotime($request->get('ends_at'))) {
            $listing->ends_at = Carbon::parse($request->get('ends_at'));
        }

        $filters = Filter::orderBy('position', 'ASC')->where('is_hidden', 0)->where('is_default', 0)->get();
        if($request->input('tags_string')) {
            $listing->tags = explode(",", $request->input('tags_string'));
            $listing->tags_string = $request->input('tags_string');
            $listing->syncTags($listing->tags);
        }
        if($request->input('deal_comment')) {
            $listing->deal_comment = $request->input('deal_comment');
            $listing->save();
        }

        $listing->price_in_btc = $request->input('price_in_btc');

        $convert = new Converter;

        if ((float)$request->input('price_in_btc') == 1) {

            $listing->price = $convert->toCurrency($listing->currency, (float)$request->input('price'));
            $listing->btc_price = (float)$request->input('price');
        } elseif((float)$request->input('price_in_btc')) {
            $listing->price = (float)$request->input('price');
            $listing->price_in_btc = 0;
            if((float)$request->input('price_in_btc') == 3){
                $listing->currency = auth()->user()->currency;
            }
            $listing->btc_price = $convert->toBtc((float)$request->input('price'), $listing->currency);
        } else {
            $listing->price = (float)$request->input('price');
            $listing->price_in_btc = 0;
            $listing->btc_price = $convert->toBtc((float)$request->input('price'), 'USD');
            $listing->currency = 'USD';
        }

        if($request->input('subtitle')) {
            $listing->subtitle = $request->input('subtitle');
        } else {
            $listing->subtitle = "";
        }

        $listing->is_return = (int)$request->input('is_return');
        $listing->pricing_model_id = (int)$request->input('pricing_model_id');
        $listing->save();

        if($request->input('filters') || $request->input('shipping') || $request->input('buyer_rating')) {
            $meta = [];
            foreach($filters as $filter) {
                if(isset($params['filters'][$filter->field])) {
                    $value = $params['filters'][$filter->field];
                    if($filter->search_ui == 'rangeSlider' || $filter->search_ui == 'priceRange') {
                        $value = (float) $value;
                    }
                    $meta[$filter->field] = $value;
                }
            }

if(!empty($params['filters']['shipping'])) {
                $meta['shipping'] = $params['filters']['shipping'];
            }

            $meta['buyer_rating'] = (float)$request->input('buyer_rating');

            $listing->meta = $meta;
            $listing->save();
        }

        if($request->input('variations')) {
            $variant_options = [];
            foreach($params['variations'] as $variant) {
                if($variant['options'])
                    $variant_options[$variant['name']] = explode(",", $variant['options']);
            }
            $listing->variant_options = $variant_options;
            $listing->save();


            //now create the variants
            $matrix = collect();
            if($listing->variant_options) {
                $matrix = collect(cartesian_product($listing->variant_options)->asArray());
            }

            #dd($listing->variant_options);

            #delete the ones we no longer need
            foreach($listing->variants as $variant) {
                $delete = true;
                foreach($matrix as $item) {
                    if(($variant->meta == $item)) {
                        $delete = false;
                    }
                }
                if($delete) {
                    $variant->delete();
                }
            }

            #insert it in db, if not exists
            foreach($matrix as $item) {
                $listing_variant = new ListingVariant();

                foreach($item as $field => $value) {
                    $listing_variant = $listing_variant->where('meta->' . $field, $value);
                }

                $listing_variant = $listing_variant->first();
                if(!$listing_variant) {
                    $listing_variant = new ListingVariant();
                    $listing_variant->listing_id = $listing->id;
                    $listing_variant->stock = 999;
                    $listing_variant->meta = $item;
                    $listing_variant->save();
                }
            }

        }

        if($request->input('variants')) {
            foreach($params['variants'] as $variant_id => $variant) {
                $listing_variant = ListingVariant::find($variant_id);
                if($listing_variant) {
                    $listing_variant->price = (float)$variant['price'];
                    $listing_variant->stock = (int)$variant['stock'];
                    $listing_variant->save();
                }

            }
        }

        //set dates we don't want them to book
        if($request->input('blocked_dates')) {
            $table = (new ListingBookedDate())->getTable();
            DB::table($table)->where('listing_id', $listing->id)->update(['is_available' => true]);
            $blocked_dates = explode(",", $params['blocked_dates']);
            foreach($blocked_dates as $blocked_date) {
                $blocked_date = Carbon::parse($blocked_date);
                $listing_booked_date = ListingBookedDate::updateOrCreate([
                    'booked_date'   => $blocked_date,
                    'listing_id'    => $listing->id
                ], ['is_available'  => false]);

            }
        }

        //shipping stuff
        $filter_sh = $request->input('filters', array());
        if (isset($filter_sh['shipping'])) {
            $filter_sh = $filter_sh['shipping'];
        } else {
            $filter_sh = array();
        }
        $params['shipping'] = array();
        if($request->input('shipping') || $request->input('default_shipping')) {
            if ($request->input('default_shipping')) {
                foreach($request->input('default_shipping') as $default => $shippings) {
                    foreach($shippings as $position => $shipping) {
                        if (in_array($default, $filter_sh)) {
                            $shipping['is_default'] = $default;

                            $params['shipping'][] = $shipping;
                        }
                    }
                }
            }

            $count = 0;
            foreach($params['shipping'] as $position => $shipping) {
                if(!$shipping['name']) {
                    $shipping['name'] = 'unnamed';
                }

                $shipping_name = $shipping['name'];

                if (isset($shipping['country']) || isset($shipping['city'])) {
                    $names = array();

                    /*if (!empty($shipping['country'])) {
                        $names[] = $shipping['country'];
                    }

                    if (!empty($shipping['city'])) {
                        $names[] = $shipping['city'];
                    }*/

                    $names[] = $shipping['name'];

                    $params['country'] = $shipping['country'];
                    $params['city'] = $shipping['city'];
                    $params['location'] = $shipping['name'];

                    $shipping_name = implode(', ', $names);
                }

                $listing_shipping_option = ListingShippingOption::updateOrCreate([
                    'position'   => $position,
                    'listing_id'    => $listing->id
                ], ['name'  => $shipping_name, 'price'  => $shipping['price'], 'parcel_items'  => $shipping['parcel_items'], 'delivery_days'  => $shipping['delivery_days'], 'is_default'  => (!empty($shipping['is_default']) ? $shipping['is_default'] : 0)]);

                $count++;
            }

            //delete the ones that were removed
            foreach($listing->shipping_options as $position => $shopping_option) {
                if($position >= $count) {
                    $shopping_option->delete();
                }
            }
        }

        if($request->input('additional')) {
            $count = 0;
            foreach($params['additional'] as $position => $additional_option) {
                if(!$additional_option['name'])
                    continue;
                $listing_shipping_option = ListingAdditionalOption::updateOrCreate([
                    'position'   => $position,
                    'listing_id'    => $listing->id
                ], ['name'  => $additional_option['name'], 'price'  => $additional_option['price'], 'max_quantity'  => $additional_option['max_quantity']]);
                $count++;
            }

            //delete the ones that were removed
            if($listing->additional_options) {
                foreach ($listing->additional_options as $position => $additional_option) {
                    if ($position >= $count) {
                        $additional_option->delete();
                    }
                }
            }
        }

        if($request->input('services')) {
            $count = 0;
            foreach($params['services'] as $position => $service) {
                if(!$service['name'])
                    continue;
                $listing_service = ListingService::updateOrCreate([
                    'position'   => $position,
                    'listing_id'    => $listing->id
                ], ['name'  => $service['name'], 'duration'  => $service['duration'], 'price'  => $service['price']]);
                $count++;
            }

            //delete the ones that were removed
            if($listing->services) {
                foreach ($listing->services as $position => $service) {
                    if ($position >= $count) {
                        $service->delete();
                    }
                }
            }
            $listing->price = (float) collect($params['services'])->sortBy('price')->first()['price'];
        }

        $listing->fill($request->only(['title', 'description', 'stock', 'lat', 'lng', 'city', 'country', 'session_duration', 'min_duration', 'max_duration']));
        #dd($request->input('photos'));
        if($request->input('photos') && is_array($request->input('photos'))) {
            $photos = $request->input('photos');
            $media = [];
            foreach($photos as $photo) {

                $photo_meta = json_decode($photo);
                $tmp = [];
                if(json_last_error() == JSON_ERROR_NONE) {
                    if(isset($photo_meta->path))
                        $tmp['photo'] = $photo_meta->path;
                    if(isset($photo_meta->original))
                        $tmp['file'] = $photo_meta->original;
                    $tmp['type'] = $photo_meta->type;
                } else {
                    $tmp['photo'] = $photo;
                }
                $media[] = $tmp;
            }
            #dev_dd($media);
            $listing->photos = $media;
        }

        if (!empty($params['location'])){
            $e_location = explode(',', $params['location']);

            $point= new Point($e_location[0], ($e_location[1] ?? 0));
            $listing->location = \DB::raw("ST_GeomFromText('POINT(".$point->getLng()." ".$point->getLat().")')");

            $listing->country = $params['country'];
            $listing->city = $params['city'];
        } else if($request->get('lat') && $request->get('lng') && empty($request->get('location'))) {
            $point= new Point($request->get('lat'), $request->get('lng'));
            $listing->location = \DB::raw("ST_GeomFromText('POINT(".$point->getLng()." ".$point->getLat().")')");
        }
        if($request->has('price_per_unit_display')) {
            $listing->price_per_unit_display = $request->input('price_per_unit_display');
            if($listing->pricing_model->widget == 'request') {
                $listing->price_per_unit_display = $listing->price_per_unit_display;
            }
        }
        if($request->has('draft')) {
            $listing->is_draft = true;
        }
        if($request->has('undraft')) {
            $listing->is_draft = false;
        }

        $listing->save();

        if($request->has('renew')) {
            return $this->publish_listing($listing);
        }

        if($request->has('publish')) {

            $listing->is_draft = false;
            if(!$listing->is_admin_verified && !setting('listings_require_verification')) {
                $listing->is_admin_verified = Carbon::now();
            }
            $listing->save();

            if(module_enabled("memberships") || module_enabled("listingfee")) {
                return $this->publish_listing($listing);
            } else {
                if(!$listing->is_published && !$listing->is_admin_verified) {
                    Mail::to(config('mail.from.address'))->send(new NewListing($listing));
                }
                $listing->is_published = true;
                $listing->save();
            }

        }

        alert()->success( __('Successfully saved.') );
        return back();
    }


    private function calculateExpiryTime($old_time, $duration_units, $duration_period) {

        $greatest_time = Carbon::now();
        #dd($old_time);
        if($old_time && $old_time->gt($greatest_time)) {
            $greatest_time = $old_time;
        }
        $function = "add".ucwords(str_plural($duration_period));
        return $greatest_time->$function($duration_units);

    }

    private function publish_listing($listing) {

        $ordered_routes = ['listingfee', 'memberships', 'credits'];
        $user = auth()->user();

        #does the user have an active membership?
        if(module_enabled("memberships")) {
            if($user->subscription('main') && $user->subscription('main')->plan->price > 0) {
                return redirect()->route('addons.memberships.payment', [$listing]);
            }
        }

        #does the user have any credits?
        if(module_enabled("credits")) {
            if($user->balance > 0) {
                return redirect()->route('addons.credits.payment', [$listing]);
            }
        }

        #otherwise redirect to a payment method
        foreach($ordered_routes as $ordered_route) {
            if(module_enabled($ordered_route)) {
                return redirect()->route('addons.'.$ordered_route.'.payment', [$listing]);
            }
        }

        #if listing fee
        /*if(module_enabled("listingfee")) {
            return redirect()->route('addons.listingfee.payment', [$listing]);
        }

        #if memberships
        if(module_enabled("memberships")) {
            return redirect()->route('addons.memberships.payment', [$listing]);
        }*/


    }

    protected function asWKT(GeometryInterface $geometry)
    {
        return $this->getQuery()->raw("ST_GeomFromText('".$geometry->toWKT()."')");
    }

    public function deleteUpload($listing, $uuid, Request $request) {
        $photos = (array) $listing->photos;
        unset($photos[$uuid]);
        $listing->photos = $photos;
        $listing->save();
        return ['success' => true];
    }

    public function session($listing, Request $request) {
        $files = [];
        if($listing->media) {
            #dd($listing->media);
            foreach($listing->media as $i => $item) {
                #dd($item);
                $tmp = [
                    "name" => 'photo_'.($i+1).'.jpg',
                    "uuid" => $i,
                    "thumbnailUrl" => $item['photo'],
                ];
                $tmp['type'] = $item['type'];
                $tmp['path'] = $item['photo'];
                if(isset($item['file']))
                    $tmp['original'] = $item['file'];
                $files[] = $tmp;
            }
        }
        return $files;
    }

    public function upload(Request $request) {
        $path = 'images/'.date('Y/m/d') .'/'. md5_file($request->qqfile->getRealPath()).'.jpg';
        $img = Image::make($request->qqfile);

        $img->fit(680, 460, function ($constraint) {
            $constraint->upsize();
        });
        $img->resizeCanvas(680, 460, 'center', false, '#000000');
        $img = (string) $img->encode('jpg', 90);

        $thumb = Storage::cloud()->put($path, $img, 'public');
        $data['success'] = true;
        $data['type'] = 'image';
        $data['path'] = Storage::cloud()->url($path);
        $data['thumbnailUrl'] = $data['path'];

        return $data;
    }


    public function getTimes($listing) {
        $this->authorize('update', $listing);

        $data = [];
        $data['listing'] = $listing;

        $slots = [];
        if($listing->timeslots) {
            foreach($listing->timeslots as $timeslot) {
                $slots[$timeslot['day']][(int) $timeslot['start_time']] = 1;
            }
        }

        /**
         * Timeslots
         */
        $days = range(1, 7);
        $hours = range(0, 23);
        $matrix = [];
        foreach($days as $day) {
            foreach($hours as $hour) {
                $matrix[$day][$hour] = array_get($slots, $day.'.'.$hour, 0);
            }
        }

        $data['matrix'] = $matrix;
        $data['slots'] = $slots;

        return view('create.times', $data);

    }

    public function postTimes($listing, Request $request) {
        $this->authorize('update', $listing);

        $times = $request->get('selection');

        $slots = [];
        foreach($times as $day => $times) {
            foreach($times as $hour => $value) {
                $slots[] = ['day' => $day, 'start_time' => $hour.':00', 'end_time' => ($hour+1).':00'];
            }
        }
        $listing->timeslots = $slots;
        $listing->save();
        return redirect(url()->current());
        return $listing;

    }
}
