-- Self Join: list of employees and their managers
SELECT 
    e1.first_name + ' ' + e1.last_name AS employee, 
    COALESCE(e2.first_name + ' ' + e2.last_name, 'No manager') AS manager
FROM Employees e1
LEFT JOIN Employees e2 ON e1.manager_id = e2.id;

-- Union: combined list of customers and employees with roles
SELECT 
    LEFT(name, CHARINDEX(' ', name + ' ') - 1) AS first_name,
    LTRIM(RIGHT(name, LEN(name) - CHARINDEX(' ', name + ' '))) AS last_name,
    'Customer' AS role
FROM Customers

UNION ALL

SELECT 
    first_name,
    last_name,
    'Employee' AS role
FROM Employees

ORDER BY first_name;
