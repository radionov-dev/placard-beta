@extends('panel::layouts.master')

@section('content')

    <h1 class="h3">Welcome {{auth()->user()->name}}</h1>
    <br />
    <br />

    <div class="row">

        <div class="col-md-6 mb-3">

            <div class="row">

                <div class="col-md-2">
                    <img src="/images/admin/tag.png" style="width: 48px" />
                </div>
                <div class="col-md-8">


                    <ul class="list-unstyled">
                        <li class="pb-1"><a href="#" class="text-muted font-weight-bold">Listings & Categories</a></li>
                        <li class="pb-1"><a href="/panel/listings">View Listings</a></li>
                        <li class="pb-1"><a href="<?= route('create.index') ?>">Post new listing</a></li>
                        <li class="pb-1"><a href="/panel/categories">View category listing</a></li>
                        <li class="pb-1"><a href="/panel/categories/create">Create new category</a></li>
                    </ul>

                </div>

            </div>

        </div>

        <div class="col-md-6 mb-3">

            <div class="row">

                <div class="col-md-2">
                    <img src="/images/admin/orders.png" style="width: 48px" />
                </div>
                <div class="col-md-8">


                    <ul class="list-unstyled">
                        <li class="pb-1"><a href="#articles" class="text-muted font-weight-bold">Users &amp; Orders</a></li>
                        <li class="pb-1"><a href="/panel/users">View Buyers &amp; Sellers</a></li>
                        <li class="pb-1"><a href="/panel/orders">View Orders</a></li>
                    </ul>

                </div>

            </div>

        </div>

        <div class="col-md-6 mb-3">

            <div class="row">

                <div class="col-md-2">
                    <img src="/images/admin/categories.png" style="width: 48px" />
                </div>
                <div class="col-md-8">


                    <ul class="list-unstyled">
                        <li class="pb-1"><a href="#articles" class="text-muted font-weight-bold">Content</a></li>
                        <li class="pb-1"><a href="/panel/pages">Manage pages</a></li>
                        <li class="pb-1"><a href="/panel/menu">Manage menu</a></li>
                    </ul>

                </div>

            </div>

        </div>
        <div class="col-md-6 mb-3">

            <div class="row">

                <div class="col-md-2">
                    <img src="/images/admin/config.png" style="width: 48px" />
                </div>
                <div class="col-md-8">


                    <ul class="list-unstyled">
                        <li class="pb-1"><a href="#articles" class="text-muted font-weight-bold">Settings</a></li>
                        <li class="pb-1"><a href="/panel/settings">General settings</a></li>
                        <li class="pb-1"><a href="/panel/home">Customize homepage</a></li>
                        @if(config('debugbar.enabled'))
                        <li class="pb-1"><a href="/panel/addons">Addons</a></li>
                        <li class="pb-1"><a href="/panel/themes">Themes</a></li>
                        @endif
                    </ul>

                </div>

            </div>

        </div>

    </div>


@stop
