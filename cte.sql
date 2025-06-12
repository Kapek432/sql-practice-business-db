-- CTE 

-- Top 3 employees by estimated total salary cost (salary × months of work)
WITH HighExpenses AS (
    SELECT 
        id,
        first_name + ' ' + last_name AS name,
        salary,
        DATEDIFF(MONTH, hire_date, GETDATE()) AS months_of_work,
        salary * DATEDIFF(MONTH, hire_date, GETDATE()) AS total_earnings
    FROM Employees
)
SELECT TOP (3) *
FROM HighExpenses
ORDER BY total_earnings DESC;


-- Top 3 customers by total amount spent
WITH CustomerTotals AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
)
SELECT TOP (3) c.name, ct.total_spent
FROM CustomerTotals ct
JOIN Customers c ON c.id = ct.customer_id
ORDER BY total_spent DESC;


-- Number of orders handled by each employee
WITH OrderCounts AS (
    SELECT 
        employee_id,
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY employee_id
)
SELECT 
    e.first_name + ' ' + e.last_name AS employee,
    order_count
FROM OrderCounts oc
JOIN Employees e ON e.id = oc.employee_id
ORDER BY order_count DESC;


-- Products that were never ordered
WITH OrderedProducts AS (
    SELECT DISTINCT product_id
    FROM OrderItems 
)
SELECT p.id, p.name
FROM Products p
LEFT JOIN OrderedProducts o ON p.id = o.product_id
WHERE o.product_id IS NULL;


-- Split customer full name into first name and last name
WITH SplitNames AS (
    SELECT 
        id,
        LEFT(name, CHARINDEX(' ', name + ' ') - 1) AS first_name,
        LTRIM(RIGHT(name, LEN(name) - CHARINDEX(' ', name + ' '))) AS last_name
    FROM Customers
)
SELECT * FROM SplitNames;


-- Recursive CTE: employee-manager hierarchy
WITH EmployeeHierarchy AS (
    SELECT 
        id,
        first_name + ' ' + last_name AS employee,
        manager_id,
        0 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT 
        e.id,
        e.first_name + ' ' + e.last_name AS employee,
        e.manager_id,
        h.level + 1
    FROM Employees e
    JOIN EmployeeHierarchy h ON e.manager_id = h.id
)
SELECT *
FROM EmployeeHierarchy
ORDER BY level, employee;


-- Recursive CTE: generate numbers from 1 to 100
WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 100
)
SELECT * FROM Numbers
OPTION (MAXRECURSION 0);


-- Recursive CTE: powers of 2 up to 1024
WITH Power2 AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n * 2 FROM Power2 WHERE n < 1024
)
SELECT * FROM Power2
OPTION (MAXRECURSION 0);


-- Recursive CTE: Fibonacci sequence (first 20 steps)
WITH Fibonacci AS (
    SELECT 0 AS a, 1 AS b, 1 AS step
    UNION ALL
    SELECT b, a + b, step + 1
    FROM Fibonacci
    WHERE step < 20
)
SELECT * FROM Fibonacci
OPTION (MAXRECURSION 0);


-- Recursive CTE: generate list of dates for the last 30 days
WITH Dates AS (
    SELECT CAST(GETDATE() - 29 AS DATE) AS dt
    UNION ALL
    SELECT DATEADD(DAY, 1, dt)
    FROM Dates
    WHERE dt < CAST(GETDATE() AS DATE)
)
SELECT * FROM Dates
OPTION (MAXRECURSION 0);
