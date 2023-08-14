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




-- find out how many non-binary competitors there have been, their biggest totals, and avg totals compared to M/F competitors
SELECT
	Sex,
    avg(TotalKg) as avg_total,
    max(TotalKg) as max_total
FROM openpl
group by Sex;