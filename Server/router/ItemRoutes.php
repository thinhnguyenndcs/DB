<?php 

$router->get("items", "ItemController@getAllItem");

$router->get("types", "ItemController@getAllTypeInfo");

$router->get("branches", "ItemController@getAllBranch");

$router->get("manufactures", "ItemController@getAllManufacture");

$router->get("types/product", "ItemController@getAllProductType");

$router->get("types/accessories", "ItemController@getAllAccessoriesType");


/**
 * $_POST
 * @param: 'name', 'functionType', 'manufactureId'
 */
$router->post("item/insert/accessories/type","ItemController@insertAccessoriesType");

/**
 * $_POST
 * @param: 'name', 'functionType', 'manufactureId', 'screenSize', 'processor, 'memoryGB', 
 */
$router->post("item/insert/product/type","ItemController@insertProductType");

/**
 * $_POST
 * @param: 'itemType': Product/Accessories, 'typeId', 'salePrice', 'importPrice', 'branchId', 'quantity'
 */
$router->post("item/insert","ItemController@insertItem");

/**
 * $_POST
 * @param: 'searchString'
 */
$router->post("item/search","ItemController@searchItem");

/**
 * $_POST
 * @param: 'searchString'
 */
$router->post("type/search","ItemController@searchType");