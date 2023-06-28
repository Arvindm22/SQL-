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
			PY.payment_method = PM.payment_method_id