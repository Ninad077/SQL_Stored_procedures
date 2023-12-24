-- Stored Procedure

-- Single procedure output
-- Create a stored procedure for displaying customer information.
Delimiter //    -- Defining // as a Delimiter (Delimiter indicates a halt for execution (for e.g. ;))
create procedure display_cust()
begin
	select customerNumber,customerName,country
    from customers;
end //          -- -- Ending the procedure with a Delimiter
Delimiter ;

call display_cust(); -- (Calling procedure without a parameter)

-- Multiple Procedure output
--  Create a Procedure to display customer details and order details
Delimiter //
create procedure display_cust()
begin
	select customerNumber,customerName,country
    from customers;
    
    select orderNumber,(quantityOrdered*priceEach) as Total_amount
    from orderdetails;
end //
Delimiter ;

call display_cust();   -- Calling procedure (Without a parameter)

-- Dropping procedure 
Drop procedure display_cust;

-- -- IN parameter (Calling procedure with a parameter)
-- Create a stored procedure for displaying customer information for a country given as an input from the user.
Delimiter //
create procedure display_cust(IN country_name varchar(40))
begin
	select customerNumber,customerName,country
    from customers
    where country=country_name;
end //
Delimiter ;

call display_cust("USA");

-- IN parameter (Calling procedure with multiple parameters)
-- Create a stored procedure for displaying customer information for multiple countries given as an input from the user.
Delimiter //
create procedure display_countries(IN country_name1 varchar(40),IN country_name2 varchar(40),IN country_name3 varchar(40))
begin
	select customerNumber,customerName,country
    from customers
    where country IN (country_name1,country_name2,country_name3);
end //
Delimiter ;

call display_countries("Spain", "USA","JAPAN");

-- User defined variable 
-- (If we use @, the variable will be fixed for one session of Workbench, one session is one log_in log_out)
-- Create a user defined variable for creditlimlit and find the customer information for all the creditlimits above the defined variable.
SET @Cred= 75000;

select customerNumber,customerName,country, creditLimit
from customers
where creditLimit>=@Cred ;

-- OUT PARAMETER 
-- (Answer of OUT parameter is stored in a variable which is prefixed by @ symbol.) 
-- (We do so to make sure the value of the OUT parameter is applicable beyound the scope of the procedure)
DELIMITER //
CREATE PROCEDURE avg_credit(OUT avg_cred int)
BEGIN
		select avg(creditLimit) into avg_cred from customers;
 
END//
DELIMITER ; 

call avg_credit(@ans); -- Saving the output in a session variable named @ans

select @ans;

SELECT customerNumber,customerName,country,creditLimit
from customers
where  creditLimit>=@ans;


-- In and OUT paremeter 
-- Create a procedure to display creditLimit of a given country which is greater than it's average creditLimit. Here the country should be given as input.
DELIMITER //
CREATE PROCEDURE avg_credit_country
(IN COUNTRY_NAME VARCHAR(40),OUT avg_cred_country float)
BEGIN
		select avg(creditLimit) into avg_cred_country
        from customers
        where country=COUNTRY_NAME;
 
END//
DELIMITER ;

call avg_credit_country("USA",@ans);

select @ans;

SELECT customerNumber,customerName,country,creditLimit
from customers
where  creditLimit>=@ans;


-- Counter 
# INOUT Parameter (Paraemter where the value of input as well as the output is stored).
DELIMITER //

CREATE PROCEDURE SetCounter(INOUT counter INT,  IN inc INT)
BEGIN

	SET counter = counter + inc;
    
END //

DELIMITER ;

SET @counter = 1;
CALL SetCounter(@counter,1); 
SELECT @counter; 

CALL SetCounter(@counter,1); 
SELECT @counter; 

CALL SetCounter(@counter,5); 
SELECT @counter; 

CALL SetCounter(@counter,10); 
SELECT @counter; 

-- Create a procedure "Get_order_status" which should accept the status value from the user and show the number of orders for each year for that status.

drop procedure Get_order_status;
DELIMITER //
CREATE PROCEDURE Get_order_status(IN orderStatus VARCHAR(40),OUT CNT int)
BEGIN
		select year(orderDate) as Year, count(orderNumber) as Count
        from orders
        where status= orderStatus
        group by Year;

END//
DELIMITER ;

call Get_order_status("Shipped",@CNT);



