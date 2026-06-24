/*
                CUSTOMER SURVEY DATA CLEANING PROJECT
Objective:
Clean raw customer survey data imported from a CSV file by
handling missing values, standardizing text, formatting dates,
splitting address fields, removing duplicates, and preparing
the dataset for analysis.

*/


/* STEP 1 : VERIFY DATA IMPORT */

-- Count total rows imported from the CSV file
SELECT COUNT(*) AS total_rows
FROM survey;

-- Preview the raw dataset
SELECT * FROM survey;


/* STEP 2 : CREATE A WORKING COPY */

-- Create a duplicate table to perform cleaning
CREATE TABLE survey_clean AS
SELECT *
FROM survey;


/* STEP 3 : INITIAL DATA VALIDATION */

-- Count total records
SELECT COUNT(customer_id) AS total_records
FROM survey_clean;

-- Count unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM survey_clean;

-- Preview data
SELECT *
FROM survey_clean;


/* STEP 4 : REMOVE LEADING AND TRAILING SPACES */

SET SQL_SAFE_UPDATES = 0;

-- Remove extra spaces from Free Text Response
UPDATE survey_clean
SET freetext_response = TRIM(freetext_response);


/* STEP 5 : STANDARDIZE SERVICE FEEDBACK */

-- Check all unique values
SELECT DISTINCT service_feedback
FROM survey_clean;

-- Standardize inconsistent text values
UPDATE survey_clean
SET service_feedback =
CASE
    WHEN service_feedback LIKE 'Poor%' THEN 'Poor'
    WHEN service_feedback LIKE 'GOOD%' THEN 'Good'
    WHEN service_feedback LIKE 'Excellent%' THEN 'Excellent'
    WHEN service_feedback LIKE 'average%' THEN 'Average'
    ELSE NULL
END;

-- Replace missing feedback with "Excellent"
UPDATE survey_clean
SET service_feedback = 'Excellent'
WHERE service_feedback IS NULL;

UPDATE survey_clean
SET service_feedback = TRIM(service_feedback) ;

/* STEP 6 : STANDARDIZE DATE FORMAT */

-- Convert different date formats into YYYY-MM-DD
UPDATE survey_clean
SET survey_date =
CASE
    WHEN survey_date LIKE '%/%'
        THEN DATE_FORMAT(STR_TO_DATE(survey_date,'%Y/%m/%d'),'%Y-%m-%d')
    WHEN survey_date LIKE '__-__-____' 
		THEN DATE_FORMAT( STR_TO_DATE(survey_date,'%d-%m-%Y'), '%Y-%m-%d')
    ELSE survey_date
END;

-- Change datatype from TEXT to DATE
ALTER TABLE survey_clean
MODIFY COLUMN survey_date DATE;


/* STEP 7 : SPLIT ADDRESS INTO SEPARATE COLUMNS */

-- Create new columns
ALTER TABLE survey_clean
ADD COLUMN street VARCHAR(20),
ADD COLUMN city VARCHAR(20),
ADD COLUMN state VARCHAR(20);

-- Extract Street, City and State
UPDATE survey_clean
SET street = SUBSTRING_INDEX(address, ',', 1),
    city = TRIM( SUBSTRING_INDEX(
					SUBSTRING_INDEX(address, ',', 2),',',-1)),
    state = TRIM(SUBSTRING_INDEX(address, ',', -1));

/* STEP 8 : CREATE PREFERRED CONTACT COLUMN */

-- Preview Preferred Contact logic
SELECT email, phone,
    COALESCE(
        NULLIF(email,''),
        NULLIF(phone,''),
        'UNKNOWN'
    ) AS preferred_contact
FROM survey_clean;

-- Add new column
ALTER TABLE survey_clean
ADD COLUMN preferred_contact VARCHAR(40);

-- Populate Preferred Contact
UPDATE survey_clean
SET preferred_contact =
COALESCE(
    NULLIF(email,''),
    NULLIF(phone,''),
    'UNKNOWN'
);


/* STEP 9 : REMOVE DUPLICATE RECORDS */

-- Add Auto Increment Primary Key
ALTER TABLE survey_clean
ADD COLUMN survey_id INT AUTO_INCREMENT PRIMARY KEY;

-- Identify duplicate customer records
WITH duplicates AS
(
    SELECT
        survey_id,
        ROW_NUMBER() OVER( PARTITION BY customer_id ORDER BY survey_id) AS rnk
    FROM survey_clean
)
SELECT *
FROM duplicates
WHERE rnk > 1;

-- Delete duplicate records while keeping the first occurrence
WITH duplicates AS
(
    SELECT survey_id,
        ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY survey_id ) AS rnk
    FROM survey_clean
)
DELETE FROM survey_clean
WHERE survey_id IN
(
    SELECT survey_id FROM
    (
        SELECT survey_id
        FROM duplicates
        WHERE rnk > 1
    ) AS temp
);


/* STEP 10 : REMOVE UNUSED COLUMNS */

ALTER TABLE survey_clean
DROP COLUMN email,
DROP COLUMN phone,
DROP COLUMN address;


/* STEP 11 : FINAL DATA VALIDATION */

-- View cleaned dataset
SELECT *
FROM survey_clean;


-- Verify total records after cleaning
SELECT COUNT(*) AS final_record_count
FROM survey_clean;

-- Verify unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM survey_clean;

-- After Data Cleaning
SELECT * FROM survey_clean;

