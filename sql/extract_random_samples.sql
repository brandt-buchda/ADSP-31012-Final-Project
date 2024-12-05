-- Step 1: Get Total Rows
SELECT COUNT(*) INTO @total_rows FROM chicago_taxi.taxi_trips_2019_raw;

-- Step 2: Create and Populate a Temporary Table with Random Row Numbers
CREATE TEMPORARY TABLE  random_numbers (row_id INT);

-- Attempt to populate this table with unique random numbers
DROP PROCEDURE IF EXISTS GenerateUniqueRandomRows;

CREATE PROCEDURE GenerateUniqueRandomRows()
BEGIN
    -- Declare variable to track remaining rows needed
    DECLARE remaining_rows INT;
    DECLARE sample_count INT;
    SET sample_count = 1000;

    -- Clear any existing data
    TRUNCATE TABLE random_numbers;

    -- First attempt to get random rows
    INSERT INTO random_numbers (row_id)
    SELECT DISTINCT FLOOR(1 + RAND() * @total_rows) AS random_row
    FROM information_schema.tables
    LIMIT sample_count;

    -- Calculate remaining rows needed
    SET remaining_rows =@sample_count - (SELECT COUNT(DISTINCT row_id) FROM random_numbers);

    -- Continue adding rows until we have exactly 10,000
    WHILE remaining_rows > 0 DO
        INSERT IGNORE INTO random_numbers (row_id)
        SELECT DISTINCT FLOOR(1 + RAND() * @total_rows) AS random_row
        FROM information_schema.tables
        LIMIT remaining_rows;

        -- Recalculate remaining rows
        SET remaining_rows = sample_count - (SELECT COUNT(DISTINCT row_id) FROM random_numbers);
    END WHILE;
END;

-- Call the procedure
CALL GenerateUniqueRandomRows();

-- Verify the number of unique rows
SELECT COUNT(DISTINCT row_id) AS unique_row_count FROM random_numbers;

-- Step 3: Select rows based on the random numbers generated in the temporary table
SELECT t.*
FROM chicago_taxi.taxi_trips_2019_raw t
INNER JOIN random_numbers r ON t.row_id = r.row_id;