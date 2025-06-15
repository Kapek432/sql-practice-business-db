-- Functions - Scalar & Table-Valued Functions

-- Scalar function: returns length of employment in days for given employee ID
CREATE FUNCTION dbo.GetLengthOfEmployment(@emp_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @days INT;

    SELECT @days = DATEDIFF(DAY, hire_date, GETDATE())
    FROM dbo.Employees
    WHERE id = @emp_id;

    RETURN @days;
END;

-- Example call
SELECT dbo.GetLengthOfEmployment(3) AS days_employed;


-- Scalar function: returns number of orders placed after the specified date
CREATE FUNCTION dbo.GetNumberOfOrdersAfter(@date DATE)
RETURNS INT
AS
BEGIN
    DECLARE @count INT;

    SELECT @count = COUNT(*)
    FROM dbo.Orders
    WHERE order_date > @date;

    RETURN @count;
END;

-- Example call
SELECT dbo.GetNumberOfOrdersAfter('2024-01-01') AS OrdersAfter2024;


-- Inline Table-Valued Function: returns all orders for given customer ID
CREATE FUNCTION dbo.GetOrdersByCustomer(@cust_id INT)
RETURNS TABLE
AS
RETURN (
    SELECT * 
    FROM dbo.Orders 
    WHERE customer_id = @cust_id
);

-- Example call
SELECT * FROM dbo.GetOrdersByCustomer(2);


-- Multi-statement Table-Valued Function: returns orders by department with total_amount above threshold
CREATE FUNCTION dbo.OrdersRealizedByDepartmentAboveThreshold(
    @dep_name NVARCHAR(100), 
    @thr MONEY
)
RETURNS @result TABLE (
    order_id INT,
    order_date DATE,
    amount_paid DECIMAL(10,2)
)
AS
BEGIN
    INSERT INTO @result
    SELECT o.id, o.order_date, o.total_amount
    FROM dbo.Orders o
    JOIN dbo.Employees e ON o.employee_id = e.id
    JOIN dbo.Departments d ON d.id = e.department_id
    WHERE d.name = @dep_name AND o.total_amount > @thr;

    RETURN;
END;

-- Example call
SELECT * FROM dbo.OrdersRealizedByDepartmentAboveThreshold('Sales', 400);
