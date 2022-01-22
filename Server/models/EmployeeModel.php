<?php

namespace App\Models;

use App\Core\AppConfig;
use App\Core\Databases\DBConnection;

use Exception;
use PDOException;
use PDO;
use stdClass;

class EmployeeModel{
    public $id;
    public $fullname;
    public $email;
    public $password;
    public $salary;
    public $branchId;
    public $managerId;

    public function __construct($id, $fullname, $email, $password, $salary, $branchId, $managerId)
    {
        $this->id = $id; 
        $this->fullname = $fullname;
        $this->email = $email;
        $this->password = $password;
        $this->salary = $salary;
        $this->branchId = $branchId;  
        $this->managerId = $managerId;  
    }

    public static function registerEmployeeProcedure($fullname, $email, $password, $salary, $branchId, $managerId){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "CALL InsertEmployeeAccount(?, ?, ?, ?, ?, ?)";

        try{    
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->bindParam(1, $password, PDO::PARAM_STR);
            $queryStmt->bindParam(2, $managerId, PDO::PARAM_STR);
            $queryStmt->bindParam(3, $fullname, PDO::PARAM_STR);
            $queryStmt->bindParam(4, $email, PDO::PARAM_STR);
            $queryStmt->bindParam(5, $salary, PDO::PARAM_STR);
            $queryStmt->bindParam(6, $branchId, PDO::PARAM_STR);
            $queryStmt->execute();
        }
        catch (PDOException $e){
            throw new Exception($e->getMessage());
        }
    }

    public static function loginEmployeeProcedure($email, $password){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "Select * FROM EMPLOYEE WHERE email=:email AND password=:password";
        $queryStmt = $pdo->prepare($queryString);
        $queryStmt->bindParam(":email", $email, PDO::PARAM_STR);
        $queryStmt->bindParam(":password", $password, PDO::PARAM_STR);
        $queryStmt->execute();
        $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
        return $queryStmt->fetchAll();
    }

    public static function updateEmployeeProcedure($id, $fullname, $password, $branchId, $managerId){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "CALL UpdateEmployeeAccount(?, ?, ?, ?, ?)";
        try{    
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->bindParam(1, $id, PDO::PARAM_STR);
            $queryStmt->bindParam(2, $password, PDO::PARAM_STR);
            $queryStmt->bindParam(3, $fullname, PDO::PARAM_STR);
            $queryStmt->bindParam(4, $managerId, PDO::PARAM_STR);
            $queryStmt->bindParam(5, $branchId, PDO::PARAM_STR);
            $queryStmt->execute();

            /**
             * If success return the new Employee info 
             */
            $queryString = "Select * FROM EMPLOYEE WHERE Id={$id}";
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->execute();
            $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
            return $queryStmt->fetch();
        }
        catch (PDOException $e){
            throw new Exception($e->getMessage());
        }
    }

    public static function getAllCustomerQuery(){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "SELECT Id, Fullname, Email, Balance from CUSTOMER";
        try{    
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->execute();
            $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
            return $queryStmt->fetchAll();
        }
        catch(PDOException $e){
            throw new Exception($e->getMessage());
        }
    }

    public static function searchCustomerByEmailProcedure($searchString){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "CALL CustomerSearchByEmail(?)";
        try {
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->bindParam(1, $searchString, PDO::PARAM_STR);
            $queryStmt->execute();
            $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
            return $queryStmt->fetchAll();
        }
        catch (PDOException $e){
            throw new Exception($e->getMessage());
        }
    }

    public static function updateCustomerBalanceProcedure($customerId, $email, $balanceChanged){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "CALL UpdateCustomerBalance(?,?,?)";
        try{
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->bindParam(1, $customerId, PDO::PARAM_STR);
            $queryStmt->bindParam(2, $email, PDO::PARAM_STR);
            $queryStmt->bindParam(3, $balanceChanged, PDO::PARAM_INT);
            $queryStmt->execute();

            /**
             * If success return the new customer balance info 
             */
            $queryString = "SELECT Id, Balance, Email from CUSTOMER WHERE Id={$customerId}";
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->execute();
            $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
            return $queryStmt->fetch();

        }
        catch(PDOException $e){
            throw new Exception($e->getMessage());
        }
    }
}