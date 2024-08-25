<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Routing\Controller;
use Kris\LaravelFormBuilder\FormBuilder;
use Modules\Panel\Forms\GeneralSettingsForm;
use Setting;

class TranslationController extends Controller
{
    /**
     * Display a listing of the resource.
     * @return Response
     */
    public function index(Request $request, FormBuilder $formBuilder)
    {
        $langs = supported_locales();
        $translations = array_filter(scandir(resource_path("lang/")), function($item) {
            return !is_dir(resource_path("lang/") . $item);
        });

        $translations_names = array();
        $language_options = GeneralSettingsForm::language_options();

        foreach ($translations as $key => &$translation) {
            $t_ex = explode('.', $translation);
            $ex = array_pop($t_ex);
            $translation = implode('.', $t_ex);
            $translations_names[$key] = (isset($language_options[strtoupper($translation)]['name'])?$language_options[strtoupper($translation)]['name']:$translation);
        }

        return view('panel::translation.index', compact('langs', 'translations', 'translations_names'));
    }

    /**
     * Show the form for creating a new resource.
     * @return Response
     */
    public function create(FormBuilder $formBuilder)
    {
        $langs = GeneralSettingsForm::language_options();

        return view('panel::translation.create', compact('langs'));
    }

    /**
     * Store a newly created resource in storage.
     * @param  Request $request
     * @return Response
     */
    public function store(Request $request)
    {

    }

    /**
     * Show the specified resource.
     * @return Response
     */
    public function show()
    {
        return view('panel::show');
    }

    /**
     * Show the form for editing the specified resource.
     * @return Response
     */
    public function edit($localeCode, FormBuilder $formBuilder)
    {
        $translations = array();

        if (strtolower(default_locale()) != strtolower($localeCode) && file_exists(resource_path("lang/").strtolower(default_locale()).'.json')) {
            $translations = json_decode(file_get_contents(resource_path("lang/") . strtolower(default_locale()) . '.json'), true);

            foreach ($translations as &$translation) {
                $translation = '';
            }
        }

        if (file_exists(resource_path("lang/").strtolower($localeCode).'.json')) {
            $local_translations = json_decode(file_get_contents(resource_path("lang/") . strtolower($localeCode) . '.json'), true);
            $translations = array_merge($translations, $local_translations);
        }

        return view('panel::translation.edit', compact('translations', 'localeCode'));
    }

    /**
     * Update the specified resource in storage.
     * @param  Request $request
     * @return Response
     */
    public function update($localeCode, Request $request)
    {
        $params = $request->all();

        $translations = array();

        if ($params['tr']) {
            foreach ($params['tr'] as $translation) {
                if(trim($translation['translation']) != "") {
                    $translations[$translation['phrase']] = $translation['translation'];
                }
            }
        }

        if (!file_exists(resource_path("lang/").strtolower($localeCode).'.json')) {
            touch(resource_path("lang/").strtolower($localeCode).'.json');
        }

        file_put_contents(resource_path("lang/").strtolower($localeCode).'.json', json_encode($translations));

        alert()->success('Successfully saved');

        return redirect(route('panel.translations.index'));
    }

    /**
     * Remove the specified resource from storage.
     * @return Response
     */
    public function destroy($localeCode)
    {
        if (file_exists(resource_path("lang/").strtolower($localeCode).'.json')) {
            unlink(resource_path("lang/").strtolower($localeCode).'.json');
        }

        alert()->success('Successfully deleted');

        return redirect(route('panel.translations.index'));
    }
}
