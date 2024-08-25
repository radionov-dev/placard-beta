<?php

return [

    'feeds' => [
        [
            /*
             * Here you can specify which class and method will return
             * the items that should appear in the feed. For example:
             * 'App\Repositories\NewsItemRepository@getAllOnline'
             */
            'items' => 'App\Models\Listing@getFeedItems',

            /*
             * The feed will be available on this url.
             */
            'url' => '/feed',

            'title' => 'My feed',

            'description' => 'Description of my feed',
        ],
    ],

];
