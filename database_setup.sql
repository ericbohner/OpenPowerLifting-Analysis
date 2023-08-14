-- Create the 'openpl' schema if it doesn't exist.
CREATE DATABASE IF NOT EXISTS openpl;

-- Use the 'openpl' schema
USE openpl;

-- For those of us who run scripts more than once
DROP TABLE IF EXISTS openpl;

-- Create the 'ipf' table with appropriate columns and data types
CREATE TABLE openpl (
    MeetID INT,
    AthleteID INT,
    AthleteName VARCHAR(100),
    Sex CHAR(2),
    EventClass VARCHAR(3),
    Equipment VARCHAR(10),
    Age DECIMAL (10,2),
    AgeClass VARCHAR(6),
    BirthYearClass VARCHAR(6),
    Division VARCHAR(255),
    BodyweightKg DECIMAL(10, 2),
    WeightClassKg DECIMAL(10, 2),
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

-- Load data from the CSV file 'openpl.csv'
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\openpl.csv'
INTO TABLE openpl
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Let's look at what we just created
DESCRIBE openpl;

-- quick look at the data
SELECT *
FROM openpl
LIMIT 10;

-- We expect 2932694 rows.  Check to make sure.
SELECT COUNT(AthleteID)
FROM openpl;

-- I want to see something simple to see if numbers seem approximately correct
SELECT 
	Equipment,
    COUNT(AthleteID)
FROM openpl
GROUP BY Equipment;

-- Let's make sure these numbers add up to the total in our database
WITH equip_counts AS (
	SELECT 
		Equipment,
		COUNT(AthleteID) AS num_athletes
	FROM openpl
	GROUP BY Equipment
)
SELECT SUM(num_athletes) AS total_athletes
FROM equip_counts;


/* 
I'll now do some data normalization.  Since we are working with a large number of columns, many parts of this data
can be split into different tables to reduce data redundancies and make data maintenance much easier.
*/

CREATE TABLE Athletes (
    AthleteID INT PRIMARY KEY,
    AthleteName VARCHAR(100),
    Sex CHAR(2),
    -- Other attributes related to the athlete
);


CREATE TABLE Events (
    EventID INT PRIMARY KEY,
    IPFEvent VARCHAR(3),
    Equipment VARCHAR(10),
    -- Other attributes related to the event
);


CREATE TABLE WeightClasses (
    WeightClassID INT PRIMARY KEY,
    WeightClassKg DECIMAL(10, 2),
    -- Other attributes related to weight classes
);


CREATE TABLE AthleteWeightClasses (
    AthleteID INT,
    WeightClassID INT,
    PRIMARY KEY (AthleteID, WeightClassID),
    FOREIGN KEY (AthleteID) REFERENCES Athletes(AthleteID),
    FOREIGN KEY (WeightClassID) REFERENCES WeightClasses(WeightClassID)
);


CREATE TABLE Lifts (
    LiftID INT AUTO_INCREMENT PRIMARY KEY,
    AthleteID INT,
    EventID INT,
    Squat1Kg DECIMAL(10, 2),
    Squat2Kg DECIMAL(10, 2),
    Squat3Kg DECIMAL(10, 2),
    Bench1Kg DECIMAL(10, 2),
    Bench2Kg DECIMAL(10, 2),
    Bench3Kg DECIMAL(10, 2),
    Deadlift1Kg DECIMAL(10, 2),
    Deadlift2Kg DECIMAL(10, 2),
    Deadlift3Kg DECIMAL(10, 2),
    -- Other lift-specific attributes
    FOREIGN KEY (AthleteID) REFERENCES Athletes(AthleteID),
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);


CREATE TABLE MeetInfo (
    MeetID INT PRIMARY KEY,
    MeetCountry VARCHAR(255),
    MeetState VARCHAR(255),
    MeetTown VARCHAR(255),
    MeetName VARCHAR(255),
    EventDate DATE,
    -- Other attributes related to meet
);


CREATE TABLE AthleteMeet (
    AthleteID INT,
    MeetID INT,
    PRIMARY KEY (AthleteID, MeetID),
    FOREIGN KEY (AthleteID) REFERENCES Athletes(AthleteID),
    FOREIGN KEY (MeetID) REFERENCES MeetInfo(MeetID)
);



