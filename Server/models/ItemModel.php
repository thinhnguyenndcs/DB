<?php 

namespace App\Models;

use App\Core\AppConfig;
use App\Core\Databases\DBConnection;

use Exception;
use PDOException;
use PDO;
use stdClass;

class ItemModel{
    public $indexId;
    public $itemType;
    public $salePrice;
    public $name;
    public $functionType;
    public $manufacturer;
    public $orderId;

    public function __construct($indexId, $itemType, $salePrice, $name, $functionType, $manufacturer, $orderId)
    {
        $this->indexId = $indexId;
        $this->itemType = $itemType;
        $this->salePrice = $salePrice;
        $this->name = $name;
        $this->functionType = $functionType;
        $this->manufacturer = $manufacturer;
        $this->orderId = $orderId;
    }

    public static function getAllBranch(){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "SELECT * FROM BRANCH";
        $queryStmt = $pdo->prepare($queryString);
        $queryStmt->execute();
        $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
        return $queryStmt->fetchAll();
    }

    public static function getAllManufacture(){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "SELECT * FROM MANUFACTURE";
        $queryStmt = $pdo->prepare($queryString);
        $queryStmt->execute();
        $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
        return $queryStmt->fetchAll();
    }

    public static function getAllProductType(){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "SELECT * FROM PRODUCT_TYPE";
        $queryStmt = $pdo->prepare($queryString);
        $queryStmt->execute();
        $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
        return $queryStmt->fetchAll();
    }

    public static function getAllAccessoriesType(){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "SELECT * FROM ACCESSORIES_TYPE";
        $queryStmt = $pdo->prepare($queryString);
        $queryStmt->execute();
        $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
        return $queryStmt->fetchAll();
    }

    public static function getAllItemProcedure(){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "CALL CreateAllItemInfoTable()";

        try{
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->execute();

            $queryString = "SELECT * FROM AllItemInfo";
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->execute();
            $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
            return $queryStmt->fetchAll();
        }
        catch(PDOException $e){
            throw new Exception($e->getMessage());
        }
    }

    public static function getAllTypeInfoProcedure(){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "CALL CreateAllTypeInfoTable()";
        try{
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->execute();

            $queryString = "SELECT * FROM AllTypeInfo";
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->execute();
            $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
            return $queryStmt->fetchAll();
        }
        catch(PDOException $e){
            throw new Exception($e->getMessage());
        }
    }

    public static function isManufactureIdExist($manufactureId, $pdo){
        $queryString = "SELECT * from MANUFACTURE WHERE Id = {$manufactureId}";
        $queryStmt = $pdo->prepare($queryString);
        $queryStmt->execute();
        $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
        $result = $queryStmt->fetchAll();
        return count($result) >= 1;
    }

    public static function insertAccessoriesTypeProcedure($name, $functionType, $manufactureId){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);

        if(!self::isManufactureIdExist($manufactureId, $pdo)){
            throw new Exception("Manufacture Id not exists");
        }

        $queryString = "CALL InsertAccessoriesType(?,?,?)";
        try{
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->bindParam(1, $name, PDO::PARAM_STR);
            $queryStmt->bindParam(2, $functionType, PDO::PARAM_STR);
            $queryStmt->bindParam(3, $manufactureId, PDO::PARAM_STR);
            $queryStmt->execute();
        }
        catch(PDOException $e){
            throw new Exception($e->getMessage());
        }
    }

    public static function insertProductTypeProcedure($name, $functionType, $manufactureId, $screenSize, $processor, $memoryGB){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "CALL InsertProductType(?,?,?,?,?,?)";

        if(!self::isManufactureIdExist($manufactureId, $pdo)){
            throw new Exception("Manufacture Id not exists");
        }

        if(!(is_numeric($screenSize) && is_numeric($memoryGB))){
            throw new Exception("Screen Size and Memory in GB must be integer value");
        }

        try{
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->bindParam(1, $name, PDO::PARAM_STR);
            $queryStmt->bindParam(2, $functionType, PDO::PARAM_STR);
            $queryStmt->bindParam(3, $manufactureId, PDO::PARAM_STR);
            $queryStmt->bindParam(4, $screenSize, PDO::PARAM_STR);
            $queryStmt->bindParam(5, $processor, PDO::PARAM_STR);
            $queryStmt->bindParam(6, $memoryGB, PDO::PARAM_STR);
            $queryStmt->execute();
        }
        catch(PDOException $e){
            throw new Exception($e->getMessage());
        }
    }

    public static function isProductTypeIdExist($typeId, $pdo){
        $queryString = "SELECT * FROM PRODUCT_TYPE where Id = {$typeId}";
        $queryStmt = $pdo->prepare($queryString);
        $queryStmt->execute();
        $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
        $result = $queryStmt->fetchAll();
        return count($result) >= 1;
    }

    public static function isAccessoriesTypeIdExist($typeId, $pdo){
        $queryString = "SELECT * FROM ACCESSORIES_TYPE where Id = {$typeId}";
        $queryStmt = $pdo->prepare($queryString);
        $queryStmt->execute();
        $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
        $result = $queryStmt->fetchAll();
        return count($result) >= 1;
    }

    public static function insertItemProcedure($itemType, $typeId, $salePrice, $importPrice, $branchId, $quantity){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "CALL InsertItems(?,?,?,?,?,?)";

        if(!(is_numeric($salePrice) && is_numeric($importPrice) && is_numeric($quantity))){
            throw new Exception("Sale Price, Import Price, Quantity must be numeric values");
        }

        if(+$salePrice <= +$importPrice){
            throw new Exception("Sale Price must higher than import price");
        }

        if(+$quantity < 1){
            throw new Exception("Quanity must be a positive number");
        }

        if($itemType != "Product" && $itemType != "Accessories"){
            throw new Exception("Item Type must be 'Product' or 'Accessories'");
        }
        else if ($itemType == "Product"){
            if(!self::isProductTypeIdExist($typeId, $pdo)){
                throw new Exception("Product Type Id not exists");
            }
        }
        else if ($itemType == "Accessories"){
            if(!self::isAccessoriesTypeIdExist($typeId, $pdo)){
                throw new Exception("Accessories Type Id not exists");
            }
        }

        try{
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->bindParam(1, $itemType, PDO::PARAM_STR);
            $queryStmt->bindParam(2, $typeId, PDO::PARAM_STR);
            $queryStmt->bindParam(3, $salePrice, PDO::PARAM_STR);
            $queryStmt->bindParam(4, $importPrice, PDO::PARAM_STR);
            $queryStmt->bindParam(5, $branchId, PDO::PARAM_STR);
            $queryStmt->bindParam(6, $quantity, PDO::PARAM_STR);
            $queryStmt->execute();
        }
        catch(PDOException $e){
            throw new Exception($e->getMessage());
        }
    }

    public static function searchItemProcedure($searchString){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "CALL SearchItemsByName(?)";
        try{
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->bindParam(1, $searchString, PDO::PARAM_STR);
            $queryStmt->execute();
            $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
            return $queryStmt->fetchAll();
        }
        catch(PDOException $e){
            throw new Exception($e->getMessage());
        }
    }

    public static function searchTypeProcedure($searchString){
        $pdo = DBConnection::make(AppConfig::get('config')['ITDatabase']);
        $queryString = "CALL SearchTypesByName(?)";
        try{
            $queryStmt = $pdo->prepare($queryString);
            $queryStmt->bindParam(1, $searchString, PDO::PARAM_STR);
            $queryStmt->execute();
            $queryStmt->setFetchMode(PDO::FETCH_ASSOC);
            return $queryStmt->fetchAll();
        }
        catch(PDOException $e){
            throw new Exception($e->getMessage());
        }
    }
}