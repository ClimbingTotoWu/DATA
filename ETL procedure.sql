
DELIMITER //
DROP PROCEDURE IF EXISTS ETLreportCustomer;
CREATE PROCEDURE ETLreportCustomer()
BEGIN
DROP TABLE IF EXISTS customersales;
CREATE TABLE IF NOT EXISTS customersales AS
	SELECT 
		o.customerNumber as ID,
		Month(orderdate) as Month, 
        Year(orderDate) as Year, 
        sum(priceEach*quantityOrdered) as sales
	FROM orderDetails d, orders o
	WHERE 
		d.orderNumber=o.orderNumber 
	GROUP BY YEAR(orderDate), Month(o.orderDate), o.customerNumber
    ORDER BY ID,YEAR, MONTH;
SELECT*FROM customersales;
END//

DELIMITER ;

CALL ETLreportCustomer();
