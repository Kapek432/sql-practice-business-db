-- Window Functions

-- Top 3 products per category based on order value
WITH RankedProducts AS (
    SELECT 
        p.name, 
        p.category, 
        o.total_amount, 
        DENSE_RANK() OVER (PARTITION BY p.category ORDER BY o.total_amount DESC) AS price_by_category_rank
    FROM Products p
    JOIN OrderItems i ON p.id = i.product_id
    JOIN Orders o ON i.order_id = o.id
)
SELECT *
FROM RankedProducts
WHERE price_by_category_rank <= 3
ORDER BY category, price_by_category_rank;


-- Top 3 employees with highest salaries per department
WITH RankedSalaries AS (
    SELECT 
        first_name + ' ' + last_name AS employee,
        department_id,
        salary,
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
    FROM Employees
)
SELECT *
FROM RankedSalaries
WHERE salary_rank <= 3
ORDER BY department_id, salary_rank;


-- Order numbering per customer (chronological)
SELECT
    customer_id,
    order_date,
    total_amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_number
FROM Orders;


-- Total sales per customer using SUM() OVER()
SELECT
    customer_id,
    total_amount,
    SUM(total_amount) OVER (PARTITION BY customer_id) AS customer_total
FROM Orders;


-- Cumulative daily total sales (running total)
SELECT 
    CAST(order_date AS DATE) AS order_day,
    SUM(total_amount) AS daily_total,
    SUM(SUM(total_amount)) OVER (ORDER BY CAST(order_date AS DATE)) AS cumulative_total
FROM Orders
GROUP BY CAST(order_date AS DATE)
ORDER BY order_day;


-- Day-to-day difference in total sales
WITH DailySales AS (
    SELECT
        CAST(order_date AS DATE) AS order_day,
        SUM(total_amount) AS daily_total
    FROM Orders
    GROUP BY CAST(order_date AS DATE)
)
SELECT
    order_day,
    daily_total,
    LAG(daily_total) OVER (ORDER BY order_day) AS previous_day_total,
    daily_total - COALESCE(LAG(daily_total) OVER (ORDER BY order_day), 0) AS sales_difference
FROM DailySales
ORDER BY order_day;


-- Average order value compared to customer's total sales
SELECT 
    customer_id,
    order_date,
    total_amount,
    AVG(total_amount) OVER (PARTITION BY customer_id) AS avg_order_per_customer,
    SUM(total_amount) OVER (PARTITION BY customer_id) AS total_customer_sales
FROM Orders
ORDER BY customer_id, order_date;


-- Employee's salary compared to department average
SELECT 
    e.first_name + ' ' + e.last_name AS employee,
    d.name AS department,
    e.salary,
    AVG(e.salary) OVER (PARTITION BY e.department_id) AS avg_department_salary,
    e.salary - AVG(e.salary) OVER (PARTITION BY e.department_id) AS salary_difference
FROM Employees e
JOIN Departments d ON e.department_id = d.id
ORDER BY department, salary DESC;
