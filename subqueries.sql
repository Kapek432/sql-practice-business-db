-- Subqueries

-- Employees with salary above the average salary in the company
SELECT 
    id,
    first_name + ' ' + last_name AS full_name,
    salary
FROM Employees
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
);

-- Customers who spent more than the average total amount across all customers
SELECT name
FROM Customers
WHERE id IN (
    SELECT customer_id
    FROM Orders 
    GROUP BY customer_id
    HAVING SUM(total_amount) > (
        SELECT AVG(total_amount)
        FROM Orders
    )
);

-- Products that have been ordered more than once
SELECT name
FROM Products
WHERE id IN (
    SELECT product_id
    FROM OrderItems
    GROUP BY product_id
    HAVING COUNT(*) > 1
);

-- Departments that have more employees than the average number per department
SELECT name
FROM Departments
WHERE id IN (
    SELECT department_id
    FROM Employees
    GROUP BY department_id
    HAVING COUNT(*) > (
        SELECT AVG(emp_count)
        FROM (
            SELECT COUNT(*) AS emp_count
            FROM Employees
            GROUP BY department_id
        ) AS sub
    )
);

-- Customers who have never placed an order (using NOT EXISTS)
SELECT name
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.id
);

-- Products that have been ordered 
SELECT name
FROM Products p
WHERE EXISTS (
    SELECT 1
    FROM OrderItems oi
    WHERE oi.product_id = p.id
);
