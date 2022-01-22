<?php

namespace App\Controllers;

use App\Core\AppConfig;
use App\Core\Ultility;
use App\Auth\AuthMiddleware;
use App\Models\CustomerModel;
use Exception;
use stdClass;

class CustomerController {

    /**
     * API Query All Customers Info
     */
    public static function getAllCustomer(){
        $queryBuilder = AppConfig::get('ITDatabase')->selectAllQueryBuilder('CUSTOMER');
        $customer = [];

        while($row = $queryBuilder->fetch()){
            array_push($customer, $row);
        }

        $response = new stdClass();
        $response->response = $customer;
        $response->status = 200;

        echo json_encode($response);
    }

    /**
     * API POST Register New Customer Account:
     * - Check if email exist inside DBMS implementation, throwing exception
     */
    public static function registerCustomer(){
        $fullname = $_POST['fullname']; 
        $email = $_POST['email']; 
        $password = $_POST['password']; 
        $balance = $_POST['balance']; 
        $address = $_POST['address'];
        $response = new stdClass();
        try{
            CustomerModel::registerCustomerProcedure($fullname, $email, $password, $balance, $address);
            $response->status = 200;
            $response->response = [
                "fullname" => $fullname,
                "email" => $email,
                "password" => "",
                "balance" => $balance,
                "address" => $address
            ];
            echo json_encode($response);

        }
        catch(Exception $e){
            $response->status = 400;
            $response->message = $e->getMessage();
            echo json_encode($response);
        }
    }

    /**
     * API POST Login Customer:
     * - Return customer info except for password and addition token for other Customer Activity authentication
     */
    public static function loginCustomer(){
        $email = $_POST['email']; 
        $password = $_POST['password']; 
        $result = CustomerModel::loginCustomerProcedure($email, $password);
        $response = new stdClass();
        if(count($result) != 0){
            $response->status = 200;
            $response->response = $result[0];
            $response->response["Password"] = "";
            $response->token = AuthMiddleware::generateToken($result[0]['Id'], $email, $password);
        }
        else {
            $response->status = 400;
            $response->message = "Login failed, invalid email or password"; 
        }
        echo json_encode($response);
    }

    /**
     * API POST Update Customer Info (fullname, password, address only):
     * - Checking Customer token is valid
     * - Update Info 
     * - If success, client side will make customer relogin
     */
    public static function updateCustomer(){
        $response = new stdClass();
        if(!AuthMiddleware::isValidToken('CUSTOMER')){
            $response->status = 400;
            $response->message = "You must login first";
            echo json_encode($response);
            die();
        }

        $id = $_POST['id'];
        $fullname = $_POST['fullname']; 
        $password = $_POST['password']; 
        $address = $_POST['address'];

        try{
            $result = CustomerModel::updateCustomerProcedure($id, $fullname, $password, $address);
            $response->response = $result;
            $response->status = 200;
            echo json_encode($response);
        }
        catch(Exception $e){
            $response->status = 400;
            $response->message = $e->getMessage();
            echo json_encode($response);
        }
    }
}