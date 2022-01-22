/* Insert Into Tables */

use IT;

/* Insert Into Manufacture */
insert into MANUFACTURE(Name, Country) values ("Asus", "Taiwan");
insert into MANUFACTURE(Name, Country) values ("Apple", "America");
insert into MANUFACTURE(Name, Country) values ("Dell", "America");
insert into MANUFACTURE(Name, Country) values ("Samsung", "Korea");

/* Insert Into Branch */
insert into BRANCH (Name, Address) values ("Headquarter", "731 Fondren, Houston, TX");
insert into BRANCH (Name, Address) values ("Branch 1", "638 Voss, Houston, TX");
insert into BRANCH (Name, Address) values ("Branch 2", "5631 Rice, Houston, TX");

/* Insert Into Employees */
insert into EMPLOYEE (Fullname, Salary, ManagerId, BranchId, Email, Password) values ("Thomas Tom", 40000, null, 3, "tt123@gmail.com", "123456");
insert into EMPLOYEE (Fullname, Salary, ManagerId, BranchId, Email, Password) values ("Laura Lora", 50000, null, 1, "ll123@gmail.com", "123456");
insert into EMPLOYEE (Fullname, Salary, ManagerId, BranchId, Email, Password) values ("Anthony Anthem", 45000, null, 2, "aa123@gmail.com", "123456");
insert into EMPLOYEE (Fullname, Salary, ManagerId, BranchId, Email, Password) values ("Thien Huynh", 50000, null, 1, "hdthien01@gmail.com", "123456");
/* Store Procedure Insert 4: Insert Employee, checking email exists */
-- CALL InsertEmployeeAccount(:_Password, :_ManagerId, :_Fullname, :_Email, :_Salary, :_BranchId);

/* Insert Into Customer */
insert into CUSTOMER (password, email, address, fullname, balance)
values ('123456', 'jw123@gmail.com', '291 Berry, Bellaire, TX', 'John Wick', '10000');
insert into CUSTOMER (password, email, address, fullname, balance)
values ('123456', 'jj123@gmail.com', '980 Dallas, Houston, TX', 'James Jorden', '5000');
insert into CUSTOMER (password, email, address, fullname, balance)
values ('123456', 'rr123@gmail.com','3321 Castle, Spring, TX', 'Roman Reign', '9000');
insert into CUSTOMER (password, email, address, fullname, balance)
values ('123456', 'hdthinh01@gmail.com','3321 Castle, Spring, TX', 'Thinh Huynh', '9000');
/* StoreProcedure Insert 1: Insert Customer Checking Email Exists */
-- Call InsertCustomerAccount(:_Password, :_Address, :_Fullname, :_Email, :_Balance); 


/* Insert Into AccessoriesType */
insert into ACCESSORIES_TYPE (Name, FunctionType, ManufactureId) values("Airpod", "Earphone", 2);
insert into ACCESSORIES_TYPE (Name, FunctionType, ManufactureId) values("GalaxyBuds", "Earphone", 4);
insert into ACCESSORIES_TYPE (Name, FunctionType, ManufactureId) values("FastCharger", "Charger", 1);
insert into ACCESSORIES_TYPE (Name, FunctionType, ManufactureId) values("DellMouse", "Mouse", 3);
/* StoreProcedure Insert 2: Add AccessoriesType, ProductType */
-- Call InsertAccessoriesType(:_Name, :_FunctionType, :_ManufactureId); 

/* Insert Into ProductType */
insert into PRODUCT_TYPE (Name, FunctionType, ManufactureId, ScreenSize, Processsor, MemoryGB) values ("Vivobook", "Laptop", 1, "15.6", "Intel i5", "8");
insert into PRODUCT_TYPE (Name, FunctionType, ManufactureId, ScreenSize, Processsor, MemoryGB) values ("Inspiron", "Laptop", 3, "14", "Intel i7", 16);
insert into PRODUCT_TYPE (Name, FunctionType, ManufactureId, ScreenSize, Processsor, MemoryGB) values ("Macbook Air", "Laptop", 2, "13.3", "Apple M1", 8);
insert into PRODUCT_TYPE (Name, FunctionType, ManufactureId, ScreenSize, Processsor, MemoryGB) values ("Galaxy S", "Phone", 4, "6.7", "Snapdragon 865", 12);
/* StoreProcedure Insert 2: Add AccessoriesType, ProductType */
-- Call InsertProductType(:_Name, :_FunctionType, :_ManufactureId, :_ScreenSize, :_Processor, :_MemoryGB); 


/* Insert Into Accessories, Product */

insert into ACCESSORIES values (1, 1, 250, 200, 1);
insert into ACCESSORIES values (1, 2, 250, 200, 2);
insert into ACCESSORIES values (2, 3, 200, 180, 3);
insert into ACCESSORIES values (2, 4, 200, 180, 2);
insert into ACCESSORIES values (3, 5, 100, 80, 3);
insert into ACCESSORIES values (3, 6, 100, 80, 1);
insert into ACCESSORIES values (4, 7, 50, 40, 2);
insert into ACCESSORIES values (4, 8, 50, 40, 3);

insert into PRODUCT values (1, 1, 850, 700, 1);
insert into PRODUCT values (1, 2, 850, 720, 2);
insert into PRODUCT values (2, 3, 1000, 880, 3);
insert into PRODUCT values (2, 4, 1050, 880, 2);
insert into PRODUCT values (3, 5, 1220, 1080, 2);
insert into PRODUCT values (3, 6, 1200, 1080, 1);
insert into PRODUCT values (4, 7, 750, 640, 2);
insert into PRODUCT values (4, 8, 720, 640, 3);

/* StoreProcedure Insert 3: Add Accessories, Product */
-- Call InsertItems(:_ItemType, :_TypeId, :_SalePrice, :_ImportPrice, :_BranchId, :_Quantity) 



/* Insert Into Orders */
/* Trigger 8: Check Trigger Orders Branch Id match Employee Branch Id
 * */
insert into ORDERS (CustomerId, StartDate, OrderStatus, PayMethod, TotalCost, EmployeeId, BranchId)
values (5, '2021-11-15', false, 'Direct', 500000, null, 3);
insert into ORDERS (CustomerId, StartDate, OrderStatus, PayMethod, TotalCost, EmployeeId, BranchId)
values (2, '2021-11-15', false, 'Direct', 0, null, 1);
insert into ORDERS (CustomerId, StartDate, OrderStatus, PayMethod, TotalCost, EmployeeId, BranchId)
values (3, '2021-11-16', false, 'Online', 0, null, 2);

/*****************************************************************************************************************************************************************************/

-- Vehicle
insert into VEHICLE
values (1, 3);
insert into VEHICLE
values (2, 5);

-- Driver
insert into DRIVER (Fullname, VehicleId)
values ('Binz', 1);
insert into DRIVER (Fullname, VehicleId)
values ('Rhymatic', 2);

-- Container
insert into CONTAINER (PackageDate, TransportFee, DriverId, OrderId)
values ('2021-11-14', '5000', 3, 5);
insert into CONTAINER (PackageDate, TransportFee, DriverId, OrderId)
values ('2021-11-15', '15000', 2, 2);
insert into CONTAINER (PackageDate, TransportFee, DriverId, OrderId)
values ('2021-11-16', '13000', 2, 3);

-- Promotion
insert into PROMOTION (price, startDate, orderId)
values ('100000', '2021-11-15', 4);
insert into PROMOTION (price, startDate, orderId)
values ('100000', '2021-11-15', null);

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';

