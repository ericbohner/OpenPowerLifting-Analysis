USE openpl;

-- sneak a peak
SELECT *
FROM openpl
LIMIT 10;

-- get an idea of the timeframe that is included in the database and how many events have been recorded
SELECT 
	MIN(EventDate) as earliest_event,
    MAX(EventDate) as latest_event,
    COUNT(DISTINCT(MeetID)) as num_events,
    COUNT(DISTINCT(AthleteID)) as num_athletes
FROM openpl;

-- identify the popularity of different equipment types (raw, single ply, multi, etc.)
SELECT
	Equipment,
    COUNT(DISTINCT(MeetID)) as num_meets, -- only count unique events
    COUNT(AthleteID) as num_athletes -- note, athletes can compete in multiple events and equip types
FROM openpl
GROUP BY Equipment
ORDER BY num_athletes DESC;

/* 
It looks like the most popular equipment types are singe-ply and raw.  I suspect, however, that this doesn't tell the whole story
since different year ranges will have differences in popularity for a given equipment type.  For instance, I think that raw has
become more popular recently (since, say, 2010?).  Let's check.
*/

SELECT
	Equipment,
    COUNT(DISTINCT(MeetID)) as num_meets, -- only count unique events
    COUNT(AthleteID) as num_athletes -- athletes can compete in multiple events
FROM openpl
WHERE YEAR(EventDate) >= 2010 
GROUP BY Equipment
ORDER BY num_athletes DESC;

/*
Note that there are now far more Raw events and competitors than single-ply. It also seems as though MOST of the raw events have
taken place after 2010, with 23,521 out of a total 25,640 raw events.  Since it covers years from 1964 - 2023, we can see that raw
events have almost entirely overtaken powerlifting in recent years.
*/


-- What is the current S/B/D and total record for each equipment type and weight class?

SET group_concat_max_len = 1000000;

DROP TABLE IF EXISTS CurrentRecordHolders;
CREATE TABLE CurrentRecordHolders AS
SELECT 
	Equipment
    , Sex 
    , WeightClassKg
    , MAX(Best3SquatKg) AS squat_record
    , SUBSTRING_INDEX(GROUP_CONCAT(DISTINCT AthleteName ORDER BY Best3SquatKg DESC), ',', 1) AS squat_record_holder
    , MAX(Best3BenchKg) AS bench_record
    , SUBSTRING_INDEX(GROUP_CONCAT(DISTINCT AthleteName ORDER BY Best3BenchKg DESC), ',', 1) AS bench_record_holder
    , MAX(Best3DeadliftKg) AS deadlift_record
    , SUBSTRING_INDEX(GROUP_CONCAT(DISTINCT AthleteName ORDER BY Best3DeadliftKg DESC), ',', 1) AS deadlift_record_holder
    , MAX(TotalKg) AS total_record
    , SUBSTRING_INDEX(GROUP_CONCAT(DISTINCT AthleteName ORDER BY TotalKg DESC), ',', 1) AS total_record_holder
FROM openpl
WHERE Place != 'DQ'
GROUP BY Equipment, Sex, WeightClassKg
ORDER BY Equipment, Sex, WeightClassKg;

SELECT *
FROM CurrentRecordHolders;

DESCRIBE openpl;

-- Who has the highest raw total?  Who has the highest DOTS?
SELECT
    CASE WHEN TotalKg = max_total_kg THEN AthleteName ELSE NULL END AS highest_total_kg_name,
    CASE WHEN Dots = max_dots THEN AthleteName ELSE NULL END AS highest_dots_name,
    max_total_kg AS highest_total_kg,
    max_dots AS highest_dots
FROM (
    SELECT
        AthleteName,
        TotalKg,
        Dots,
        MAX(TotalKg) OVER () AS max_total_kg,
        MAX(Dots) OVER () AS max_dots
    FROM openpl -- Replace with your actual table name
) AS subquery
WHERE TotalKg = max_total_kg OR Dots = max_dots;


-- Raw lifters only now:

SELECT AthleteName, TotalKg
FROM openpl
WHERE Equipment = 'Raw'
ORDER BY TotalKg Desc
LIMIT 1;

SELECT AthleteName, DOTS
FROM openpl
WHERE Equipment = 'Raw'
ORDER BY DOTS Desc
LIMIT 1;

-- How many "enhanced" lifters are there?

SELECT
	Tested
    , COUNT(distinct(AthleteID))
FROM openpl
GROUP BY Tested;


-- How many people attend the average meet?

SELECT AVG(competitor_count) AS average_competitors
FROM (
    SELECT MeetID, COUNT(DISTINCT AthleteID) AS competitor_count
    FROM openpl
    GROUP BY MeetID
) AS meet_competitors;

DESCRIBE openpl;

-- How many people make their third attempt?
SELECT
    (SUM(CASE WHEN Squat3Kg IS NOT NULL AND Squat3Kg > 0 THEN 1 ELSE 0 END) / COUNT(Squat3Kg)) * 100 AS percentage_positive_squat3
    , (SUM(CASE WHEN Bench3Kg IS NOT NULL AND Bench3Kg > 0 THEN 1 ELSE 0 END) / COUNT(Bench3Kg)) * 100 AS percentage_positive_bench3
    , (SUM(CASE WHEN Deadlift3Kg IS NOT NULL AND Deadlift3Kg > 0 THEN 1 ELSE 0 END) / COUNT(Deadlift3Kg)) * 100 AS percentage_positive_deadlift3
FROM openpl
WHERE Squat3Kg IS NOT NULL;



-- find out how many non-binary competitors there have been, their biggest totals, and avg totals compared to M/F competitors
SELECT
	Sex,
    avg(TotalKg) as avg_total,
    max(TotalKg) as max_total
FROM openpl
group by Sex;