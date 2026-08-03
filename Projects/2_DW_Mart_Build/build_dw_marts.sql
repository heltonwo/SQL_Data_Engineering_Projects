-- Master build script for data warehouse and mart pipeline
-- This file runs all steps in sequence to build the complete warehouse and marts
--
-- Usage (Local):
--   Run this script with: duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Step 1: DW Create Star Schema Tables
.read 01_create_tables_dw.sql

-- Step 2: Load data from csv files into tables
.read 02_load_schema_dw.sql

-- Step 3: Creat flat mart
.read 03_create_flat_mart.sql

-- Step 4: Create Skills Demand Mart
.read 04_create_skills_mart.sql

-- Step 5: Create Priority Mart
.read 05_create_priority_mart.sql

-- Step 6: Update Priority Mart
.read 06_update_priority_mart.sql