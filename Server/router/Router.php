<?php

namespace App\Router;

use FFI\Exception;

// get(), post() will be called in routes.php by programmers to configure the router at the beginning

// direct() will running seamlessly called from the router created and returned from the Router::load()
// always listening for request from client, fetch URI and METHOD then using it to route to the desired controller

class Router{
    protected $routes = [
        'GET' => [],
        'POST' => [],
    ];

    /* static function not instance method, not having access to $this variable */
    static public function load(){
        $router = new static;
        require 'router/ItemRoutes.php';
        require 'router/CustomerRoutes.php';
        require 'router/EmployeeRoutes.php';
        require 'router/OrderRoutes.php';
        return $router;                              
    }


    /**
     * get() post() [$uri] will be convert into regex before insert into $routes
     *
     */
    public function get($uri, $controller){
        $this->routes['GET'][$uri] = $controller;
    }
    public function post($uri, $controller){
        $this->routes['POST'][$uri] = $controller;
    }


    /**
     * 
     * direct() will not user array_key_exist to match exact string $uri
     * must use regex to match some routes with parameter
     * 
     * @param $uri: full link
     * @param $methodType: GET/POST
     */
    public function direct($uri, $methodType){
        if(array_key_exists($uri, $this->routes[$methodType])){
            $params = explode('@',$this->routes[$methodType][$uri]);

            $controller = $params[0];
            $action = $params[1];
            $this->callAction($controller, $action);
            return;
        }
        throw new Exception("No routes defined for this URI");
    }

    public function callAction($controller, $action){
        $controller = "App\\Controllers\\{$controller}";

        $controller = new $controller();
        if(method_exists($controller, $action)){
            return $controller->$action();
        }
        throw new Exception("$controller has no $action action");
    }
}