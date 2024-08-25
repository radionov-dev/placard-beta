<?php

namespace App\Http\Controllers;

use Jimmerioles\BitcoinCurrencyConverter\Converter;
use App\Mail\ListingVerified;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Routing\Controller;

use App\Models\Filter;
use App\Models\Listing;
use App\Models\Category;
use Grimzy\LaravelMysqlSpatial\Types\Point;
use View;
use Location;
use Mapper;
use Setting;
use MetaTag;
use Mail;
use Carbon\Carbon;

class ListingController extends Controller
{

    protected $category_id;

    /**
     * Display a listing of the resource.
     * @return Response
     */
    public function index($listing, $slug, Request $request)
    {
	
        $data = [];
        $visible_listing = $listing->is_published && $listing->is_admin_verified && !$listing->is_disabled;
        $can_edit = auth()->check() && (auth()->user()->id == $listing->user_id || auth()->user()->can('edit listing'));

        $averageRate = auth()->check()? round((auth()->user()->averageRate()/3)*100) : 0;

        if($listing->meta['buyer_rating'] > $averageRate) {
            $visible_listing = false;
        }

        if(!$visible_listing && !$can_edit) {
            return abort(404);
        }

        if ($listing->price_in_btc) {
            $convert = new Converter;

            $listing->price = $convert->toCurrency($listing->currency, (float)$listing->btc_price);
            $listing->save();
        }

		$breadcrumbs = [];
		$category = $listing->category;
		if($category) {
			$i = 0;
			while($category = $category->child) {
				$breadcrumbs[] = $category;
				$i ++;
				if($i == 5)
					break;
			}
		}
        $data['breadcrumbs'] = array_reverse($breadcrumbs);

        $data['has_map'] = $data['is_snapshot'] = false;
        if($listing->location && setting('googlmapper.key')) {
            Mapper::map($listing->location->getLat(), $listing->location->getLng(), ['zoom' => 14, 'zoomControl' => false, 'streetViewControl' => false, 'mapTypeControl' => false, 'center' => true, 'marker' => true]);
            $data['has_map'] = true;
        }

        $data['facets'] = BrowseController::getFacets();
        $category_id = $listing->category->id;
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


		$listing->load('shipping_options');
		$listing->load('additional_options');


        $data['listing'] = $listing;
        $data['seller'] = $listing->user;
		$data['filters'] = Filter::orderBy('position', 'ASC')->get();

        $data['listing']['def_filters'] = $data['filters'];

        $data['rate'] = $request->get('rate', '');

        if ((int)$data['rate']) {
            $data['comments'] = $listing->comments()->with('commenter')->with('listing')->where('rate', $data['rate'])->paginate(20);
        } else {
            $data['comments'] = $listing->comments()->with('commenter')->with('listing')->paginate(20);
        }

        #$data['comments'] = $listing->comments()->orderBy('created_at', 'DESC')->limit(5)->get();
        #$data['comment_count'] = $listing->totalCommentCount();

        MetaTag::set('title', $listing->title);
        MetaTag::set('description', $listing->description);
		#dd($listing->thumbnail);
        MetaTag::set('image', url($listing->thumbnail));
        if($request->has('iframe')) {
            return view('listing.iframe', $data);
        }
        return view('listing.show', $data);
    }

	public function card($listing, $slug, Request $request) {
		
        $data = [];
        $visible_listing = $listing->is_published && $listing->is_admin_verified && !$listing->is_disabled;
        if(!$visible_listing && !$can_edit) {
            return abort(404);
        }

        $data['listing'] = $listing;
        $data['seller'] = $listing->user;
		
        MetaTag::set('title', $listing->title);
        MetaTag::set('description', $listing->description);
        MetaTag::set('image', url($listing->thumbnail));
        return view('listing.card', $data);
    }

    public function star($listing) {
        $listing->toggleFavorite();
        return view('listing.partials.favorite', compact('listing'));
    }
    public function spotlight($listing) {
        if(auth()->user()->can('disable listing')) {
            $listing->toggleSpotlight();
        }
        return redirect(route('listing', [$listing, $listing->slug]));
    }
    public function verify($listing) {
        //sleep(2);
        if(auth()->user()->can('disable listing')) {
            if($listing->is_admin_verified && !$listing->is_disabled) {
                $listing->is_disabled = Carbon::now();
            } elseif($listing->is_admin_verified && $listing->is_disabled) {
                $listing->is_disabled = null;
            }

            if(!$listing->is_admin_verified) {
                $listing->is_admin_verified = Carbon::now();
                $listing->is_disabled = null;
                #Mail::to(auth()->user()->email)->send(new ListingVerified($listing));
                Mail::to($listing->user->email)->send(new ListingVerified($listing));
            }

            $listing->save();
        }
        return redirect(route('listing', [$listing, $listing->slug]));
    }

    /**
     * Show the form for editing the specified resource.
     * @return Response
     */
    public function edit($listing)
    {
        $data = [];
        $data['listings_form'] = Setting::get('listings_form', []);
        $data['listing'] = $listing;
        $categories = Category::nested()->get();
        $categories = flatten($categories, 0);
        $list = [];
        foreach($categories as $category) {
            $list[''] = '';
            $list[$category['id']] = str_repeat("&mdash;", $category['depth']+1) . " " .$category['name'];
        }
        $data['categories'] = $list;


        $data['pricing_models'] = [];
        foreach(config('pricing-models') as $price_option => $value) {
            $data['pricing_models'][$price_option] = $value['label'];
        }

        $selected_category = null;
        $selected_category = Category::find(request('category', $listing->category_id));
        $selected_pricing_model = null;

        $data['selected_category'] = $selected_category;
        $data['selected_pricing_model'] = $selected_pricing_model;
        $data['form'] = 'edit';

        return view('create.details', $data);
    }
	
}
