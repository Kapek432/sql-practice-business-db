-- Temp Tables

-- Create a local temp table manually with CREATE TABLE
-- # -> local to the current session
-- ## -> global, visible to all sessions

CREATE TABLE #TopCustomers ( 
    customer_id INT,
    total_spent MONEY
);

-- Insert total spending per customer into the temp table
INSERT INTO #TopCustomers
SELECT customer_id, SUM(total_amount)
FROM Orders
GROUP BY customer_id;

-- Get the top 5 customers by total amount spent
SELECT TOP 5 tc.customer_id, c.name, tc.total_spent
FROM #TopCustomers tc
JOIN Customers c ON c.id = tc.customer_id
ORDER BY total_spent DESC;

-- Drop the temp table
DROP TABLE #TopCustomers;



-- Create a temp table using SELECT INTO
-- Premium employees: salary above company average

SELECT
    e.id,
    e.first_name + ' ' + e.last_name AS employee_name,
    e.salary
INTO #PremiumEmployees
FROM Employees e
WHERE e.salary > (
    SELECT AVG(salary) FROM Employees
);

-- View the contents of the temp table
SELECT * FROM #PremiumEmployees;

-- Drop it
DROP TABLE #PremiumEmployees;



-- Select all orders from year 2024 into a temp table

SELECT *
INTO #Orders_2024
FROM Orders
WHERE YEAR(CAST(order_date AS DATE)) = 2024;

-- Query the result
SELECT * FROM #Orders_2024;

-- Drop the table after use
DROP TABLE #Orders_2024;



-- Average salary by department into temp table

SELECT 
    department_id,
    AVG(salary) AS avg_salary
INTO #AvgSalaries
FROM Employees
GROUP BY department_id;

-- List employees whose salary is above department average
SELECT 
    e.first_name + ' ' + e.last_name AS employee,
    e.salary,
    d.name AS department,
    a.avg_salary
FROM Employees e
JOIN Departments d ON e.department_id = d.id
JOIN #AvgSalaries a ON e.department_id = a.department_id
WHERE e.salary > a.avg_salary;

DROP TABLE #AvgSalaries;