-- Triggers

-- Create a log table to store details of deleted orders along with deletion timestamp
CREATE TABLE DeletedOrdersLog (
	order_id INT,
	customer_id INT,
	employee_id INT,
    order_date DATETIME,
    total_amount DECIMAL(10,2),
    deleted_at DATETIME DEFAULT GETDATE()
);

-- Trigger that logs deleted orders into DeletedOrdersLog table after an order is deleted
CREATE TRIGGER trg_LogDeletedOrder
ON Orders
AFTER DELETE
AS
BEGIN
	INSERT INTO DeletedOrdersLog (order_id, customer_id, employee_id, order_date, total_amount, deleted_at)
	SELECT id, customer_id, employee_id, order_date, total_amount, GETDATE()
	FROM deleted;
END;

-- Insert sample order
INSERT INTO Orders (customer_id, employee_id, order_date, total_amount)
VALUES (1, 2, GETDATE(), 450.00);

-- Delete the most recent order by max id (which will trigger trg_LogDeletedOrder)
DELETE FROM Orders
WHERE id = (
	SELECT MAX(id)
	FROM Orders
);

-- Check contents of DeletedOrdersLog to verify deleted order was logged
SELECT * 
FROM DeletedOrdersLog;


-- Trigger that prevents insertion or update of orders with negative total_amount
CREATE TRIGGER trg_BlockNegativeTotalAmount
ON Orders
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted WHERE total_amount < 0
    )
    BEGIN
        RAISERROR('total_amount cannot be less than 0.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- Attempt to insert an order with negative total_amount (will fail due to trigger)
INSERT INTO Orders (customer_id, employee_id, order_date, total_amount)
VALUES (1, 2, GETDATE(), -100.00);


-- Create table to store suspicious orders flagged for review
CREATE TABLE SuspiciousOrders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    order_date DATETIME,
    total_amount DECIMAL(10,2),
    flagged_at DATETIME DEFAULT GETDATE()
);

-- Trigger to flag newly inserted orders as suspicious if their total_amount
-- is at least 5 times greater than the maximum total_amount of existing orders
CREATE TRIGGER trg_FlagSuspiciousOrders
ON Orders
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	-- If there are no existing orders except newly inserted ones, do nothing
	IF NOT EXISTS(
		SELECT 1 FROM Orders WHERE id NOT IN (SELECT id FROM inserted)
	)
	BEGIN
		RETURN;
	END

	DECLARE @max_amount DECIMAL(10,2);

	-- Find max total_amount among existing orders (excluding newly inserted)
	SELECT @max_amount = MAX(total_amount)
	FROM Orders
	WHERE id NOT IN (SELECT id FROM inserted);

	-- Insert into SuspiciousOrders any inserted orders with total_amount
	-- at least 5 times greater than the existing max total_amount
	INSERT INTO SuspiciousOrders (order_id, customer_id, employee_id, order_date, total_amount)
    SELECT i.id, i.customer_id, i.employee_id, i.order_date, i.total_amount
    FROM inserted i
    WHERE i.total_amount >= 5 * @max_amount;

END;

-- Insert an order with very high total_amount to trigger suspicious flagging
INSERT INTO Orders (customer_id, employee_id, order_date, total_amount)
VALUES (1, 2, GETDATE(), 1000000.00);

-- Check SuspiciousOrders to verify the order was flagged
SELECT *
FROM SuspiciousOrders;
