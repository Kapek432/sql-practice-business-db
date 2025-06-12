-- Pivot 

-- Static pivot: total amount paid by payment method 
SELECT *
FROM (
    SELECT 
        c.name AS customer,
        p.payment_method,
        p.amount_paid
    FROM Payments p
    JOIN Orders o ON p.order_id = o.id
    JOIN Customers c ON o.customer_id = c.id
) AS payment_data
PIVOT (
    SUM(amount_paid)
    FOR payment_method IN ([Cash], [Credit Card], [Bank Transfer], [PayPal])
) AS pivot_result;



-- Static pivot: total payment amount by month
SELECT *
FROM (
    SELECT 
        MONTH(CAST(o.order_date AS DATE)) AS month,
        p.amount_paid
    FROM Payments p
    JOIN Orders o ON p.order_id = o.id
) AS payments_by_month
PIVOT (
    SUM(amount_paid)
    FOR month IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) AS pivot_result;



-- Static pivot: count of orders by month
SELECT *
FROM (
    SELECT 
        MONTH(CAST(o.order_date AS DATE)) AS month,
        id AS order_id
    FROM Orders o 
) AS orders_per_month
PIVOT (
    COUNT(order_id)
    FOR month IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) AS pivot_result;



-- Static pivot: number of orders by customer and month
SELECT *
FROM (
    SELECT 
        c.name AS customer,
        MONTH(CAST(o.order_date AS DATE)) AS month,
        o.id AS order_id
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.id
) AS orders_by_customer
PIVOT (
    COUNT(order_id)
    FOR month IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) AS pivot_result;



-- Dynamic pivot: count of absences by reason
DECLARE @columns NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX);

-- Step 1: get all unique absence reasons and format them as [col1], [col2], ...
SELECT @columns = STRING_AGG(QUOTENAME(absence_reason), ',')
FROM (
    SELECT DISTINCT absence_reason
    FROM EmployeeAbsences
) AS reasons;

-- Step 2: build the dynamic SQL for pivoting
SET @sql = '
SELECT *
FROM (
	SELECT absence_reason, id AS absence_id
	FROM EmployeeAbsences
) AS source
PIVOT (
	COUNT(absence_id)
	FOR absence_reason IN (' + @columns + ')
) AS pivot_result;
';

-- Step 3: execute the dynamic SQL
EXEC sp_executesql @sql;
