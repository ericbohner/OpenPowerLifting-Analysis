# OpenPowerLifting-Analysis
An analysis of Open Powerlifting Data from 1964-2023 from the [OpenPowerlifting Project](https://www.openpowerlifting.org).  A copy of the data was downloaded from [here](https://gitlab.com/openpowerlifting/opl-data).

In this project, I explore powerlifting data from 1964-09-05 to 2023-07-30 to answer simple but interesting-to-me questions like: 

- How many people compete in (sanctioned) powerlifting meets each year?
- How many events have been held?
- How has popularity of the sport grown over time?
- What equipment types are the most popular (Multi-ply, Single-ply, Raw, Wraps, etc.).
- Who holds current records across different weight classes and federations?
- What are those records?
- Are some weight classes overpowered compared to others?
- What interesting insights can we find from data on non-binary lifters? (This last one is a complex question.)

## Data Cleaning

I wanted the data to be suitable for a SQL database (mostly because I wanted to practice my SQL skills).  Some cleaning of the data was required to make this task easier.  This was done in the data_cleaning.ipynb notebook in Python.  A unique MeetID and AtheletID was created for each athlete and meet.  Weight classes were also frequently missing.  To impute this data, the athlete's body weight, sex, federation, parent federation and date of competition were used to identify the correct weight class.  These weight classes were then converted to float datatypes for ease of use.  '+' weight classes (e.g., 120+ and 84+ in the IPF after 2011) were stripped of the '+' and a 0 was appended.  So, for instance, the 120+ category became the 1200 category.  Since weight classes are never used to perform calculations (in the sense that you will never sum or multipy their values), this solution seemed simple and appropriate to ensure Super Heavy Weights (SHWs) were not accidentally sorted into the wrong weight class.  Note that strength performance metrics (WILKS, DOTS, GB, GL, etc.) use the athletes bodyweight for scores, _not_ the weight class, so there is no issue with the change I made to weight classes.

Lift values were also frequently missing and had to be imputed.  The sixteen lift columns (Squat1-4Kg, Best3SquatKg, Bench1-4Kg, Best3BenchKg, Deadlift1-4Kg, Best3DeadliftKg, and TotalKg) are optional, meaning that lifts were recorded and submitted in a variety of ways: sometimes only best attempts were recorded; sometimes only a total was recorded; sometimes individual lifts were recorded, but best attempts were not recorded; etc.).  To handle this, Best3**Lift**Kg columns were imputed using the best of the four attempt columns and TotalKg was calculated by summing the values in the Best3LiftKg columns.  Care was taken, however, to ensure that values that had been entered were not overwritten in the event that the imputed data conflicted with existing values.  For instance, if a TotalKg value had been entered while all other columns were left blank, then the best 3 lifts would total 0, which would have conflicted with the existing value in TotalKg.  In those instances, the existing value was to be preferred over the calculated total.

Finally, the data was exported to a csv ('openpl.csv') and loaded into a sql database.  Setup for the MySQL database is found in the database_setup.sql file.  

## Preliminary Findings

Here are some interesting findings, in a simple infographic:





## Deeper Findings

Here we see the popularity of the sport over time, measured in the number of meets that were held.

![Powerlifting Popularity](https://github.com/ericbohner/OpenPowerLifting-Analysis/assets/131715470/442d4788-dbd9-4727-abdf-a9233ff9646a)

It's also interesting to see how the sport has changed over the years.  For many years, Single-ply was the norm (aka equipped lifting).  In recent years however, as the sport has become more popular, there has been a notable shift away from equipped lifting to Raw lifting (raw lifting is usually identified as no knee wraps, no straps, and no squat/deadlift/bench suits/shirts).


![Equipment Popularity](https://github.com/ericbohner/OpenPowerLifting-Analysis/assets/131715470/d8f0581b-69e6-49c7-b7b2-6b2cc803af0a)

We see that, in the very early days, knee wraps were often used, which almost went away entirely until ~2006 when it saw a sudden resurgence.  Then, in the 1977, single-ply dominated the powerlifting scene until ~2010 when Raw started to become more popular, eventually overtaking single-ply in 2015.

Interestingly, even though Single-ply was dominant for so long, because of the growth of the sport, it only barely holds the lead over Raw: there have been 29,306 Single-ply meets with 1,319,300 athletes competing compared to 25,640 Raw meets with 1,288,288 athletes competing.  Here's a quick and dirty chart showing the distribution of equipment type by number of athletes who have competed (note that an athlete may compete in multiple events with different equipment regulations:


![Distribution of Equipment Type](https://github.com/ericbohner/OpenPowerLifting-Analysis/assets/131715470/e0b9c7d3-9763-4eb5-bff1-7477c57178be)



## Deepest Findings

This area is a work in progress.  I want to evaluate different Strength Performance Metrics (WILKS, DOTS, etc.) to see how they perform compared to each other, identifying if it favours particular weight classes over others and other possible insights.  

In addition to this, it would be interesting to see data on non-binary lifters.  There is frequent (and often heated) discussion within the powerlifting community whether trans men or trans women should be able to compete, and in which division.  Arguments to the effect of "trans women have an unfair advantage over other women because they had the benefits of increased testosterone during puberty" are often thrown around (often less eloquently than I've described it).  With the small dataset available to me, it would be interesting to see whether there is any truth to such a claim.  A very quick query, for instance, highlights the following differences:

| Sex | Average TotalKg | Max TotalKG |
|-----|-----------------|-------------|
| F | 250.5 | 932.5 |
| M | 414.9 | 1407.5 |
| Mx | 282.9 | 555.7 |

This dataset unfortunately does not give us further details about the Sex column (for instance, whether Mx athletes self-identified as non-binary, or in which weight classes they competed), buth it would nevertheless be interesting to determine whether these differences are statistically significant.  In future work, I can test whether these, and other values, are statistically significant given the assumption that athletes follow a normal distribution.






