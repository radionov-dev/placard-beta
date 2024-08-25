<?php

namespace App\Http\Controllers;

use App\Models\bElectrum;
use App\Models\BitDeals;
use App\Models\Order;
use App\Models\PricingModel;
use Carbon\Carbon;
use Grimzy\LaravelMysqlSpatial\Types\LineString;
use Grimzy\LaravelMysqlSpatial\Types\Polygon;
use Illuminate\Http\Request;
use App\Models\Filter;
use App\Models\Listing;
use App\Models\Category;
use App\Models\User;
use App\Models\Bit_Message;
use Grimzy\LaravelMysqlSpatial\Types\Point;
use Setting;
use MetaTag;
use GeoIP;
use App\Widgets\Order\BuyWidget as buyWidget;

class BrowseController extends Controller
{

    public function listings(Request $request) {
        #save address in session
        foreach($request->only(['lat', 'lng', 'bounds', 'location']) as $k => $v) {
            session([$k => $v]);
        }

        $data = $this->getListingData($request);
        if($request->get('ajax')) {
            return response()->json($data);
        }

        $r_all = $request->all();

        MetaTag::set('rss', url('/feed') . (($r_all) ? ('?' . http_build_query($r_all)) : ''));
        MetaTag::set('title', __("Browse listings"));
        return view('browse.index', $data);
    }

    public function getFacets() {
        /*
            listing fields editor must have category selector

            inputFilter     ->  anything
            refinementList  ->  get list of values
            menuSelect      ->  get list of values
            rangeSlider     ->  min, max
            priceRange      ->  min, max

            go through listing fields
                get searchUI
                check categories
        */
        $filters = Filter::where('is_hidden', 0)->where('is_searchable', 1)->orderBy('position', 'ASC')->get();
        $facet_groups = [];
        $category_id = request('category', 0) ? :0;

        foreach($filters as $filter) {

            if($filter->is_category_specific && $filter->categories && is_array($filter->categories)){
                if(!in_array($category_id, $filter->categories)) {
                    continue;
                }
            }

            $facet_group = [];
            $facet_group['field'] = $filter->field;
            $facet_group['name'] = $filter->name;
            $facet_group['search_ui'] = $filter->search_ui;
            $listings = new Listing();
            if(in_array($filter->search_ui, ['refinementList', 'menuSelect', 'colorSelect'])) {
                $facet_group['options'] = [];
                if($filter->form_input_meta && isset($filter->form_input_meta['values'])) {
                    foreach($filter->form_input_meta['values'] as $k => $v) {
                        $tmp = [];
                        $tmp['name'] = $v['label'];
                        $tmp['value'] = $v['value'] ;
                        $facet_group['options'][] = $tmp;
                    }

                } else {
                    $listings = $listings->groupBy('meta->'.$filter->field)
                        ->whereNotNull('meta->'.$filter->field.'')
                        ->select('meta->'.$filter->field.' as name', 'meta->'.$filter->field.' as value', \DB::raw('count(*) as total'))
                        ->orderBy('meta->'.$filter->field, 'ASC')
                        ->get();

                    $facet_group['options'] = $listings->toArray();
                }

            } else if(in_array($filter->search_ui, ['rangeSlider', 'priceRange'])) {
                //$min = $listings->min('meta->'.$filter->field);
                //$max = $listings->max('meta->'.$filter->field);
                //$facet_group['options'] = [$min, $max];
                $facet_group['options'] = null;
            } elseif($filter->search_ui == 'pricingModel') {
                if (!empty($category_id)) {
                    $selected_category = Category::find($category_id);
                    $pricing_models = $selected_category->pricing_models->pluck('name', 'id');
                }

                $facet_group['options'] = [];

                if (empty($pricing_models)) {
                    $pricing_models = PricingModel::pluck('name', 'id');
                }

                foreach($pricing_models as $id => $name) {
                    $tmp = [];
                    $tmp['name'] = $name;
                    $tmp['value'] = $id;
                    $facet_group['options'][] = $tmp;
                }
            } else {
                $facet_group['options'] = null;
            }
            $facet_groups[$filter->field] = json_decode(json_encode($facet_group));
        }

        return $facet_groups;
    }

    public function getListingData(Request $request, $all = 0) {

        $averageRate = auth()->check()? round((auth()->user()->averageRate()/3)*100) : 0;

        $data = [];
        $data['facets'] = $this->getFacets();

        $listings = new Listing();
        $listings = $listings->active();
        $listings = $listings->where(function ($query) use ($averageRate){
            $query->where('meta->buyer_rating', '<=', $averageRate)->orWhereNull('meta->buyer_rating');
        });

        //search by title, description, tags
        if($request->get('q')) {
            $exclusions = array();
            $includes = array();
            $sub_strs = explode('"', $request->get('q'));

            $i = 0;
            foreach($sub_strs as $sub_str) {
                if(($i % 2) && isset($sub_strs[$i+1])) {
                    $includes[] = $sub_str;
                }
                $i++;
            }

            $words = $request->get('q');
            $replace = array();
            $replace[] = '""';
            $replace[] = '" "';


            foreach ($includes as $include) {
                $words = str_replace('"'.$include.'"', str_replace(' ', '$_sp_$', $include), $words);
            }

            $words = explode(' ', str_replace($replace, '', $words));

            foreach($words as $key => &$word) {
                $word = str_replace('$_sp_$', ' ', $word);
                $e_exclusion = explode('-', $word);
                $e_include = explode('+', $word);
                if (isset($e_exclusion[1]) && empty($e_exclusion[0])) {
                    $exclusions[] = $e_exclusion[1];
                    unset($words[$key]);
                } elseif(isset($e_include[1]) && empty($e_include[0])) {
                    //$includes[] = $e_include[1];
                    //unset($words[$key]);
                } elseif(empty($word)) {
                    unset($words[$key]);
                }
            }

            if ($words) {
                $listings = $listings->where(function ($query) use ($words) {
                    foreach($words as $word) {
                        $query->where('title', 'LIKE', '%' . $word . '%')->orWhere('description', 'LIKE', '%' . $word . '%');
                    }
                });
                //$listings->search(implode(' ', $words));
            }

            /*if ($includes) {
                $listings = $listings->where(function ($query) use ($includes) {
                    foreach($includes  as $include) {
                        $query->where('title', 'LIKE', '%'.$include.'%')->orWhere('description', 'LIKE', '%'.$include.'%');
                    }
                });
            }*/

            if ($exclusions) {
                $listings = $listings->where(function ($query) use ($exclusions) {
                    foreach($exclusions  as $exclusion) {
                        $query->where('title', 'NOT LIKE', '%'.$exclusion.'%')->where('description', 'NOT LIKE', '%'.$exclusion.'%');
                    }
                });
            }
            #dd(debug_backtrace ());
        }
        if($request->get('clear')) {
            $request->session()->forget(['lat', 'lng', 'bounds', 'location']);
            #dd(debug_backtrace ());
        }
        if($request->get('user')) {
            $listings = $listings->where('user_id', '=', (int)$request->get('user'));
        }
        if($request->get('price_min')) {
            $listings = $listings->where('price', '>=', (int) $request->get('price_min'));
        }
        if($request->get('price_max')) {
            $listings = $listings->where('price', '<=', (int) $request->get('price_max'));
        }

        //$listings = $listings->with('user');

        $filters = Filter::orderBy('position', 'ASC')->where('is_hidden', 0)->where('is_default', 0)->get();
        $is_filtered = false;
        if($request->has('category')) {
            $is_filtered = true;
        }
      
      $is_shipping = false;

        $category_id = $request->get('category', 0) ? :0; //get the category
        foreach($filters as $filter) {
            if($filter->default){
                continue;
            }

            if(in_array($filter->search_ui, ['menuSelect']) && $request->input($filter->field)) {
                $listings = $listings->where('meta->' . $filter->field, $request->input($filter->field));
                $is_filtered = true;
            } elseif(in_array($filter->search_ui, ['refinementList', 'colorSelect']) && $request->input($filter->field) !== NULL) {
                if ($filter->field == 'shipping') {
                  $is_shipping = true;
                  
                    $listings = $listings->whereRaw('json_contains(meta, \'{"shipping": ["' . $request->input($filter->field) . '"]}\')');
                    if (in_array((int)$request->input($filter->field), array(2,3,4))) {
                        $listings->whereHas('user', function ($query) use ($request, $filter) {
                            $query->join('users_meta', 'users_meta.user_id', '=', 'users.id');
                            $query->where('users_meta.value','LIKE', '%"' . current_locale() . '"%');
                            $query->where('users_meta.key', 'delivery_regions');
                          
                            if ((int)$request->input($filter->field) == 4) {
                                $query->where('users.country', '<>', current_locale());
                            } else {
                                $query->where('users.country', current_locale());
                            }
                            $query->whereNull('banned_at')->whereNull('deleted_at');
                            //$query->where('country', current_locale())->whereNull('banned_at')->whereNull('deleted_at');
                        });
                    } else {
                      $listings->whereHas('user', function ($query) {
                        $query->whereNull('banned_at')->whereNull('deleted_at');
                      }); 
                    }

                } else {
                    $listings = $listings->where('meta->' . $filter->field, $request->input($filter->field));
                }
                /*$filter_values = collect($request->input($filter->field))->filter(function ($value, $key) {
                    return $value == 1;
                })->keys();

                $listings->where(function ($query) use($filter_values, $filter) {
                    foreach($filter_values as $filter_value) {
                        $filter_value = urldecode($filter_value);
                        $filter_value = trim($filter_value,'"');
                        $query->orWhereRaw("JSON_CONTAINS(meta, '".addslashes(json_encode([$filter->field => $filter_value]))."')");
                    }
                });*/

                $is_filtered = true;
            } elseif(in_array($filter->search_ui, ['pricingModel']) && $request->input($filter->field)) {

                $listings = $listings->where('pricing_model_id', $request->input($filter->field));
                $is_filtered = true;
            } elseif(in_array($filter->search_ui, ['rangeSlider', 'priceRange'])) {
                if($request->input($filter->field.'_min')) {
                    $listings = $listings->where('meta->'.$filter->field, '>=', (int) $request->input($filter->field.'_min'));
                    $is_filtered = true;
                }
                if($request->input($filter->field.'_max')) {
                    $listings = $listings->where('meta->'.$filter->field, '<=', (int) $request->input($filter->field.'_max'));
                    $is_filtered = true;
                }


            } else {
                if($filter->field && $request->input($filter->field)) {
                    $listings = $listings->where('meta->' . $filter->field, $request->input($filter->field));
                    $is_filtered = true;
                }
            }

        }
      
        $listings = $listings->with('pricing_model');
          
        if(!$is_shipping) {
          $listings->where(function ($query) {
            $query->where(function ($query) {
                $query->whereRaw('json_contains(meta, \'{"shipping": ["4"]}\')')
                    ->whereHas('user', function ($query) {
                        $query->join('users_meta', 'users_meta.user_id', '=', 'users.id');
                        $query->where('users_meta.value','LIKE', '%"' . current_locale() . '"%');
                        $query->where('users_meta.key', 'delivery_regions')->where('users.country', '<>',current_locale())->whereNull('banned_at')->whereNull('deleted_at');
                    });
            })->orWhere(function ($query) {
                $query->whereRaw('json_contains(meta, \'{"shipping": ["3"]}\')')
                    ->whereHas('user', function ($query) {
                        $query->join('users_meta', 'users_meta.user_id', '=', 'users.id');
                        $query->where('users_meta.value','LIKE', '%"' . current_locale() . '"%');
                        $query->where('users_meta.key', 'delivery_regions')->where('users.country', current_locale())->whereNull('banned_at')->whereNull('deleted_at');
                        //$query->where('country', current_locale())->whereNull('banned_at')->whereNull('deleted_at');
                    });
            })->orWhere(function ($query) {
                $query->whereRaw('json_contains(meta, \'{"shipping": ["2"]}\')')
                    ->whereHas('user', function ($query) {
                        $query->join('users_meta', 'users_meta.user_id', '=', 'users.id');
                        $query->where('users_meta.value','LIKE', '%"' . current_locale() . '"%');
                        $query->where('users_meta.key', 'delivery_regions')->whereNull('banned_at')->whereNull('deleted_at');
                        //$query->where('country', current_locale())->whereNull('banned_at')->whereNull('deleted_at');
                    });
            })->orWhere(function ($query) {
                $query->whereRaw('NOT json_contains(meta, \'{"shipping": ["2"]}\')')->whereRaw('NOT json_contains(meta, \'{"shipping": ["3"]}\')')->whereRaw('NOT json_contains(meta, \'{"shipping": ["4"]}\')')
                    ->whereHas('user', function ($query) {
                        $query->whereNull('banned_at')->whereNull('deleted_at');
                    });
            });
          });
        }

        $category_id = $request->get('category', 0) ? :0; //get the category

        //get listings with category and child categories
        $full_categories = Category::orderBy('order', 'ASC')->all();
        $categories = $this->getSearchableCategories($full_categories, $category_id); //get all child categories

        $listings = $listings->whereIn('category_id', $categories);
        //$listings = $listings->whereNotNull('lat');
        //$listings = $listings->whereNotNull('lng');
        //$listings = $listings->whereNotNull('location');

        if($request->input('tagged')) {
            $tagged = $request->input('tagged');
            $listings = $listings->whereRaw('json_contains(tags, \'["' . $tagged . '"]\')');
            //$listings = $listings->whereJsonContains('tags', $tagged);
        }

        $this->categories = $categories;
        $category = Category::find($category_id); //current category

        $level_categories = Category::where('parent_id', $category_id)->orderBy('order', 'ASC')->get(); //categories on this level
        $parent_categories = $this->getParentCategories($category_id);

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



        //distance calculations
        $lat = $request->get('lat') ? : GeoIP::getLatitude();
        $lng = $request->get('lng') ? : GeoIP::getLongitude();
        if($request->get('bounds') || ( $request->get('lat') && $request->get('lng') )) {
            $bounds = $request->get('bounds');
            $bounds = explode(",", $bounds);

            if(count($bounds) == 4) {
                $swLat = $bounds[0];
                $swLon = $bounds[1];
                $neLat = $bounds[2];
                $neLon = $bounds[3];

                $southWest = new \Geokit\LatLng($swLat, $swLon);
                $northEast = new \Geokit\LatLng($neLat, $neLon);
                $bounds = new \Geokit\Bounds($southWest, $northEast);

                if($request->input('distance') && (int) $request->input('distance') >= 0) {

                    $math = new \Geokit\Math();
                    $expandedBounds = $math->expand($bounds, $request->input('distance').config('marketplace.distance_unit'));

                    $swLat = $expandedBounds->getSouthWest()->getLatitude();
                    $swLon = $expandedBounds->getSouthWest()->getLongitude();
                    $neLat = $expandedBounds->getNorthEast()->getLatitude();
                    $neLon = $expandedBounds->getNorthEast()->getLongitude();
                }

                $polygon = new Polygon([new LineString([
                    new Point($swLat, $swLon),
                    new Point($neLat, $swLon),
                    new Point($neLat, $neLon),
                    new Point($swLat, $neLon),
                    new Point($swLat, $swLon),
                ])]);

                if($request->input('distance') >= 0) {
                    $listings = $listings->within('location', $polygon);
                }

            } else {
                if($request->get('distance')) {
                    $listings = $listings->distanceSphere($request->get('distance', 1000)*1000, new Point($lat, $lng), 'location');
                }
            }

            $listings = $listings->distanceSphereValue('location', new Point($lat, $lng));
        } elseif($request->input('sort') == 'distance') {
            $listings = $listings->distanceSphereValue('location', new Point($lat, $lng));
        }

        $data['view'] = $request->get('view', setting('default_view', 'map'));
        $data['filters'] = $filters;
        $data['lat'] = $lat;
        $data['lng'] = $lng;

        #$sort = $request->input('sort')?:'date';
        if($request->input('q') && !$request->input('sort')) {
            $sort = 'relevance';
        } else {
            $sort = $request->input('sort')?:'date';
        }

        $listings->withCount('comments');

        $listings = $listings->orderByRaw('IF(priority_until>NOW(), 1, 0) DESC');
        if($sort == 'popular') {
            $listings = $listings->orderBy('comments_count', 'DESC');
        }
        if($sort == 'date') {
            $listings = $listings->orderBy('created_at', 'DESC');
        }
        /*if($sort == 'ending_soon') {
            $listings = $listings->orderByRaw('ISNULL(ends_at), ends_at ASC')->orderBy('expires_at', 'ASC');
        }*/
        if($sort == 'price_lowest_first') {
            $listings = $listings->orderBy('btc_price', 'ASC');
        }
        if($sort == 'price_highest_first') {
            $listings = $listings->orderBy('btc_price', 'DESC');
        }
        /*if($sort == 'distance') {
            $listings = $listings->orderBy('distance', 'ASC');
        }*/

        if($all) {
            return $listings->get();
        }

        if($request->get('ajax')) {
            $data['map_listings'] =  $listings->whereNotNull('lat')->whereNotNull('lng')->limit(1000)->get();
        }

        $data['params'] = $request->all();
        $data['sort'] = $sort;

        $sort_options = [];
        if($request->input('q')) {
            $sort_options['relevance'] = __('Relevance');
        }
        $sort_options['date'] = __('Most recent first');
        $sort_options['popular'] = __('Popular');
        //$sort_options['ending_soon'] = __('Ending soonest');
        $sort_options['price_lowest_first'] = __('Cheap');
        $sort_options['price_highest_first'] = __('Expensive');
        //$sort_options['distance'] = __('Nearest first');
        $data['sort_options'] = $sort_options;

        $data['listings'] = $listings->paginate(24);

        foreach ($data['listings'] as &$listing) {
            $delivery_regions = !empty($listing->user->delivery_regions) ? $listing->user->delivery_regions : array();
            $delivery_country = $listing->user->country;

            $factor = 0;
            $extend_days = 1;

            if (!empty($listing->user->delivery_settings)) {
                foreach ($listing->user->delivery_settings as $delivery_settings) {
                    if (!empty($delivery_settings['countries']) && in_array(current_locale(), $delivery_settings['countries'])) {
                        $factor = (float)$delivery_settings['factor'] > 0 ? $delivery_settings['factor'] : 1;
                        $extend_days = (int)$delivery_settings['extend_days'];
                        break;
                    }
                }
            }

            foreach($listing->shipping_options as $key => &$shipping_option) {
                if (($shipping_option->is_default == 4 && !in_array(current_locale(), $delivery_regions)) || ($shipping_option->is_default == 3 && $delivery_country != current_locale()) || !in_array($shipping_option->is_default, $listing->meta['shipping'])) {
                    unset($listing->shipping_options[$key]);
                } elseif ($shipping_option->is_default == 4) {
                    $shipping_option->days = $shipping_option->delivery_days + $extend_days;
                    $shipping_option->price *= $factor;
                } else {
                    $shipping_option->days = $shipping_option->delivery_days;
                }
            }

            #calculate shipping cost
            $selected_shipping_price = 0;
            foreach($listing->shipping_options->sortByDesc('price') as $key => &$selected_shipping_method) {
                    $selected_shipping_price = $selected_shipping_method->price;
                    if ($selected_shipping_method->is_default == 3) {
                        break;
                    }
           }

            $listing->price += $selected_shipping_price;
            if ($listing->price_in_btc) {
                //$listing->btc_price += $selected_shipping_price;
            }
        }

        $data['is_filtered'] = $is_filtered;

        $data['load_time'] = round(microtime(true) - LARAVEL_START);
        return $data;
    }

    private function recursiveSearch(&$value) {
        $value['child_ids'][] = $value['id'];
        if (isset($value['child'])) {
            foreach ($value['child'] as &$child) {
                $id = $this->recursiveSearch($child);
                if ( is_array($id) ) {
                    $value['child_ids'] = array_merge($value['child_ids'], $id);
                } else {
                    $value['child_ids'][] = $id;
                }
            }
            $this->category_childs[$value['id']] = $value['child_ids'];
            return $value['child_ids'];
        }
    }

    private function getCategoryCounts() {

        $categories = Category::all();
        $counts = [];
        foreach($categories as $category) {
            $listings_count = Listing::where('category_id', $category->id)->active()->count();
            $counts[$category->id] = $listings_count;
        }

        $categories = Category::orderBy('order', 'ASC')->nested()->get();
        $categories = [
            'id' => 0,
            'child' => $categories
        ];
        #dev_dd($categories);
        $this->recursiveSearch($categories);

        $category_listing_counts = [];
        foreach($this->category_childs as $category_id => $values) {
            $category_listing_counts[$category_id] = 0;
            foreach($values as $value) {
                $category_listing_counts[$category_id] += $counts[$value];
            }

        }

        return $category_listing_counts;

    }

    private function removeEmptyCategories($categories, $counts) {

        $empty_categories = [];
        foreach($categories as $category) {

            $listings_count = $counts[$category->id];
            if($listings_count == 0) {
                $empty_categories[] = $category->id;
            }
        }

        return $categories->reject(function($category) use($empty_categories) {
            return in_array($category->id, $empty_categories);
        });
    }

    public function getParentCategories($category_id, $parents = []) {
        $category = Category::find($category_id);
        if($category) {
            $parents[] = $category->parent_id;
            if($category->parent_id) {
                $parents = self::getParentCategories($category->parent_id, $parents);
            }
        }
        return $parents;
    }

    private function getSearchableCategories($full_categories, $category_id, $level = null) {

        $categories = $full_categories->where('parent_id', (int) $category_id)->pluck('id')->all();

        foreach($categories as $category) {
            if(!$level) {
                $children = $this->getSearchableCategories($full_categories, $category);
                $categories = array_merge($categories, $children);
            }
        }
        $categories = array_unique($categories);

        //current category
        $categories[] = $category_id;
        return $categories;
    }


    public function categories() {

        $categories = Category::nested()->get();
        $data['categories'] = $categories;
        $data['load_time'] = round(microtime(true) - LARAVEL_START);
        return $data;
    }

    public function feed(Request $request, Listing $event)
    {
        return $event;
    }

    public function checkElectrumAddress(Request $request)
    {
        /*echo "2MshG4dBx8HnHWgS345k3rGmCRiN8qQtgSp<br><br>bc_history: <br>";
        var_dump(BitDeals::bc_history(array('account' => '2MshG4dBx8HnHWgS345k3rGmCRiN8qQtgSp')));

        $balace = bElectrum::getAddressBalace('2MshG4dBx8HnHWgS345k3rGmCRiN8qQtgSp');
        echo "<br><br>Electrum Balace: <br>";
        var_dump($balace);*/

        $orders = Order::whereNotNull('payment_address')->where('status', 'open')->where('payment_until', '>=', Carbon::today())->inRandomOrder()->take(5)->get();
        //$orders = Order::whereNotNull('payment_address')->where('id', '101')->take(5)->get();

        foreach($orders as $order) {
            $is_cath = false;
          try {
            list($balace, $confirmed_balace) = bElectrum::getAddressBalace($order->payment_address);
          } catch (\Electrum\Response\Exception\ElectrumResponseException $e) {
        	$balace = $confirmed_balace = 0;
            $is_cath = true;
    	  }
          
          //var_dump((int)$is_cath . ' - ' . $balace);
          
            if ($is_cath) {
              $status_deal = BitDeals::status_deal(array('address' => $order->payment_address));
              $payload = nl2br(base64_decode($status_deal->payload));
              
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
                  } elseif (!empty($order_status) && in_array($order_status, array('Paid'))) {
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
            } elseif ((float)$balace >= (float)$order->getAttribute('btc_payment_sum')) {
                $btc_payment_is = $order->getAttribute('btc_payment_is')?$order->getAttribute('btc_payment_is'):0;

                if($confirmed_balace >= (float)$order->getAttribute('btc_payment_sum')) {
                    $order = Order::find($order->id);
                    $order->accepted_at = Carbon::now();
                    $order->status = 'paid';
                    $order->save();
                }

                if(!$btc_payment_is) {
                    $order->setAttribute('btc_payment_is', 1);
                    $order->save();

                    //$widget = '\App\Widgets\Order\\'.camel_case($order->listing->pricing_model->widget).'Widget';
                    $widget = new buyWidget();
                    $widget->decrease_stock($order, $order->listing);
                }

                if($confirmed_balace >= (float)$order->getAttribute('btc_payment_sum')) {
                    $user = User::find($order->seller_id);
                    if ($user->bitmessage) {
                        Bit_Message::send($user->bitmessage, __('New Paid deal'), __("You have a new paid deal.\n\rThe deal: " . route('account.orders.show', $order)));
                    }


                    $bd_type = $order->getAttribute('bd_type');

                    if ($bd_type == 'mediation') {
                        $bd_type = 'postpayment';
                    }

                    $seller_rating = $order->listing->user->totalCommentCount() . ", " . round(($order->listing->user->averageRate() / 3) * 100) . "%";
                    $customer_rating = $order->user->totalCommentCount() . ", " . round(($order->user->averageRate() / 3) * 100) . "%";

                    $deal = BitDeals::pay_deal(array(
                        'order' => 'Pay',
                        'type' => $bd_type,
                        'at' => url('/'),
                        'date' => date("Y-m-d H:i:s", $order->getAttribute('timestamp')) . ' UTC',
                        'seller_address' => $order->listing->user->bitcoin,
                        'seller_rating' => $seller_rating,
                        'customer_address' => $order->user->bitcoin,
                        'customer_rating' => $customer_rating,
                        'payment_sum' => $order->getAttribute('btc_payment_sum'),
                        'payment_address' => $order->payment_address,
                        'payment_until' => date("Y-m-d H:i:s", strtotime($order->payment_until)) . ' UTC',
                        'feedback_leave_before' => date("Y-m-d H:i:s", $order->getAttribute('end_timestamp')) . ' UTC'
                    ));
                }
            }
        }
    }
}
