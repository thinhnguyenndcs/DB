<?php

namespace App\Auth;

use App\Core\AppConfig;
use App\Core\Databases\DBConnection;

use Exception;
use PDOException;
use PDO;
use stdClass;

class AuthMiddleware{
    public static function generateToken($id, $email, $password){
        return "{$id}.*{$email}.*{$password}";
    }

    public static function isValidToken($table){
        $all_headers = getallheaders();

        // $response = new stdClass();
        // $response->status = 400;
        // $response->response = $all_headers;
        // json_encode($response);
        // die();

        if(empty($all_headers) || !array_key_exists('token', $all_headers)) {
          return false;
        }
        $token = $all_headers['token'];

        $params = explode(".*", $token);
        $id = $params[0];
        $email = $params[1];
        $password = $params[2];
        return self::isValidUser($table, $id, $email, $password) != false;
    }

    /**
     * 
     * @return user id or false
     */
    public static function isValidUser($table, $id, $email, $password){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "Select * FROM {$table} WHERE email=:email AND password=:password";
        $queryStmt = $pdo->prepare($queryString);
        $queryStmt->bindParam(":email", $email, PDO::PARAM_STR);
        $queryStmt->bindParam(":password", $password, PDO::PARAM_STR);
        $queryStmt->execute();
        $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
        
        $user = $queryStmt->fetchAll();
        return (count($user) != 0);
    }
}