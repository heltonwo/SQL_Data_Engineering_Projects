/*
================================================================================
QUERY 1: TOP DEMANDED DATA ENGINEER SKILLS
================================================================================
OBJECTIVE:
Identify the most requested skills for remote Data Engineer roles.

METHOD:
- Count job postings for each skill.
- Rank skills by total demand.
================================================================================
*/

SELECT 
    sd.skills,
    COUNT(jpf.job_id) AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
GROUP BY
    sd.skills
ORDER BY
    demand_count DESC
LIMIT 10; 


┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘

/*
Key Insights

-- SQL was the most in-demand skill, appearing in **29,221 remote Data Engineer job postings.

-- Python ranked a close second with **28,776 postings, 
    reinforcing its role as a core programming language for data engineering.

-- AWS, Azure, and GCP all ranked in the top 10, 
    highlighting the strong demand for cloud platform expertise.

-- Spark, Airflow, Snowflake, and Databricks demonstrate 
    that modern data pipeline and big data technologies are highly valued.

-- The top 10 skills indicate that employers prioritize 
    a combination of SQL, Python, cloud platforms, and data engineering frameworks.

*/