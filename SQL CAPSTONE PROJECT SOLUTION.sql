SELECT * FROM SALESORDER
SELECT * FROM ORDERDETAILS
SELECT * FROM CUSTOMER
SELECT * FROM PRODUCTS

--Total Sales Revenue:

SELECT SUM(total_amount) AS total_sales
FROM SALESORDER
WHERE status = 'Completed';

--Top 5 Customers by Purchase Amount:

SELECT TOP 5 c.name, c.email, SUM(s.total_amount) AS total_spent
FROM CUSTOMER c
JOIN SALESORDER s ON c.customer_id = s.order_id
WHERE status = 'Completed'
GROUP BY c.name, c.email
ORDER BY total_spent DESC

--Monthly Sales Trend:
SELECT FORMAT(order_date, 'yyyy-MM') AS month, SUM(total_amount) AS monthly_sales
FROM SALESORDER
WHERE status = 'Completed'
GROUP BY FORMAT(order_date, 'yyyy-MM')
--OR
--Monthly Sales Trend:
SELECT DATENAME(MONTH, order_date) AS month, SUM(total_amount) AS total_sales
FROM SALESORDER
WHERE status = 'Completed'
GROUP BY DATENAME(MONTH, order_date), MONTH(order_date)
ORDER BY MONTH(order_date);

--Most Sold Products:

SELECT p.product_name, SUM(od.quantity) AS total_sold
FROM ORDERDETAILS od
JOIN PRODUCTS p ON od.product_id = p.product_id
JOIN SALESORDER s ON od.order_id = s.order_id
WHERE s.status = 'Completed'
GROUP BY p.product_name
ORDER BY total_sold DESC

--Average Order Value (AOV):

SELECT AVG(total_amount) AS avg_order_value
FROM SALESORDER
WHERE status = 'Completed';

--Customer Retention (Repeat Customers):

SELECT COUNT(DISTINCT customer_id) AS repeat_customers
FROM SALESORDER
WHERE customer_id IN (
    SELECT customer_id
    FROM SALESORDER
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
);

--Cancelled Orders by Month:
SELECT DATENAME(MONTH, order_date) AS month, COUNT(*) AS cancelled_orders
FROM SALESORDER
WHERE status = 'Cancelled'
GROUP BY DATENAME(MONTH, order_date), MONTH(order_date)
ORDER BY MONTH(order_date);

--Best-Selling Product Category:

SELECT p.category, SUM(od.quantity) AS total_sold
FROM ORDERDETAILS od
JOIN PRODUCTS p ON od.product_id = p.product_id
JOIN SALESORDER s ON od.order_id = s.order_id
WHERE s.status = 'Completed'
GROUP BY p.category
ORDER BY total_sold DESC

--Customers with No Orders:

SELECT c.name, c.email
FROM CUSTOMER c
LEFT JOIN SALESORDER s ON c.customer_id = s.customer_id
WHERE s.order_id IS NULL;

--Product Stock Status:

SELECT product_name, stock_quantity
FROM PRODUCTS
WHERE stock_quantity < 10
ORDER BY stock_quantity ASC;

