-- View all employees and their absences
SELECT * FROM Employees;
SELECT * FROM EmployeeAbsences;

-- List of absences with employee full name and reason
SELECT e.first_name + ' ' + e.last_name AS fullname, a.absence_reason
FROM Employees e
JOIN EmployeeAbsences a ON e.id = a.employee_id;

-- Total number of absence days per employee
SELECT 
    e.id,
    e.first_name + ' ' + e.last_name AS fullname,
    SUM(DATEDIFF(DAY, a.absence_start, a.absence_end) + 1) AS TotalAbsenteismDays
FROM Employees e
JOIN EmployeeAbsences a ON e.id = a.employee_id
GROUP BY e.id, e.first_name, e.last_name
ORDER BY TotalAbsenteismDays DESC;

-- View all departments and number of employees in each
SELECT * FROM Departments;

SELECT d.name AS department_name, COUNT(e.id) AS number_of_employees
FROM Departments d
JOIN Employees e ON d.id = e.department_id
GROUP BY d.name
ORDER BY number_of_employees DESC;

-- View customers, orders, and payments
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Payments;

-- Top 5 customers by total value of orders
SELECT TOP (5)
    c.id, c.name, SUM(o.total_amount) AS Total_Spent
FROM Customers c
JOIN Orders o ON c.id = o.customer_id
GROUP BY c.id, c.name
ORDER BY Total_Spent DESC;

-- Payment statistics grouped by payment method
SELECT 
    p.payment_method AS PaymentMethod,
    COUNT(*) AS NumberOfPayments,
    MAX(p.amount_paid) AS MaxAmount,
    MIN(p.amount_paid) AS MinAmount,
    AVG(p.amount_paid) AS AvgAmount
FROM Payments p
GROUP BY p.payment_method;

-- View all products
SELECT * FROM Products;

-- Average price and count of products per category
SELECT category, AVG(price) AS average_price, COUNT(*) AS num_of_products
FROM Products
GROUP BY category;

-- Top 3 best-selling products by number of orders
SELECT TOP (3) p.name, COUNT(o.id) AS number_sold
FROM Products p
JOIN OrderItems i ON p.id = i.product_id
JOIN Orders o ON i.order_id = o.id
GROUP BY p.name
ORDER BY number_sold DESC;

-- Full order details with employee, customer, product and price
SELECT 
    o.id AS order_id,
    e.first_name + ' ' + e.last_name AS employee_name,
    c.name AS customer_name,
    p.name AS product_name,
    oi.quantity,
    oi.unit_price,
    o.order_date,
    oi.quantity * oi.unit_price AS line_total
FROM Orders o
JOIN Employees e ON o.employee_id = e.id
JOIN Customers c ON o.customer_id = c.id
JOIN OrderItems oi ON o.id = oi.order_id
JOIN Products p ON oi.product_id = p.id
ORDER BY o.id;

-- Top 5 employees by number of handled orders
SELECT TOP (5)
    e.first_name + ' ' + e.last_name AS employee_name,
    COUNT(o.id) AS orders_handled
FROM Employees e
JOIN Orders o ON e.id = o.employee_id
GROUP BY e.first_name, e.last_name
ORDER BY orders_handled DESC;

-- Employees who handled the highest number of unique customers
WITH UniqueClients AS (
    SELECT 
        e.id,
        e.first_name + ' ' + e.last_name AS fullname,
        COUNT(DISTINCT o.customer_id) AS unique_customers
    FROM Employees e
    JOIN Orders o ON e.id = o.employee_id
    GROUP BY e.id, e.first_name, e.last_name
)
SELECT *
FROM UniqueClients
WHERE unique_customers = (SELECT MAX(unique_customers) FROM UniqueClients);

-- Products that were never ordered
SELECT p.id, p.name
FROM Products p
LEFT JOIN OrderItems oi ON p.id = oi.product_id
WHERE oi.id IS NULL;

-- Customers who placed only one order
SELECT c.id, c.name, COUNT(o.id) AS order_count
FROM Customers c
JOIN Orders o ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING COUNT(o.id) = 1;

-- Monthly order volume and total sales value
SELECT 
    FORMAT(order_date, 'yyyy-MM') AS OrderMonth,
    COUNT(*) AS OrdersCount,
    SUM(total_amount) AS TotalValue
FROM Orders
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY OrderMonth;

-- Average number of products per order
SELECT 
    AVG(item_count) AS AvgItemsPerOrder
FROM (
    SELECT order_id, SUM(quantity) AS item_count
    FROM OrderItems
    GROUP BY order_id
) AS sub;

-- Top 3 departments by average employee salary
SELECT TOP (3) d.name AS department, AVG(e.salary) AS avg_salary
FROM Departments d
JOIN Employees e ON d.id = e.department_id
GROUP BY d.name
ORDER BY avg_salary DESC;
