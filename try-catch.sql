-- TRY & CATCH 

BEGIN TRY
    SELECT 1 / 0;
END TRY
BEGIN CATCH
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
    PRINT ERROR_NUMBER();     -- Error number
    PRINT ERROR_SEVERITY();   -- Severity level
    PRINT ERROR_STATE();      -- State number
    PRINT ERROR_PROCEDURE();  -- Procedure name (if applicable)
END CATCH;


-- Trigger: block inserting or updating orders with a future date
CREATE TRIGGER trg_BlockFutureDate
ON Orders
AFTER INSERT, UPDATE
AS
BEGIN
    -- If any new or updated order has a date in the future, raise an error and rollback
    IF EXISTS (
        SELECT 1 FROM inserted WHERE order_date > GETDATE()
    )
    BEGIN
        RAISERROR('Invalid date: order_date can''t be from the future!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


-- TRY & CATCH block: attempting to insert an order with a future date
BEGIN TRY
    INSERT INTO Orders (customer_id, employee_id, order_date, total_amount)
    VALUES (2, 4, DATEADD(day, 2, GETDATE()), 200);
    
    PRINT 'Insert succeeded';
END TRY
BEGIN CATCH
    PRINT 'Error caught: ' + ERROR_MESSAGE();
END CATCH;
