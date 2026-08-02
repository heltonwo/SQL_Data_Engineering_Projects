-- Step 1: DW Create Star Schema Tables

-- Drop existing tables if they exist (for idempotency)
DROP TABLE IF EXISTS skills_job_dim;
DROP TABLE IF EXISTS job_postings_fact;
DROP TABLE IF EXISTS company_dim;
DROP TABLE IF EXISTS skills_dim;

-- Create company_dim table
CREATE TABLE company_dim (
    company_id  INTEGER     PRIMARY KEY,
    name        VARCHAR
);

-- Create skills_dim table
CREATE TABLE skills_dim (
    skill_id    INTEGER     PRIMARY KEY,
    skills      VARCHAR,
    type        VARCHAR
);

-- Create job_postings_fact table
CREATE TABLE job_postings_fact (
    job_id                  INTEGER     PRIMARY KEY,
    company_id              INTEGER,
    job_title_short         VARCHAR,
    job_title               VARCHAR,
    job_location            VARCHAR,   
    job_via                 VARCHAR, 
    job_schedule_type       VARCHAR,           
    job_work_from_home      BOOLEAN,
    search_location         VARCHAR,
    job_posted_date         TIMESTAMP,
    job_no_degree_mention   BOOLEAN,
    job_health_insurance    BOOLEAN,   
    job_country             VARCHAR,     
    salary_rate             VARCHAR, 
    salary_year_avg         DOUBLE,
    salary_hour_avg         DOUBLE,
    FOREIGN KEY(company_id) REFERENCES company_dim(company_id)
);

-- Create skills_job_dim bridge table
CREATE TABLE skills_job_dim (
    skill_id    INTEGER,
    job_id      INTEGER,
    PRIMARY KEY(skill_id, job_id),   
    FOREIGN KEY(skill_id)   REFERENCES skills_dim(skill_id),
    FOREIGN KEY(job_id)     REFERENCES job_postings_fact(job_id)
);

-- Check Tables Created
SHOW TABLES;

-- Note: Tables are created in dependency order to respect foreign key constraints.
-- Dimension tables (company_dim, skills_dim) are created first (no dependencies),
-- followed by the fact table (job_postings_fact), and finally the bridge table (skills_job_dim).
-- Drop statements follow the reverse order.