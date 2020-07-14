
select distinct productLine from classicmodels.products;

use classicmodels;

#single entity
#1
SELECT * FROM offices 
ORDER BY country, state, city;

#2
SELECT COUNT(employeeNumber)
FROM employees;

#3
SELECT SUM(amount)
FROM payments;

#4
SELECT DISTINCT productLine 
FROM products
WHERE productLine LIKE '%Cars%';

#5
SELECT sum(amount)
FROM payments 
WHERE paymentDate='2004-10-28';

#6
SELECT *
FROM payments
WHERE amount > 100000;

#7 ???????
SELECT productName, productLine
FROM products
ORDER BY productLine;

#8
SELECT productLine, COUNT(productName) as productNumber
FROM products
Group by productLine;

#9
SELECT MIN(amount)
FROM payments;

#10
SELECT *
FROM payments
WHERE amount < (SELECT AVG(amount) FROM payments);


#11
SELECT AVG((MSRP-buyPrice)/buyPrice)
FROM products;

#12
SELECT COUNT(DISTINCT productName)
from products;

#13
SELECT customerName, city
FROM customers
WHERE salesRepEmployeeNumber IS NULL;

#14 
SELECT CONCAT(firstName, ' ', lastName) as Name
FROM employees
WHERE jobTitle like '%VP%' or jobTitle like '%Manager%';

#15
SELECT *
FROM orderdetails
WHERE quantityOrdered*priceEach > 5000;

#one to many

#1
SELECT 
	c.customerNumber, c.customerName, c.salesRepEmployeeNumber, 
	CONCAT(e.firstName,' ', e.lastName) as RepNAME
FROM customers c, employees e
WHERE c.salesRepEmployeeNumber=e.employeeNumber;

#2
SELECT c.customerNumber,c.customerName, sum(p.amount)
FROM customers c, payments p
WHERE c.customerNumber = p.customerNumber and c.customerName='Atelier graphique'
GROUP BY c.customerNumber;

#3
SELECT paymentDate, sum(amount) as totalPayment
FROM payments
GROUP BY paymentDate;

#4
SELECT p.productName, o.quantityOrdered 
FROM products p
LEFT JOIN orderdetails o
ON o.productCode=p.productCode
WHERE o.quantityOrdered IS NULL;

#5
SELECT p.customerNumber, c.customerName, sum(p.amount) as totalAmount
FROM payments p, customers c
WHERE p.customerNumber = c.customerNumber
GROUP BY p.customerNumber;

#6
SELECT c.customerName, count(*) as orderCount
FROM customers c, orders o
WHERE c.customerNumber = o.customerNumber and c.customerName='Herkku Gifts'
GROUP BY c.customerNumber;

#7
SELECT e.employeeNumber, e.lastName, e.firstName
FROM employees e, offices o
WHERE o.officeCode=e.officeCode and o.city="Boston";

#8
SELECT p.customerNumber, c.customerName, p.amount
FROM payments p, customers c
WHERE p.customerNumber=c.customerNumber and p.amount >100000
ORDER BY amount DESC;

#9
SELECT o.orderNumber as onHoldOrder, sum(d.quantityOrdered*d.priceEach) as Value
FROM orders o, orderdetails d
WHERE o.status ='On Hold' and o.orderNumber=d.orderNumber  
GROUP BY onHoldOrder;

#10
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
FROM customers
WHERE customerName like '%Diecast';



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

#9

