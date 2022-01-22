/* IT Function */
SET GLOBAL log_bin_trust_function_creators = 1;

use IT;


-- ----------
-- Lấy tên tài xế
drop function if exists get_driver_name;

delimiter $$

create function get_driver_name(
	id int
)
returns varchar(30)
begin
	declare driver_name varchar(30) default null;
    select fullname into driver_name
    from driver D
    where D.id = id;
    if driver_name is null then return "Not found";
    end if;
    return driver_name;
end $$

delimiter ;

select get_driver_name(10) as driver_name;

-- -----------------
/*Lấy số tiền sau khi đã trừ số tiền khuyến mãi*/
drop function if exists get_final_price;

delimiter $$

create function get_final_price(
	orderId int
)
returns int
begin
	declare promotion_price int;
	declare total_price int;
	if	orderId > 0 then
		select price into promotion_price
		from promotion P
		where P.orderId = orderId;
		select totalCost into total_price
		from Orders
		where Id = orderId;
		if promotion_price is null or total_price is null then return -1;
		end if;
		return total_price - promotion_price;
	end if;
    return -1;
end $$

delimiter ;

-- select get_final_price(4);


/*Tính toán số dư còn lại của khách hàng sau khi mua hàng*/
drop function if exists calculate_balance;

delimiter $$

create function calculate_balance(
	_id int
)
returns int
begin
	declare _balance int;
    declare final_price int;
    declare _customerId int;
    declare _count int;
    select count(*) into _count from orders;
	if	_id > 0 and _count > 0 then
		select customerId into _customerId from orders where _id = id;
        select balance into _balance from customer where id = _customerId;
		select get_final_price(_id) into final_price;
        if final_price <=> -1 then
			select TotalCost into final_price from orders where Id = _id;
        end if;
        if _balance - final_price > 0 then return _balance - final_price;
        end if;
	end if;
    return -1;
end $$

delimiter ;

-- select calculate_balance(10);/*Lấy số tiền sau khi đã trừ số tiền khuyến mãi*/
drop function if exists get_final_price;

delimiter $$

create function get_final_price(
	orderId int
)
returns int
begin
	declare promotion_price int;
	declare total_price int;
	if	orderId > 0 then
		select price into promotion_price
		from promotion P
		where P.orderId = orderId;
		select totalCost into total_price
		from Orders
		where Id = orderId;
		if promotion_price is null or total_price is null then return -1;
		end if;
		return total_price - promotion_price;
	end if;
    return -1;
end $$

delimiter ;

-- select get_final_price(4);


/*Tính toán số dư còn lại của khách hàng sau khi mua hàng*/
drop function if exists calculate_balance;

delimiter $$

create function calculate_balance(
	_id int
)
returns int
begin
	declare _balance int;
    declare final_price int;
    declare _customerId int;
    declare _count int;
    select count(*) into _count from orders;
	if	_id > 0 and _count > 0 then
		select customerId into _customerId from orders where _id = id;
        select balance into _balance from customer where id = _customerId;
		select get_final_price(_id) into final_price;
        if final_price <=> -1 then
			select TotalCost into final_price from orders where Id = _id;
        end if;
        if _balance - final_price > 0 then return _balance - final_price;
        end if;
	end if;
    return -1;
end $$

delimiter ;

-- select calculate_balance(10);