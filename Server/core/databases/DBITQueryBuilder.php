<?php

namespace App\Core\Databases;

use FFI\Exception;

use PDO;

class DBITQueryBuilder{
    public function __construct($pdo){
        $this->pdo = $pdo;
    }

    public function selectAllQueryBuilder($table){
        try{
            $queryString="select * from $table";
            $query = $this->pdo->prepare($queryString);
        }catch(Exception $e){
            echo "[QueryBuilder.php] Failed at PDO::prepared in QueryBuilder->selectQueryAll(): ".$e->getMessage();
        }
        $query->execute();
        $query->setFetchMode(PDO::FETCH_ASSOC);
        return $query;
    }

    public function selectQuery($table, $parameter){
        $queryString = "select * from $table where ";
        $count = 0;
        foreach($parameter as $key=>$value){
            if($count == 0){
                $queryString = $queryString . "$key=$value";
            }
            else{
                $queryString += $queryString . " AND $key=$value";
            }
            $count++;
        }
        $query = $this->pdo->prepare($queryString);
        $query->execute();
        $query->setFetchMode(PDO::FETCH_ASSOC);
        return $query->fetchALL();
    }
    
    public function insertQuery($table, $parameter){
        $queryString = sprintf(
            'insert into %s(%s) values(%s)',
            $table, 
            implode(', ', array_keys($parameter)),
            ':'.implode(', :', array_keys($parameter))
        );

        try{
            $query = $this->pdo->prepare($queryString);
            $query->execute($parameter);
        }catch(Exception $e){
            echo "[QueryBuilder.php] Failed at PDO::prepared in QueryBuilder: ".$e->getMessage();
        }
    }

    public function updateQuery($table, $parameter){
        $queryString = "update $table set ";
        $count = 0;
        foreach($parameter as $key=>$value){
            if($key != 'id'){
                if($count == 1){
                    $queryString = $queryString . "$key='$value'";
                }
                else{
                    $queryString = $queryString . ", $key='$value'";
                }
            }
            $count++;
        }
        $id = $parameter['id'];
        $queryString = $queryString . " where id=$id";
        //die(var_dump($queryString));
        try{
            $query = $this->pdo->prepare($queryString);
            $query->execute();
        }catch(Exception $e){
            echo "[QueryBuilder.php] Failed at PDO::prepared Update in QueryBuilder: ".$e->getMessage();
        }
    }    

    public function deleteQuery($table, $parameter){
        $queryString = sprintf(
            'delete from %s where %s=%s',
            $table, 
            implode(', ', array_keys($parameter)),
            ':'.implode(', :', array_keys($parameter))
        );

        try{
            $query = $this->pdo->prepare($queryString);
            $query->execute($parameter);
        }catch(Exception $e){
            echo "[QueryBuilder.php] Failed at PDO::prepared in QueryBuilder: ".$e->getMessage();
        }
    }
}