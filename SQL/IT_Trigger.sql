/* TRIGGER BTL */

use IT;


/*  Đ.Thịnh   */
/* Trigger 0: Tạo Index Id Autoincrement cho Product và Accessories thông qua một bảng phụ và trigger */
DROP Trigger if exists Auto_Increment_Accessories_Index_Id;
Delimiter $$
CREATE Trigger Auto_Increment_Accessories_Index_Id
BEFORE
INSERT
ON ACCESSORIES
FOR EACH ROW 
BEGIN
	INSERT INTO ACCESSORIES_INDEX_ID_TABLE VALUES(null);
	SET NEW.IndexId = LAST_INSERT_ID(); 
END$$
Delimiter ;

DROP Trigger if exists Auto_Increment_Product_Index_Id;
Delimiter $$
CREATE Trigger Auto_Increment_Product_Index_Id
BEFORE
INSERT
ON PRODUCT
FOR EACH ROW 
BEGIN
	INSERT INTO PRODUCT_INDEX_ID_TABLE VALUES(null);
	SET NEW.IndexId = LAST_INSERT_ID(); 
END$$
Delimiter ;

/*
 * EX 2: 2 TRIGGER FOR INSERT/UPDATE/DELETE
 * 
 * Note: At least one trigger update other table than the triggered one
 * 
 * */


/* Trigger 1: Add Accessories cụ thể thì add vô luôn Item Key:(TypeId, IndexId, Type)  
 * */
DROP Trigger if exists Add_Item_On_Insert_Accessories;
Delimiter $$
CREATE TRIGGER Add_Item_On_Insert_Accessories
AFTER
INSERT 
ON ACCESSORIES
FOR EACH ROW 
BEGIN 
	DECLARE v_count INT;
	SET v_count = (SELECT Count(*) FROM ITEM WHERE TypeId=NEW.AccessoriesTypeId AND IndexId=NEW.IndexId AND ItemType="Accessories");
	IF v_count != 0 THEN 
		SIGNAL SQLSTATE '45000' SET message_text = "Exist an item with the same primary key"; 
	END IF;
	INSERT INTO ITEM (TypeId, IndexId, OrderId, ItemType) VALUES (NEW.AccessoriesTypeId, NEW.IndexId, null, "Accessories");
END$$
Delimiter ;

/* Trigger 2: Xóa Accessories cụ thể thì xóa luôn Item 
 * */
DROP Trigger if exists Remove_Item_On_Delete_Accessories;
Delimiter $$
CREATE TRIGGER Remove_Item_On_Delete_Accessories
AFTER
DELETE 
ON ACCESSORIES
FOR EACH ROW 
BEGIN 
	DELETE FROM ITEM WHERE TypeId = OLD.AccessoriesTypeId AND IndexId = OLD.IndexId AND ItemType = "Accessories";
END$$
Delimiter ;

/* Trigger 3: Add Product cụ thể thì add vô luôn Item Key:(TypeId, IndexId, Type)  
 * */
DROP Trigger if exists Add_Item_On_Insert_Product;
Delimiter $$
CREATE TRIGGER Add_Item_On_Insert_Product
AFTER
INSERT 
ON PRODUCT
FOR EACH ROW 
BEGIN 
	DECLARE v_count INT;
	SET v_count = (SELECT Count(*) FROM ITEM WHERE TypeId=NEW.ProductTypeId AND IndexId=NEW.IndexId AND ItemType="Product");
	IF v_count != 0 THEN 
		SIGNAL SQLSTATE '45000' SET message_text = "Exist an item with the same primary key"; 
	END IF;
	INSERT INTO ITEM (TypeId, IndexId, OrderId, ItemType) VALUES (NEW.ProductTypeId, NEW.IndexId, null, "Product");
END$$
Delimiter ;

/* Trigger 4: Xóa Product cụ thể thì xóa luôn Item 
 * */
DROP Trigger if exists Remove_Item_On_Delete_Product;
Delimiter $$
CREATE TRIGGER Remove_Item_On_Delete_Product
AFTER
DELETE 
ON PRODUCT
FOR EACH ROW 
BEGIN 
	DELETE FROM ITEM WHERE TypeId = OLD.ProductTypeId AND IndexId = OLD.IndexId AND ItemType = "Product";
END; 
Delimiter ;

delete from product where productTypeId = 1;

/* Trigger 5: Accessories Giá bán phải lớn hơn giá nhập (Insert Update) 
 * */
DROP Trigger if exists Sale_Price_Higher_Than_Import_Price_Accessories_On_Insert;
Delimiter $$
CREATE Trigger Sale_Price_Higher_Than_Import_Price_Accessories_On_Insert
BEFORE
INSERT 
ON ACCESSORIES
FOR EACH ROW 
BEGIN 
	IF NEW.SalePrice <= NEW.ImportPrice THEN 
		SIGNAL SQLSTATE '45000' SET message_text = "Sale price must be larger then import price";
	END IF;
END;
Delimiter ;

DROP Trigger if exists Sale_Price_Higher_Than_Import_Price_Accessories_On_Update;
Delimiter $$
CREATE Trigger Sale_Price_Higher_Than_Import_Price_Accessories_On_Update
BEFORE
UPDATE 
ON ACCESSORIES
FOR EACH ROW 
BEGIN 
	IF !(OLD.SalePrice <=> NEW.SalePrice AND OLD.ImportPrice <=> NEW.ImportPrice) THEN
		IF NEW.SalePrice <= NEW.ImportPrice THEN 
			SIGNAL SQLSTATE '45000' SET message_text = "Sale price must be larger then import price";
		END IF;
	END IF;
END$$
Delimiter ;

/* Trigger 6: Product Giá bán phải lớn hơn giá nhập (Insert Update) 
 * */
DROP Trigger if exists Sale_Price_Higher_Than_Import_Price_Product_On_Insert;
Delimiter $$
CREATE Trigger Sale_Price_Higher_Than_Import_Price_Product_On_Insert
BEFORE
INSERT 
ON PRODUCT
FOR EACH ROW 
BEGIN 
	IF NEW.SalePrice <= NEW.ImportPrice THEN 
		SIGNAL SQLSTATE '45000' SET message_text = "Sale price must be larger then import price";
	END IF;
END$$
Delimiter ;

DROP Trigger if exists Sale_Price_Higher_Than_Import_Price_Product_On_Update;
Delimiter $$
CREATE Trigger Sale_Price_Higher_Than_Import_Price_Product_On_Update
BEFORE
UPDATE 
ON PRODUCT
FOR EACH ROW 
BEGIN 
	IF !(OLD.SalePrice <=> NEW.SalePrice AND OLD.ImportPrice <=> NEW.ImportPrice) THEN
		IF NEW.SalePrice <= NEW.ImportPrice THEN 
			SIGNAL SQLSTATE '45000' SET message_text = "Sale price must be larger then import price";
		END IF;
	END IF;
END$$
Delimiter ;

/* Trigger 7: Lương nhân viên chỉ được update tăng
 * */
DROP Trigger if exists Employee_Salary_Must_Increase_On_Update;
Delimiter $$
CREATE Trigger Employee_Salary_Must_Increase_On_Update
Before 
UPDATE 
ON EMPLOYEE 
FOR EACH ROW 
BEGIN 
	IF !(OLD.Salary <=> NEW.Salary) THEN
		IF NEW.Salary <= OLD.Salary THEN 
			SIGNAL SQLSTATE '45000' SET message_text = "Salary updates must be increase update";
		END IF;
	END IF;
END$$
Delimiter ;

Update employee set salary = 30000 where id = 1;

/* Trigger 8: Chi nhánh của Order phải trùng với chi nhánh của nhân viên quản lý Order (Insert, Update)
 * */
DROP Trigger if exists Order_Branch_Id_Match_Employee_Branch_Id_On_Insert;
Delimiter $$
CREATE Trigger Order_Branch_Id_Match_Employee_Branch_Id_On_Insert
Before
INSERT 
ON ORDERS
FOR EACH ROW 
BEGIN 
	DECLARE EmployeeId Int;
	DECLARE EmployeeBranchId Int;
	DECLARE OrderBranchId Int;
	SET EmployeeId = NEW.EmployeeId;
	SET OrderBranchId = NEW.BranchId;

	
	SELECT BranchId INTO EmployeeBranchId FROM EMPLOYEE e WHERE e.Id = EmployeeId;
	if EmployeeBranchId != OrderBranchId then 
		SIGNAL SQLSTATE '45000' SET message_text = "Order BranchId must match its Employee BranchId";
	end if;
END$$
Delimiter ;

DROP Trigger if exists Order_Branch_Id_Match_Employee_Branch_Id_On_Update_EmployeeId;
Delimiter $$
CREATE Trigger Order_Branch_Id_Match_Employee_Branch_Id_On_Update_EmployeeId
Before
UPDATE 
ON ORDERS
FOR EACH ROW 
BEGIN 
	DECLARE EmployeeId Int;
	DECLARE EmployeeBranchId Int;
	DECLARE OrderBranchId Int;
	SET EmployeeId = NEW.EmployeeId;
	SET OrderBranchId = NEW.BranchId;

	IF !(OLD.EmployeeId <=> NEW.EmployeeId) THEN
		SELECT BranchId INTO EmployeeBranchId FROM EMPLOYEE e WHERE e.Id = EmployeeId;
		if EmployeeBranchId != OrderBranchId then 
			SIGNAL SQLSTATE '45000' SET message_text = "Order BranchId must match its Employee BranchId";
		end if;
	END IF;
END$$
Delimiter ;

/*  Đ.Thịnh   */
/**
 * Trigger 9: Cập nhật Total Cost của một khi một Accessories/Product update foreignKey trỏ về/ra khỏi Order đó             
 * 
 * Không cho đổi trực tiếp một Item từ order này sang order khác
 */
DROP Trigger if exists Update_Order_Total_Cost_On_Item_OrderId_Change;
Delimiter $$
CREATE Trigger Update_Order_Total_Cost_On_Item_OrderId_Change
AFTER
UPDATE 
ON ITEM
FOR EACH ROW 
BEGIN 
	DECLARE ItemPrice Int;
	DECLARE ItemTypeId Int;
	DECLARE ItemIndexId Int;
	DECLARE ItemType Varchar(20);
	SET ItemTypeId = NEW.TypeId;
	SET ItemIndexId = NEW.IndexId;
	SET ItemType = NEW.ItemType;

	IF !(OLD.OrderId <=> NEW.OrderId) THEN

		IF NEW.ItemType = 'Accessories' THEN
			SELECT SalePrice INTO ItemPrice FROM ACCESSORIES a where a.AccessoriesTypeID=ItemTypeId AND a.IndexId=ItemIndexId;
		ELSEIF NEW.ItemType = 'Product' THEN
			SELECT SalePrice INTO ItemPrice FROM PRODUCT p where p.ProductTypeId=ItemTypeId AND p.IndexId=ItemIndexId;
		ELSE 
			SIGNAL SQLSTATE '45000' SET message_text = "Invalid Item Type";
		END IF;
	
		IF OLD.OrderId IS NULL AND NEW.OrderId IS NOT NULL THEN 
			UPDATE ORDERS SET TotalCost = TotalCost + ItemPrice WHERE Id = NEW.OrderId;
		ELSEIF OLD.OrderId IS NOT NULL AND NEW.OrderId IS NULL THEN
			UPDATE ORDERS SET TotalCost = TotalCost - ItemPrice WHERE Id = OLD.OrderId;
		ELSE
			SIGNAL SQLSTATE '45000' SET message_text = "Item Order ID Only set from null to value or inverse";
		END IF;

	END IF;

END;
Delimiter ;

/* Trigger 10: Số tiền tài khoản khách hàng chỉ được update tăng
 * */
/*
DROP Trigger if exists Customer_Balance_Must_Increase_On_Update;
Delimiter $$
CREATE Trigger Customer_Balance_Must_Increase_On_Update
Before 
UPDATE 
ON CUSTOMER 
FOR EACH ROW 
BEGIN 
	IF !(OLD.Balance <=> NEW.Balance) THEN
		IF NEW.Balance <= OLD.Balance THEN 
			SIGNAL SQLSTATE '45000' SET message_text = "Customer balances updates must be increase update";
		END IF;
	END IF;
END$$
Delimiter ;
*/

/* Trigger 11: Cập nhật số tiền còn lại trong tài khoản sau khi chuyển trạng thái OrderStatus thành True 
 * */
DROP Trigger if exists Minus_Customer_Balance_On_Confirm_Order;
Delimiter $$
CREATE Trigger Minus_Customer_Balance_On_Confirm_Order
Before 
UPDATE 
ON 
ORDERS 
FOR EACH ROW 
BEGIN 
	DECLARE CustomerId INT;
	DECLARE CurrentBalance INT;
	IF !(OLD.OrderStatus <=> NEW.OrderStatus) THEN
		IF OLD.OrderStatus = false AND NEW.OrderStatus = true THEN 
			SET CustomerId = OLD.CustomerId;
			SELECT Balance INTO CurrentBalance FROM CUSTOMER c WHERE c.Id = CustomerId;
			IF CurrentBalance < OLD.TotalCost THEN
				SIGNAL SQLSTATE '45000' SET message_text = "Customer Balance must higher than Order TotalCost before accepting Order";
			END IF;
			UPDATE CUSTOMER SET Balance = Balance - OLD.TotalCost WHERE Id = CustomerId;
		ELSE 
			SIGNAL SQLSTATE '45000' SET message_text = "Confirmed Order cannot edit OrderStatus back to 0";
		END IF; 
	END IF;
END$$
Delimiter ;











