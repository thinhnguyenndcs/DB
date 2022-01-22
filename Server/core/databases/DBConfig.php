<?php

namespace App\Core\Databases;

use PDO;

/**
 * 
 * Class input for DB Make Connection
 * 
 */

class DBConfig{
    public static function config(){
        return [
            'carDatabase' => [
                'username' => 'root',
                'password' => '123456',
                'dbname' => 'CARS',
                'host' => '127.0.0.1',
                'options' => [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                ]
            ],
            'ITDatabase' => [
                'username' => 'root',
                'password' => '123456',
                'dbname' => 'IT',
                'host' => '127.0.0.1',
                'options' => [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                ]
            ]
        ];
    }
}