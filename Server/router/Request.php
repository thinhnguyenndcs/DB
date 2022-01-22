<?php

namespace App\Router;

// TAKING URI and METHOD from GLOBAL VARIABLE $_REQUEST for the Router to routing to controllers
// , can be described as the Router.php input handler

class Request{
    static public function uri(){
        return trim(
            parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH),"/"
        );
    }
    static public function method(){
        return $_SERVER['REQUEST_METHOD'];
    }
}