/* IT StoreProcedure */
use IT;

/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* 
 * EXERCISE 3: 2 STORE PROCEDURE FOR SELECT 
 * 
 * */

/*  Đ.Thịnh   */
/* StoreProcedure Select 1: Truy xuất tất cả thông tin về các Accessories và Product đã nhập */
DROP PROCEDURE if exists CreateAllItemInfoTable;
Delimiter $$
CREATE Procedure CreateAllItemInfoTable()
BEGIN
	Drop Temporary Table If exists AllItemInfo;
	CREATE Temporary Table AllItemInfo(
		IndexId Int,
		ItemType Varchar(20),
		SalePrice Int, 
		Name Varchar(20),
		FunctionType Varchar(20),
		Manufacturer Varchar(20),
		OrderId Int
	);

	Insert Into AllItemInfo (IndexId, ItemType, SalePrice, Name, FunctionType, Manufacturer, OrderId)
	SELECT a.IndexId, ItemType, SalePrice, at2.Name, FunctionType, m.Name as Manufacturer, i.OrderId as OrderId
	from ITEM i, ACCESSORIES a, ACCESSORIES_TYPE at2, MANUFACTURE m 
	WHERE i.IndexId = a.IndexId AND a.AccessoriesTypeID = at2.Id AND ItemType = 'Accessories' AND at2.ManufactureId = m.Id;

	Insert Into AllItemInfo (IndexId, ItemType, SalePrice, Name, FunctionType, Manufacturer, OrderId)
	SELECT p.IndexId, ItemType, SalePrice, pt.Name, FunctionType, m.Name as Manufacturer, i.OrderId as OrderId
	from ITEM i, PRODUCT p , PRODUCT_TYPE pt, MANUFACTURE m 
	WHERE i.IndexId = p.IndexId AND p.ProductTypeId = pt.Id AND ItemType = 'Product' AND pt.ManufactureId = m.Id;

END$$
Delimiter ;

-- CALL CreateAllItemInfoTable();
-- SELECT * from AllItemInfo;

/*  Đ.Thịnh   */
/* StoreProcedure Select 2: Liệt kê danh sách tất cả Accessories Type/ Product Type và đếm TotalNumber LeftNumber của mối loại  */
DROP PROCEDURE if exists CreateAllTypeInfoTable;
Delimiter $$
CREATE Procedure CreateAllTypeInfoTable()
BEGIN
	Declare	_IndexId Int;
	Declare	_ItemType Varchar(20);
	Declare	_SalePrice Int;
	Declare	_Name Varchar(20);
	Declare	_FunctionType Varchar(20);
	Declare	_Manufacturer Varchar(20);
	Declare	_OrderId Int;

	DECLARE endLoop INT DEFAULT FALSE;
	Declare ItemCursor CURSOR For SELECT * FROM AllItemInfo;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET endLoop = TRUE;	

	Drop Temporary Table If Exists AllTypeInfo;
	CREATE Temporary Table AllTypeInfo(
		ItemType Varchar(20),
		TypeId int,
		Name Varchar(20),
		FunctionType Varchar(20),
		Manufacturer Varchar(20),
		TotalNumber Int,
		LeftNumber Int
	);
	CALL CreateAllItemInfoTable();

	-- Insert Into AllTypeInfo
	-- SELECT ItemType, Name, FunctionType, Manufacturer, Count(*) as TotalNumber, 0 as LeftNumber 
	-- From AllItemInfo
	-- GROUP BY ItemType, Name, FunctionType, Manufacturer;

	Insert Into AllTypeInfo
	SELECT "Product", pt.Id, pt.Name, FunctionType, m.Name as Manufacturer, 0 as TotalNumber, 0 as LeftNumber
	From PRODUCT_TYPE pt, MANUFACTURE m 
	WHERE pt.ManufactureId = m.Id;
	
	Insert Into AllTypeInfo
	SELECT "Accessories", at1.Id, at1.Name, FunctionType, m.Name as Manufacturer, 0 as TotalNumber, 0 as LeftNumber
	From ACCESSORIES_TYPE  at1, MANUFACTURE m 
	WHERE at1.ManufactureId = m.Id;
	

	Open ItemCursor;
	labelStart: LOOP	
		Fetch ItemCursor Into _IndexId, _ItemType, _SalePrice, _Name, _FunctionType, _Manufacturer, _OrderId;
		if endLoop then 
			LEAVE labelStart;
		end if;
		If _OrderId is null then
			UPDATE AllTypeInfo Set LeftNumber = LeftNumber + 1 where ItemType = _ItemType AND Name = _Name AND Manufacturer = _Manufacturer AND FunctionType = _FunctionType;
		end if;
		UPDATE AllTypeInfo Set TotalNumber = TotalNumber + 1 where ItemType = _ItemType AND Name = _Name AND Manufacturer = _Manufacturer AND FunctionType = _FunctionType;
	END LOOP;
	Close ItemCursor;
END$$
Delimiter ;

-- CALL CreateAllTypeInfoTable(); 
-- Select * from AllTypeInfo;


/* Người làm Customer dùng để Search lấy các Accessories theo loại đã nhập */
/* StoreProcedure Select 3: Truy xuất tất cả thông tin về các Accessories theo loại đã nhập */
DROP PROCEDURE if exists GetAccessoriesByType;
Delimiter $$
CREATE Procedure GetAccessoriesByType(in _FunctionType varchar(20))
BEGIN
	CREATE Temporary Table AccessoriesByTypeInfo(
		IndexId Int,
		SalePrice Int, 
		Name Varchar(20),
		FunctionType Varchar(20),
		Manufacturer Varchar(20),
		OrderId Int
	);
	CALL CreateAllItemInfoTable();
	Insert into AccessoriesByTypeInfo
	Select IndexId, SalePrice, Name, FunctionType, Manufacturer, OrderId From AllItemInfo Where FunctionType=_FunctionType AND ItemType="Accessories";
	SELECT * from AccessoriesByTypeInfo;
	Drop Temporary Table if exists AccessoriesByTypeInfo;
END$$
Delimiter ;

/* Người làm Customer dùng để Search lấy các Product theo loại đã nhập */
/* StoreProcedure Select 4: Truy xuất tất cả thông tin về các Product theo loại đã nhập */
DROP PROCEDURE if exists GetProductByType;
Delimiter $$
CREATE Procedure GetProductByType(in _FunctionType varchar(20))
BEGIN
	CREATE Temporary Table ProductByTypeInfo(
		IndexId Int,
		SalePrice Int, 
		Name Varchar(20),
		FunctionType Varchar(20),
		Manufacturer Varchar(20),
		OrderId Int
	);
	CALL CreateAllItemInfoTable();
	Insert into ProductByTypeInfo
	Select IndexId, SalePrice, Name, FunctionType, Manufacturer, OrderId From AllItemInfo Where FunctionType=_FunctionType AND ItemType="Product";
	SELECT * from ProductByTypeInfo;
	Drop Temporary Table if exists ProductByTypeInfo;
END$$
Delimiter ;

/*  Cho người làm Customer   */
/* StoreProcedure Select 5: Truy xuất thông tin tất cả item đang có trong giỏ hàng */
DROP PROCEDURE if exists GetOrderDetailInfo;
Delimiter $$
Create Procedure GetOrderDetailInfo(in _OrderId int)
BEGIN 
	Drop Temporary Table If exists OrderDetail;
	CREATE Temporary Table OrderDetail(
		IndexId Int,
		ItemType Varchar(20),
		SalePrice Int, 
		Name Varchar(20),
		FunctionType Varchar(20),
		Manufacturer Varchar(20),
		OrderId Int
	);
	CALL CreateAllItemInfoTable();
	INSERT Into OrderDetail
	Select IndexId, ItemType, SalePrice, Name, FunctionType, Manufacturer, OrderId From AllItemInfo Where OrderId = _OrderId;
	Select * from OrderDetail;
	Drop Temporary Table OrderDetail;
END$$
Delimiter ;

/* StoreProcedure Select 6: Trả về danh sách customer có email chứa chuỗi tìm kiếm */
DROP PROCEDURE if exists CustomerSearchByEmail;
Delimiter $$
Create Procedure CustomerSearchByEmail(in searchString varchar(40))
BEGIN
	Drop Temporary Table If exists CustomerQueries;
	CREATE Temporary Table CustomerQueries(
		Id int,
		Fullname varchar(20),
		Email varchar(40),
		Balance int
	);
	INSERT into CustomerQueries
	SELECT Id, Fullname, Email, Balance FROM CUSTOMER WHERE Email LIKE CONCAT('%', searchString, '%');
	SELECT * from CustomerQueries;
	DROP Temporary Table CustomerQueries;
END$$
Delimiter ;

call CustomerSearchByEmail('hdthinh01@gmail.com');

/*Lấy thông tin tất cả khách hàng*/
DROP PROCEDURE if exists CustomerSearchAll;
Delimiter $$
Create Procedure CustomerSearchAll()
BEGIN
	SELECT * FROM CUSTOMER;
END$$
Delimiter ;

call CustomerSearchAll();

/* StoreProcedure Select 7: Trả về danh sách các Items theo tên (Field Name) đã nhập */
DROP Procedure if exists SearchItemsByName;
Delimiter $$
CREATE Procedure searchItemsByName(
	in searchString varchar(40)
)
BEGIN
	CALL CreateAllItemInfoTable();
	SELECT * From AllItemInfo where Name LIKE CONCAT('%', searchString, '%');
END$$
Delimiter ;

-- CALL searchItemsByName(:searchString); 


/* StoreProcedure Select 8: Trả về danh sách các Types theo tên (Field Name) đã nhập */

DROP Procedure if exists SearchTypesByName;
Delimiter $$
CREATE Procedure searchTypesByName(
	in searchString varchar(40)
)
BEGIN
	CALL CreateAllTypeInfoTable();
	SELECT * From AllTypeInfo where Name LIKE CONCAT('%', searchString, '%');
END$$
Delimiter ;

-- CALL searchTypesByName(:searchString); 


-- CALL CustomerSearchByEmail(:searchString); 

/* 
 * EXERCISE 1: 1 STORE PROCEDURE FOR INSERT 
 * 
 * */

/* Store Procedure Insert 1: Insert Customer, checking email exists (Cho người làm UI login register) */
DROP PROCEDURE if exists InsertCustomerAccount;
Delimiter $$
CREATE Procedure InsertCustomerAccount(
	in _Password varchar(15),
    in _Address varchar(30),
    in _Fullname varchar(30),
    in _Email varchar(40),
    in _Balance int
)
BEGIN
	declare v_count_email int;
	SELECT count(*) into v_count_email from CUSTOMER c WHERE c.Email = _Email;
	if v_count_email != 0 then
		Signal sqlstate '45000' set message_text = 'Email has been used';
	else
		INSERT INTO CUSTOMER SET
			Password = _Password,
			Address = _Address,
			Fullname = _Fullname,
			Email = _Email,
			Balance = _Balance;
		Select * from customer where Email = _Email;
	end if;
END$$
Delimiter ;

call InsertCustomerAccount('123456', 'HCM', 'Thinh Nguyen', 'thinhnguyen@gmail.com', '100000');

/* StoreProcedure Insert 2: Add AccessoriesType, ProductType (Đ.Thịnh: trang Employee) */
DROP PROCEDURE if exists InsertAccessoriesType;
Delimiter $$
Create Procedure InsertAccessoriesType(
	in _Name VarChar(20),
	in _FunctionType Varchar(20),
	in _ManufactureId int
)
BEGIN
	Declare v_count_manufacture int;
	Select count(*) into v_count_manufacture from MANUFACTURE m where Id = _ManufactureId;
	if v_count_manufacture = 1 then
		Insert Into ACCESSORIES_TYPE Set Name=_Name, FunctionType=_FunctionType, ManufactureId = _ManufactureId;
	else
		Signal Sqlstate '45000' set message_text = 'Manufacture Id not found';
	end if;
END$$
Delimiter ;

DROP PROCEDURE if exists InsertProductType;
Delimiter $$
Create Procedure InsertProductType(
	in _Name VarChar(20),
	in _FunctionType Varchar(20),
	in _ManufactureId int,
	in _ScreenSize int,
	in _Processor Varchar(20),
	in _MemoryGB int
)
BEGIN
	Declare v_count_manufacture int;
	Select count(*) into v_count_manufacture from MANUFACTURE m where Id = _ManufactureId;
	if v_count_manufacture = 1 then
		Insert Into PRODUCT_TYPE Set Name=_Name, FunctionType=_FunctionType, ManufactureId=_ManufactureId, ScreenSize=_ScreenSize, Processsor=_Processor, MemoryGB = _MemoryGB;
	else
		Signal Sqlstate '45000' set message_text = 'Manufacture Id not found';
	end if;
END$$
Delimiter ;

/* StoreProcedure Insert 3: Add Accessories, Product (Đ.Thịnh: trang Employee) */
DROP PROCEDURE if exists InsertItems;
Delimiter $$
Create Procedure InsertItems(
	in _ItemType Varchar(20),
	in _TypeId int, 
	in _SalePrice int,
	in _ImportPrice int,
	in _BranchId int,
	in _Quantity int
)
BEGIN
	Declare v_count_item_type int;
	Declare loopCounter int default 0;
	if _ItemType = "Accessories" then
		Select count(*) into v_count_item_type from ACCESSORIES_TYPE where Id = _TypeId;
		if v_count_item_type != 1 then
			Signal Sqlstate '45000' set message_text = 'Accessories Type Id not found';
		end if;
		While loopCounter < _Quantity do
			Insert Into ACCESSORIES set AccessoriesTypeId = _TypeId, SalePrice = _SalePrice, ImportPrice = _ImportPrice, BranchId = _BranchId;
			Set loopCounter = loopCounter + 1;
		END While;
	
	elseif _ItemType = "Product" then
		Select count(*) into v_count_item_type from PRODUCT_TYPE where Id = _TypeId;
		if v_count_item_type != 1 then
			Signal Sqlstate '45000' set message_text = 'Product Type Id not found';
		end if;
		While loopCounter < _Quantity do
			Insert Into PRODUCT set ProductTypeId = _TypeId, SalePrice = _SalePrice, ImportPrice = _ImportPrice, BranchId = _BranchId;
			Set loopCounter = loopCounter + 1;
		END While;
	end if;
END$$
Delimiter ;

/* Store Procedure Insert 4: Insert Employee, checking email exists (Cho người làm UI login register) */
DROP PROCEDURE if exists InsertEmployeeAccount;
Delimiter $$
CREATE Procedure InsertEmployeeAccount(
	in _Password varchar(15),
    in _ManagerId varchar(30),
    in _Fullname varchar(30),
    in _Email varchar(40),
    in _Salary int,
    in _BranchId int
)
BEGIN
	declare v_count_email int;
	SELECT count(*) into v_count_email from EMPLOYEE e WHERE e.Email = _Email;
	if v_count_email != 0 then
		Signal sqlstate '45000' set message_text = 'Email has been used';
	else
		INSERT INTO EMPLOYEE SET
			Password = _Password,
			ManagerId = _ManagerId,
			Fullname = _Fullname,
			Email = _Email,
			Salary = _Salary,
			BranchId = _BranchId;
	end if;
END$$
Delimiter ;


/*Store Procedure Insert 5: Insert Order,                    (Cho người làm trang Customer) */


/* 
 * ADDITONAL EXERCISE FOR UPDATE 
 * 
 * */

/* StoreProcedure Update 1: Update Employee Salary */

DROP procedure if exists Update_Sal;
Delimiter $$
CREATE procedure Update_Sal(
	in Id int, 
	in Factor numeric(3,2)
)
BEGIN
	declare v_count int;
	select count(*) into v_count from EMPLOYEE e WHERE e.Id = Id;
	if (v_count = 1) then
		UPDATE EMPLOYEE e
		SET e.Salary = e.Salary * Factor
		WHERE e.Id = Id;
	end if;
END$$
Delimiter ;


/*  StoreProcedure Update 2: Add Item To Order */
DROP Procedure if exists AddItemToOrder;
Delimiter $$
CREATE Procedure AddItemToOrder(
	in _IndexId int,
	in _OrderId int,
	in _ItemType varchar(20)
)
BEGIN 
	declare _OrderStatus bool;
	declare v_count int;
	select OrderStatus into _OrderStatus from ORDERS where Id = _OrderId;
	if _OrderStatus = false then
		select count(*) into v_count from ITEM i where i.IndexId = _IndexId and ItemType = _ItemType;
		if v_count = 1 then
		 UPDATE ITEM SET OrderId = _OrderId where IndexId = _IndexId and ItemType = _ItemType ;
		end if;
	else
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order has been accepted, cannot modify order items';
	end if;
END$$
Delimiter ;

/* StoreProcedure Update 3: Remove Item From Order */
DROP Procedure if exists RemoveItemFromOrder;
Delimiter $$
CREATE Procedure RemoveItemFromOrder(
	in _IndexId int,
	in _ItemType varchar(20)
)
BEGIN 
	declare _OrderStatus bool;
	declare v_count int;
	select o.OrderStatus into _OrderStatus from ORDERS o, ITEM i where i.OrderId = o.Id AND i.IndexId = _IndexId AND i.ItemType = _ItemType;
	if _OrderStatus = false then
		select count(*) into v_count from ITEM i where i.IndexId = _IndexId and ItemType = _ItemType;
		if v_count = 1 then
		 UPDATE ITEM SET OrderId = null where IndexId = _IndexId and ItemType = _ItemType ;
		end if;
	else
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order has been accepted, cannot modify order items';
	end if;
END$$
Delimiter ;

/* StoreProcedure Update 4: Confirm Customer Order, Set Status Order To 1 */
DROP PROCEDURE if exists ConfirmOrder;
Delimiter $$
CREATE Procedure ConfirmOrder(
	in _OrderId int
)
BEGIN 
	declare v_count int;
	declare _OrderStatus bool;
	select count(*) into v_count from ORDERS where Id = _OrderId;
	if v_count = 1 then
		select OrderStatus into _OrderStatus from ORDERS where Id = _OrderId;
		if _OrderStatus = false then
	 		UPDATE ORDERS SET OrderStatus = true where Id = _OrderId;
	 	else 
	 		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order has been accepted';
	 	end if;
	else
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order Id not found';
	end if;
END$$
Delimiter ;

/* StoreProcedure Update 5: Assign Order To Employee */
DROP PROCEDURE if exists AssignOrderToEmployee;
Delimiter $$
CREATE Procedure AssignOrderToEmployee(
	in _OrderId int,
	in _EmployeeId int
)
BEGIN
	declare v_count_order int;
	declare v_count_employee int;
	select count(*) into v_count_order from ORDERS where Id = _OrderId;
	select count(*) into v_count_employee from EMPLOYEE e where e.Id = _EmployeeId;
	if v_count_order = 1 AND v_count_employee = 1 then 
		UPDATE ORDERS SET EmployeeId = _EmployeeId WHERE Id = _OrderId;
	else
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order Id or Employee Id not found';
	end if;
END$$
Delimiter ;


/* Store Procedure Update 6: Update Customer Info */
DROP PROCEDURE if exists UpdateCustomerAccount;
Delimiter $$
CREATE PROCEDURE UpdateCustomerAccount(
	in _Id int,
	in _Password varchar(15),
    in _Address varchar(30),
    in _Fullname varchar(30)
)
BEGIN    
    declare v_count_customer int;
   	SELECT count(*) into v_count_customer from CUSTOMER c Where c.Id = _Id;
    if v_count_customer != 1 then 
    	Signal sqlstate '45000' set message_text = 'Account not exist for editing';
    else
    	UPDATE CUSTOMER SET 
    		Password = _Password,
    		Address = _Address,
    		Fullname = _Fullname
    	WHERE Id = _Id;
    end if;
END$$
Delimiter ;

/* Store Procedure Update 6: Update Employee Info */
DROP PROCEDURE if exists UpdateEmployeeAccount;
Delimiter $$
CREATE PROCEDURE UpdateEmployeeAccount(
	in _Id int,
	in _Password varchar(15),
    in _Fullname varchar(30),
    in _ManagerId int,
    in _BranchId int
)
BEGIN    
    declare v_count_employee int;
    declare v_count_manager int;
   	declare v_count_branch int;
   	SELECT count(*) into v_count_employee from EMPLOYEE e Where e.Id = _Id;
    SELECT count(*) into v_count_manager from EMPLOYEE e Where e.Id = _ManagerId;
    SELECT count(*) into v_count_branch from BRANCH b Where b.Id = _BranchId;
    if v_count_employee != 1 then 
    	Signal sqlstate '45000' set message_text = 'Account not exist for editing';
    end if;
    if v_count_manager != 1 AND _ManagerId is not null then 
    	Signal sqlstate '45000' set message_text = 'Manager Id not exist';
    end if;
    if v_count_branch != 1 then 
    	Signal sqlstate '45000' set message_text = 'Branch Id not exist';
    end if;
	UPDATE EMPLOYEE SET 
		Password = _Password,
		Fullname = _Fullname,
		ManagerId = _ManagerId,
		BranchId = _BranchId
	WHERE Id = _Id;
END$$
Delimiter ;

-- CALL UpdateEmployeeAccount(:_Id, :_Password, :_Fullname, :_ManagerId, :_BranchId);

/* Store Procedure Update 7: Update Customer Balance */
DROP Procedure if exists UpdateCustomerBalance;
Delimiter $$
CREATE Procedure UpdateCustomerBalance(
	in _CustomerId int,
	in _Email varchar(40),
	in _BalanceChanged int
)
BEGIN
	declare v_count_customer int;
	if _BalanceChanged <= 0 then
		Signal sqlstate '45000' set message_text = 'Balance changed must be positive amount';
	end if;
	select count(*) into v_count_customer from CUSTOMER c where c.Id = _CustomerId or c.Email = _Email;
	if v_count_customer < 1 then
		Signal sqlstate '45000' set message_text = 'Customer account not exist for editing';
	else
		UPDATE CUSTOMER set Balance = Balance + _BalanceChanged where Id = _CustomerId or Email = _Email;
	end if;
END$$
Delimiter ;

-- CALL UpdateCustomerBalance(:_CustomerId, :_Email, :_BalanceChanged); 


/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
-- Thêm tài xế

drop procedure if exists InsertDriver;

delimiter $$

create procedure InsertDriver(
	in _id int,
	in fullname varchar(30),
    in _vehicleId int,
	in weight int
)
begin
	insert into VEHICLE values (_vehicleId, weight);
    insert into DRIVER values (_id, fullname, _vehicleId);
    select * from (select * from driver where vehicleId = _vehicleId) as D, (select Weight from vehicle where id = _vehicleId) as V;
end $$

delimiter ;

call InsertDriver('1', 'Binz', '1', '10');

/*Lấy thông tin tất cả tài xế*/
DROP PROCEDURE if exists DriverSearchAll;
Delimiter $$
Create Procedure DriverSearchAll()
BEGIN
	SELECT * FROM DRIVER;
END$$
Delimiter ;

call DriverSearchAll();

/*Lấy thông tin tài xế và phương tiện tương ứng*/
DROP PROCEDURE if exists DriverVehicleSearchAll;
Delimiter $$
Create Procedure DriverVehicleSearchAll()
BEGIN
	SELECT D.Id, Fullname, VehicleId, Weight
    FROM DRIVER D, VEHICLE V
    WHERE D.VehicleId = V.Id
    ORDER BY D.Id;
END$$
Delimiter ;

call DriverVehicleSearchAll();

/*Xóa tài xế và phương tiện tương ứng*/
DROP PROCEDURE if exists DeleteDriver;
Delimiter $$
Create Procedure DeleteDriver(_id int)
BEGIN
	if _id <= 0 then
		Signal sqlstate '45000' set message_text = 'Invalid Driver';
    end if;
	delete from vehicle where id = _id;
END$$
Delimiter ;

call DeleteDriver(11);

/*Cập nhật thông tên tài xế*/
DROP PROCEDURE if exists UpdateDriver;
Delimiter $$
Create Procedure UpdateDriver(
	in _id int,
	in _fullname varchar(30)
)
BEGIN
	if _id <= 0 then
		Signal sqlstate '45000' set message_text = 'Invalid Driver';
    end if;
	update driver set fullname = _fullname where id = _id;
END$$
Delimiter ;

call UpdateDriver(1, 'Binzz');


/*Lấy thông tin và số lượng đơn hàng của các tài xế có đơn hàng trong một ngày cụ thể*/
DROP PROCEDURE if exists Info_And_Count_Driver_Container_Within_Day;
Delimiter $$
Create Procedure Info_And_Count_Driver_Container_Within_Day(
	_date date
)
BEGIN
	declare _count int;
    DROP Temporary Table if exists Result;
    CREATE Temporary Table Result(
		Id int,
        Fullname varchar(30),
        CountOrders int
	);
	Insert into Result
		SELECT D.Id, Fullname, Count(*) as CountOrders
		FROM Container C, Driver D
		WHERE D.Id = C.DriverId and C.PackageDate = _date
		GROUP BY D.Id
		HAVING CountOrders > 0;
	select count(*) into _count from Result;
	if _count < 1 then
		DROP Temporary Table Result;
		Signal sqlstate '45000' set message_text = 'No drivers have orders for this day';
	end if;
    Select * from Result;
    DROP Temporary Table Result;
END$$
Delimiter ;

call Info_And_Count_Driver_Container_Within_Day('2021-11-11');