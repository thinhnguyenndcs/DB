<?php

namespace App\Controllers;

use App\Core\AppConfig;
use App\Core\Ultility;
use App\Auth\AuthMiddleware;
use App\Models\EmployeeModel;
use Exception;
use stdClass;

class EmployeeController{
    /**
     * API Query All Employees Info
     */
    public static function getAllEmployee(){
        $queryBuilder = AppConfig::get('ITDatabase')->selectAllQueryBuilder('EMPLOYEE');
        $employee = [];

        while($row = $queryBuilder->fetch()){
            array_push($employee, $row);
        }

        $response = new stdClass();
        $response->response = $employee;
        $response->status = 200;

        echo json_encode($response);
    }

    /**
     * API POST Register New Employee Account:
     * - Check if email exist inside DBMS implementation, throwing exception
     */
    public static function registerEmployee(){
        $fullname = $_POST['fullname']; 
        $email = $_POST['email']; 
        $password = $_POST['password']; 
        $salary = $_POST['salary']; 
        $branchId = $_POST['branchId'];
        $managerId = null;

        $response = new stdClass();
        try{
            EmployeeModel::registerEmployeeProcedure($fullname, $email, $password, $salary, $branchId, $managerId);
            $response->status = 200;
            $response->response = [
                "fullname" => $fullname,
                "email" => $email,
                "password" => "",
                "salary" => $salary,
                "managerId" => $managerId,
                "branchId" => $branchId,
            ];
            echo json_encode($response);

        }
        catch(Exception $e){
            $response->status = 400;
            $response->message = "Email has been used";
            echo json_encode($response);
        }
    }

    /**
     * API POST Login Employee:
     * - Return employee info except for password and addition token for other Customer Activity authentication
     */
    public static function loginEmployee(){
        $email = $_POST['email']; 
        $password = $_POST['password']; 
        $result = EmployeeModel::loginEmployeeProcedure($email, $password);
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
     * API POST Update Employee Info (fullname, password, branchId, managerId):
     * - Checking Customer token is valid
     * - Update Info 
     * - If success, client side will make customer relogin
     */
    public static function updateEmployee(){
        $response = new stdClass();
        if(!AuthMiddleware::isValidToken('EMPLOYEE')){
            $response->status = 400;
            $response->message = "You must login as Employee first";
            echo json_encode($response);
            die();
        }

        $id = $_POST['id'];
        $fullname = $_POST['fullname']; 
        $password = $_POST['password']; 
        $branchId = $_POST['branchId'];
        $managerId = $_POST['managerId'];

        try{
            $result = EmployeeModel::updateEmployeeProcedure($id, $fullname, $password, $branchId, $managerId);
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

    public static function getAllCustomer(){
        $response = new stdClass();
        if(!AuthMiddleware::isValidToken('EMPLOYEE')){
            $response->status = 400;
            $response->message = "You must login as Employee first";
            echo json_encode($response);
            die();
        }
        try {
            $result = EmployeeModel::getAllCustomerQuery();
            $response->status = 200;
            $response->response = $result;
            echo json_encode($response);
        }
        catch (Exception $e){
            $response->status = 400;
            $response->message = $e->getMessage();
            echo json_encode($response);
        }
    }

    public static function searchCustomer(){
        $response = new stdClass();
        if(!AuthMiddleware::isValidToken('EMPLOYEE')){
            $response->status = 400;
            $response->message = "You must login as Employee first";
            echo json_encode($response);
            die();
        }
        $searchString = $_POST['searchString'];
        
        try {
            $result = EmployeeModel::searchCustomerByEmailProcedure($searchString);
            $response->status = 200;
            $response->response = $result;
            echo json_encode($response);
        }
        catch (Exception $e){
            $response->status = 400;
            $response->message = $e->getMessage();
            echo json_encode($response);
        }
    }

    
    public static function updateCustomerBalance(){
        $response = new stdClass();
        if(!AuthMiddleware::isValidToken('EMPLOYEE')){
            $response->status = 400;
            $response->message = "You must login as Employee first";
            echo json_encode($response);                    
            die();
        }                                                   
        $customerId = $_POST['customerId'];
        $email = $_POST['email'];
        $balanceChanged = $_POST['balanceChanged']; 

        try{
            $result = EmployeeModel::updateCustomerBalanceProcedure($customerId, $email, $balanceChanged);
            $response->status = 200;
            $response->response = $result;
            echo json_encode($response);
        }
        catch(Exception $e){
            $response->status = 400;
            $response->message = $e->getMessage();
            echo json_encode($response);
        }
    }
}
