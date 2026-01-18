USE cyclistic_db;

-- Drop the empty table if it exists
DROP TABLE IF EXISTS rides;

-- Create table with proper structure
CREATE TABLE rides (
    ride_id VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    ride_length_sec INT,
    ride_length_min DECIMAL(10,2),
    day_of_week INT,
    day_name VARCHAR(20),
    start_station_id VARCHAR(50),
    start_station_name VARCHAR(255),
    end_station_id VARCHAR(50),
    end_station_name VARCHAR(255),
    member_type VARCHAR(20),
    bike_id VARCHAR(50),
    gender VARCHAR(20),
    birth_year INT,
    age INT,
    start_lat DECIMAL(10,6),
    start_lng DECIMAL(10,6),
    end_lat DECIMAL(10,6),
    end_lng DECIMAL(10,6),
    rideable_type VARCHAR(50),
    quarter VARCHAR(20),
    year INT,
    month INT,
    hour INT,
    date DATE
);

-- Load data from CSV
LOAD DATA LOCAL INFILE '/Cyclistic_Case_Study/02_Cleaned_Data/cyclistic_cleaned_FINAL.csv'
INTO TABLE rides
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;