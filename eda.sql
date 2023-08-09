USE ipf;


-- I want to know how many weight classes there are in total.
SELECT 
    COUNT(DISTINCT WeightClassKg) as unique_weightclasses
FROM ipf;

-- And how many entries are in each weight class
SELECT 
    WeightClassKg
    , COUNT(WeightClassKg) as entries_by_weightclass
FROM ipf
GROUP BY WeightClassKg
ORDER BY entries_by_weightclass DESC;

/* Many of the weight classes only have a single entry.  A weight class of 103.3, for instance,
doesn't make a lot of sense, so is probably user input error.  It is likely the weight of the
athlete, and not the weight class that the athlete was competing in. Alternatively, it might be
a conversion between lbs and kg.  For instance, the 92.9kg weight class might be the -205lbs weight
class. All of these need to be dealt with to be able to draw meaningful conclusions from them.*/

SELECT 
    WeightClassKg
    , COUNT(WeightClassKg) as entries
FROM ipf
GROUP BY WeightClassKg
ORDER BY WeightClassKg DESC;

