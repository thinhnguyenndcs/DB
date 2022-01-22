<?php

namespace App\Models;

use App\Core\AppConfig;
use App\Core\Databases\DBConnection;

use Exception;
use PDOException;
use PDO;
use stdClass;

class CustomerModel{
    public $id;
    public $fullname;
    public $email;
    public $password;
    public $balance;
    public $address;

    public function __construct($id, $fullname, $email, $password, $balance, $address)
    {
        $this->id = $id; 
        $this->fullname = $fullname;
        $this->email = $email;
        $this->password = $password;
        $this->balance = $balance;
        $this->address = $address;  
    }

    public static function registerCustomerProcedure($fullname, $email, $password, $balance, $address){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "CALL InsertCustomerAccount(?, ?, ?, ?, ?)";

        try{    
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->bindParam(1, $password, PDO::PARAM_STR);
            $queryStmt->bindParam(2, $address, PDO::PARAM_STR);
            $queryStmt->bindParam(3, $fullname, PDO::PARAM_STR);
            $queryStmt->bindParam(4, $email, PDO::PARAM_STR);
            $queryStmt->bindParam(5, $balance, PDO::PARAM_STR);
            $queryStmt->execute();
        }
        catch (PDOException $e){
            throw new Exception($e->getMessage());
        }
    }

    public static function loginCustomerProcedure($email, $password){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "Select * FROM CUSTOMER WHERE email=:email AND password=:password";
        $queryStmt = $pdo->prepare($queryString);
        $queryStmt->bindParam(":email", $email, PDO::PARAM_STR);
        $queryStmt->bindParam(":password", $password, PDO::PARAM_STR);
        $queryStmt->execute();
        $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
        return $queryStmt->fetchAll();
    }

    public static function updateCustomerProcedure($id, $fullname, $password, $address){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "CALL UpdateCustomerAccount(?, ?, ?, ?)";
        try{    
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->bindParam(1, $id, PDO::PARAM_STR);
            $queryStmt->bindParam(2, $password, PDO::PARAM_STR);
            $queryStmt->bindParam(3, $address, PDO::PARAM_STR);
            $queryStmt->bindParam(4, $fullname, PDO::PARAM_STR);
            $queryStmt->execute();

            /**
             * If success return the new user info 
             */
            $queryString = "Select * FROM CUSTOMER WHERE Id={$id}";
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->execute();
            $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
            return $queryStmt->fetch();
        }
        catch (PDOException $e){
            throw new Exception($e->getMessage());
        }
    }
}