-- PJME Electricity Load Data: Database Setup & Import
-- Loads raw hourly load data from CSV into MySQL for analysis

CREATE DATABASE electricity_data;
USE electricity_data;

-- Staging table to hold raw imported data
CREATE TABLE temp_pjme_data (
    Datetime VARCHAR(50),
    PJME_MW DECIMAL(10,2)
);

-- Import CSV into staging table
-- NOTE: Update this file path to match your own system before running
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pjme_hourly.csv'
INTO TABLE temp_pjme_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Datetime, PJME_MW);

-- Final table with proper DATETIME type
CREATE TABLE pjme_data (
    Datetime DATETIME,
    PJME_MW DECIMAL(10,2)
);

-- Convert and insert cleaned data from staging table
INSERT INTO pjme_data (Datetime, PJME_MW)
SELECT STR_TO_DATE(Datetime, '%m/%d/%Y %H:%i'), PJME_MW
FROM temp_pjme_data;

-- Verify import
SELECT * FROM pjme_data LIMIT 10;

-- Cleanup: remove staging table now that data is in the final table
DROP TABLE temp_pjme_data;
