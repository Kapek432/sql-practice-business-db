-- Views

DROP VIEW IF EXISTS vw_OrderesPerMonth;

-- Create a view that aggregates the number of orders per year and month
CREATE VIEW vw_OrderesPerMonth AS
SELECT
    YEAR(order_date) as year,         
    MONTH(order_date) as month,       
    COUNT(*) as order_count           
FROM Orders
GROUP BY YEAR(order_date), MONTH(order_date);  

-- Query example: Get all orders counts for the year 2024 from the view
SELECT * 
FROM vw_OrderesPerMonth
WHERE year = 2024;


DROP VIEW IF EXISTS vw_Top10Customers;

-- Create a view showing top 10 customers by total amount spent
CREATE VIEW vw_Top10Customers AS
SELECT TOP 10
    c.id AS customer_id,              
    c.name AS customer_name,          
    SUM(p.amount_paid) AS total_spent 
FROM Customers c
JOIN Orders o ON c.id = o.customer_id           
JOIN Payments p ON p.order_id = o.id            
GROUP BY c.id, c.name                           
ORDER BY SUM(p.amount_paid) DESC;               

-- Query all top 10 customers with their total spending
SELECT *
FROM vw_Top10Customers;


DROP VIEW IF EXISTS vw_EmployeesWithDepartments;

-- Create a view that combines employee information with their department details
CREATE VIEW vw_EmployeesWithDepartments AS
SELECT
    e.id AS employee_id,                          
    e.first_name + ' ' + e.last_name AS employee_full_name, 
    d.name AS department_name,                    
    e.position                                     
FROM employees e
JOIN Departments d ON e.department_id = d.id;     

-- Query all employees with department info
SELECT *
FROM vw_EmployeesWithDepartments;


DROP VIEW IF EXISTS vw_SalesPerDepartment;

-- Create a view to calculate total income (sales) generated per department
CREATE VIEW vw_SalesPerDepartment AS
SELECT
    d.id AS department_id,                
    d.name AS department_name,            
    SUM(p.amount_paid) AS total_income    
FROM Departments d
JOIN Employees e ON d.id = e.department_id      
JOIN Orders o ON o.employee_id = e.id            
JOIN Payments p ON p.order_id = o.id            
GROUP BY d.id, d.name                           

-- Query total sales per department, ordered by income descending
SELECT *
FROM vw_SalesPerDepartment
ORDER BY total_income DESC;
