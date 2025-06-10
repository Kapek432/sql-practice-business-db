-- String Functions

-- Extract email domains from customer emails
SELECT 
    name, 
    SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) AS email_domain
FROM Customers;

-- Show Apple products with 'Apple' removed from the product name
SELECT 
    name, 
    TRIM(REPLACE(name, 'Apple', '')) AS short_name
FROM Products
WHERE name LIKE '%Apple%';

-- Show formatted employee info as a full string line
SELECT 
    first_name + ' ' + last_name + ', Role: ' + position +
    ', Working since ' + CONVERT(VARCHAR, hire_date, 23) AS employee_data
FROM Employees;

-- Generate short department codes from full department names
SELECT 
    name,
    CASE 
        WHEN LEN(name) <= 3 THEN name
        WHEN CHARINDEX(' ', name) > 0 THEN 
            LEFT(name, 1) + SUBSTRING(name, CHARINDEX(' ', name) + 1, 1)
        ELSE 
            LEFT(name, 3)
    END AS abbreviation
FROM Departments;

-- Find customers with more than one 'a' in their first name
SELECT 
    name
FROM Customers
WHERE LEN(LOWER(LEFT(name, CHARINDEX(' ', name + ' ') - 1))) 
    - LEN(REPLACE(LOWER(LEFT(name, CHARINDEX(' ', name + ' ') - 1)), 'a', '')) > 1;

-- Replace 'Manager' with 'Mgr' in position names
SELECT 
    first_name + ' ' + last_name AS full_name, 
    REPLACE(position, 'Manager', 'Mgr') AS short_position
FROM Employees;

-- Generate initials from employee name
SELECT 
    name,
    LEFT(name, 1) + '.' + 
    CASE 
        WHEN CHARINDEX(' ', name) > 0 
        THEN SUBSTRING(name, CHARINDEX(' ', name) + 1, 1) + '.' 
        ELSE ''
    END AS initials
FROM Customers;

-- Count characters in product names and sort by length
SELECT 
    name, 
    LEN(name) AS name_length
FROM Products
ORDER BY name_length DESC;

-- Find customers whose name contains a hyphen or apostrophe
SELECT 
    name 
FROM Customers
WHERE name LIKE '%''%' OR name LIKE '%-%';

-- Normalize product names to lowercase
SELECT 
    name, 
    LOWER(name) AS normalized_name
FROM Products;

-- Extract first name and last name into separate columns
SELECT 
    LEFT(name, CHARINDEX(' ', name + ' ') - 1) AS first_name,
    LTRIM(RIGHT(name, LEN(name) - CHARINDEX(' ', name + ' '))) AS last_name
FROM Customers
WHERE CHARINDEX(' ', name) > 0;
