
select distinct productLine from classicmodels.products;

use classicmodels;

#single entity
#1 Prepare a list of offices sorted by country, state, city.
SELECT * FROM offices 
ORDER BY country, state, city;

#2 How many employees are there in the company?
SELECT COUNT(employeeNumber)
FROM employees;

#3 What is the total of payments received?
SELECT SUM(amount)
FROM payments;

#4 List the product lines that contain 'Cars'.
SELECT DISTINCT productLine 
FROM products
WHERE productLine LIKE '%Cars%';

#5 Report total payments for October 28, 2004
SELECT sum(amount)
FROM payments 
WHERE paymentDate='2004-10-28';

#6 Report those payments greater than $100,00
SELECT *
FROM payments
WHERE amount > 100000;

#7 List the products in each product line
SELECT productName, productLine
FROM products
ORDER BY productLine;

#8 How many products in each product line?
SELECT productLine, COUNT(productName) as productNumber
FROM products
Group by productLine;

#9 What is the minimum payment received?
SELECT MIN(amount)
FROM payments;

#10 List all payments greater than twice the average payment.
SELECT *
FROM payments
WHERE amount < (SELECT AVG(amount) FROM payments);


#11 What is the average percentage markup of the MSRP on buyPrice?
SELECT AVG((MSRP-buyPrice)/buyPrice)
FROM products;

#12 How many distinct products does ClassicModels sell?
SELECT COUNT(DISTINCT productName)
from products;

#13  Report the name and city of customers who don't have sales representatives?
SELECT customerName, city
FROM customers
WHERE salesRepEmployeeNumber IS NULL;

#14  What are the names of executives with VP or Manager in their title?
#Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
SELECT CONCAT(firstName, ' ', lastName) as Name
FROM employees
WHERE jobTitle like '%VP%' or jobTitle like '%Manager%';

#15 Which orders have a value greater than $5,000?
SELECT orderNumber, sum(quantityOrdered*priceEach) as value
FROM orderdetails
GROUP BY orderNumber
Having value > 5000;


#one to many

#1 Report the account representative for each customer.
SELECT 
	c.customerNumber, c.customerName, c.salesRepEmployeeNumber, 
	CONCAT(e.firstName,' ', e.lastName) as RepNAME
FROM customers c, employees e
WHERE c.salesRepEmployeeNumber=e.employeeNumber;

#2 Report total payments for Atelier graphique.
SELECT c.customerNumber,c.customerName, sum(p.amount)
FROM customers c, payments p
WHERE c.customerNumber = p.customerNumber and c.customerName='Atelier graphique'
GROUP BY c.customerNumber;

#3 Report the products that have not been sold.
SELECT paymentDate, sum(amount) as totalPayment
FROM payments
GROUP BY paymentDate;

#4List the amount paid by each customer.

SELECT p.productName, o.quantityOrdered 
FROM products p
LEFT JOIN orderdetails o
ON o.productCode=p.productCode
WHERE o.quantityOrdered IS NULL;

#5 List the amount paid by each customer.

SELECT p.customerNumber, c.customerName, sum(p.amount) as totalAmount
FROM payments p, customers c
WHERE p.customerNumber = c.customerNumber
GROUP BY p.customerNumber;

#6 How many orders have been placed by Herkku Gifts?

SELECT c.customerName, count(*) as orderCount
FROM customers c, orders o
WHERE c.customerNumber = o.customerNumber and c.customerName='Herkku Gifts'
GROUP BY c.customerNumber;

#7 Who are the employees in Boston?

SELECT e.employeeNumber, e.lastName, e.firstName
FROM employees e, offices o
WHERE o.officeCode=e.officeCode and o.city="Boston";

#8 Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first.

SELECT p.customerNumber, c.customerName, p.amount
FROM payments p, customers c
WHERE p.customerNumber=c.customerNumber and p.amount >100000
ORDER BY amount DESC;

#9 List the value of 'On Hold' orders.

SELECT o.orderNumber as onHoldOrder, sum(d.quantityOrdered*d.priceEach) as Value
FROM orders o, orderdetails d
WHERE o.status ='On Hold' and o.orderNumber=d.orderNumber  
GROUP BY onHoldOrder;

#10 Report the number of orders 'On Hold' for each customer.

SELECT c.customerNumber, c.customerName,count(*) as holdOrder
FROM orders o, customers c
WHERE o.status ='On Hold' and o.customerNumber=c.customerNumber
GROUP BY customerNumber;

#many to many relationship

#1 List products sold by order date. ???(list 
SELECT o.orderDate, p.productCode, p.productName
FROM orders o, orderdetails d, products p
WHERE o.orderNumber=d.orderNumber and d.productCode=p.productCode
ORDER BY o.orderDate;

#2 List the order dates in descending order for orders for the 1940 Ford Pickup Truck.
SELECT o.orderDate
FROM orders o, products p, orderdetails d
WHERE 
	p.productName='1940 Ford Pickup Truck' and 
	d.productCode=p.productCode and
	d.orderNumber=o.orderNumber
ORDER BY o.orderDate DESC;

#3 List the names of customers and their corresponding order number where a particular order 
#from that customer has a value greater than $25,000?

SELECT c.customerName, o.orderNumber, sum(d.quantityOrdered*d.priceEach)as orderValue
FROM  customers c, orders o, orderdetails d
WHERE 
	c.customerNumber=o.customerNumber and 
    d.orderNumber=o.orderNumber
GROUP BY d.orderNumber
Having orderValue > 25000;

#4 Are there any products that appear on all orders???????????
SELECT
  productCode,
  COUNT(*) AS num
FROM
  orderdetails
GROUP BY
  productCode
Having  num > count(DISTINCT orderNumber);

#5 List the names of products sold at less than 80% of the MSRP.
SELECT p.productName, p.MSRP, o.orderNumber, o.priceEach
FROM products p, orderdetails o
WHERE 
	p.productCode = o.productCode and
    o.priceEach < p.MSRP*0.8;
    
#6 Reports those products that have been sold with a markup of 100% or more 
#(i.e.,  the priceEach is at least twice the buyPrice)

SELECT  p.productName, max(p.buyPrice), min(o.priceEach)
FROM products p, orderdetails o
WHERE 
	p.productCode = o.productCode and
    o.priceEach >= p.buyPrice*2
GROUP BY p.productName;

#7 List the products ordered on a Monday.
SELECT d.productCode, p.productName, o.orderNumber
FROM orders o,  orderdetails d, products p
WHERE 
	WEEKDAY(o.orderDate)=1 and
    o.orderNumber=d.orderNumber and
    p.productCode=d.productCode;
    
#8 What is the quantity on hand for products listed on 'On Hold' orders?
SELECT p.productCode, p.productName, p.quantityInStock
FROM orders o, orderdetails d, products p
WHERE 
	o.status ='On Hold' and 
    p.productCode=d.productCode and
    o.orderNumber=d.orderNumber;
    

#Regular expressions
#1. Find products containing the name 'Ford'.
SELECT * 
FROM products
WHERE productName like '%Ford%';

#2  List products ending in 'ship'.
SELECT * 
FROM products
WHERE productName like '%ship';

#3 Report the number of customers in Denmark, Norway, and Sweden.
SELECT country, COUNT(*) as cutomercount
FROM customers
WHERE 
	country in ('Denmark', 'Norway', 'Sweden')
GROUP BY country;

#4 What are the products with a product code in the range S700_1000 to S700_1499?
SELECT *
FROM products
WHERE productCode between 'S700_100' and 'S700_1499';

#5 Which customers have a digit in their name?
Select *
FROM customers
WHERE customerName like '%[0-9]%';

#6 List the names of employees called Dianne or Diane.

SELECT CONCAT(firstName, ' ', lastName) as Name
FROM employees
WHERE firstName like '%Dian%' or lastName like '%Dian%';

#7 List the products containing ship or boat in their product name.
SELECT *
FROM products
WHERE productName like '%ship%' or productName like '%boat%';

#8. List the products with a product code beginning with S700.
SELECT *
FROM products
WHERE productCode like 'S700%';

#9 List the names of employees called Larry or Barry.
SELECT CONCAT(firstName, ' ', lastName) as Name
FROM employees
WHERE firstName like '%arry%';

#10 List the names of employees with non-alphabetic characters in their names
SELECT *
FROM employees
WHERE firstName LIKE '%[^a-z]%';

#11 List the vendors whose name ends in Diecast
SELECT *
FROM products
WHERE productVendor like '%Diecast';



#General queries

#1 Who is at the top of the organization (i.e.,  reports to no one).
SELECT *
FROM employees
WHERE reportsTo IS NULL;

#2 Who reports to William Patterson?
SELECT * 
FROM employees e, employees m
WHERE 
	e.reportsTo=m.employeeNumber AND
    m.firstName='William' AND
    m.lastName='Patterson';

#3  List all the products purchased by Herkku Gifts

SELECT p.productName
FROM customers c, orderdetails d, orders o, products p
WHERE 
	c.customerNumber=o.customerNumber AND
    c.customerName='Herkku Gifts' AND
    d.orderNumber=o.orderNumber AND
    p.productCode=d.productCode;
    
#4 Compute the commission for each sales representative, 
#assuming the commission is 5% of the value of an order. 
#Sort by employee last name and first name.

 SELECT e.lastName, e.firstName, sum(d.quantityOrdered*d.priceEach)*0.05 as commission
 FROM orderdetails d, orders o, customers c, employees e
 WHERE 
	d.orderNumber=o.orderNumber AND
    o.customerNumber=c.customerNumber AND
    c.salesRepEmployeeNumber=e.employeeNumber
GROUP BY e.employeeNumber
ORDER BY e.lastName, e.firstName;

#5  What is the difference in days between the most recent and oldest order date in the Orders file?
SELECT DATEDIFF(max(orderDate), min(orderDate))
FROM orders;

#6 Compute the average time between order date and ship date for each customer ordered by the largest difference.
SELECT customerNumber, AVG(DATEDIFF(shippedDate, orderDate)) AS waittime
FROM orders
GROUP BY customerNumber
ORDER BY waittime DESC;

#7 What is the value of orders shipped in August 2004? (Hint).
SELECT d.orderNumber, sum(d.quantityOrdered*d.priceEach) AS orderValue
FROM orders o, orderdetails d
WHERE
	o.orderNumber=d.orderNumber AND
    MONTH(o.shippedDate)= 8 AND
    YEAR(o.shippedDate)=2004
GROUP BY d.orderNumber;

#8 Compute the total value ordered, total amount paid, 
#and their difference for each customer for orders placed in 2004 
#and payments received in 2004 (Hint; Create views for the total paid and total ordered).

SELECT 
	o.customerNumber,
	sum(d.quantityOrdered*d.priceEach) as totalValue, 
    sum(p.amount) as totalAmount,
    sum(p.amount)-sum(d.quantityOrdered*d.priceEach) as Diff
FROM orders o, orderdetails d, payments p
WHERE
	o.orderNumber=d.orderNumber AND
    o.customerNumber=p.customerNumber AND
    YEAR(o.orderDate)=2004 AND
    YEAR(p.paymentDate)=2004
GROUP BY o.customerNumber;


#try to use crerate view 
CREATE VIEW totalpaid1 AS
SELECT customerNumber, sum(amount) as paid
FROM payments
WHERE 
	YEAR(paymentDate)=2004
GROUP BY customerNumber;

CREATE VIEW totalvalue1 AS
SELECT o.customerNumber, sum(d.quantityOrdered*d.priceEach) as value
FROM orderdetails d, orders o
WHERE 
	o.orderNumber=d.orderNumber AND
    YEAR(orderDate)=2004
GROUP BY o.customerNumber;

SELECT p.customerNumber, paid, value, paid-value as diff
FROM totalpaid1 p, totalvalue1 v
WHERE  p.customerNumber=v.customerNumber; 


#9  List the employees who report to those employees who report to Diane Murphy. 
#Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
SELECT CONCAT(e.firstName, ' ', e.lastName)as name
FROM employees e, employees m, employees d
WHERE
	d.firstName='Diane' AND d.lastName='Murphy' AND
    m.reportsTo=d.employeeNumber AND
    e.reportsTo=m.employeeNumber;

#10 What is the percentage value of each product in inventory 
#sorted by the highest percentage first (Hint: Create a view first).
CREATE VIEW proValue AS
SELECT productCode, productName, quantityInStock*MSRP as Value
FROM products 
GROUP BY productCode;

SELECT productCode, productName, value/(select sum(value)from proValue) as percentage
FROM proValue;

#11 Write a function to convert miles per gallon to liters per 100 kilometers.
CREATE FUNCTION convertMile (milesPerGallon DEC(10,2))
RETURNS DEC(10,2) DETERMINISTIC
RETURN milesPerGallon*235;


#12 Write a procedure to increase the price of a specified product category by a given percentage. 
-- You will need to create a product table with appropriate data to test your procedure. 
-- Alternatively, load the ClassicModels database on your personal machine so you have complete access. 
-- You have to change the DELIMITER prior to creating the procedure.

CREATE TABLE productPrice AS
   SELECT p.productCode, productName, productLine, AVG(priceEach) as Price
   FROM products p, orderdetails o
   WHERE p.productCode=o.productCode
   GROUP BY p.productCode;

SELECT*FROM productPrice;

DELIMITER //

CREATE PROCEDURE priceProductLine 
	(IN p_productLine varchar(50),
    IN percentage  DEC(10,2))
BEGIN
UPDATE productPrice
SET Price=Price* (1+percentage) 
WHERE productLine = p_productLine;
END//

DELIMITER ;

SET SQL_SAFE_UPDATES = 0;
#TEST
CALL priceProductLine ('Motorcycles', 0.5) ;
SELECT*FROM productPrice;

#13 What is the value of orders shipped in August 2004? (Hint).

SELECT d.orderNumber, sum(d.quantityOrdered*d.priceEach) AS orderValue
FROM  orderdetails d
Left Join orders o
ON o.orderNumber=d.orderNumber
WHERE
    MONTH(o.shippedDate)= 8 AND
    YEAR(o.shippedDate)=2004
GROUP BY d.orderNumber;

#14 What is the ratio the value of payments made to orders received for each month of 2004. 
#(i.e., divide the value of payments made by the orders received)?

CREATE VIEW monthlyPaid AS
SELECT Month(paymentDate) as Month, sum(amount) as paid
FROM payments
WHERE 
	YEAR(paymentDate)=2004
GROUP BY Month;

CREATE VIEW monthlyValue AS
SELECT MONTH(o.orderDate) as Month, sum(d.quantityOrdered*d.priceEach)as value
FROM orderdetails d 
JOIN orders o
ON	o.orderNumber=d.orderNumber 
WHERE  
   YEAR(o.orderDate)=2004
GROUP BY Month;

SELECT p.Month, paid, value, paid/value as ratio
FROM monthlyPaid p, monthlyValue v
WHERE  p.Month=v.Month; 

#15 What is the difference in the amount received for each month of 2004 compared to 2003?

CREATE VIEW apayments as
SELECT Month(paymentDate) as Month, sum(amount) as paid
FROM payments
WHERE 
	YEAR(paymentDate)=2004
GROUP BY Month;

CREATE VIEW bpayments as
SELECT Month(paymentDate) as Month, sum(amount) as paid
FROM payments
WHERE 
	YEAR(paymentDate)=2003
GROUP BY Month;

SELECT a.Month, a.paid-b.paid as Diff
FROM apayments a, bpayments b
WHERE  a.Month=b.Month
ORDER BY Month;

#16 Write a procedure to report the amount ordered 
#in a specific month and year for customers containing a specified character string in their name.

DELIMITER //

CREATE PROCEDURE reportAmount 
	(IN mn int,
    IN yr  int,
    In chac varchar(50))
BEGIN
SELECT MONTH(orderDate), Year(orderDate), c.customerName, sum(priceEach*quantityOrdered)
FROM orderDetails d, orders o, customers c
WHERE 
	c.customerNumber=o.customerNumber AND
    d.orderNumber=o.orderNumber AND
	MONTH(o.orderDate)=mn AND
    YEAR(o.orderDate)=yr AND
    c.customerName like CONCAT('%', chac , '%')
GROUP BY o.orderDate, c.customername;
END//

DELIMITER ;
#test
CALL reportAmount(8,2004,'co');

#17 Write a procedure to change the credit limit of all customers in a specified country by a specified percentage.

DELIMITER //

CREATE PROCEDURE changeCreditLimit
	(IN ctry varchar(50),
    IN percent dec(10,2))
BEGIN
ALTER TABLE customers
ADD newCreditLimit dec(10,2);
UPDATE customers
    SET newCreditLimit= 
		IF(country=ctry, 
			creditLimit* (1+percent), 
            creditLimit);
END//

DELIMITER ;

#TEST
ALTER TABLE customers
DROP COLUMN newCreditLimit;
CALL changeCreditLimit('France',0.5);
SELECT*FROM customers;

#18: basket of goods analysis: A common retail analytics task is to analyze each basket 
#or order to learn what products are often purchased together. 
#Report the names of products that appear in the same order ten or more times.

WITH Pair AS   
(
SELECT 
	CONCAT(t1.productCode, ',', t2.productCode) as productpair, 
    CONCAT(p1.productName, ',', p2.productName) as namepair,
    t1.orderNumber
FROM 
    orderdetails as t1, orderdetails as t2, 
    products as p1, products as p2
WHERE 
    t1.orderNumber = t2.orderNumber AND
    t1.productCode != t2.productCode AND
    t1.productCode < t2.productCode  AND
		t1.productCode=p1.productCode AND
		t2.productCode=p2.productCode
)
SELECT namepair, count(*) as 'Freq' 
FROM Pair
GROUP BY namepair 
Having Freq > 10
ORDER BY Freq DESC, namepair;   
    
#19  ABC reporting: Compute the revenue generated by each customer based on their orders. 
#Also, show each customer's revenue as a percentage of total revenue. Sort by customer name.

WITH Revenue as
(
SELECT 
	c.customerName, 
	sum(d.priceEach*d.quantityOrdered) as Revenue
FROM orderDetails d, orders o, customers c
WHERE 
	
    c.customerNumber=o.customerNumber AND
    d.orderNumber=o.orderNumber 
GROUP BY c.customername
)
SELECT customerName, Revenue, Revenue/(select sum(Revenue)from Revenue)*100 as Percentage
From Revenue
ORDER BY customerName;

#20 Compute the profit generated by each customer based on their orders. 
#Also, show each customer's profit as a percentage of total profit. Sort by profit descending.

WITH profit as
(
SELECT 
	c.customerName, 
	sum((d.priceEach-p.buyPrice)*d.quantityOrdered) as profit
FROM orderDetails d, orders o, customers c, products p
WHERE 
	
    c.customerNumber=o.customerNumber AND
    d.orderNumber=o.orderNumber AND
	d.productCode=p.productCode 
    
GROUP BY c.customername
)
SELECT customerName, profit, profit/(select sum(profit)from profit)*100 as Percentage
From profit
ORDER BY Percentage DESC;

#21 Compute the revenue generated by each sales representative 
#based on the orders from the customers they serve.

SELECT 
	e.lastName, e.firstName, 
	sum(d.quantityOrdered*d.priceEach) as Revenue
 FROM orderdetails d, orders o, customers c, employees e
 WHERE 
	d.orderNumber=o.orderNumber AND
    o.customerNumber=c.customerNumber AND
    c.salesRepEmployeeNumber=e.employeeNumber
GROUP BY e.employeeNumber
ORDER BY e.lastName, e.firstName;

#22 Compute the profit generated by each sales representative 
#based on the orders from the customers they serve. Sort by profit generated descending.

SELECT 
	e.lastName, e.firstName, 
	sum((d.priceEach-p.buyPrice)*d.quantityOrdered) as profit
 FROM orderdetails d, orders o, customers c, employees e, products p
 WHERE 
	p.productCode=d.productCode AND
    d.orderNumber=o.orderNumber AND
    o.customerNumber=c.customerNumber AND
    c.salesRepEmployeeNumber=e.employeeNumber 
GROUP BY e.employeeNumber
ORDER BY profit DESC;

#23 Compute the revenue generated by each product, sorted by product name.
SELECT 
	productName, 
	sum(priceEach*quantityOrdered) as revenue
FROM orderdetails d, products p
WHERE 
	p.productCode=d.productCode 
GROUP BY productName
ORDER BY productName;

#24 Compute the profit generated by each product line, sorted by profit descending.
SELECT 
	p.productLine, 
	sum((d.priceEach-p.buyPrice)*d.quantityOrdered) as profit
 FROM orderdetails d, products p
 WHERE 
	p.productCode=d.productCode 
GROUP BY p.productLine
ORDER BY profit DESC;

#25 Same as Last Year (SALY) analysis: Compute the ratio for each product of sales for 2003 versus 2004.

CREATE VIEW sale2004 as
SELECT 
	p.productName, 
	sum(d.priceEach*d.quantityOrdered) as sales
FROM products p, orderdetails d, orders o
WHERE 
	p.productCode=d.productCode AND
    o.orderNumber=d.orderNumber AND
    YEAR(o.orderDate)=2004
GROUP BY p.productName;

CREATE VIEW sale2003 as
SELECT 
	p.productName, 
	sum(d.priceEach*d.quantityOrdered) as sales
FROM products p, orderdetails d, orders o
WHERE 
	p.productCode=d.productCode AND
    o.orderNumber=d.orderNumber AND
    YEAR(o.orderDate)=2003
GROUP BY p.productName;

SELECT 
	a.productName, 
	a.sales as sale2004, 
    b.sales as sale2003,
    a.sales/b.sales as ratio
FROM sale2004 a, sale2003 b
WHERE  a.productName=b.productName;

#26 Compute the ratio of payments for each customer for 2003 versus 2004.

WITH paymentyear as
(
SELECT 
	customerNumber, 
	sum(amount) as payment,
    Year(paymentDate) as year
FROM payments
GROUP BY customerNumber, Year(paymentDate)
)
SELECT 
	a.customerNumber,
    a.payment/b.payment as Ratio
FROM 
	paymentyear a, 
    paymentyear b
WHERE 
	a.customerNumber = b.customerNumber AND
	a.Year = 2004 AND
    b.Year = 2003;
    
#27 Find the products sold in 2003 but not 2004.

WITH productyear as
(
SELECT 
	d.productCode, 
    Year(o.orderDate) as year
FROM orderDetails d
LEFT JOIN orders o
ON o.orderNumber=d.orderNumber
GROUP BY productCode, year
)
SELECT 
	a.productCode, a.year as year1, b.year as year2
FROM 
	productyear a
LEFT Join
    productyear b
ON 
	a.productCode = b.productCode AND
	a.year=2003 and 
    b.year=2004
HAVING year1=2003 AND year2 IS NULL;


#28 Find the customers without payments in 2003.
SELECT 
	c.customerName, Year(p.paymentDate) as year
FROM 
	customers c
LEFT Join
    payments p
ON 
	c.customerNumber = p.customerNumber AND
    Year(p.paymentDate)=2003
HAVING year IS NULL;

#Correlated subqueries

#1 Who reports to Mary Patterson?
SELECT * 
FROM employees e, employees m
WHERE 
	e.reportsTo=m.employeeNumber AND
    m.firstName='Mary' AND
    m.lastName='Patterson';

#2 Which payments in any month and year are more than twice the average for that month and year 
#(i.e. compare all payments in Oct 2004 with the average payment for Oct 2004)? 
#Order the results by the date of the payment. You will need to use the date functions.

WITH averagepayment as
(
SELECT AVG(amount) as average, Month(paymentDate) as month, Year(paymentDate) as year
FROM payments
GROUP BY month, year
ORDER BY year, month
)
SELECT *
FROM payments p, averagepayment a
WHERE 
	Month(p.paymentDate)=a.month AND
    Year(p.paymentDate)=a.year AND
    p.amount > a.average*2
ORDER BY p.paymentdate;   



#3 Report for each product, the percentage value of its stock on hand as a percentage 
#of the stock on hand for product line to which it belongs. Order the report 
#by product line and percentage value within product line descending. 
#Show percentages with two decimal places.

WITH productlineValue as
(
SELECT productLine, SUM(quantityInStock*MSRP) as linevalue
FROM products 
GROUP BY productLine
)

SELECT 
	p.productName, 
    p.productLine, 
    CAST(quantityInStock*MSRP/l.linevalue*100 AS DEC(10,2))AS Percentage
FROM products p, productlineValue l
WHERE p.productLine=l.productLine
ORDER BY p.productline;

#4 For orders containing more than two products, 
#report those products that constitute more than 50% of the value of the order.

WITH ordervalue as
(
SELECT orderNumber, SUM(quantityOrdered*priceEach) as ordervalue
FROM orderdetails
GROUP by orderNumber
HAVING count(*)>2
)
SELECT productCode, quantityOrdered*priceEach as productvalue, v.ordervalue
FROM orderdetails o, ordervalue v
WHERE  
	o.orderNumber=v.orderNumber
HAVING productvalue > 0.5*v.ordervalue
    

