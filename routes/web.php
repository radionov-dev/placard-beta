<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
/*
Route::get('/', function () {
    return view('welcome');
});

Route::get('/test', function () {
    return view('welcome');
});
*/

use App\Models\Category;
use App\Models\PageTranslation;
use App\Models\Listing;

include "admin.php";
include "payments.php";

Route::get('/feed', 'BrowseController@feed')->name('feeds.main');
Route::get('/electrum_check', 'BrowseController@checkElectrumAddress')->name('electrum.check');

Route::get('sitemap', function() {

    // create new sitemap object
    $sitemap = App::make('sitemap');

    // set cache key (string), duration in minutes (Carbon|Datetime|int), turn on/off (boolean)
    // by default cache is disabled
    $sitemap->setCache('laravel.sitemap', 60);

    // check if there is cached sitemap and build new only if is not
    if (!$sitemap->isCached()) {
        $now_date = date('c',time());

        // add item to the sitemap (url, date, priority, freq)
        //$sitemap->add(URL::to('/'), $now_date, '0.9', 'monthly');

        $posts = PageTranslation::all();
        foreach ($posts as $post) {
            $sitemap->add(route('page', ['slug' => $post->slug]), date('c', strtotime($post->updated_at)), '1.0', 'monthly');
        }

        $sitemap->add(URL::to('browse'), $now_date, '1.0', 'daily');

        // get all posts from db
        $posts = Category::all();

        // add every post to the sitemap
        foreach ($posts as $post) {
            $sitemap->add(URL::to('browse') . "?category=" . $post->id, date('c', strtotime($post->updated_at)), '1.0', 'daily');
        }

        $posts = Listing::where('is_published', 1)->where('is_draft', 0)->whereNotNull('is_admin_verified')->whereNull('is_disabled')->get();

        foreach ($posts as $post) {
            $sitemap->add(route('listing', ['id' => $post, 'slug' => $post->slug]), date('c', strtotime($post->updated_at)), '0.9', 'monthly');
        }
    }

    // show your sitemap (options: 'xml' (default), 'html', 'txt', 'ror-rss', 'ror-rdf')
    return $sitemap->render('xml');
});

Route::get('/clear-cache', function() {
    Artisan::call('cache:clear');
    //Artisan::call('route:cache');
    return "Cache is cleared";
})->name('clear.cache');

#errors
Route::get('/suspended',function(){
    return 'Sorry something went wrong.';
})->name('error.suspended');

Route::any('/bs_status', 'Auth\RegisterController@check_bs_user')->name('bitdeals.status');

Route::group(['prefix' => LaravelLocalization::setLocale(), 'middleware' => 'jailBanned'], function()
{
    Auth::routes();
    Route::get('email-verification', 'Auth\EmailVerificationController@sendEmailVerification')->name('email-verification.send');
    Route::get('email-verification/error', 'Auth\EmailVerificationController@getVerificationError')->name('email-verification.error');
    Route::get('email-verification/check/{token}', 'Auth\EmailVerificationController@getVerification')->name('email-verification.check');

    Route::get('/', 'HomeController@index')->name('home');
    Route::get('/browse', 'BrowseController@listings')->name('browse');
    //Route::get('/feed', 'BrowseController@feed')->name("feeds.main");
    Route::get('/categories', 'BrowseController@categories')->name('categories');

    Route::get('/contact', 'ContactController@index')->name('contact');
    Route::post('/contact', 'ContactController@postIndex')->name('contact.post');

    Route::get('/profile/{user}', 'ProfileController@index')->name('profile'); //PROFILE
    Route::get('/profile/{user}/follow', 'ProfileController@follow')->name('profile.follow'); //PROFILE

    //LISTINGS
    Route::group(['prefix' => 'listing'], function()
    {
        Route::get('/{listing}/{slug}', 'ListingController@index')->name('listing');
        Route::get('/{listing}/{slug}/card', 'ListingController@card')->name('listing.card');
        Route::get('/{listing}/{slug}/spotlight', 'ListingController@spotlight')->middleware('auth.ajax')->name('listing.spotlight');
        Route::get('/{listing}/{slug}/verify', 'ListingController@verify')->middleware('auth.ajax')->name('listing.verify');
        Route::get('/{listing}/{slug}/star', 'ListingController@star')->middleware('auth.ajax')->name('listing.star');
        Route::get('/{listing}/{slug}/edit', 'ListingController@edit')->name('listing.edit');
        #Route::get('/{listing}/{slug}/availability', 'AvailabilityController@availability')->name('listing.availability');
        Route::any('/{id}/update', 'ListingController@update')->name('listing.update');

    });

    //CHECKOUT
    Route::get('/checkout/error', 'CheckoutController@error_page')->name('checkout.error');
    Route::get('/checkout/{listing}', 'CheckoutController@index')->name('checkout');
    Route::post('/checkout/{listing}', 'CheckoutController@store')->name('checkout.store');
    Route::get('/checkout/{session}/callback', 'CheckoutController@callback')->name('checkout.callback');
    Route::any('/checkout/process/{listing}', 'CheckoutController@process')->name('checkout.process');
    #Route::any('/checkout/test', 'CheckoutController@test')->name('checkout.test');
    #Route::resource('stripe', 'StripeController');
    #Route::any('/stripe/connect', 'StripeController@connect')->name('stripe.connect');

    #Route::any('/paypal/{listing}/start', 'PaypalController@start')->name('paypal.start');
    #Route::any('/paypal/cancel', 'PaypalController@cancel')->name('paypal.cancel');
    #Route::any('/paypal/callback', 'PaypalController@callback')->name('paypal.callback');
    #Route::any('/paypal/confirm', 'PaypalController@confirm')->name('paypal.confirm');
    #Route::any('/paypal/create_agreement', 'PaypalController@create_agreement')->name('paypal.create_agreement');

    //ACCOUNT
    Route::group(['middleware' => ['auth', 'isVerified'], 'prefix' => 'account', 'as' => 'account.', 'namespace' => 'Account'], function()
    {
        Route::get('/', function () {
            return redirect(route('account.edit_profile.index'));
        });
        Route::resource('change_password', 'PasswordController');
        Route::resource('edit_profile', 'ProfileController');

        Route::resource('purchase-history', 'PurchaseHistoryController');
        Route::resource('favorites', 'FavoritesController');

        Route::resource('listings', 'ListingsController');
        Route::resource('orders', 'OrdersController');
        Route::put('/orders/comment/replay', 'OrdersController@feedback_replay')->name('orders.feedback_replay');
        Route::get('/orders/{order}/feedback', 'OrdersController@feedback')->name('orders.feedback');
        Route::post('/orders/{order}/feedback', 'OrdersController@feedback_post')->name('orders.feedback');
        Route::get('/orders/{order}/dispute', 'OrdersController@dispute')->name('orders.dispute');
        Route::post('/orders/{order}/dispute', 'OrdersController@dispute_post')->name('orders.dispute');
        Route::get('/orders/{order}/snapshot', 'OrdersController@snapshot')->name('orders.snapshot');
      

        Route::get('payments/{id}/unlink', 'BankAccountController@unlink')->name('payments.unlink');
        Route::resource('bank-account', 'BankAccountController');
        Route::resource('delivery', 'DeliveryController');

        #Route::get('paypal/connect', 'PayPalController@connect')->name('paypal.connect');
        #Route::get('paypal/callback', 'PayPalController@callback')->name('paypal.callback');

    });

    //REQUIRES AUTHENTICATION
    Route::group(['middleware' => ['auth', 'isVerified']], function () {

        //INBOX
        Route::resource('inbox', 'InboxController')->middleware('talk'); //Inbox
        Route::get('/inbox/messages/{id}', 'InboxController@messages')->name('inbox.messages');

        //CREATE LISTING
        Route::resource('create', 'CreateController');
        Route::any('/create/{listing}/session', 'CreateController@session')->name('create.session');
        Route::get('/create/{listing}/images', 'CreateController@images')->name('create.images');
        Route::get('/create/{listing}/additional', 'CreateController@additional')->name('create.additional');
        Route::get('/create/{listing}/pricing', 'CreateController@pricing')->name('create.pricing');
        Route::get('/create/{listing}/times', 'CreateController@getTimes')->name('create.times');
        Route::post('/create/{listing}/times', 'CreateController@postTimes')->name('create.times');
        Route::get('/create/{listing}/boost', 'CreateController@boost')->name('create.boost');

        Route::post('/create/{listing}/uploads', 'CreateController@upload')->name('create.upload');
        Route::delete('/create/{listing}/image/{uuid?}', 'CreateController@deleteUpload')->name('create.delete-image');

        #Route::delete('/uploads/delete/{id}', arraylistings('as' => 'upload', 'uses' => 'CreateController@deleteUpload'))->name('create.delete-image');;
        #Route::get('/listings/{id}/session', array('as' => 'create', 'uses' => 'CreateController@session'));

    });

    //REQUIRES AUTHENTICATION
    Route::group(['middleware' => ['auth']], function () {

        Route::get('email-verification', 'Auth\EmailVerificationController@index')->name('email-verification.index');
        Route::get('resend-verification', 'Auth\EmailVerificationController@resend')->name('email-verification.resend');
        Route::get('email-verified', 'Auth\EmailVerificationController@verified')->name('email-verification.verified');

    });

    Route::get('login/facebook', 'Auth\LoginController@redirectToProvider');
    Route::get('login/facebook/callback', 'Auth\LoginController@handleProviderCallback');

    Route::get('/{slug?}', 'PageController@index')->name('page');

});