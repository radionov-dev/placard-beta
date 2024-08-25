<?php

namespace Modules\Panel\Forms;

use Kris\LaravelFormBuilder\Form;
use App\Models\PricingModel;
use LaravelLocalization;

class GeneralSettingsForm extends Form
{
    public function buildForm()
    {
        $this->add('site_name', 'text', [
            'rules' => '',
            'default_value' => $this->getData('site_name')
        ]);
        $this->add('site_url', 'text', [
            'rules' => '',
            'default_value' => $this->getData('site_url')
        ]);
        $this->add('site_title', 'text', [
            'rules' => '',
            'default_value' => $this->getData('site_title')
        ]);
        $this->add('site_description', 'text', [
            'rules' => '',
            'default_value' => $this->getData('site_description')
        ]);
        $this->add('email_address', 'text', [
            'rules' => '',
            'default_value' => $this->getData('email_address')
        ]);
        $this->add('site_logo', 'file', [
            'rules' => '',
            'help_block' => [
                'text' => "Max height: 24px, Max width: 165px"
            ]
        ]);

        $supported_locales = [];
        foreach(LaravelLocalization::getSupportedLocales() as $k => $supported_locale) {
            $supported_locales[$k] = $supported_locale['name'];
        }

        $language_options = [];
        foreach($this->language_options() as $k => $language_option) {
            $language_options[$k] = $language_option['name'];
        }
        $this->add('supported_locales', 'select', [
            'choices' => $language_options,
            'selected' => $this->getData('supported_locales', ['en']),
            'attr' => [
                'id' => 'supported_locales',
                'class' => '',
                'multiple' => 'multiple'
            ]
        ]);
        $this->add('default_locale', 'select', [
            'choices' => $language_options,
            'selected' => $this->getData('default_locale', 'US'),
            'empty_value' => '-- SELECT --'
        ]);
        $this->add('google_analytics_key', 'text', [
            'rules' => '',
            'default_value' => $this->getData('google_analytics_key')
        ]);

        $this->add('default_view', 'select', [
            'choices' => ['grid' => 'Grid', 'list' => 'List'],
            'selected' => $this->getData('default_view', 'grid'),
            'empty_value' => '-- SELECT --'
        ]);
        $this->add('show_grid', 'checkbox', [
            'value' => 1,
            'checked' => (bool) $this->getData('show_grid', 1)
        ]);
        $this->add('show_list', 'checkbox', [
            'value' => 1,
            'checked' => (bool) $this->getData('show_list', 1)
        ]);

        $currencies = ["AFA","ALL","DZD","USD","EUR","AOA","XCD","NOK","XCD","ARA","AMD","AWG","AUD","EUR","AZM","BSD","BHD","BDT","BBD","BYR","EUR","BZD","XAF","BMD","BTN","BOB","BAM","BWP","NOK","BRL","GBP","BND","BGN","XAF","BIF","KHR","XAF","CAD","CVE","KYD","XAF","XAF","CLF","CNY","AUD","AUD","COP","KMF","CDZ","XAF","NZD","CRC","HRK","CUP","EUR","CZK","DKK","DJF","XCD","DOP","TPE","USD","EGP","USD","XAF","ERN","EEK","ETB","FKP","DKK","FJD","EUR","EUR","EUR","EUR","XPF","EUR","XAF","GMD","GEL","EUR","GHC","GIP","EUR","DKK","XCD","EUR","USD","GTQ","GNS","GWP","GYD","HTG","AUD","EUR","HNL","HKD","HUF","ISK","INR","IDR","IRR","IQD","EUR","ILS","EUR","XAF","JMD","JPY","JOD","KZT","KES","AUD","KPW","KRW","KWD","KGS","LAK","LVL","LBP","LSL","LRD","LYD","CHF","LTL","EUR","MOP","MKD","MGF","MWK","MYR","MVR","XAF","EUR","USD","EUR","MRO","MUR","EUR","MXN","USD","MDL","EUR","MNT","XCD","MAD","MZM","MMK","NAD","AUD","NPR","EUR","ANG","XPF","NZD","NIC","XOF","NGN","NZD","AUD","USD","NOK","OMR","PKR","USD","PAB","PGK","PYG","PEI","PHP","NZD","PLN","EUR","USD","QAR","EUR","ROL","RUB","RWF","XCD","XCD","XCD","WST","EUR","STD","SAR","XOF","EUR","SCR","SLL","SGD","EUR","EUR","SBD","SOS","ZAR","GBP","EUR","LKR","SHP","EUR","SDG","SRG","NOK","SZL","SEK","CHF","SYP","TWD","TJR","TZS","THB","XAF","NZD","TOP","TTD","TND","TRY","TMM","USD","AUD","UGS","UAH","SUR","AED","GBP","USD","USD","UYU","UZS","VUV","VEF","VND","USD","USD","XPF","XOF","MAD","ZMK","USD"];
        $currencies = array_combine($currencies, $currencies);
        $this->add('currency', 'select', [
            'choices' => $currencies,
            'selected' => $this->getData('currency'),
            'empty_value' => '-- SELECT --'
        ]);
        $this->add('marketplace_percentage_fee', 'text', [
            'rules' => '',
            'default_value' => $this->getData('marketplace_percentage_fee')
        ]);
        $this->add('marketplace_transaction_fee', 'hidden', [
            'rules' => '',
            'default_value' => $this->getData('marketplace_transaction_fee')
        ]);
        $this->add('listings_require_verification', 'checkbox', [
            'value' => 1,
            'checked' => (bool) $this->getData('listings_require_verification', 1)
        ]);
        $this->add('show_search_sidebar', 'checkbox', [
            'value' => 1,
            'checked' => (bool) $this->getData('show_search_sidebar', 0)
        ]);

        $this->add('twitter_url', 'text', [
            'rules' => '',
            'default_value' => $this->getData('twitter_url')
        ]);
        $this->add('facebook_url', 'text', [
            'rules' => '',
            'default_value' => $this->getData('facebook_url')
        ]);
        $this->add('instagram_url', 'text', [
            'rules' => '',
            'default_value' => $this->getData('instagram_url')
        ]);

        $this->add('facebook_key', 'text', [
            'rules' => '',
            'default_value' => $this->getData('facebook_key')
        ]);
        $this->add('facebook_secret', 'password', [
            'rules' => '',
            'attr' => [
                'autocomplete' => 'new-password',
            ]
        ]);

        $this->add('listing_expiry', 'number', [
            'label' => 'Default number of days a listing should be active for:',
            'rules' => 'integer',
            'default_value' => $this->getData('listing_expiry'),
            'help_block' => [
                'text' => "<i>e.g. Setting this to 30 will automatically expire listings after 30 days.</i>",
            ],
            'attr' => ['min' => 0, 'step' => 1]
        ]);

        $this->add('cookie_consent_enabled', 'checkbox', [
            'value' => 1,
            'checked' => (bool) $this->getData('cookie_consent_enabled', 0)
        ]);

        /*
                - show map
            - show list
                - show grid

            - site name
            - site title
            - site description
            - site slogan
            - logo

            - Google analytics key
            - GOOGLE Maps _API_KEY
            - default map location
        */

        $this->add('submit', 'submit', ['attr' => ['class' => 'btn btn-primary']]);
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
}
