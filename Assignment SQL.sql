select 
	name,
	unit_price,
    (unit_price*1.1) AS New_price
from products;

select *
from orders
where order_date > '2019-01-01';

select *
from order_items
where order_id = 6 and  unit_price * quantity > 30;

SELECT *
FROM products 
WHERE quantity_in_stock IN (49, 38, 72);

SELECT *
FROM customers
WHERE birth_date BETWEEN '1990/01/01' AND '2000/01/01';

SELECT *
FROM customers
WHERE address LIKE '%TRAIL%' OR address LIKE '%Avenue%';
	
SELECT *
FROM customers
WHERE phone LIKE '%9';    

SELECT *
FROM customers
WHERE first_name REGEXP 'ELKA|AMBUR';

SELECT *
FROM customers
WHERE last_name REGEXP 'EY$|ON$';

SELECT *
FROM customers
WHERE last_name REGEXP '^MY|SE';

SELECT *
FROM customers
WHERE last_name REGEXP 'B[RU]';

SELECT *
FROM orders 
WHERE shipped_date IS NULL;

SELECT *, quantity*unit_price AS total_price
FROM order_items
WHERE order_id=2
ORDER BY total_price DESC;

-- LIMIT clause 
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;

-- Inner Joins
SELECT order_id, p.product_id, name, quantity, o.unit_price
FROM products p
JOIN order_items o  ON p.product_id = o.product_id;

-- Joining Muliple Tables
SELECT 
		PY.date,
        PY.invoice_id,
        PY.amount,
		c.client_id,
        c.name,
        PM.name
FROM payments PY
JOIN clients c ON 
		PY.client_id = c.client_id
JOIN payment_methods PM ON
			PY.payment_method = PM.payment_method_id;
            
  -- OUTER JOIN          
  SELECT p.product_id, name, o.quantity 
  FROM products p
  LEFT JOIN order_items o ON 
			p.product_id = o.product_id;

-- OUTER JOIN MULTIPLE TABLES
SELECT 	
	o.order_date,
    o.order_id,
    c.first_name,
    s.name as Shipper,
    os.name as Status
    
FROM orders o
LEFT JOIN  customers c ON
			o.customer_id = c.customer_id
LEFT JOIN shippers s ON
			o.shipper_id = s.shipper_id
JOIN order_statuses os ON
			o.status = os.order_status_id
ORDER BY os.name;

-- USING CLAUSE
SELECT 
		p.date,
        c.name as Client,
        p.amount,
        pym.name as Mode_of_Payment
FROM payments p
JOIN clients c
		USING(client_id)
JOIN payment_methods pym ON
			p.payment_method = pym.payment_method_id;

-- CROSS JOIN 
-- 1.Implicit Syntax
SELECT *
FROM shippers, products;
-- 2.EXPLICIT Syntax
SELECT *
FROM shippers
CROSS JOIN products;

-- UNIONS
SELECT 
	c.customer_id,
    c.first_name as Name,
    c.points,
    'BRONZE' as Medal
FROM customers c
WHERE points <2000
UNION
SELECT 
	customer_id,
    first_name as Name,
    points,
    'SILVER' as Medal
FROM customers 
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT 
	customer_id,
    first_name as Name,
    points,
    'GOLD' as Medal
FROM customers 
WHERE points >3000
ORDER BY Name;

-- Inserting Multiple Rows
INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES('Cricket Bat',100 , 3.25),
		('Hoodies', 50, 5.00 ),
        ('Snickers', 200 , 1.50);

-- Subqueries and creating copy of a table
CREATE TABLE invoices_archived AS
SELECT 
	c.name AS Client_name,
    i.invoice_id,
    i.number,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date
FROM clients c
JOIN invoices i USING(client_id)
WHERE payment_date IS NOT NULL;

-- Updating Multiple Rows
UPDATE customers
SET points=points+50
WHERE birth_date < '1990-01-01' ;

-- Subqueries in UPDATES
UPDATE orders
SET comments = "Gold Customer"
WHERE customer_id IN
			(SELECT c.customer_id
			FROM customers c
			WHERE points>3000);
            
-- AGGREGATE FUNCTIONS
SELECT 
		'First half of 2019' AS date_range,
        SUM(invoice_total) AS total_sales,
        SUM(payment_total) AS total_payments,
        SUM(invoice_total - payment_total) AS Difference
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT 
		'Second half of 2019' AS date_range,
        SUM(invoice_total) AS total_sales,
        SUM(payment_total) AS total_payments,
        SUM(invoice_total - payment_total) AS Difference
FROM invoices
WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT 
		'Total Year' AS date_range,
        SUM(invoice_total) AS total_sales,
        SUM(payment_total) AS total_payments,
        SUM(invoice_total - payment_total) AS Difference
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-12-31';

-- GROUP BY CLAUSE
SELECT 
		p.date,
        pm.name AS payment_method,
        SUM(p.amount) AS Total_payment
FROM payments p
JOIN payment_methods pm ON
			p.payment_method = pm.payment_method_id
GROUP BY date, pm.name
ORDER BY date;

-- Having Clause
SELECT 
		c.first_name,
		c.customer_id,
		c.state,
        SUM(oi.quantity * oi.unit_price) AS Total_amount
FROM customers c
JOIN orders o  USING(customer_id)
JOIN order_items oi USING (order_id)
GROUP BY c.customer_id, c.state
HAVING state = 'VA' AND Total_amount > 100;

-- ROLLUP Operator
SELECT
		pm.name as Payment_method,
        SUM(p.amount) AS Total_amount
FROM payments p
JOIN payment_methods pm ON
				p.payment_method = pm.payment_method_id
GROUP BY pm.name with rollup;

-- SUBQUERIES
SELECT 
		employee_id,
        first_name,
        last_name
FROM employees       
WHERE salary >(
SELECT 
		avg(salary)
FROM employees
);

-- IN OPERATOR 
SELECT *
FROM clients
WHERE client_id NOT IN (
		SELECT DISTINCT client_id
        FROM invoices
        );
        
SELECT 
	customer_id, 
    first_name, 
    last_name
FROM customers
WHERE customer_id in  (
	SELECT o.customer_id
    FROM order_items
    JOIN orders o  USING(order_id)
    WHERE product_id=3
)
ORDER BY customer_id;

-- CORRELATED SUBQUERIES
SELECT *
FROM invoices i
WHERE invoice_total > (
		Select AVG(invoice_total)
        FROM invoices
        WHERE client_id = i.client_id
        );
-- Exists Operator
SELECT *
FROM products p
WHERE NOT EXISTS (
	SELECT product_id
    FROM order_items
    WHERE product_id =p.product_id
);

-- Subqueries in SELECT Clause
SELECT 
		client_id,
        name,
        (Select sum(invoice_total) 
		FROM invoices
        WHERE client_id = c.client_id ) AS Total_sales,
        (Select avg(invoice_total) FROM invoices) AS Average,
        (Select Total_sales - Average) AS Difference
FROM clients c;

-- IFNULL AND COALESCE FUNCTIONS
SELECT 
		CONCAT(first_name, ' ', last_name) AS Customer_name,
		IFNULL(phone,'Unknown') AS Contact_no
FROM customers;

-- IF Function
SELECT
		DISTINCT product_id,
        name AS Product,
        COUNT(*) AS Orders,
        IF (COUNT(*) > 1, 'Many Times', 'Once') AS Frequency
FROM products P
JOIN order_items USING(product_id)
GROUP BY product_id, name;

-- CASE OPERATOR
SELECT 
		CONCAT(first_name, ' ', last_name) AS Customer_name,
        points,
        CASE
			WHEN points > 3000 THEN 'Gold'
            WHEN points > 2000 THEN 'Silver'
            ELSE 'Bronze'
		END AS Category
FROM customers
ORDER BY points;

-- Views
CREATE OR REPLACE VIEW client_balance AS
	SELECT 
			client_id,
            name AS customer,
            SUM((invoice_total - payment_total)) AS Balance
	FROM clients
    JOIN invoices USING (client_id)
    GROUP BY client_id, name
    ORDER BY client_id;
    
    -- Creating Stored Procedures
	DELIMITER $$
	CREATE PROCEDURE invoices_with_balance()
	BEGIN
			SELECT *
            FROM invoices
            WHERE invoice_total - payment_total > 0;
	END $$
    DELIMITER ;

-- Procedure with Parameters
DROP PROCEDURE IF EXISTS get_inovices_by_client;
DELIMITER $$
CREATE PROCEDURE get_invoices_by_client
( 
	client_id INT
)
BEGIN 
		SELECT *
        FROM invoices i
        WHERE i.client_id = client_id;
END$$
DELIMITER ;
CALL get_invoices_by_client(5);

-- DEFAULT PARAMETERS
DROP PROCEDURE IF EXISTS get_payments;
DELIMITER $$
CREATE PROCEDURE get_payments
(
	client_id INT,
    payment_method_id TINYINT
)
BEGIN	
		SELECT *
        FROM payments p
        WHERE P.client_id = IFNULL(client_id,p.client_id) AND 
        p.payment_method = IFNULL(payment_method_id ,p.payment_method);
END$$
DELIMITER ;
CALL get_payments(3,1)