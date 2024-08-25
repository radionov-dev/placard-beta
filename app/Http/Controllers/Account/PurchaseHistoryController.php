<?php

namespace App\Http\Controllers\Account;

use App\Models\Filter;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\Order;

class PurchaseHistoryController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        $orders = Order::with('listing', 'listing.user')->where('user_id', auth()->user()->id)->orderBy('id', 'DESC')->paginate(15);

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

        return view('account.orders.index', compact('orders', 'default_shipping'));
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
    public function show($order)
    {
        return view('account.purchase_history.show', compact('order'));
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
