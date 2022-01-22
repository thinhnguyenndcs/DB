<?php

$router->get("employees", "EmployeeController@getAllEmployee");

$router->get("employee/all/customer", "EmployeeController@getAllCustomer");

/**
 * $_POST
 * @param: 'fullname', 'email', 'password', 'salary', 'branchId', 'managerId'
 */
$router->post("employee/register", "EmployeeController@registerEmployee");

/**
 * $_POST
 * @param: 'email', 'password'
 */
$router->post("employee/login", "EmployeeController@loginEmployee");

/**
 * $_POST
 * @param: 'id', 'fullname', 'password', 'salary', 'branchId'
 */
$router->post("employee/update", "EmployeeController@updateEmployee");

/**
 * $_POST
 * @param: 'searchString'
 */
$router->post("employee/search/customer", "EmployeeController@searchCustomer");

/**
 * $_POST
 * @param: 'customerId', 'email', 'balanceChanged'
 */
$router->post("employee/update/customer/balance", "EmployeeController@updateCustomerBalance");