<?php
use Jimmerioles\BitcoinCurrencyConverter\Converter;

function url_shorten( $url, $length = 35 ) {
    $stripped = str_replace( array( 'https://', 'http://', 'www.' ), '', $url );
    $short_url = rtrim( $stripped, '/\\' );

    if ( strlen( $short_url ) > $length ) {
        $short_url = substr( $short_url, 0, $length - 3 ) . '&hellip;';
    }
    return $short_url;
}

function file_upload_max_size() {
  static $max_size = -1;

  if ($max_size < 0) {
    // Start with post_max_size.
    $post_max_size = parse_size(ini_get('post_max_size'));
    if ($post_max_size > 0) {
      $max_size = $post_max_size;
    }

    // If upload_max_size is less, then reduce. Except if upload_max_size is
    // zero, which indicates no limit.
    $upload_max = parse_size(ini_get('upload_max_filesize'));
    if ($upload_max > 0 && $upload_max < $max_size) {
      $max_size = $upload_max;
    }
  }
  return $max_size;
}

function recaptcha() {
    return NoCaptcha::renderJs().NoCaptcha::display();
}
function current_theme() {
    return Theme::current()->name;
}
function current_locale() {
    return auth()->user()->id ? auth()->user()->country : LaravelLocalization::getCurrentLocale();
}
function current_currency() {
    $codes = [
        'RU'         => 'RUB',
        'UA'         => 'UAH',
        'BY'         => 'BYR',
        'KZ'         => 'KZT',
        'DE'         => 'EUR',
        'ABKHAZIA'   => 'RUB',
        'AU'         => 'AUD',
        'AT'         => 'EUR',
        'AZ'         => 'AZM',
        'AL'         => 'EUR',
        'DZ'         => 'DZD',
        'AO'         => 'AOA',
        'AI'         => 'XCD',
        'AD'         => 'EUR',
        'AG'         => 'XCD',
        'AN'         => 'ANG',
        'AR'         => 'ARS',
        'AM'         => 'AMD',
        'AW'         => 'AWG',
        'AF'         => 'USD',
        'BS'         => 'BSD',
        'BD'         => 'BDT',
        'BB'         => 'BBD',
        'BH'         => 'BHD',
        'BZ'         => 'BZD',
        'BE'         => 'EUR',
        'BJ'         => 'XOF',
        'BM'         => 'BMD',
        'BG'         => 'EUR',
        'BO'         => 'BOB',
        'BA'         => 'BAM',
        'BW'         => 'BWP',
        'BR'         => 'BRL',
        'VG'         => 'USD',
        'BN'         => 'BND',
        'BF'         => 'XOF',
        'BI'         => 'BIF',
        'BT'         => 'BTN',
        'WF'         => 'XPF',
        'VU'         => 'VUV',
        'GB'         => 'GBP',
        'HU'         => 'HUF',
        'VE'         => 'VEB',
        'TL'         => 'USD',
        'VN'         => 'VND',
        'GA'         => 'XAF',
        'HT'         => 'HTG',
        'GY'         => 'GYD',
        'GM'         => 'GMD',
        'GH'         => 'GHS',
        'GP'         => 'EUR',
        'GT'         => 'GTQ',
        'GN'         => 'GNF',
        'GW'         => 'XOF',
        'GG'         => 'GBP',
        'GI'         => 'GIP',
        'HN'         => 'HNL',
        'HK'         => 'HKD',
        'GD'         => 'XCD',
        'GL'         => 'DKK',
        'GR'         => 'EUR',
        'GE'         => 'GEL',
        'DK'         => 'DKK',
        'JE'         => 'GBP',
        'DJ'         => 'DJF',
        'DO'         => 'DOP',
        'EG'         => 'EGP',
        'ZM'         => 'ZMK',
        'EH'         => 'USD',
        'ZW'         => 'ZWD',
        'IL'         => 'ILS',
        'IN'         => 'INR',
        'ID'         => 'IDR',
        'JO'         => 'JOD',
        'IQ'         => 'NID',
        'IR'         => 'HUI',
        'IE'         => 'EUR',
        'IS'         => 'ISK',
        'ES'         => 'EUR',
        'IT'         => 'EUR',
        'YE'         => 'YER',
        'CV'         => 'CVE',
        'KH'         => 'KHR',
        'CM'         => 'XAF',
        'CA'         => 'CAD',
        'QA'         => 'QAR',
        'KE'         => 'KES',
        'CY'         => 'EUR',
        'KI'         => 'AUD',
        'CN'         => 'EUR',
        'CO'         => 'COP',
        'KM'         => 'USD',
        'CD'         => 'USD',
        'CR'         => 'CRC',
        'CI'         => 'XOF',
        'CU'         => 'XOF',
        'KW'         => 'KWD',
        'CK'         => 'NZD',
        'KG'         => 'KGS',
        'LA'         => 'LAK',
        'LV'         => 'EUR',
        'LS'         => 'LSL',
        'LR'         => 'LRD',
        'LB'         => 'USD',
        'LY'         => 'LYD',
        'LT'         => 'EUR',
        'LI'         => 'CHF',
        'LU'         => 'EUR',
        'MU'         => 'MUR',
        'MR'         => 'MRO',
        'MG'         => 'MGA',
        'MK'         => 'EUR',
        'MW'         => 'MWK',
        'MY'         => 'MYR',
        'ML'         => 'XOF',
        'MV'         => 'MVR',
        'MT'         => 'EUR',
        'MQ'         => 'EUR',
        'MX'         => 'MXN',
        'MZ'         => 'MZM',
        'MD'         => 'MDL',
        'MC'         => 'EUR',
        'MN'         => 'MNT',
        'MA'         => 'MAD',
        'MM'         => 'XOF',
        'IM'         => 'XOF',
        'NA'         => 'XOF',
        'NR'         => 'XOF',
        'NP'         => 'NPR',
        'NE'         => 'XOF',
        'NG'         => 'NGN',
        'NL'         => 'EUR',
        'NI'         => 'NIO',
        'NZ'         => 'NZD',
        'NC'         => 'XPF',
        'NO'         => 'NOK',
        'NF'         => 'AUD',
        'AE'         => 'AED',
        'OM'         => 'OMR',
        'PK'         => 'PKR',
        'PA'         => 'PAB',
        'PG'         => 'PGK',
        'PY'         => 'PYG',
        'PE'         => 'USD',
        'PN'         => 'USD',
        'PL'         => 'PLN',
        'PT'         => 'EUR',
        'PR'         => 'USD',
        'RE'         => 'EUR',
        'RW'         => 'RWF',
        'RO'         => 'ROL',
        'US'         => 'USD',
        'SV'         => 'USD',
        'WS'         => 'WST',
        'SM'         => 'EUR',
        'ST'         => 'STD',
        'SA'         => 'SAR',
        'SZ'         => 'SZL',
        'LC'         => 'XCD',
        'SH'         => 'XCD',
        'KP'         => 'USD',
        'SC'         => 'SCR',
        'PM'         => 'USD',
        'SN'         => 'XCD',
        'KN'         => 'XCD',
        'VC'         => 'USD',
        'RS'         => 'EUR',
        'SG'         => 'SGD',
        'SY'         => 'USD',
        'SK'         => 'EUR',
        'SI'         => 'EUR',
        'SB'         => 'EUR',
        'SO'         => 'USD',
        'SD'         => 'USD',
        'SR'         => 'USD',
        'SL'         => 'LSL',
        'TJ'         => 'TJS',
        'TW'         => 'TWD',
        'TH'         => 'THB',
        'TZ'         => 'TZS',
        'TG'         => 'XOF',
        'TK'         => 'XOF',
        'TO'         => 'XOF',
        'TT'         => 'TTD',
        'TV'         => 'AUD',
        'TN'         => 'TND',
        'TM'         => 'TMT',
        'TC'         => 'USD',
        'TR'         => 'TRY',
        'UG'         => 'UGX',
        'UZ'         => 'UZS',
        'UY'         => 'UYU',
        'FO'         => 'DKK',
        'FJ'         => 'FJD',
        'PH'         => 'PHP',
        'FI'         => 'EUR',
        'FR'         => 'EUR',
        'GF'         => 'EUR',
        'PF'         => 'EUR',
        'HR'         => 'EUR',
        'TD'         => 'XAF',
        'ME'         => 'EUR',
        'CZ'         => 'CZK',
        'CL'         => 'CLP',
        'CH'         => 'CHF',
        'SE'         => 'SEK',
        'LK'         => 'LKR',
        'EC'         => 'USD',
        'GQ'         => 'XAF',
        'ER'         => 'ERN',
        'EE'         => 'EUR',
        'ET'         => 'ETB',
        'ZA'         => 'ZAR',
        'KR'         => 'USD',
        'SOUTH-'     => 'USD',
        'JM'         => 'JMD',
        'JP'         => 'JPY',
        'MO'         => 'MOP',
    ];

    $currency = isset($codes[LaravelLocalization::getCurrentLocale()]) ? $codes[LaravelLocalization::getCurrentLocale()] : 'USD';

    return auth()->user()->currency ? auth()->user()->currency : $currency;
}
function default_locale() {
    return LaravelLocalization::getDefaultLocale();
}
function current_locale_direction() {
    return LaravelLocalization::getCurrentLocaleDirection();
}
function current_locale_native() {
    return LaravelLocalization::getCurrentLocaleNative();
}
function supported_locales() {
    $langs = LaravelLocalization::getSupportedLocales();

    uasort($langs, function($a, $b) {
        return strcasecmp($a['name'], $b['name']);
    });

    return $langs;
}
function get_low_localized_url($locale_code){
    return LaravelLocalization::getLocalizedURL(strtolower($locale_code), null, [], (strtolower($locale_code) != strtolower(default_locale())));
}
function get_localized_url($locale_code) {
    return LaravelLocalization::getLocalizedURL($locale_code, null, [], ($locale_code != default_locale()));
}
function current_website() {
    return config('website');
}

function parse_size($size) {
  $unit = preg_replace('/[^bkmgtpezy]/i', '', $size); // Remove the non-unit characters from the size.
  $size = preg_replace('/[^0-9\.]/', '', $size); // Remove the non-numeric characters from the size.
  if ($unit) {
    // Find the position of the unit in the ordered string which is the power of magnitude to multiply a kilobyte by.
    return round($size * pow(1024, stripos('bkmgtpezy', $unit[0])));
  }
  else {
    return round($size);
  }
}

function flatten($elements, $depth) {
    $result = array();

    foreach ($elements as $element) {
        $element['depth'] = $depth;

        if (isset($element['child'])) {
            $children = $element['child'];
            unset($element['child']);
        } else {
            $children = null;
        }

        $result[] = $element;

        if (isset($children)) {
            $result = array_merge($result, flatten($children, $depth + 1));
        }
    }

    return $result;
}

function filter_message($message) {
    if(setting('messaging_disable_contact_sharing')) {
        $message = preg_replace('/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i', '(phone hidden)', $message); // extract email
        $message = preg_replace('/(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?/', '(email hidden)', $message);
    }
    return $message;
}

function metersToMiles($i) {
     return number_format($i*0.000621371192, 0) . ' miles';
}
function milesToMeters($i) {
     return number_format($i*1609.344, 0) . ' km';
}

function format_btc($price, $currency) {
    $convert = new Converter;

    $price = number_format($convert->toBtc($price, $currency), 8, '.', '');

    $last = substr($price, -3);

    $first = intval($price) . '.' . substr(substr($price, 0, -3), -5);

    if ((int)$first < 1) {
        $first_ex = explode('.', $first);

        $is = false;
        $strs = str_split($first_ex[1]);
        foreach ($strs as &$str) {
            if ($str == 0 && !$is) {
                $str = '<span style="color: gray">0</span>';
            } else {
                $is = true;
            }
        }

        $first = '<span style="color: gray">'.$first_ex[0].'.</span>' . implode('', $strs);
    }

    $price = $first . '<span style="color: gray">'.$last.'</span>';

	return $price . ' BTC';
}

function format_usd($price, $currency) {
    $convert = new Converter;

	return $convert->toCurrency('USD', $convert->toBtc($price, $currency)) . ' USD';
}

function format_to_money($price, $currency, $new_currency) {
    if ($currency == $new_currency) {
        return $price . ' ' . $new_currency;
    }

    $convert = new Converter;

    return $convert->toCurrency($new_currency, $convert->toBtc($price, $currency)) . ' ' . $new_currency;
}
function format_currency($price, $currency, $new_currency) {
    if ($currency == $new_currency) {
        return $price;
    }

    $convert = new Converter;

    return $convert->toCurrency($new_currency, $convert->toBtc($price, $currency));
}

function format_money($price, $currency) {
	$placement = 'before';
	try {
		$currency = new \Gerardojbaez\Money\Currency($currency);
		$currency->setSymbolPlacement($placement);
		if($price > 1000) {
			$currency->setPrecision(0);
		}
		$money = new \Gerardojbaez\Money\Money($price, $currency);
		return $money->format();
	} catch(\Exception $e) {
		if($placement == 'before')
			return $currency . ' '. number_format($price, 2);
		else
			return number_format($price, 2) . ' ' . $currency ;
	}
}
function getDir($id, $levels_deep = 32) {
    $file_hash   = md5($id);
    $dirname     = implode("/", str_split(
        substr($file_hash, 0, $levels_deep)
    ));
    return $dirname;
}
function store($dirname, $filename) {
    return $dirname . "/" . $filename;
}


function jsdeliver_combine($theme = 'default', $type = 'js') {
    $jsdeliver_js = "";
    if(file_exists(themes_path($theme.'/jsdeliver.json'))) {
        $files = json_decode(file_get_contents(themes_path($theme.'/jsdeliver.json')), true);
        $jsdeliver_js = implode(",", $files[$type]);
    }
    return $jsdeliver_js;
}

function array_to_string($input, $level = 0) {
    $array = json_decode(json_encode($input), true);
    $text = "";
    foreach($array as $k => $v) {
        if(is_array($v)) {
            $level = $level+1;
            $text .= str_repeat("&#8212;", $level) . " " . $k."\n";
            $text .= array_to_string($v, $level);
        } else{
            if($v)
                $text .= str_repeat("&#8212;", $level+1) . " $k: $v\n";
        }
    }
    return $text;
}

use App\Models\Category;
use Barryvdh\TranslationManager\Models\Translation;

function save_language_file($file, $strings) {
    /*$file = resource_path("views/langs/$file.php");
    $output = "<?php\n\n";
    foreach($strings as $string) {
        $output .= "__('".$string."');\n";
    }
    \File::put($file, $output);

    foreach($strings as $string) {
        $output .= "__('".$string."');\n";
    }*/

    //insert it into the database
    /*$selected_locale = 'en';

    if ($strings instanceof Illuminate\Support\Collection) {
        $strings = $strings->toArray();
    }
    $strings = array_unique($strings);
    $strings = array_filter($strings);
    foreach($strings as $string) {
        $translation_row = Translation::where('locale', $selected_locale)
            ->where('group', '_json')
            ->where('key', $string)
            ->first();
        if(!$translation_row) {
            $translation_row = new Translation();
            $translation_row->key = $string;
            $translation_row->locale = $selected_locale;
            $translation_row->group = '_json';
            $translation_row->value = null;
            $translation_row->save();
        }
    }*/

    //insert it into the json
    $localeCode = strtolower(default_locale());
    $translations = array();
    foreach($strings as $string) {
        $translations[$string] = $string;
    }
    if (file_exists(resource_path("lang/").strtolower($localeCode).'.json')) {
        $local_translations = json_decode(file_get_contents(resource_path("lang/") . strtolower($localeCode) . '.json'), true);
        $translations = array_merge($local_translations, $translations);

        file_put_contents(resource_path("lang/").strtolower($localeCode).'.json', json_encode($translations));
    }
}

function menu($location = null, $locale = null) {
    if(!$locale)
        $locale = LaravelLocalization::getCurrentLocale();
    if(!$location)
        $location = 'top';
    $menu = \App\Models\Menu::where('location', $location)->where('locale', $locale)->first();
    if($menu)
        return $menu->items;
    return [];
}

function get_categories($parent_id = 0) {
    return \App\Models\Category::orderBy('order', 'ASC')->where('parent_id', (int)$parent_id)->get();
}

function getUnreadMessagesCount() {
    return \App\Models\Message::select('id')->join('conversations', 'conversations.id', '=', 'conversation_id')->where('user_id','!=',auth()->user()->id)->where(function($query) {
        $query->where('conversations.user_one', auth()->user()->id)
            ->orWhere('conversations.user_two', auth()->user()->id);
    })->where('is_seen',0)->count();
}

function _l($string) {
    return __($string);
}

function _p($string, $number = 2) {

    if(!$string) {
        return "";
    }
    if((int) $number == 1) {
        return __($string);
    }

    if(!str_contains(__($string.'_plural'), "_plural")) {
        return __($string.'_plural');
    }

    try {
        return str_plural(__($string));
    } catch(\Exception $e) {

    }

    return __($string);
}

function widget($widget_class, $params = []) {
    try {
        return \Widget::run($widget_class, $params);
    } catch(\Exception $e) {

    }
}

function asyncWidget($widget_class, $params = []) {
    try {
        return \AsyncWidget::run($widget_class, $params);
    } catch(\Exception $e) {

    }
}

function get_query_string() {
    return app('request')->getQueryString();
}
function module_enabled($alias) {
    $module = \Module::findByAlias($alias);
    return (bool) ($module && $module->enabled());
}


function unslug($text, $delimiter = '-')
{
    return ucfirst(str_replace($delimiter, ' ', $text));
}

function glob_recursive($pattern, $flags = 0)
{
    $files = glob($pattern, $flags);

    foreach (glob(dirname($pattern).'/*', GLOB_ONLYDIR|GLOB_NOSORT) as $dir)
    {
        $files = array_merge($files, glob_recursive($dir.'/'.basename($pattern), $flags));
    }

    return $files;
}

function language_options() {
    return [
        'RU'         => ['name' => 'Russia',               'script' => 'Latn', 'native' => 'Россия', 'regional' => ''],
        'UA'         => ['name' => 'Ukraine',               'script' => 'Latn', 'native' => 'Украина', 'regional' => ''],
        'BY'         => ['name' => 'Belarus',               'script' => 'Latn', 'native' => 'Беларусь', 'regional' => ''],
        'KZ'         => ['name' => 'Kazakhstan',               'script' => 'Latn', 'native' => 'Казахстан', 'regional' => ''],
        'DE'         => ['name' => 'Germany',               'script' => 'Latn', 'native' => 'Германия', 'regional' => ''],
        'ABKHAZIA'         => ['name' => 'Abkhazia',               'script' => 'Latn', 'native' => 'Абхазия', 'regional' => ''],
        'AU'         => ['name' => 'Australia',               'script' => 'Latn', 'native' => 'Австралия', 'regional' => ''],
        'AT'         => ['name' => 'Austria',               'script' => 'Latn', 'native' => 'Австрия', 'regional' => ''],
        'AZ'         => ['name' => 'Azerbaijan',               'script' => 'Latn', 'native' => 'Азербайджан', 'regional' => ''],
        'AL'         => ['name' => 'Albania',               'script' => 'Latn', 'native' => 'Албания', 'regional' => ''],
        'DZ'         => ['name' => 'Algeria',               'script' => 'Latn', 'native' => 'Алжир', 'regional' => ''],
        'AO'         => ['name' => 'Angola',               'script' => 'Latn', 'native' => 'Ангола', 'regional' => ''],
        'AI'         => ['name' => 'Anguilla',               'script' => 'Latn', 'native' => 'Ангуилья', 'regional' => ''],
        'AD'         => ['name' => 'Andorra',               'script' => 'Latn', 'native' => 'Андорра', 'regional' => ''],
        'AG'         => ['name' => 'Antigua and Barbuda',               'script' => 'Latn', 'native' => 'Антигуа и Барбуда', 'regional' => ''],
        'AN'         => ['name' => 'Netherlands Antilles',               'script' => 'Latn', 'native' => 'Антильские о-ва', 'regional' => ''],
        'AR'         => ['name' => 'Argentina',               'script' => 'Latn', 'native' => 'Аргентина', 'regional' => ''],
        'AM'         => ['name' => 'Armenia',               'script' => 'Latn', 'native' => 'Армения', 'regional' => ''],
        'AW'         => ['name' => 'Aruba',               'script' => 'Latn', 'native' => 'Арулько', 'regional' => ''],
        'AF'         => ['name' => 'Afghanistan',               'script' => 'Latn', 'native' => 'Афганистан', 'regional' => ''],
        'BS'         => ['name' => 'Bahamas',               'script' => 'Latn', 'native' => 'Багамские о-ва', 'regional' => ''],
        'BD'         => ['name' => 'Bangladesh',               'script' => 'Latn', 'native' => 'Бангладеш', 'regional' => ''],
        'BB'         => ['name' => 'Barbados',               'script' => 'Latn', 'native' => 'Барбадос', 'regional' => ''],
        'BH'         => ['name' => 'Bahrain',               'script' => 'Latn', 'native' => 'Бахрейн', 'regional' => ''],
        'BZ'         => ['name' => 'Belize',               'script' => 'Latn', 'native' => 'Белиз', 'regional' => ''],
        'BE'         => ['name' => 'Belgium',               'script' => 'Latn', 'native' => 'Бельгия', 'regional' => ''],
        'BJ'         => ['name' => 'Benin',               'script' => 'Latn', 'native' => 'Бенин', 'regional' => ''],
        'BM'         => ['name' => 'Bermuda',               'script' => 'Latn', 'native' => 'Бермуды', 'regional' => ''],
        'BG'         => ['name' => 'Bulgaria',               'script' => 'Latn', 'native' => 'Болгария', 'regional' => ''],
        'BO'         => ['name' => 'Bolivia',               'script' => 'Latn', 'native' => 'Боливия', 'regional' => ''],
        'BA'         => ['name' => 'Bosnia and Herzegovina',               'script' => 'Latn', 'native' => 'Босния/Герцеговина', 'regional' => ''],
        'BW'         => ['name' => 'Botswana',               'script' => 'Latn', 'native' => 'Ботсвана', 'regional' => ''],
        'BR'         => ['name' => 'Brazil',               'script' => 'Latn', 'native' => 'Бразилия', 'regional' => ''],
        'VG'         => ['name' => 'British Virgin Islands',               'script' => 'Latn', 'native' => 'Британские Виргинские о-ва', 'regional' => ''],
        'BN'         => ['name' => 'Brunei',               'script' => 'Latn', 'native' => 'Бруней', 'regional' => ''],
        'BF'         => ['name' => 'Burkina Faso',               'script' => 'Latn', 'native' => 'Буркина Фасо', 'regional' => ''],
        'BI'         => ['name' => 'Burundi',               'script' => 'Latn', 'native' => 'Бурунди', 'regional' => ''],
        'BT'         => ['name' => 'Bhutan',               'script' => 'Latn', 'native' => 'Бутан', 'regional' => ''],
        'WF'         => ['name' => 'Wallis and Futuna',               'script' => 'Latn', 'native' => 'Валлис и Футуна о-ва', 'regional' => ''],
        'VU'         => ['name' => 'Vanuatu',               'script' => 'Latn', 'native' => 'Вануату', 'regional' => ''],
        'GB'         => ['name' => 'United Kingdom',               'script' => 'Latn', 'native' => 'Великобритания', 'regional' => ''],
        'HU'         => ['name' => 'Hungary',               'script' => 'Latn', 'native' => 'Венгрия', 'regional' => ''],
        'VE'         => ['name' => 'Venezuela',               'script' => 'Latn', 'native' => 'Венесуэла', 'regional' => ''],
        'TL'         => ['name' => 'East Timor',               'script' => 'Latn', 'native' => 'Восточный Тимор', 'regional' => ''],
        'VN'         => ['name' => 'Vietnam',               'script' => 'Latn', 'native' => 'Вьетнам', 'regional' => ''],
        'GA'         => ['name' => 'Gabon',               'script' => 'Latn', 'native' => 'Габон', 'regional' => ''],
        'HT'         => ['name' => 'Haiti',               'script' => 'Latn', 'native' => 'Гаити', 'regional' => ''],
        'GY'         => ['name' => 'Guyana',               'script' => 'Latn', 'native' => 'Гайана', 'regional' => ''],
        'GM'         => ['name' => 'Gambia',               'script' => 'Latn', 'native' => 'Гамбия', 'regional' => ''],
        'GH'         => ['name' => 'Ghana',               'script' => 'Latn', 'native' => 'Гана', 'regional' => ''],
        'GP'         => ['name' => 'Guadeloupe',               'script' => 'Latn', 'native' => 'Гваделупа', 'regional' => ''],
        'GT'         => ['name' => 'Guatemala',               'script' => 'Latn', 'native' => 'Гватемала', 'regional' => ''],
        'GN'         => ['name' => 'Guinea',               'script' => 'Latn', 'native' => 'Гвинея', 'regional' => ''],
        'GW'         => ['name' => 'Guinea-Bissau',               'script' => 'Latn', 'native' => 'Гвинея-Бисау', 'regional' => ''],
        'GG'         => ['name' => 'Guernsey',               'script' => 'Latn', 'native' => 'Гернси о-в', 'regional' => ''],
        'GI'         => ['name' => 'Gibraltar',               'script' => 'Latn', 'native' => 'Гибралтар', 'regional' => ''],
        'HN'         => ['name' => 'Honduras',               'script' => 'Latn', 'native' => 'Гондурас', 'regional' => ''],
        'HK'         => ['name' => 'Hong Kong',               'script' => 'Latn', 'native' => 'Гонконг', 'regional' => ''],
        'GD'         => ['name' => 'Grenada',               'script' => 'Latn', 'native' => 'Гренада', 'regional' => ''],
        'GL'         => ['name' => 'Greenland',               'script' => 'Latn', 'native' => 'Гренландия', 'regional' => ''],
        'GR'         => ['name' => 'Greece',               'script' => 'Latn', 'native' => 'Греция', 'regional' => ''],
        'GE'         => ['name' => 'Georgia',               'script' => 'Latn', 'native' => 'Грузия', 'regional' => ''],
        'DK'         => ['name' => 'Denmark',               'script' => 'Latn', 'native' => 'Дания', 'regional' => ''],
        'JE'         => ['name' => 'Jersey',               'script' => 'Latn', 'native' => 'Джерси о-в', 'regional' => ''],
        'DJ'         => ['name' => 'Djibouti',               'script' => 'Latn', 'native' => 'Джибути', 'regional' => ''],
        'DO'         => ['name' => 'Dominican Republic',               'script' => 'Latn', 'native' => 'Доминиканская республика', 'regional' => ''],
        'EG'         => ['name' => 'Egypt',               'script' => 'Latn', 'native' => 'Египет', 'regional' => ''],
        'ZM'         => ['name' => 'Zambia',               'script' => 'Latn', 'native' => 'Замбия', 'regional' => ''],
        'EH'         => ['name' => 'Western Sahara',               'script' => 'Latn', 'native' => 'Западная Сахара', 'regional' => ''],
        'ZW'         => ['name' => 'Zimbabwe',               'script' => 'Latn', 'native' => 'Зимбабве', 'regional' => ''],
        'IL'         => ['name' => 'Israel',               'script' => 'Latn', 'native' => 'Израиль', 'regional' => ''],
        'IN'         => ['name' => 'India',               'script' => 'Latn', 'native' => 'Индия', 'regional' => ''],
        'ID'         => ['name' => 'Indonesia',               'script' => 'Latn', 'native' => 'Индонезия', 'regional' => ''],
        'JO'         => ['name' => 'Jordan',               'script' => 'Latn', 'native' => 'Иордания', 'regional' => ''],
        'IQ'         => ['name' => 'Iraq',               'script' => 'Latn', 'native' => 'Ирак', 'regional' => ''],
        'IR'         => ['name' => 'Iran',               'script' => 'Latn', 'native' => 'Иран', 'regional' => ''],
        'IE'         => ['name' => 'Ireland',               'script' => 'Latn', 'native' => 'Ирландия', 'regional' => ''],
        'IS'         => ['name' => 'Iceland',               'script' => 'Latn', 'native' => 'Исландия', 'regional' => ''],
        'ES'         => ['name' => 'Spain',               'script' => 'Latn', 'native' => 'Испания', 'regional' => ''],
        'IT'         => ['name' => 'Italy',               'script' => 'Latn', 'native' => 'Италия', 'regional' => ''],
        'YE'         => ['name' => 'Yemen',               'script' => 'Latn', 'native' => 'Йемен', 'regional' => ''],
        'CV'         => ['name' => 'Cape Verde',               'script' => 'Latn', 'native' => 'Кабо-Верде', 'regional' => ''],
        'KH'         => ['name' => 'Cambodia',               'script' => 'Latn', 'native' => 'Камбоджа', 'regional' => ''],
        'CM'         => ['name' => 'Cameroon',               'script' => 'Latn', 'native' => 'Камерун', 'regional' => ''],
        'CA'         => ['name' => 'Canada',               'script' => 'Latn', 'native' => 'Канада', 'regional' => ''],
        'QA'         => ['name' => 'Qatar',               'script' => 'Latn', 'native' => 'Катар', 'regional' => ''],
        'KE'         => ['name' => 'Kenya',               'script' => 'Latn', 'native' => 'Кения', 'regional' => ''],
        'CY'         => ['name' => 'Cyprus',               'script' => 'Latn', 'native' => 'Кипр', 'regional' => ''],
        'KI'         => ['name' => 'Kiribati',               'script' => 'Latn', 'native' => 'Кирибати', 'regional' => ''],
        'CN'         => ['name' => 'China',               'script' => 'Latn', 'native' => 'Китай', 'regional' => ''],
        'CO'         => ['name' => 'Colombia',               'script' => 'Latn', 'native' => 'Колумбия', 'regional' => ''],
        'KM'         => ['name' => 'Comoros',               'script' => 'Latn', 'native' => 'Коморские о-ва', 'regional' => ''],
        'CD'         => ['name' => 'Congo (Kinshasa)',               'script' => 'Latn', 'native' => 'Конго (Kinshasa)', 'regional' => ''],
        'CR'         => ['name' => 'Costa Rica',               'script' => 'Latn', 'native' => 'Коста-Рика', 'regional' => ''],
        'CI'         => ['name' => 'Cote D\'Ivoire',               'script' => 'Latn', 'native' => 'Кот-д\'Ивуар', 'regional' => ''],
        'CU'         => ['name' => 'Cuba',               'script' => 'Latn', 'native' => 'Куба', 'regional' => ''],
        'KW'         => ['name' => 'Kuwait',               'script' => 'Latn', 'native' => 'Кувейт', 'regional' => ''],
        'CK'         => ['name' => 'Cook Islands',               'script' => 'Latn', 'native' => 'Кука о-ва', 'regional' => ''],
        'KG'         => ['name' => 'Kyrgyzstan',               'script' => 'Latn', 'native' => 'Кыргызстан', 'regional' => ''],
        'LA'         => ['name' => 'Laos',               'script' => 'Latn', 'native' => 'Лаос', 'regional' => ''],
        'LV'         => ['name' => 'Latvia',               'script' => 'Latn', 'native' => 'Латвия', 'regional' => ''],
        'LS'         => ['name' => 'Lesotho',               'script' => 'Latn', 'native' => 'Лесото', 'regional' => ''],
        'LR'         => ['name' => 'Liberia',               'script' => 'Latn', 'native' => 'Либерия', 'regional' => ''],
        'LB'         => ['name' => 'Lebanon',               'script' => 'Latn', 'native' => 'Ливан', 'regional' => ''],
        'LY'         => ['name' => 'Libya',               'script' => 'Latn', 'native' => 'Ливия', 'regional' => ''],
        'LT'         => ['name' => 'Lithuania',               'script' => 'Latn', 'native' => 'Литва', 'regional' => ''],
        'LI'         => ['name' => 'Liechtenstein',               'script' => 'Latn', 'native' => 'Лихтенштейн', 'regional' => ''],
        'LU'         => ['name' => 'Luxembourg',               'script' => 'Latn', 'native' => 'Люксембург', 'regional' => ''],
        'MU'         => ['name' => 'Mauritius',               'script' => 'Latn', 'native' => 'Маврикий', 'regional' => ''],
        'MR'         => ['name' => 'Mauritania',               'script' => 'Latn', 'native' => 'Мавритания', 'regional' => ''],
        'MG'         => ['name' => 'Madagascar',               'script' => 'Latn', 'native' => 'Мадагаскар', 'regional' => ''],
        'MK'         => ['name' => 'Macedonia',               'script' => 'Latn', 'native' => 'Македония', 'regional' => ''],
        'MW'         => ['name' => 'Malawi',               'script' => 'Latn', 'native' => 'Малави', 'regional' => ''],
        'MY'         => ['name' => 'Malaysia',               'script' => 'Latn', 'native' => 'Малайзия', 'regional' => ''],
        'ML'         => ['name' => 'Mali',               'script' => 'Latn', 'native' => 'Мали', 'regional' => ''],
        'MV'         => ['name' => 'Maldives',               'script' => 'Latn', 'native' => 'Мальдивские о-ва', 'regional' => ''],
        'MT'         => ['name' => 'Malta',               'script' => 'Latn', 'native' => 'Мальта', 'regional' => ''],
        'MQ'         => ['name' => 'Martinique',               'script' => 'Latn', 'native' => 'Мартиника о-в', 'regional' => ''],
        'MX'         => ['name' => 'Mexico',               'script' => 'Latn', 'native' => 'Мексика', 'regional' => ''],
        'MZ'         => ['name' => 'Mozambique',               'script' => 'Latn', 'native' => 'Мозамбик', 'regional' => ''],
        'MD'         => ['name' => 'Moldova',               'script' => 'Latn', 'native' => 'Молдова', 'regional' => ''],
        'MC'         => ['name' => 'Monaco',               'script' => 'Latn', 'native' => 'Монако', 'regional' => ''],
        'MN'         => ['name' => 'Mongolia',               'script' => 'Latn', 'native' => 'Монголия', 'regional' => ''],
        'MA'         => ['name' => 'Morocco',               'script' => 'Latn', 'native' => 'Марокко', 'regional' => ''],
        'MM'         => ['name' => 'Myanmar (Burma)',               'script' => 'Latn', 'native' => 'Мьянма (Бирма)', 'regional' => ''],
        'IM'         => ['name' => 'Isle of Man',               'script' => 'Latn', 'native' => 'Мэн о-в', 'regional' => ''],
        'NA'         => ['name' => 'Namibia',               'script' => 'Latn', 'native' => 'Намибия', 'regional' => ''],
        'NR'         => ['name' => 'Nauru',               'script' => 'Latn', 'native' => 'Науру', 'regional' => ''],
        'NP'         => ['name' => 'Nepal',               'script' => 'Latn', 'native' => 'Непал', 'regional' => ''],
        'NE'         => ['name' => 'Niger',               'script' => 'Latn', 'native' => 'Нигер', 'regional' => ''],
        'NG'         => ['name' => 'Nigeria',               'script' => 'Latn', 'native' => 'Нигерия', 'regional' => ''],
        'NL'         => ['name' => 'Netherlands',               'script' => 'Latn', 'native' => 'Нидерланды (Голландия)', 'regional' => ''],
        'NI'         => ['name' => 'Nicaragua',               'script' => 'Latn', 'native' => 'Никарагуа', 'regional' => ''],
        'NZ'         => ['name' => 'New Zealand',               'script' => 'Latn', 'native' => 'Новая Зеландия', 'regional' => ''],
        'NC'         => ['name' => 'New Caledonia',               'script' => 'Latn', 'native' => 'Новая Каледония о-в', 'regional' => ''],
        'NO'         => ['name' => 'Norway',               'script' => 'Latn', 'native' => 'Норвегия', 'regional' => ''],
        'NF'         => ['name' => 'Norfolk Island',               'script' => 'Latn', 'native' => 'Норфолк о-в', 'regional' => ''],
        'AE'         => ['name' => 'United Arab Emirates',               'script' => 'Latn', 'native' => 'О.А.Э.', 'regional' => ''],
        'OM'         => ['name' => 'Oman',               'script' => 'Latn', 'native' => 'Оман', 'regional' => ''],
        'PK'         => ['name' => 'Pakistan',               'script' => 'Latn', 'native' => 'Пакистан', 'regional' => ''],
        'PA'         => ['name' => 'Panama',               'script' => 'Latn', 'native' => 'Панама', 'regional' => ''],
        'PG'         => ['name' => 'Papua New Guinea',               'script' => 'Latn', 'native' => 'Папуа Новая Гвинея', 'regional' => ''],
        'PY'         => ['name' => 'Paraguay',               'script' => 'Latn', 'native' => 'Парагвай', 'regional' => ''],
        'PE'         => ['name' => 'Peru',               'script' => 'Latn', 'native' => 'Перу', 'regional' => ''],
        'PN'         => ['name' => 'Pitcairn Islands',               'script' => 'Latn', 'native' => 'Питкэрн о-в', 'regional' => ''],
        'PL'         => ['name' => 'Poland',               'script' => 'Latn', 'native' => 'Польша', 'regional' => ''],
        'PT'         => ['name' => 'Portugal',               'script' => 'Latn', 'native' => 'Португалия', 'regional' => ''],
        'PR'         => ['name' => 'Puerto Rico',               'script' => 'Latn', 'native' => 'Пуэрто Рико', 'regional' => ''],
        'RE'         => ['name' => 'Reunion',               'script' => 'Latn', 'native' => 'Реюньон', 'regional' => ''],
        'RW'         => ['name' => 'Rwanda',               'script' => 'Latn', 'native' => 'Руанда', 'regional' => ''],
        'RO'         => ['name' => 'Romania',               'script' => 'Latn', 'native' => 'Румыния', 'regional' => ''],
        'US'         => ['name' => 'United States',               'script' => 'Latn', 'native' => 'США', 'regional' => ''],
        'SV'         => ['name' => 'El Salvador',               'script' => 'Latn', 'native' => 'Сальвадор', 'regional' => ''],
        'WS'         => ['name' => 'Samoa',               'script' => 'Latn', 'native' => 'Самоа', 'regional' => ''],
        'SM'         => ['name' => 'San Marino',               'script' => 'Latn', 'native' => 'Сан-Марино', 'regional' => ''],
        'ST'         => ['name' => 'Sao Tome and Principe',               'script' => 'Latn', 'native' => 'Сан-Томе и Принсипи', 'regional' => ''],
        'SA'         => ['name' => 'Saudi Arabia',               'script' => 'Latn', 'native' => 'Саудовская Аравия', 'regional' => ''],
        'SZ'         => ['name' => 'Swaziland',               'script' => 'Latn', 'native' => 'Свазиленд', 'regional' => ''],
        'LC'         => ['name' => 'Saint Lucia',               'script' => 'Latn', 'native' => 'Святая Люсия', 'regional' => ''],
        'SH'         => ['name' => 'Saint Helena',               'script' => 'Latn', 'native' => 'Святой Елены о-в', 'regional' => ''],
        'KP'         => ['name' => 'North Korea',               'script' => 'Latn', 'native' => 'Северная Корея', 'regional' => ''],
        'SC'         => ['name' => 'Seychelles',               'script' => 'Latn', 'native' => 'Сейшеллы', 'regional' => ''],
        'PM'         => ['name' => 'Saint Pierre and Miquelon',               'script' => 'Latn', 'native' => 'Сен-Пьер и Микелон', 'regional' => ''],
        'SN'         => ['name' => 'Senegal',               'script' => 'Latn', 'native' => 'Сенегал', 'regional' => ''],
        'KN'         => ['name' => 'Saint Kitts and Nevis',               'script' => 'Latn', 'native' => 'Сент Китс и Невис', 'regional' => ''],
        'VC'         => ['name' => 'Saint Vincent and the Grenadines',               'script' => 'Latn', 'native' => 'Сент-Винсент и Гренадины', 'regional' => ''],
        'RS'         => ['name' => 'Serbia',               'script' => 'Latn', 'native' => 'Сербия', 'regional' => ''],
        'SG'         => ['name' => 'Singapore',               'script' => 'Latn', 'native' => 'Сингапур', 'regional' => ''],
        'SY'         => ['name' => 'Syria',               'script' => 'Latn', 'native' => 'Сирия', 'regional' => ''],
        'SK'         => ['name' => 'Slovakia',               'script' => 'Latn', 'native' => 'Словакия', 'regional' => ''],
        'SI'         => ['name' => 'Slovenia',               'script' => 'Latn', 'native' => 'Словения', 'regional' => ''],
        'SB'         => ['name' => 'Solomon Islands',               'script' => 'Latn', 'native' => 'Соломоновы о-ва', 'regional' => ''],
        'SO'         => ['name' => 'Somalia',               'script' => 'Latn', 'native' => 'Сомали', 'regional' => ''],
        'SD'         => ['name' => 'Sudan',               'script' => 'Latn', 'native' => 'Судан', 'regional' => ''],
        'SR'         => ['name' => 'Suriname',               'script' => 'Latn', 'native' => 'Суринам', 'regional' => ''],
        'SL'         => ['name' => 'Sierra Leone',               'script' => 'Latn', 'native' => 'Сьерра-Леоне', 'regional' => ''],
        'TJ'         => ['name' => 'Tajikistan',               'script' => 'Latn', 'native' => 'Таджикистан', 'regional' => ''],
        'TW'         => ['name' => 'Taiwan',               'script' => 'Latn', 'native' => 'Тайвань', 'regional' => ''],
        'TH'         => ['name' => 'Thailand',               'script' => 'Latn', 'native' => 'Таиланд', 'regional' => ''],
        'TZ'         => ['name' => 'Tanzania',               'script' => 'Latn', 'native' => 'Танзания', 'regional' => ''],
        'TG'         => ['name' => 'Togo',               'script' => 'Latn', 'native' => 'Того', 'regional' => ''],
        'TK'         => ['name' => 'Tokelau',               'script' => 'Latn', 'native' => 'Токелау о-ва', 'regional' => ''],
        'TO'         => ['name' => 'Tonga',               'script' => 'Latn', 'native' => 'Тонга', 'regional' => ''],
        'TT'         => ['name' => 'Trinidad and Tobago',               'script' => 'Latn', 'native' => 'Тринидад и Тобаго', 'regional' => ''],
        'TV'         => ['name' => 'Tuvalu',               'script' => 'Latn', 'native' => 'Тувалу', 'regional' => ''],
        'TN'         => ['name' => 'Tunisia',               'script' => 'Latn', 'native' => 'Тунис', 'regional' => ''],
        'TM'         => ['name' => 'Turkmenistan',               'script' => 'Latn', 'native' => 'Туркменистан', 'regional' => ''],
        'TC'         => ['name' => 'Turks and Caicos Islands',               'script' => 'Latn', 'native' => 'Туркс и Кейкос', 'regional' => ''],
        'TR'         => ['name' => 'Turkey',               'script' => 'Latn', 'native' => 'Турция', 'regional' => ''],
        'UG'         => ['name' => 'Uganda',               'script' => 'Latn', 'native' => 'Уганда', 'regional' => ''],
        'UZ'         => ['name' => 'Uzbekistan',               'script' => 'Latn', 'native' => 'Узбекистан', 'regional' => ''],
        'UY'         => ['name' => 'Uruguay',               'script' => 'Latn', 'native' => 'Уругвай', 'regional' => ''],
        'FO'         => ['name' => 'Faroe Islands',               'script' => 'Latn', 'native' => 'Фарерские о-ва', 'regional' => ''],
        'FJ'         => ['name' => 'Fiji',               'script' => 'Latn', 'native' => 'Фиджи', 'regional' => ''],
        'PH'         => ['name' => 'Philippines',               'script' => 'Latn', 'native' => 'Филиппины', 'regional' => ''],
        'FI'         => ['name' => 'Finland',               'script' => 'Latn', 'native' => 'Финляндия', 'regional' => ''],
        'FR'         => ['name' => 'France',               'script' => 'Latn', 'native' => 'Франция', 'regional' => ''],
        'GF'         => ['name' => 'French Guiana',               'script' => 'Latn', 'native' => 'Французская Гвинея', 'regional' => ''],
        'PF'         => ['name' => 'French Polynesia',               'script' => 'Latn', 'native' => 'Французская Полинезия', 'regional' => ''],
        'HR'         => ['name' => 'Croatia',               'script' => 'Latn', 'native' => 'Хорватия', 'regional' => ''],
        'TD'         => ['name' => 'Chad',               'script' => 'Latn', 'native' => 'Чад', 'regional' => ''],
        'ME'         => ['name' => 'Montenegro',               'script' => 'Latn', 'native' => 'Черногория', 'regional' => ''],
        'CZ'         => ['name' => 'Czech Republic',               'script' => 'Latn', 'native' => 'Чехия', 'regional' => ''],
        'CL'         => ['name' => 'Chile',               'script' => 'Latn', 'native' => 'Чили', 'regional' => ''],
        'CH'         => ['name' => 'Switzerland',               'script' => 'Latn', 'native' => 'Швейцария', 'regional' => ''],
        'SE'         => ['name' => 'Sweden',               'script' => 'Latn', 'native' => 'Швеция', 'regional' => ''],
        'LK'         => ['name' => 'Sri Lanka',               'script' => 'Latn', 'native' => 'Шри-Ланка', 'regional' => ''],
        'EC'         => ['name' => 'Ecuador',               'script' => 'Latn', 'native' => 'Эквадор', 'regional' => ''],
        'GQ'         => ['name' => 'Equatorial Guinea',               'script' => 'Latn', 'native' => 'Экваториальная Гвинея', 'regional' => ''],
        'ER'         => ['name' => 'Eritrea',               'script' => 'Latn', 'native' => 'Эритрея', 'regional' => ''],
        'EE'         => ['name' => 'Estonia',               'script' => 'Latn', 'native' => 'Эстония', 'regional' => ''],
        'ET'         => ['name' => 'Ethiopia',               'script' => 'Latn', 'native' => 'Эфиопия', 'regional' => ''],
        'ZA'         => ['name' => 'South Africa',               'script' => 'Latn', 'native' => 'ЮАР', 'regional' => ''],
        'KR'         => ['name' => 'South Korea',               'script' => 'Latn', 'native' => 'Южная Корея', 'regional' => ''],
        'SOUTH-'         => ['name' => 'South Ossetia',               'script' => 'Latn', 'native' => 'Южная Осетия', 'regional' => ''],
        'JM'         => ['name' => 'Jamaica',               'script' => 'Latn', 'native' => 'Ямайка', 'regional' => ''],
        'JP'         => ['name' => 'Japan',               'script' => 'Latn', 'native' => 'Япония', 'regional' => ''],
        'MO'         => ['name' => 'Macau',               'script' => 'Latn', 'native' => 'Макао', 'regional' => ''],
    ];
}