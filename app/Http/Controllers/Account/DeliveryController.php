<?php

namespace App\Http\Controllers\Account;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\User;
use App\Http\Requests\UpdateUserProfile;
use Image;
use Storage;
use GeoIP;

class DeliveryController extends Controller
{
    public function index()
    {
        $data = array();

        $data['language_options'] = [];
        foreach(language_options() as $language_option => $values) {
            if( in_array($language_option, setting('supported_locales') )) {
                $data['language_options'][$language_option] = $values;
            }
        }

        $data['user'] = auth()->user();
        $data['delivery_settings'] = !empty($data['user']->delivery_settings) ? $data['user']->delivery_settings : array();

        $data['regions'] = array(
            array(
                'name' => 'North America',
                'countries' => array (
                    0 => 'Antigua and Barbuda',
                    1 => 'Bahamas',
                    2 => 'Barbados',
                    3 => 'Belize',
                    4 => 'Canada',
                    5 => 'Costa Rica',
                    6 => 'Cuba',
                    7 => 'Dominica',
                    8 => 'Dominican Republic',
                    9 => 'El Salvador',
                    10 => 'Grenada',
                    11 => 'Guatemala',
                    12 => 'Haiti',
                    13 => 'Honduras',
                    14 => 'Jamaica',
                    15 => 'Mexico',
                    16 => 'Nicaragua',
                    17 => 'Panama',
                    18 => 'Saint Kitts and Nevis',
                    19 => 'Saint Lucia',
                    20 => 'Saint Vincent and the Grenadines',
                    21 => 'Trinidad and Tobago',
                    22 => 'United States',
                )
            ),
            array(
                'name' => 'South America',
                'countries' => array (
                    0 => 'Argentina',
                    1 => 'Bolivia',
                    2 => 'Brazil',
                    3 => 'Chile',
                    4 => 'Colombia',
                    5 => 'Ecuador',
                    6 => 'Guyana',
                    7 => 'Paraguay',
                    8 => 'Peru',
                    9 => 'Suriname',
                    10 => 'Uruguay',
                    11 => 'Venezuela',
                )
            ),
            array(
                'name' => 'Europe',
                'countries' => array (
                    0 => 'Albania',
                    1 => 'Andorra',
                    2 => 'Armenia',
                    3 => 'Austria',
                    4 => 'Belarus',
                    5 => 'Belgium',
                    6 => 'Bosnia and Herzegovina',
                    7 => 'Bulgaria',
                    8 => 'Croatia',
                    9 => 'Cyprus',
                    10 => 'Czechia',
                    11 => 'Denmark',
                    12 => 'Estonia',
                    13 => 'Finland',
                    14 => 'France',
                    15 => 'Germany',
                    16 => 'Greece',
                    17 => 'Hungary',
                    18 => 'Iceland',
                    19 => 'Ireland',
                    20 => 'Italy',
                    21 => 'Kosovo',
                    22 => 'Latvia',
                    23 => 'Liechtenstein',
                    24 => 'Lithuania',
                    25 => 'Luxembourg',
                    26 => 'Malta',
                    27 => 'Moldova',
                    28 => 'Monaco',
                    29 => 'Montenegro',
                    30 => 'Netherlands',
                    31 => 'North Macedonia',
                    32 => 'Norway',
                    33 => 'Poland',
                    34 => 'Portugal',
                    35 => 'Romania',
                    36 => 'Russia',
                    37 => 'San Marino',
                    38 => 'Serbia',
                    39 => 'Slovakia',
                    40 => 'Slovenia',
                    41 => 'Spain',
                    42 => 'Sweden',
                    43 => 'Switzerland',
                    44 => 'Turkey',
                    45 => 'Ukraine',
                    46 => 'United Kingdom',
                    47 => 'Vatican City',
                )
            ),
            array(
                'name' => 'Asia',
                'countries' => array (
                    0 => 'Afghanistan',
                    1 => 'Armenia',
                    2 => 'Azerbaijan',
                    3 => 'Bahrain',
                    4 => 'Bangladesh',
                    5 => 'Bhutan',
                    6 => 'Brunei',
                    7 => 'Cambodia',
                    8 => 'China',
                    9 => 'Cyprus',
                    10 => 'Georgia',
                    11 => 'India',
                    12 => 'Indonesia',
                    13 => 'Iran',
                    14 => 'Iraq',
                    15 => 'Israel',
                    16 => 'Japan',
                    17 => 'Jordan',
                    19 => 'Kazakhstan',
                    20 => 'Kuwait',
                    21 => 'Kyrgyzstan',
                    22 => 'Laos',
                    23 => 'Lebanon',
                    24 => 'Malaysia',
                    25 => 'Maldives',
                    26 => 'Mongolia',
                    27 => 'Myanmar',
                    28 => 'Nepal',
                    29 => 'North Korea',
                    30 => 'Oman',
                    31 => 'Pakistan',
                    32 => 'Palestine',
                    33 => 'Philippines',
                    34 => 'Qatar',
                    35 => 'North Macedonia',
                    36 => 'Saudi Arabia',
                    37 => 'Singapore',
                    38 => 'South Korea',
                    39 => 'Sri Lanka',
                    40 => 'Syria',
                    41 => 'Taiwan',
                    42 => 'Tajikistan',
                    43 => 'Thailand',
                    44 => 'Timor-Leste',
                    45 => 'Turkmenistan',
                    46 => 'United Arab Emirates',
                    47 => 'Uzbekistan',
                    48 => 'Vietnam',
                    49 => 'Yemen',
                )
            ),
            array(
                'name' => 'Africa',
                'countries' => array (
                    0 => 'Algeria',
                    1 => 'Angola',
                    2 => 'Benin',
                    3 => 'Botswana',
                    4 => 'Burkina Faso',
                    5 => 'Burundi',
                    6 => 'Cabo Verde',
                    7 => 'Cameroon',
                    8 => 'Central African Republic (CAR)',
                    9 => 'Chad',
                    10 => 'Comoros',
                    11 => 'Congo',
                    12 => 'Democratic Republic of the',
                    13 => 'Congo',
                    14 => 'Republic of the',
                    15 => 'Cote d’Ivoire',
                    16 => 'Djibouti',
                    17 => 'Egypt',
                    18 => 'Equatorial Guinea',
                    19 => 'Eritrea',
                    20 => 'Eswatini',
                    21 => 'Ethiopia',
                    22 => 'Gabon',
                    23 => 'Gambia',
                    24 => 'Ghana',
                    25 => 'Guinea',
                    26 => 'Guinea-Bissau',
                    27 => 'Kenya',
                    28 => 'Lesotho',
                    29 => 'Liberia',
                    30 => 'Libya',
                    31 => 'Madagascar',
                    32 => 'Malawi',
                    33 => 'Mali',
                    34 => 'Mauritania',
                    35 => 'Mauritius',
                    36 => 'Morocco',
                    37 => 'Mozambique',
                    38 => 'Namibia',
                    39 => 'Niger',
                    40 => 'Nigeria',
                    41 => 'Rwanda',
                    42 => 'Sao Tome and Principe',
                    43 => 'Senegal',
                    44 => 'Seychelles',
                    45 => 'Sierra Leone',
                    46 => 'Somalia',
                    47 => 'South Africa',
                    48 => 'South Sudan',
                    49 => 'Sudan',
                    50 => 'Tanzania',
                    51 => 'Togo',
                    52 => 'Tunisia',
                    53 => 'Uganda',
                    54 => 'Zambia',
                    55 => 'Zimbabwe',
                )
            ),
            array(
                'name' => 'Oceania',
                'countries' => array (
                    0 => 'Australia',
                    1 => 'Fiji',
                    2 => 'Kiribati',
                    3 => 'Marshall Islands',
                    4 => 'Micronesia',
                    5 => 'Nauru',
                    6 => 'New Zealand',
                    7 => 'Palau',
                    8 => 'Papua New Guinea',
                    9 => 'Samoa',
                    10 => 'Solomon Islands',
                    11 => 'Tonga',
                    12 => 'Tuvalu',
                    13 => 'Vanuatu',
                )
            )
        );

        return view('account.delivery', $data);
    }

    public function store(Request $request)
    {
        $delivery_settings = $request->input('delivery_settings', array());
        $delivery_regions = array();

        foreach($delivery_settings as $delivery_region) {
            $delivery_regions = array_merge($delivery_regions, !empty($delivery_region['countries'])?$delivery_region['countries']:array());
        }

        $user = auth()->user();
        $user->delivery_regions = $delivery_regions;
        $user->delivery_settings = $delivery_settings;
        $user->save();

        alert()->success(__('Successfully saved!'));
        return redirect(route('account.delivery.index'));
    }
}