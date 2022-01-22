<?php

$router->get("customers", "CustomerController@getAllCustomer");

/**
 * $_POST
 * @param: 'fullname', 'email', 'password', 'balance', 'address'
 */
$router->post("customer/register", "CustomerController@registerCustomer");

/**
 * $_POST
 * @param: 'email', 'password'
 */
$router->post("customer/login", "CustomerController@loginCustomer");

/**
 * $_POST
 * @param: 'id', 'fullname', 'password', 'address'
 */
$router->post("customer/update", "CustomerController@updateCustomer");