<?php

namespace Modules\Panel\Forms;

use Kris\LaravelFormBuilder\Form;
use LaravelLocalization;

class WidgetForm extends Form
{
    protected $formOptions = [
        'id' => 'listings_form'
    ];

    public function buildForm()
    {
        $this->add('title', 'text', [
            'rules' => 'required|min:3'
        ]);

        $this->add('alignment', 'select', [
            'choices' => ['center' => 'center', 'left' => 'left', 'right' => 'right'],
            'empty_value' => '-- SELECT --'
        ]);

        $form_ui = [
            'paragraph'         =>   'Paragraph',
            'hero'              =>   'Hero',
            'video'             =>   'Video',
            'category_listing'  =>   'Category Listing',
            'latest_listings'   =>   'Latest Listings',
            'featured_listings'  =>  'Featured Listings',
            'popular_listings'  =>   'Popular Listings',
            'image_gallery'     =>   'Image Gallery'
        ];


        $this->add('type', 'select', [
            'choices' => $form_ui,
            'attr' => [
                'class' => 'form-control',
                'id' => 'form_ui'
            ]
        ]);

        $language_options = [];
        foreach(LaravelLocalization::getSupportedLocales() as $k => $language_option) {
            $language_options[$k] = $language_option['name'];
        }

        $this->add('locale', 'select', [
            'choices' => $language_options,
            'selected' => $this->getData('default_locale', 'US'),
            'empty_value' => '-- SELECT --'
        ]);

        $this->add('metadata_str', 'hidden', [
            'attr' => [
                'id' => 'metadata'
            ]
        ]);

        $this->add('position', 'number', [
            'rules' => 'integer'
        ]);

        $this->add('background', 'text', []);
        $this->add('style', 'text', []);

        $this->add('submit', 'submit', ['attr' => ['class' => 'btn btn-primary']]);
    }
}
