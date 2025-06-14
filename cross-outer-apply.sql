-- Cross / Outer Apply

-- Select customers with their most recent order using CROSS APPLY 
-- Only customers who have at least one order will appear
SELECT 
    c.id AS customer_id, 
    c.name AS customer_name,
    o.id AS last_order_id,
    o.order_date AS last_order_date
FROM Customers c
CROSS APPLY (
    SELECT TOP 1 o.id, o.order_date
    FROM Orders o
    WHERE o.customer_id = c.id
    ORDER BY o.order_date DESC
) o;

-- Insert a new customer without any orders
INSERT INTO Customers 
VALUES('Kacper Lipiec', 'mymail@gmail.pl', GETDATE());

-- Select customers with their most recent order using OUTER APPLY
-- All customers will appear, even those without any orders (last_order_id and date will be NULL)
SELECT 
    c.id AS customer_id, 
    c.name AS customer_name,
    o.id AS last_order_id,
    o.order_date AS last_order_date
FROM Customers c
OUTER APPLY (
    SELECT TOP 1 o.id, o.order_date
    FROM Orders o
    WHERE o.customer_id = c.id
    ORDER BY o.order_date DESC
) o;

-- Insert a new order for new inserted customer with ID 31 and employee with ID 2
INSERT INTO Orders 
VALUES (31, 2, GETDATE(), 400);

-- Select customers with their most recent order and total amount paid for that order
-- If they haven't paid, there will be NULL
SELECT 
    c.id AS customer_id,
    c.name AS customer_name,
    o.id AS last_order_id,
    o.order_date,
    p.total_paid
FROM Customers c
CROSS APPLY (
    SELECT TOP 1 o.id, o.order_date
    FROM Orders o
    WHERE o.customer_id = c.id
    ORDER BY o.order_date DESC
) o
OUTER APPLY (
    SELECT SUM(amount_paid) AS total_paid
    FROM Payments p
    WHERE p.order_id = o.id
) p;