<?php

namespace App\Core;

use FFI\Exception;

class AppConfig
{
    protected static $registry;

    public static function bind($key, $value){
        self::$registry[$key] = $value;
    }

    public static function get($key){
        if (!array_key_exists($key, self::$registry)){
            throw new Exception("No $key is bound in DI");
        }
        return self::$registry[$key];
    }
}