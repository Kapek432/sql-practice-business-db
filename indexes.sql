-- Indexes

-- Non-clustered index to speed up lookups by email
CREATE NONCLUSTERED INDEX idx_Customers_Email ON Customers(email);

SELECT * FROM Customers WHERE email = (SELECT email FROM Customers WHERE id = 1);

-- Clustered index defines the physical order of data in the table (only one allowed per table)
CREATE CLUSTERED INDEX idx_Orders_OrderDate ON Orders(order_date);

SELECT * FROM Orders ORDER BY order_date;

-- Unique index ensures that each email is unique
CREATE UNIQUE INDEX idx_Customers_UniqueEmail ON Customers(email);

-- Due to unique constraint, this will fail if the email already exists
INSERT INTO Customers (name, email, registration_date)
SELECT name + 'k', email, registration_date
FROM Customers
WHERE id = 1;

-- Composite index for queries filtering by customer_id and order_date
CREATE NONCLUSTERED INDEX idx_Orders_CustomerDate ON Orders(customer_id, order_date);

SELECT * FROM Orders WHERE customer_id = 5 AND order_date > '2023-01-01';

-- Filtered index for high-value orders
CREATE NONCLUSTERED INDEX idx_Orders_HighValue ON Orders(total_amount) WHERE total_amount > 1000;

SELECT * FROM Orders WHERE total_amount > 1000;

-- View indexes on a specific table
EXEC sp_helpindex 'Orders';

-- Drop all added indexes

DROP INDEX idx_Customers_Email ON Customers;
DROP INDEX idx_Customers_UniqueEmail ON Customers;
DROP INDEX idx_Orders_OrderDate ON Orders;
DROP INDEX idx_Orders_CustomerDate ON Orders;
DROP INDEX idx_Orders_HighValue ON Orders;
