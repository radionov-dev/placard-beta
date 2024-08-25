<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cache;
//use Bitmessage;

class Bit_Message extends Model {
    public static $bmc = null;
    public static $from = null;

    private static function clientInstance() {
        if (self::$bmc === null) {
            $bitmessage_ip = explode(':', env('BITMESSAGE_IP', ''));
            self::$bmc = new \Bitmessage\BitmessageClient($bitmessage_ip[0], (isset($bitmessage_ip[1]) ? $bitmessage_ip[1] : '8444'), env('BITMESSAGE_CLIENT_USERNAME', ''), env('BITMESSAGE_CLIENT_PASSWORD', ''));
        }

        $from = Cache::get('bitmessage_address', false);

        if (empty($from)) {
            $list = self::$bmc->listAddresses();

            if (!empty($list['addresses'])) {
                self::$from = $list['addresses'][ rand(0, (count($list['addresses'])-1)) ]['address'];
            } else {
                self::$from = self::$bmc->createRandomAddress(config('app.name'));
            }

            Cache::add('bitmessage_address', self::$from, 180);
        } else {
            self::$from = $from;
        }
    }

    public function send($to, $subject, $message) {
        if (self::$bmc === null || self::$from === null) {
            self::clientInstance();
        }

        return self::$bmc->sendMessage($to, self::$from, $subject, $message);
    }
}