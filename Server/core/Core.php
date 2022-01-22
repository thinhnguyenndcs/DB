<?php

namespace App\Core;

use App\Core\Databases\DBConnection;
use App\Core\Databases\DBITQueryBuilder;
use App\Core\Databases\DBConfig;

/*
 * QueryBuilder is an object carrying an PDO as private attribute and reponsible to make every type of query
 * for the programmers: commands like Create, Read, Update, Delete on every tables inside the databases that
 * defined in the $PDO
 */
 

AppConfig::bind('config', DBConfig::config());


AppConfig::bind('ITDatabase', new DBITQueryBuilder(
    DBConnection::make(AppConfig::get('config')['ITDatabase'])
)
); 


class Ultility {
    public static function view($name, $data = []){
        /**
         * Example extract()
         * $data = ['name' => 'Thinh', 'age' => '20']
         * 
         * extract($data) 
         * $name = 'Thinh';
         * $age = '20';
         */
    
        extract($data);
        return require "views/{$name}.view.php";
    }
    
    public static function redirect($path){
        header("Location: /{$path}");
    }
}