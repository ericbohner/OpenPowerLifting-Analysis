-- Create the 'ipf' schema if it doesn't exist.
CREATE DATABASE IF NOT EXISTS ipf;

-- Use the 'ipf' schema
USE ipf;

-- For those of us who run scripts more than once
DROP TABLE IF EXISTS ipf;

-- Create the 'ipf' table with appropriate columns and data types
CREATE TABLE ipf (
    AthleteName VARCHAR(100),
    Sex CHAR(2),
    IPFEvent VARCHAR(3),
    Equipment VARCHAR(10),
    Age INT,
    AgeClass VARCHAR(6),
    BirthYearClass VARCHAR(6),
    Division VARCHAR(255),
    BodyweightKg DECIMAL(10, 2),
    WeightClassKg VARCHAR(10),
    Squat1Kg DECIMAL(10, 2),
    Squat2Kg DECIMAL(10, 2),
    Squat3Kg DECIMAL(10, 2),
    Squat4Kg DECIMAL(10, 2),
    Best3SquatKg DECIMAL(10, 2),
    Bench1Kg DECIMAL(10, 2),
    Bench2Kg DECIMAL(10, 2),
    Bench3Kg DECIMAL(10, 2),
    Bench4Kg DECIMAL(10, 2),
    Best3BenchKg DECIMAL(10, 2),
    Deadlift1Kg DECIMAL(10, 2),
    Deadlift2Kg DECIMAL(10, 2),
    Deadlift3Kg DECIMAL(10, 2),
    Deadlift4Kg DECIMAL(10, 2),
    Best3DeadliftKg DECIMAL(10, 2),
    TotalKg DECIMAL(10, 2),
    Place VARCHAR(5),
    Dots DECIMAL(10, 2),
    Wilks DECIMAL(10, 2),
    Glossbrenner DECIMAL(10, 2),
    Goodlift DECIMAL(10, 2),
    Tested VARCHAR(10),
    Country VARCHAR(255),
    CountryState VARCHAR(255),
    Federation VARCHAR(255),
    ParentFederation VARCHAR(255),
    EventDate DATE,
    MeetCountry VARCHAR(255),
    MeetState VARCHAR(255),
    MeetTown VARCHAR(255),
    MeetName VARCHAR(255)
);

-- Find out where to save the csv in order to load it into my table
SHOW VARIABLES LIKE 'secure_file_priv';

-- Load data from the CSV file 'openipf-2023-08-05-ae3dc469'
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\openpl.csv'
INTO TABLE ipf
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Let's look at what we just created
DESCRIBE ipf;