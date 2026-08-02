-- Step 2: DW - Load data from CSV files into star schema tables (Data Warehouse)

-- Load dimension tables first (no foreign key dependencies)
INSERT INTO company_dim (company_id, name)
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv', 
    AUTO_DETECT=true,
    HEADER=true);

INSERT INTO skills_dim (skill_id, skills, type)
SELECT skill_id, skills, type
FROM read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv', 
    AUTO_DETECT=true,
    HEADER=true)
WHERE skills IS NOT NULL;


-- Load fact table second
-- ignore_errors=true discards ~13 malformed rows from the source CSV
-- (unquoted commas in job_title and corrupted segments) — acceptable data loss (~0.0008%)
INSERT INTO job_postings_fact (
    job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
)
SELECT 
    job_id, company_id, job_title_short, job_title, job_location, 
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance, 
    job_country, salary_rate, salary_year_avg, salary_hour_avg
FROM read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv', 
    AUTO_DETECT=true,
    HEADER=true,
    ignore_errors=true);


-- Load bridge table last (depends on skills_dim and job_postings_fact)
-- Filters out orphan job_ids that were discarded in the fact table load
-- to prevent foreign key constraint errors
INSERT INTO skills_job_dim (skill_id, job_id)
SELECT skill_id, job_id
FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv', 
    AUTO_DETECT=true,
    HEADER=true,
    ignore_errors=true)
WHERE job_id IN (SELECT job_id FROM job_postings_fact);

-- Data Validation
SELECT 'Company Dimension' AS table_name, COUNT(*) as record_count FROM company_dim
UNION ALL
SELECT 'Skills Dimension', COUNT(*) FROM skills_dim
UNION ALL
SELECT 'Job Postings Fact', COUNT(*) FROM job_postings_fact
UNION ALL
SELECT 'Skills Job Bridge', COUNT(*) FROM skills_job_dim;


SELECT  * FROM company_dim
LIMIT 10;
 
SELECT * FROM skills_dim
LIMIT 10;

SELECT * FROM job_postings_fact
LIMIT 10;

SELECT * FROM skills_job_dim
LIMIT 10;