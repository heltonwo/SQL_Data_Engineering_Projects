/*
================================================================================
QUERY 2.1 : TOP PAYING DATA ENGINEER SKILLS
================================================================================
OBJECTIVE:
Identify the highest-paying skills for remote Data Engineer roles.

METHOD:
- Calculate the median salary for each skill.
- Keep only skills with more than 100 job postings.
- Rank skills by median salary.
================================================================================
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
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
HAVING
    COUNT(jpf.job_id) > 100
ORDER BY
    median_salary DESC
LIMIT 25;


┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ terraform  │      184000.0 │         3248 │
│ golang     │      184000.0 │          912 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ django     │      155000.0 │          265 │
│ bitbucket  │      155000.0 │          478 │
│ crystal    │      154224.0 │          129 │
│ c          │      151500.0 │          444 │
│ atlassian  │      151500.0 │          249 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ ruby       │      150000.0 │          736 │
│ css        │      150000.0 │          262 │
│ airflow    │      150000.0 │         9996 │
│ node       │      150000.0 │          179 │
│ redis      │      149000.0 │          605 │
│ ansible    │      148798.0 │          475 │
│ vmware     │      148798.0 │          136 │
│ jupyter    │      147500.0 │          400 │
└────────────┴───────────────┴──────────────┘

/* Key Insights

-- Rust offered the highest median salary ($210K), though with moderate 
   demand (232 postings).

-- Terraform stood out by combining a $184K median salary with strong 
   demand (3,248 postings).

-- Golang matched Terraform's salary while maintaining solid demand 
   (912 postings).

-- The extended top 25 reveals a striking pattern: Airflow ($150K median, 
   9,996 postings) and Kubernetes ($150.5K median, 4,202 postings) combine 
   high salaries with by far the highest demand in the entire list — 
   even surpassing Terraform. This contradicts the earlier assumption that 
   high pay only comes from niche/specialized skills; some of the most 
   in-demand tools are also among the best-paid.

-- Overall, the top 25 shows a mix of two skill profiles: (1) niche, 
   lower-volume specialties commanding premium salaries (Rust, Neo4j, 
   Crystal), and (2) high-volume, high-demand skills that still pay well 
   (Airflow, Kubernetes, Terraform) — these represent the safest 
   "high demand + high pay" bets for career investment.

*/




/*
================================================================================
QUERY 2.2: TOP PAYING COMPANIES (REMOTE DATA ENGINEER ROLES)
================================================================================
OBJECTIVE:
Identify which companies offer the best compensation for remote Data Engineer
roles, filtering out companies with too few postings to be statistically
meaningful.

METHOD:
- CTE (company_stats): aggregate median salary and posting count per company.
- Outer query: rank companies by median salary using RANK() so ties share
  the same position (unlike ROW_NUMBER, which would break ties arbitrarily).
================================================================================
*/

WITH company_stats AS (
    SELECT
        cd.name AS company_name,
        COUNT(jpf.job_id) AS demand_count,
        ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary
    FROM job_postings_fact AS jpf
    INNER JOIN company_dim AS cd
        ON jpf.company_id = cd.company_id
    WHERE
        jpf.job_title_short = 'Data Engineer'
        AND jpf.job_work_from_home = TRUE
        AND jpf.salary_year_avg IS NOT NULL
    GROUP BY
        cd.name
    HAVING
        COUNT(jpf.job_id) >= 5   -- minimum postings for statistical reliability
)

SELECT
    company_name,
    median_salary,
    demand_count,
    RANK() OVER (ORDER BY median_salary DESC) AS salary_rank
FROM company_stats
ORDER BY
    salary_rank
LIMIT 10;



┌────────────────────────────┬───────────────┬──────────────┬─────────────┐
│        company_name        │ median_salary │ demand_count │ salary_rank │
│          varchar           │    double     │    int64     │    int64    │
├────────────────────────────┼───────────────┼──────────────┼─────────────┤
│ Edge & Node                │      264000.0 │            6 │           1 │
│ Capital One                │      200256.0 │            7 │           2 │
│ Garner Health              │      200000.0 │           61 │           3 │
│ Confirmo                   │      200000.0 │           19 │           3 │
│ Meta                       │      198500.0 │           14 │           5 │
│ Harnham                    │      195000.0 │            5 │           6 │
│ WEX Inc.                   │      184000.0 │           18 │           7 │
│ Storm3                     │      182500.0 │            6 │           8 │
│ Microsoft Legal Department │      180048.0 │            5 │           9 │
│ Walmart                    │      175500.0 │           17 │          10 │
└────────────────────────────┴───────────────┴──────────────┴─────────────┘

/*
Key Findings
-- Edge & Node leads with a median salary of $264,000, but with only 6 
   postings — a signal to interpret with caution given the low volume.
-- Garner Health is the most robust result in the top 3: a $200,000 median 
   backed by 61 postings, far more statistically reliable than Edge & Node 
   or Capital One (6-7 postings).
-- Tie at 3rd place (RANK "skips" to 5): Garner Health and Confirmo both 
   share a $200,000 median — showing RANK() behaving as expected.
-- Meta is the only "big tech" company in the top 5, with a $198,500 median 
   and 14 postings.
-- Most of the top 10 companies have low volume (5-19 postings), reinforcing 
   that very high salaries tend to come from niche/smaller companies rather 
   than large, high-volume employers.
*/