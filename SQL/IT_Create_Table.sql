DROP Database if exists IT;

CREATE database IT;

use IT;

CREATE TABLE MANUFACTURE
(
	-- Primary Key
	Id INT auto_increment,
	Name VARCHAR(20) unique,
	Country VARCHAR(20),
	Primary Key(Id)
);

CREATE TABLE ACCESSORIES_TYPE
(
	Id INT auto_increment,
	Name VARCHAR(20) unique,
	-- Domain: Earphone, Charger, Port
	FunctionType VARCHAR(20),
	-- Foreign Key To Manufacture
	ManufactureId INT, 	
	-- TotalNumber INT,
	-- LeftNumber INT, 
	Primary Key(Id)
);

ALTER Table ACCESSORIES_TYPE
Add constraint AccessoriesToManufactureId
foreign key (ManufactureId) references MANUFACTURE(Id)
	ON delete Cascade
	ON update cascade;

CREATE TABLE PRODUCT_TYPE
(
	Id INT auto_increment,
	Name VARCHAR(20) unique,
	-- Domain: Laptop, Phone, Tablet
	FunctionType VARCHAR(20),
	-- Foreign Key To Manufacture
	ManufactureId INT,	
	-- Domain 5 -> 17
	ScreenSize INT,		
	-- Domain: i3, i5, i7
	Processsor VARCHAR(20), 
	MemoryGB INT,
	-- TotalNumber INT,
	-- LeftNumber INT, 
	Primary Key(Id)
);

ALTER Table PRODUCT_TYPE 
Add constraint ProductToManufactureId
foreign key (ManufactureId) references MANUFACTURE(Id)
	ON delete Cascade
	ON update cascade;

CREATE TABLE BRANCH
(
	Id Int auto_increment,
	Address VARCHAR(50) unique,
	Name VARCHAR(20) unique,
	PRIMARY KEY(Id)
);

-- Trigger 1: Sale Price > Import Price
CREATE TABLE ACCESSORIES
(
-- ForeignKey To AccessoriesType and PrimaryKey
	AccessoriesTypeID Int, 
	-- Partial PrimaryKey 
	IndexId INT, 
	SalePrice INT,
	 -- Import Price < Sale Price
	ImportPrice INT,
	-- ForeignKey To Branch
	BranchId INT, 
	PRIMARY KEY(AccessoriesTypeId, IndexId)
) ;

CREATE TABLE ACCESSORIES_INDEX_ID_TABLE
(
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY
);

ALTER Table ACCESSORIES
Add constraint AccessoriesToAccessoriesTypeId
foreign key (AccessoriesTypeId) references ACCESSORIES_TYPE(Id)
	ON delete Cascade
	ON update cascade;

-- DROP Table ACCESSORIES ;

CREATE TABLE PRODUCT
(
 	-- ForeignKey To ProductType and PrimaryKey
	ProductTypeId INT,
	 -- Partial PrimaryKey 
	IndexId INT ,
	SalePrice INT,
	-- Import Price < Sale Price
	ImportPrice INT,
	 -- ForeignKey To Branch
	BranchId INT,
	PRIMARY KEY(ProductTypeId, IndexId)
);

CREATE TABLE PRODUCT_INDEX_ID_TABLE
(
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY
);

ALTER Table PRODUCT
Add constraint ProductToProductTypeId
foreign key (ProductTypeId) references PRODUCT_TYPE(Id)
	ON delete Cascade
	ON update cascade;


-- Trigger add vô khi thêm một món cụ thể vào bảng Product cụ thể, Accessories 
CREATE TABLE ITEM 
-- Union Type of Product, Accessories
(
	-- ForeignKey to ProductId, AccessoriesId
	TypeId Int, 
	-- ForeignKey to Product, Accessories
	IndexId Int, 
	-- ForeignKey to Order NULLABLE if not bought
	OrderId Int,
	-- ItemType is Product / Accessories
	ItemType VARCHAR(20),
	PRIMARY KEY(IndexId, ItemType)
);

CREATE TABLE EMPLOYEE
(
	Id Int not null auto_increment,
	Fullname VARCHAR(20),
	Salary INT,
	 -- Self Forgein Key to Employee, NULLABLE
	ManagerId INT,
	-- ForeignKey To Branch
	BranchId INT,
	Password varchar(15),
	Email varchar(40) unique,
	Primary Key (id)
) ENGINE=InnoDB;

alter table EMPLOYEE 
add constraint EmployeeToBranchId
foreign key(BranchId) references BRANCH(Id)
on delete cascade
on update cascade;

Create table CUSTOMER
(
	Id int not null auto_increment,
    Password varchar(15),
    Address varchar(30),
    Fullname varchar(30),
    Email varchar(40) unique,
    Balance int,
    Primary key(Id)
);

/* Table ORDERS
 * */
CREATE TABLE ORDERS(
	Id int not null auto_increment,
    CustomerId int,
    EmployeeId int,
    BranchId int,
    StartDate date,
    OrderStatus bool,
    PayMethod varchar(15),
    TotalCost int,
    Primary key (Id)
);

alter table ITEM 
add constraint ItemToOrderId
foreign key (OrderId) references ORDERS(Id)
on UPDATE cascade
on DELETE cascade;

alter table ORDERS
add constraint OrdersToCustomerId
foreign key(CustomerId) references CUSTOMER(Id)
on delete cascade
on update cascade;

alter table ORDERS
add constraint OrdersToEmployeeId
foreign key(EmployeeId) references EMPLOYEE(Id)
on delete cascade
on update cascade;

alter table ORDERS
add constraint OrdersToBranchId
foreign key(BranchId) references BRANCH(Id)
on delete cascade
on update cascade;


/******************************************************************/

Create table CONTAINER(
	Id int not null auto_increment,
    PackageDate date,
    TransportFee int,
    DriverId int,  
    OrderId int,	
    Primary key (Id)
);


Create table DRIVER(
	Id int not null auto_increment,
    Fullname varchar(30),
    VehicleId int, 
    primary key(Id)
);

alter table DRIVER auto_increment=1;

Create table VEHICLE(
	Id int not null,
    Weight int,
    primary key (Id)
);

alter table CONTAINER
add constraint foreign key(DriverId) references DRIVER(Id)
on delete cascade
on update cascade;

alter table CONTAINER
add constraint foreign key(OrderId) references ORDERS(Id)
on delete cascade
on update cascade;

alter table DRIVER
add constraint foreign key(VehicleId) references VEHICLE(Id)
on delete cascade
on update cascade;


-- ---------------------------------------
-- Tạo bảng khuyến mãi
create table PROMOTION(
	id int not null auto_increment,
    price int,
    startDate date,
    orderId int,
    primary key(id)
);

alter table PROMOTION
add constraint foreign key(orderId) references ORDERS(Id)
on delete cascade
on update cascade;
