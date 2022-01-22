<?php

namespace App\Models;

use App\Core\AppConfig;
use App\Core\Databases\DBConnection;

use Exception;
use PDOException;
use PDO;
use stdClass;

class OrderModel{
    public $id;
    public $customerId;
    public $employeeId;
    public $branchId;
    public $startDate;
    public $orderStatus;
    public $payMethod;
    public $totalCost;

    public function __construct($id, $customerId, $employeeId, $branchId, $startDate, $orderStatus, $payMethod, $totalCost)
    {
        $this->id = $id;
        $this->customerId = $customerId;
        $this->employeeId = $employeeId;
        $this->branchId = $branchId;
        $this->startDate = $startDate;
        $this->orderStatus = $orderStatus;
        $this->payMethod = $payMethod;
        $this->totalCost = $totalCost;
    }
}