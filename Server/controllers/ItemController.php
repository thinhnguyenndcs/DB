<?php

namespace App\Controllers;

use App\Core\AppConfig;
use App\Core\Ultility;
use App\Auth\AuthMiddleware;
use App\Models\ItemModel;
use Exception;
use stdClass;

class ItemController {
    public static function getAllBranch(){
        $response = new stdClass();
        try {
            $result = ItemModel::getAllBranch();
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

    public static function getAllManufacture(){
        $response = new stdClass();
        try {
            $result = ItemModel::getAllManufacture();
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

    public static function getAllProductType(){
        $response = new stdClass();
        try {
            $result = ItemModel::getAllProductType();
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

    public static function getAllAccessoriesType(){
        $response = new stdClass();
        try {
            $result = ItemModel::getAllAccessoriesType();
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

    public static function getAllItem(){
        $response = new stdClass();
        if(!AuthMiddleware::isValidToken('EMPLOYEE') && !AuthMiddleware::isValidToken('CUSTOMER')){
            $response->status = 400;
            $response->message = "You must login as Employee or Customer first";
            echo json_encode($response);
            die();
        }

        try {
            $result = ItemModel::getAllItemProcedure();
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

    public static function getAllTypeInfo(){
        
        $response = new stdClass();
        if(!AuthMiddleware::isValidToken('EMPLOYEE')){
            $response->status = 400;
            $response->message = "You must login as Employee first";
            echo json_encode($response);
            die();
        }
        try {
            $result = ItemModel::getAllTypeInfoProcedure();
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

    public static function insertAccessoriesType(){
        $response = new stdClass();
        if(!AuthMiddleware::isValidToken('EMPLOYEE')){
            $response->status = 400;
            $response->message = "You must login as Employee first";
            echo json_encode($response);
            die();
        }

        $name = $_POST['name'];
        $functionType = $_POST['functionType'];
        $manufactureId = $_POST['manufactureId'];
        
        try {
            ItemModel::insertAccessoriesTypeProcedure($name, $functionType, $manufactureId);
            $response->status = 200;
            $response->response = "Accessories Type Inserted, please reload employee page";
            echo json_encode($response);
        }
        catch (Exception $e){
            $response->status = 400;
            $response->message = $e->getMessage();
            echo json_encode($response);
        }
    }

    public static function insertProductType(){
        $response = new stdClass();
        if(!AuthMiddleware::isValidToken('EMPLOYEE')){
            $response->status = 400;
            $response->message = "You must login as Employee first";
            echo json_encode($response);
            die();
        }
        $name = $_POST['name'];
        $functionType = $_POST['functionType'];
        $manufactureId = $_POST['manufactureId'];
        $screenSize = $_POST['screenSize'];
        $processor = $_POST['processor'];
        $memoryGB = $_POST['memoryGB'];

        try {
            ItemModel::insertProductTypeProcedure($name, $functionType, $manufactureId, $screenSize, $processor, $memoryGB);
            $response->status = 200;
            $response->response = "Product Type Inserted, please reload employee page";
            echo json_encode($response);
        }
        catch (Exception $e){
            $response->status = 400;
            $response->message = $e->getMessage();
            echo json_encode($response);
        }
    }

    public static function insertItem(){
        $response = new stdClass();
        if(!AuthMiddleware::isValidToken('EMPLOYEE')){
            $response->status = 400;
            $response->message = "You must login as Employee first";
            echo json_encode($response);
            die();
        }
        $itemType = $_POST['itemType'];
        $typeId = $_POST['typeId'];
        $salePrice = $_POST['salePrice'];
        $importPrice = $_POST['importPrice'];
        $branchId = $_POST['branchId'];
        $quantity = $_POST['quantity'];
        try {
            ItemModel::insertItemProcedure($itemType, $typeId, $salePrice, $importPrice, $branchId, $quantity);
            $response->status = 200;
            $response->response = "Product Type Inserted, please reload employee page";
            echo json_encode($response);
        }
        catch (Exception $e){
            $response->status = 400;
            $response->message = $e->getMessage();
            echo json_encode($response);
        }
    }
 
    public static function searchItem(){
        $response = new stdClass();
        if(!AuthMiddleware::isValidToken('EMPLOYEE')){
            $response->status = 400;
            $response->message = "You must login as Employee first";
            echo json_encode($response);
            die();
        }
        $searchString = $_POST['searchString'];
        try {
            $result = ItemModel::searchItemProcedure($searchString);
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

    public static function searchType(){
        $response = new stdClass();
        if(!AuthMiddleware::isValidToken('EMPLOYEE')){
            $response->status = 400;
            $response->message = "You must login as Employee first";
            echo json_encode($response);
            die();
        }
        $searchString = $_POST['searchString'];
        try {
            $result = ItemModel::searchTypeProcedure($searchString);
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
}
