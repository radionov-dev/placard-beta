<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cache;
use Plankton\Client\Client;
use Plankton\Client\Strategy\BasicAuthentication;
use Plankton\Response;
use Plankton\Request;
use Plankton\Client\Strategy\ClientCredentialsAuthentication;
use Plankton\Logging\SimpleLogger;
use Illuminate\Support\Facades\Log;

class BitDeals extends Model {

    public static $bd_client = null;
    public static $bd_auth = null;
    private $apiEntryPoint = null;

    private static function clientInstance() {
        if (env('BITDEALS_USERNAME', '') && env('BITDEALS_PASSWORD', '') && (!env('BITDEALS_SECRET', '') || !env('BITDEALS_CLIENT_ID', '') || !env('BITDEALS_CLIENT_SECRET', ''))) {
            self::$bd_auth = new BasicAuthentication(env('BITDEALS_USERNAME', ''), env('BITDEALS_PASSWORD', ''));
            self::$bd_client = new Client(env('BITDEALS_HOST', 'localhost') . ":" . env('BITDEALS_PORT', '4999') . "/api/v1", self::$bd_auth);
            self::$bd_client->enableSSL(false);
        } else {
            $token = Cache::get('_token_bitdeals', false);

            $token_data = [];

            if (env('BITDEALS_USERNAME', '') && env('BITDEALS_PASSWORD', '') && env('BITDEALS_SECRET', '')) {
                $token_data = [
                    "grant_type" => 'password',
                    "username" => env('BITDEALS_USERNAME', ''),
                    "password" => env('BITDEALS_PASSWORD', ''),
                    "secret" => env('BITDEALS_SECRET', '')
                ];
            }

            self::$bd_auth =  new ClientCredentialsAuthentication(env('BITDEALS_CLIENT_ID', ''), env('BITDEALS_CLIENT_SECRET', ''), env('BITDEALS_HOST', 'localhost') . "/oauth2/token", ['bitdeals'], $token_data);


            if (!empty($token) && $token->getExpiration() > time()) {
                self::$bd_auth->setAccessToken($token);
            }

            self::$bd_client = new Client(env('BITDEALS_HOST', 'localhost')."/api/v1", new BasicAuthentication(env('BITDEALS_CLIENT_ID', ''), env('BITDEALS_CLIENT_SECRET', '')));
            self::$bd_client->enableSSL(false);

            
            $time = self::$bd_client->get("/time");


            $AccessToken = self::$bd_auth->getAccessToken();

            if ($AccessToken && $token != $AccessToken) {
                Cache::add('_token_bitdeals', $AccessToken, (($AccessToken->getExpiration()-time())*60));
            }

            self::$bd_client = new Client(env('BITDEALS_HOST', 'localhost'). ":" . env('BITDEALS_PORT', '4999') . "/api/v1", self::$bd_auth);
        }

        self::$bd_client->setLogger(new SimpleLogger());
    }

    public function get(string $uri, callable $callback = NULL): ?Response{
        $request = new Request(env('BITDEALS_HOST', 'localhost') . ":" . env('BITDEALS_PORT', '4999') . "/api/v1" . $uri, Request::METHOD_GET);

        $request
            ->setHeader("Origin", url('/'));

        return self::$bd_client->send($request, $callback);
    }

    /**
     * @access public
     * @param string $uri
     * @param mixed $data
     * @param callable $callback
     * @return \Plankton\Response|null
     */
    public function post(string $uri, $data, callable $callback = NULL): ?Response{
        $request = new Request(env('BITDEALS_HOST', 'localhost') . ":" . env('BITDEALS_PORT', '4999') . "/api/v1" . $uri);
        $request
            ->setMethod(Request::METHOD_POST)
            ->setContentType(self::guessContentType($data))
            ->setHeader("Origin", url('/'))
            ->setData($data);

        return self::$bd_client->send($request, $callback);
    }

    /**
     * @access public
     * @param string $uri
     * @param mixed $data
     * @param callable $callback
     * @return \Plankton\Response|null
     */
    public function put(string $uri, $data, callable $callback = NULL): ?Response{
        $request = new Request(env('BITDEALS_HOST', 'localhost') . ":" . env('BITDEALS_PORT', '4999') . "/api/v1" . $uri);
        $request
            ->setMethod(Request::METHOD_PUT)
            ->setContentType(self::guessContentType($data))
            ->setHeader("Origin", url('/'))
            ->setData($data);

        return self::$bd_client->send($request, $callback);
    }

    /**
     * @access public
     * @param string $uri
     * @param mixed $data
     * @param callable $callback
     * @return \Plankton\Response|null
     */
    public function patch(string $uri, $data, callable $callback = NULL): ?Response{
        $request = new Request(env('BITDEALS_HOST', 'localhost') . ":" . env('BITDEALS_PORT', '4999') . "/api/v1" . $uri);
        $request
            ->setMethod(Request::METHOD_PATCH)
            ->setContentType(self::guessContentType($data))
            ->setHeader("Origin", url('/'))
            ->setData($data);

        return self::$bd_client->send($request, $callback);
    }

    /**
     * @access public
     * @param string $uri
     * @param callable $callback
     * @return \Plankton\Response|null
     */
    public function delet(string $uri, callable $callback = NULL): ?Response{
        $request = new Request(env('BITDEALS_HOST', 'localhost') . ":" . env('BITDEALS_PORT', '4999') . "/api/v1" . $uri, Request::METHOD_DELETE);
        $request
            ->setHeader("Origin", url('/'));

        return self::$bd_client->send($request, $callback);
    }

    private function sendRequest(string $endpoint, $data = [], $type = 'GET', callable $callback = NULL) {
        if (self::$bd_client === null) {
            self::clientInstance();
        }

        switch ($type) {
            case Request::METHOD_POST:
                $response = self::post($endpoint, $data, $callback);
                break;
            case Request::METHOD_PUT:
                $response = self::put($endpoint, $data, $callback);
                break;
            case Request::METHOD_PATCH:
                $response = self::patch($endpoint, $data, $callback);
                break;
            case Request::METHOD_DELETE:
                if ($data) {
                    $endpoint .= "?" . http_build_query($data);
                }

                $response = self::delet($endpoint, $callback);
                break;
            default:
                if ($data) {
                    $endpoint .=  "?" . http_build_query($data);
                }

                $response = self::get($endpoint, $callback);
        }

        //var_dump($response);

        foreach (self::$bd_client->getLogger()->getLogs() as $request) {
            $lresponse = self::$bd_client->getLogger()->getLogs()[$request];
            \Log::info(['bd_client'=>self::$bd_client, 'endpoint' => $endpoint, 'type' => $type, 'data' => $data, 'response' => $lresponse]);
        }

        /*if($response) {
            $r = json_decode($response->getContent(), true);
            if(!empty($r['error']) || empty($r['result']['success'])) {
                echo "<pre>";
                var_dump($response);
                echo "<br>endpoint: " . $endpoint;
                echo "<br>type: " . $type ."<br>data: ";
                var_dump($data);
                echo "<br>response: ";
                var_dump($r);
                echo "</pre>";
            }
        }*/


        return $response;
    }

    public function get_user_status($params) {
        $address = (!empty($params['address'])) ? $params['address'] : null;

        $response = self::sendRequest('/account/status', array('address' => $address), 'POST');

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent());
    }

    public function time($params) {
        $response = self::sendRequest('/time', $params);

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent());
    }

    public function create_deal($params) {
        $response = self::sendRequest('/deal/create', $params, 'POST');

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent());
    }

    public function pay_deal($params) {
        $response = self::sendRequest('/deal/pay', $params, 'POST');

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent());
    }

    public function complete_deal($params) {
        $response = self::sendRequest('/deal/complete', $params, 'POST');

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent());
    }

    public function status_deal($params) {
        $response = self::sendRequest('/deal/status', $params, 'POST');

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent());
    }

    public function new_user($params) {
        $params['url'] = [url('/')];
        $response = self::sendRequest('/account/new', $params, 'POST');

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent());
    }

    public function add_user($params) {
        $status = self::get_user_status($params);

        if (!empty($status->result) && empty($status->result->success)) {
            return self::new_user($params);
        }

        return self::update_user($params);

        /*$response = self::sendRequest('/account/add', $params, 'POST');

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent());*/
    }

    public function update_user($params) {
        $status = self::get_user_status($params);

        if (!empty($status->result) && empty($status->result->success)) {
            return self::new_user($params);
        } else {
            $info = array('urltrusted'=>array());
            $params_pr = array('code'=>$params['address']);

            $response = self::sendRequest('/user/profile', $params_pr, 'POST');

            //var_dump($params_pr);
            //var_dump($response);

            if($response){
                $info = json_decode($response->getContent(), true);
            }
        }

        $params['date'] = date('Y-m-d');

        if(!empty($info['urltrusted'])) {
            $params['url'] = $info['urltrusted'];
        } else {
            $params['url'] = [];
        }

        if(!in_array(url('/'), $params['url'])) {
            $params['url'][] = url('/');
        }

        if(!empty($params['sign'])) {
            $params['sign'] = trim($params['sign']);
        }

        //todo: maybe need to delete
        if(isset($params['bitmessage'])) {
            unset($params['bitmessage']);
        }

        $response = self::sendRequest('/account/update?address='.$params['address'], json_encode($params), 'POST');

        //var_dump($response);

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent());
    }

    public function bc_history($params) {
        $account = (!empty($params['account'])) ? $params['account'] : null;

        $response = self::sendRequest('/bc/history', array('account' => $account), 'POST');

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent());
    }

    public function user_profile($params = array()) {
        $params_pr = array('code'=>$params['address']);
        $response = self::sendRequest('/user/profile', $params_pr, 'POST');

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent(), true);
    }
  
    public function feedback_list($params) {
        $account = (!empty($params['account'])) ? $params['account'] : null;
        $status = (!empty($params['status'])) ? $params['status'] : null;
		$json = '{"search": [{"field": "sellercode", "value": "'.$account.'"}]}';
      
        if(in_array($status, array(3,1))) {
          $status = ($status==3)?1:-1;
          $json = '{"search": [{"field": "sellercode", "value": "'.$account.'"}, {"field": "status", "value": '.$status.' }]}';
        }
      
        $response = self::sendRequest('/deal/feedback/list', $json, 'POST');
        //$response = self::sendRequest('/deal/feedback/list', array('search' => array('field' => 'sellercode', 'value' => $account)), 'POST');

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent());
    }
  
    public function deal_cancel($params) {
        $response = self::sendRequest('/deal/cancel', $params, 'POST');

        if (!$response) {
            return false;
        }

        return json_decode($response->getContent());
    }

    private function guessContentType($data){
        if (is_array($data)) {
            return Request::CONTENT_TYPE_X_WWW_FORM_URLENCODED;
        }

        if (is_object($data)) {
            return Request::CONTENT_TYPE_JSON;
        }

        if (preg_match("#^\s*[[{].*[]}]\s*\$#", $data)
            && json_decode($data)
            && json_last_error() == JSON_ERROR_NONE) {
            return Request::CONTENT_TYPE_JSON;
        }

        if (preg_match("#^\s*<\?xml.+\$#", $data)
            && simplexml_load_string($data)) {
            return Request::CONTENT_TYPE_XML;
        }

        return Request::CONTENT_TYPE_TEXT_PLAIN;
    }
}