<?php

namespace App\Core\Databases;

use PDO;

use PDOException;

class DBConnection {
    public static function make($config)
    {
        try{
            $pdo = new PDO(
                "mysql:host={$config['host']};
                dbname={$config['dbname']}", 
                $config['username'], 
                $config['password'], 
            );
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            return $pdo;
        }
        catch(PDOException $e){
            echo "Failed at creating PDO: ".$e->getMessage();
            die();
        }
    }
}