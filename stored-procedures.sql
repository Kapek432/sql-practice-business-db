-- Stored Procedures

DROP PROCEDURE IF EXISTS usp_InsertCustomer;

-- Procedure to insert a new customer
CREATE PROCEDURE usp_InsertCustomer
	@name NVARCHAR(100),
	@email NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Customers (name, email, registration_date)
	VALUES (@name, @email, GETDATE());
END;
GO

EXEC usp_InsertCustomer @name = 'Anna Kowalska', @email = 'anna@example.com';
GO

SELECT * FROM Customers;


DROP PROCEDURE IF EXISTS usp_UpdateCustomerEmail;

-- Procedure to update a customer's email
CREATE PROCEDURE usp_UpdateCustomerEmail
	@id INT,
	@email NVARCHAR(100)
AS 
BEGIN
	SET NOCOUNT ON;

	UPDATE Customers
	SET email = @email
	WHERE id = @id;
END;
GO

EXEC usp_UpdateCustomerEmail @id = 31, @email = 'peter.lipiec@poczta.onet.pl';
GO

SELECT * FROM Customers WHERE id = 31;


DROP PROCEDURE IF EXISTS usp_InsertOrder;

-- Procedure to insert a new order with validation
CREATE PROCEDURE usp_InsertOrder
    @customer_id INT,
    @employee_id INT,
    @amount MONEY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @amount < 0
            THROW 50000, 'Amount must be non-negative.', 1;

        IF NOT EXISTS (SELECT 1 FROM Customers WHERE id = @customer_id)
            THROW 50001, 'Customer ID does not exist.', 1;

        IF NOT EXISTS (SELECT 1 FROM Employees WHERE id = @employee_id)
            THROW 50002, 'Employee ID does not exist.', 1;

        INSERT INTO Orders (customer_id, employee_id, order_date, total_amount)
        VALUES (@customer_id, @employee_id, GETDATE(), @amount);
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test valid order
EXEC usp_InsertOrder 2, 3, 200;
GO

-- Test invalid order (negative amount)
EXEC usp_InsertOrder 6, 7, -344;
GO

-- Test invalid order (nonexistent customer)
EXEC usp_InsertOrder 555, 7, 344;
GO


DROP PROCEDURE IF EXISTS usp_GetEmployeesByDepartment;

-- Procedure to return employees from a given department
CREATE PROCEDURE usp_GetEmployeesByDepartment
    @DepartmentID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		e.id AS employee_id,
        e.first_name,
        e.last_name,
        d.id AS department_id
    FROM Employees e
    JOIN Departments d ON e.department_id = d.id
    WHERE e.department_id = @DepartmentID;
END;
GO

EXEC usp_GetEmployeesByDepartment @DepartmentID = 2;
GO

DROP PROCEDURE IF EXISTS usp_CreateManagersTableWithSubordinates;

-- Procedure to return each manager and a list of their subordinates
CREATE PROCEDURE usp_CreateManagersTableWithSubordinates
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        m.id AS manager_id,
        m.first_name + ' ' + m.last_name AS manager_name,
        STRING_AGG(e.first_name + ' ' + e.last_name, ', ') AS subordinates
    FROM Employees m
    JOIN Employees e ON e.manager_id = m.id
    GROUP BY m.id, m.first_name, m.last_name;
END;
GO

EXEC usp_CreateManagersTableWithSubordinates;
GO
