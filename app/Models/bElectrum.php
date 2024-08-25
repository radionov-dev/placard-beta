<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cache;
use Electrum;

class bElectrum extends Model {
    public static $client = null;

    private static function clientInstance() {
        if (self::$client === null) {
            $electrum_ip = explode(':', env('ELECTRUM_IP', ''));

            self::$client = new \Electrum\Client('http://' . $electrum_ip[0], (isset($electrum_ip[1]) ? $electrum_ip[1] : '7777'), 0, env('ELECTRUM_CLIENT_USERNAME', ''), env('ELECTRUM_CLIENT_PASSWORD', ''));
        }
    }

    public function generateAddress() {
        if (self::$client === null) {
            self::clientInstance();
        }

        $wallet_path = '';

        $load_wallet = new \Electrum\Request\Method\Wallet\LoadWallet(self::$client);
        foreach(self::wallets() as $wallet) {
            $wallet_path = $wallet['path'];
            break;
        }

        $load_wallet->execute(['wallet_path' => $wallet_path]);

        $wallet = new \Electrum\Request\Method\Payment\AddRequest(self::$client);
        $tx     = $wallet->execute(['wallet' => $wallet_path]);
        return $tx->getAddress();
    }

    public function getAddressBalace($address) {
        if (self::$client === null) {
            self::clientInstance();
        }

        //var_dump($address);

        $wallet_path = '';

        $load_wallet = new \Electrum\Request\Method\Wallet\LoadWallet(self::$client);
        foreach(self::wallets() as $wallet) {
            $wallet_path = $wallet['path'];
            break;
        }

        $load_wallet->execute(['wallet_path' => $wallet_path]);

        $newAddress = new \Electrum\Request\Method\Address\GetAddressBalance(self::$client);
        $newAddress = $newAddress->setAddress($address);
        $tx2 = $newAddress->execute();

        return [$tx2->getTotal(), $tx2->getConfirmed()];

        //var_dump($tx2->getTotal());


        //exit;


        //$newAddress = new \Electrum\Request\Method\Wallet\GetBalance(self::$client);
        //$tx = $newAddress->execute(['wallet'  => $wallet_path]);

        //var_dump($tx->getTotal());
        //var_dump($tx->getTotal()); exit;

        /*$tx2 = $newAddress->execute(['wallet'  => $wallet_path]);

        var_dump($tx2->)

        $wallet = new \Electrum\Request\Method\Payment\AddRequest(self::$client);
        $tx3     = $wallet->execute(['wallet'  => $wallet_path]);

        return $tx3->getAddress();*/
    }

    public function wallets() {
        if (self::$client === null) {
            self::clientInstance();
        }

        $list_wallets = new \Electrum\Request\Method\Wallet\ListWallets(self::$client);
        $wallets = $list_wallets->execute();

        if (!$wallets) {
            $load_wallet = new \Electrum\Request\Method\Wallet\LoadWallet(self::$client);
            $load_wallet->execute(['wallet_path' => '~/.electrum/wallets/'.config('app.name')]);

            $list_wallets = new \Electrum\Request\Method\Wallet\ListWallets(self::$client);
            $wallets = $list_wallets->execute();

            if (!$wallets) {
                $wallet = new \Electrum\Request\Method\Wallet\CreateWallet(self::$client);
                $wallet->execute(['wallet_path' => '~/.electrum/wallets/' . config('app.name')]);

                //var_dump($wallet_response);

                //$newAddress = new \Electrum\Request\Method\Address\CreateNewAddress(self::$client);
                //$newAddress_response2 = $newAddress->execute(['wallet'  => '~/.electrum/wallets/'.config('app.name')]);

                //var_dump($newAddress_response2);

                //$load_wallet = new Electrum\Request\Method\Wallet\LoadWallet(self::$client);
                //$load_wallet->execute(['wallet_path' => '~/.electrum/wallets/test']);


                $list_wallets = new \Electrum\Request\Method\Wallet\ListWallets(self::$client);
                $wallets = $list_wallets->execute();
            }
        }

        return $wallets;
    }
}