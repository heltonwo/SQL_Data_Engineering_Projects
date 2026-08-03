# 📊 SQL Data Engineering Projects

A portfolio of SQL-focused data engineering projects — from exploratory analysis to a full ETL pipeline with a star-schema data warehouse and analytical data marts.

Built entirely in **SQL** on **DuckDB**, covering the full path from raw data to production-style incremental updates.

---

## 📁 Projects

| Project | Description |
|---|---|
| [`1_EDA`](./Projects/1_EDA) | Exploratory SQL analysis on tech job postings — top demanded skills, salary insights, and optimal skill combinations |
| [`2_DW_Mart_Build`](./Projects/2_DW_Mart_Build) | End-to-end ETL pipeline: raw CSVs → star schema data warehouse → analytical data marts (flat, skills, priority, company), with a production-style incremental **MERGE** pattern |

Each project has its own README with full details, architecture diagrams, and query results.

---

## 🛠️ Stack

- **DuckDB** — embedded OLAP database
- **SQL** — DDL, DML, window functions, CTEs, `MERGE`, nested types

---

## 📂 Repository Structure

```text
SQL_Data_Engineering_Projects/
├── Projects/
│   ├── 1_EDA/                  # Exploratory SQL analysis
│   └── 2_DW_Mart_Build/        # Data warehouse + marts pipeline
├── Resources/
│   └── images/                 # Diagrams and query result screenshots
└── README.md                   # You are here
```

---

## 👋 About

This repo is part of my journey building a Data Analyst / Data Engineering portfolio.