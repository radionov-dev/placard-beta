<?php

namespace App\Http\Controllers\Account;

use App\Http\Controllers\BrowseController;
use App\Models\Category;
use App\Models\Filter;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Listing;

class FavoritesController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
		$user = User::find(auth()->user()->id);
		$favorites = $user->favorite(Listing::class)->reverse();
		/*$favorites = $user->favorites()->where('favoriteable_type', Listing::class)->with('favoriteable')->get()->mapWithKeys(function ($item) {
			$tmp = $item['favoriteable'];
			$tmp['user'] = $item['user'];
            return [$item['favoriteable']->id=>$tmp];
        });*/

        $data['facets'] = BrowseController::getFacets();
        $category_id = 0;
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

        $data['filters'] = Filter::orderBy('position', 'ASC')->where('is_hidden', 0)->where('is_default', 0)->get();;
        $data['parent_categories'] = $parent_categories;
        $data['level_categories'] = $level_categories;
        $data['category'] = $category;
        $data['category_id'] = $category_id;
        $data['user'] = $user;
        $data['favorites'] = $data['listings'] = $favorites;
        #var_dump($favorites->toArray());
		return view('account.favorites', $data);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
