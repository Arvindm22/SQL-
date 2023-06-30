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
			WHERE points>3000)