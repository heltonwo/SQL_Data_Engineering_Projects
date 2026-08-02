-- Step 3: Create Flat Mart
-- Denormalizes the star schema into a single wide table for analytics.
-- Skills are nested as an array of structs to maintain one row per job.

DROP SCHEMA IF EXISTS flat_mart CASCADE;

CREATE SCHEMA flat_mart;

 
CREATE OR REPLACE TABLE flat_mart.job_postings AS

SELECT 
-- Fact Table
    jpf.job_id, 
    jpf.job_title_short, jpf.job_title, 
    jpf.job_location, jpf.job_via, 
    jpf.job_schedule_type, jpf.job_work_from_home, 
    jpf.search_location, jpf.job_posted_date, 
    jpf.job_no_degree_mention, jpf.job_health_insurance, 
    jpf.job_country, jpf.salary_rate, 
    jpf.salary_year_avg, jpf.salary_hour_avg,

-- Dimentions Tables
    cd.company_id, cd.name  AS company_name,
    ARRAY_AGG(
        STRUCT_PACK(
            type := sd.type,
            name := sd.skills
                )
    )AS skill_and_types

FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id 
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
GROUP BY ALL; 

-- Note: DuckDB syntax: groups by all non-aggregated columns

-- Data Validation
SELECT 'Flat Mart Job Postings' AS table_name,
         COUNT(*) AS record_count
   
FROM flat_mart.job_postings;

SELECT *
FROM flat_mart.job_postings
LIMIT 10;



