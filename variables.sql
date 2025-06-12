-- Variables

-- Declare and set a simple threshold variable
DECLARE @my_salary MONEY;
SET @my_salary = 5000;

-- Select employees earning less than @my_salary
SELECT 
    first_name + ' ' + last_name AS employee,
    salary
FROM Employees
WHERE salary < @my_salary;



-- Declare and assign variable with SELECT (average salary)
DECLARE @avg_salary MONEY;
SELECT @avg_salary = AVG(salary) FROM Employees;

-- Select employees earning more than average
SELECT 
    first_name + ' ' + last_name AS employee,
    salary,
    @avg_salary AS avg_salary
FROM Employees
WHERE salary > @avg_salary;



-- Find the most frequently ordered product category
DECLARE @most_frequent_category NVARCHAR(100);

SELECT TOP 1 @most_frequent_category = category
FROM Products p
JOIN OrderItems i ON p.id = i.product_id
GROUP BY category
ORDER BY COUNT(*) DESC;

-- Use that value in a query
SELECT name, price
FROM Products
WHERE category = @most_frequent_category;



-- Combine multiple variables to customize query behavior
DECLARE @top_n INT = 3;
DECLARE @min_orders INT = 2;

-- Show top @top_n customers who made at least @min_orders orders
SELECT TOP (@top_n)
    c.name,
    COUNT(o.id) AS order_count
FROM Customers c
JOIN Orders o ON o.customer_id = c.id
GROUP BY c.id, c.name
HAVING COUNT(o.id) >= @min_orders
ORDER BY order_count DESC;



-- Use variable to filter by specific month (e.g. June)
DECLARE @june INT = 6;

SELECT *
FROM Orders
WHERE MONTH(CAST(order_date AS DATE)) = @june;
