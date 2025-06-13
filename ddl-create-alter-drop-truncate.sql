-- DDL (Data Definition Language)

-- Create table for storing customer feedback
CREATE TABLE CustomerFeedback (
	id INT IDENTITY PRIMARY KEY,
	customer_id INT NOT NULL,
	feedback_text NVARCHAR(400),
	created_at DATETIME DEFAULT GETDATE()
);

-- Add new column for rating
ALTER TABLE CustomerFeedback
ADD rating INT;

-- Modify column size (increase max text length)
ALTER TABLE CustomerFeedback
ALTER COLUMN feedback_text NVARCHAR(500);

-- Drop the 'rating' column
ALTER TABLE CustomerFeedback
DROP COLUMN rating;

-- Rename column: feedback_text → feedback
EXEC sp_rename 'CustomerFeedback.feedback_text', 'feedback', 'COLUMN';

-- Remove all rows from the table (keep structure)
TRUNCATE TABLE CustomerFeedback;

-- Drop table if it exists
DROP TABLE IF EXISTS CustomerFeedback;
