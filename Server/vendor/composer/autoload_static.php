<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInit6503fe0eccc62d72d452991b20420030
{
    public static $classMap = array (
        'App\\Auth\\AuthMiddleware' => __DIR__ . '/../..' . '/auth/AuthMiddleware.php',
        'App\\Controllers\\CustomerController' => __DIR__ . '/../..' . '/controllers/CustomerController.php',
        'App\\Controllers\\EmployeeController' => __DIR__ . '/../..' . '/controllers/EmployeeController.php',
        'App\\Controllers\\ItemController' => __DIR__ . '/../..' . '/controllers/ItemController.php',
        'App\\Controllers\\OrderController' => __DIR__ . '/../..' . '/controllers/OrderController.php',
        'App\\Core\\AppConfig' => __DIR__ . '/../..' . '/core/AppConfig.php',
        'App\\Core\\Databases\\DBConfig' => __DIR__ . '/../..' . '/core/databases/DBConfig.php',
        'App\\Core\\Databases\\DBConnection' => __DIR__ . '/../..' . '/core/databases/DBConnection.php',
        'App\\Core\\Databases\\DBITQueryBuilder' => __DIR__ . '/../..' . '/core/databases/DBITQueryBuilder.php',
        'App\\Core\\Ultility' => __DIR__ . '/../..' . '/core/Core.php',
        'App\\Models\\CustomerModel' => __DIR__ . '/../..' . '/models/CustomerModel.php',
        'App\\Models\\EmployeeModel' => __DIR__ . '/../..' . '/models/EmployeeModel.php',
        'App\\Models\\ItemModel' => __DIR__ . '/../..' . '/models/ItemModel.php',
        'App\\Models\\OrderModel' => __DIR__ . '/../..' . '/models/OrderModel.php',
        'App\\Router\\Request' => __DIR__ . '/../..' . '/router/Request.php',
        'App\\Router\\Router' => __DIR__ . '/../..' . '/router/Router.php',
        'ComposerAutoloaderInit6503fe0eccc62d72d452991b20420030' => __DIR__ . '/..' . '/composer/autoload_real.php',
        'Composer\\Autoload\\ClassLoader' => __DIR__ . '/..' . '/composer/ClassLoader.php',
        'Composer\\Autoload\\ComposerStaticInit6503fe0eccc62d72d452991b20420030' => __DIR__ . '/..' . '/composer/autoload_static.php',
        'Composer\\InstalledVersions' => __DIR__ . '/..' . '/composer/InstalledVersions.php',
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->classMap = ComposerStaticInit6503fe0eccc62d72d452991b20420030::$classMap;

        }, null, ClassLoader::class);
    }
}
