-- DML (Data Manipulation Language)

-- INSERT: Add one customer
INSERT INTO Customers (name, email, registration_date)
VALUES ('Kacper Lipiec', 'klipiec@gmail.com', GETDATE());

-- Check that the customer was inserted
SELECT *
FROM Customers
WHERE name = 'Kacper Lipiec';



-- INSERT: Add multiple products
INSERT INTO Products (name, category, price)
VALUES 
('iPhone 17', 'Smartphones', 6999),
('Galaxy S25', 'Smartphones', 6499),
('Lenovo Yoga 9i', 'Laptops', 7499);



-- UPDATE: Set a minimum salary threshold
DECLARE @min_salary MONEY = 4000;

UPDATE Employees
SET salary = @min_salary
WHERE salary < @min_salary;

-- UPDATE: Increase salary for Sales Managers by 10%
UPDATE Employees
SET salary = salary * 1.1
WHERE position = 'Sales Manager';



-- DELETE: Remove customers who spent less than 50 in total
DELETE FROM Customers
WHERE id IN (
	SELECT customer_id
	FROM Orders
	GROUP BY customer_id
	HAVING SUM(total_amount) < 50
);

-- DELETE: Remove unpaid orders older than one year
DELETE FROM Orders
WHERE id NOT IN (
	SELECT order_id
	FROM Payments
)
AND order_date < DATEADD(YEAR, -1, GETDATE());



-- MERGE: Add or update department
MERGE INTO Departments AS target
USING (
	SELECT 'AI Department' AS name, 'Sandomierz' AS location
) AS source
ON target.name = source.name
WHEN MATCHED THEN 
	UPDATE SET target.location = source.location
WHEN NOT MATCHED THEN
	INSERT (name, location)
	VALUES (source.name, source.location);



-- MERGE: Add or update product list from temp table
CREATE TABLE #NewProducts (
	name NVARCHAR(100),
	category NVARCHAR(100),
	price MONEY
);

INSERT INTO #NewProducts (name, category, price)
VALUES 
('iPhone 17', 'Smartphones', 7299),
('iPad Air M2', 'Tablets', 4699),
('Apple Watch X', 'Wearables', 3899);

MERGE INTO Products AS target
USING #NewProducts AS source
ON target.name = source.name
WHEN MATCHED THEN
	UPDATE SET 
		target.category = source.category,
		target.price = source.price
WHEN NOT MATCHED THEN
	INSERT (name, category, price)
	VALUES (source.name, source.category, source.price);

DROP TABLE #NewProducts;
