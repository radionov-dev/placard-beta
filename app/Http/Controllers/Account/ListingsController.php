<?php

namespace App\Http\Controllers\Account;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Listing;

class ListingsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $status = $request->get('status');
        $q = $request->get('q');
        $sort_price = $request->get('sort-price');

        $listings = Listing::where('user_id', auth()->user()->id);

        if(!empty($q)) {
            $listings = $listings->search($q);
        }

        if($status !== null) {
            $listings->where('is_published', $status);
        }

        if(in_array($sort_price, array('DESC', 'ASC'))) {
            $listings->orderBy('price', $sort_price);
        } else {
            $listings->orderBy('created_at', 'DESC');
        }


        $listings = $listings->paginate(10);
        return view('account.listings', compact('listings', 'status', 'q', 'sort_price'));
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
