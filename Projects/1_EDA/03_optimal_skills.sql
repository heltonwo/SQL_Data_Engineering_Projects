/*
================================================================================
QUERY 3: OPTIMAL SKILL SCORE ANALYSIS (EQUILIBRIUM METRIC)
================================================================================
OBJECTIVE:
Identify the optimal skills for remote Data Engineer roles by balancing
demand and compensation into a single ranking metric.

METHOD:
- Calculate median salary and job demand per skill.
- Apply natural log (LN) scaling to demand, so that a handful of
  extremely high-frequency skills don't dominate the ranking purely
  on volume (diminishing returns on demand).
- Combine LN(demand) with median salary into a single "optimal_score".
- Keep only skills with more than 100 job postings for statistical reliability.

NOTE:
demand_count here reflects only postings with a non-null salary
(salary_year_avg IS NOT NULL), so it will be lower than the demand_count
in 01_top_demanded_skills.sql, which counts all postings regardless of
salary data availability.
================================================================================
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.job_id) AS demand_count,
    ROUND(LN(COUNT(jpf.job_id)), 1) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.job_id))) / 1000000, 2) AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.job_id) > 100
ORDER BY
    optimal_score DESC
LIMIT 10;


┌───────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│  skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar  │    double     │    int64     │     double      │    double     │
├───────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform │      184000.0 │          193 │             5.3 │          0.97 │
│ python    │      135000.0 │         1133 │             7.0 │          0.95 │
│ aws       │      137320.0 │          783 │             6.7 │          0.91 │
│ sql       │      130000.0 │         1128 │             7.0 │          0.91 │
│ airflow   │      150000.0 │          386 │             6.0 │          0.89 │
│ spark     │      140000.0 │          503 │             6.2 │          0.87 │
│ kafka     │      145000.0 │          292 │             5.7 │          0.82 │
│ snowflake │      135500.0 │          438 │             6.1 │          0.82 │
│ azure     │      128000.0 │          475 │             6.2 │          0.79 │
│ java      │      135000.0 │          303 │             5.7 │          0.77 │
└───────────┴───────────────┴──────────────┴─────────────────┴───────────────┘



/*
Key Findings

-- Top Skill: `terraform` leads with an optimal score of 0.97, driven by its
   exceptional median salary ($184,000) despite a lower demand count compared
   to languages like Python or SQL.
   
-- High-Demand Baseline: Python and SQL retain highly competitive scores
   (0.95 and 0.91) due to their massive market penetration (>1,100 postings).
*/
