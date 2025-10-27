# SQL-Project
Its a Project On Real Estate Listings and Analytics
# Real Estate Listings & Analytics

## Project
Real Estate Listings and Analytics — PostgreSQL backend to track property listings, transactions and produce price insights.

## Structure
- sql/01_schema.sql         -- DDL (tables, extensions, indexes)
- sql/02_sample_data.sql    -- small sample INSERTs (safe to run)
- sql/03_views.sql          -- views & materialized views
- sql/04_triggers.sql       -- triggers & routines
- sql/05_queries.sql        -- analytical queries (ranking, trends)
- scripts/generate_data.py  -- Python generator (Faker) to create large CSV datasets
- scripts/load_data.sh      -- example load script using psql \copy
- docs/erd.puml             -- PlantUML ERD
- reports/report.pdf        -- (add final 1-2 page report here)

## Quick start (PostgreSQL)
1. Create database:
   `createdb realestate_db`
2. Run schema:
   `psql -d realestate_db -f sql/01_schema.sql`
3. Load sample data:
   `psql -d realestate_db -f sql/02_sample_data.sql`
4. Create triggers, views, materialized views:
   `psql -d realestate_db -f sql/04_triggers.sql`
   `psql -d realestate_db -f sql/03_views.sql`
5. Run queries:
   `psql -d realestate_db -f sql/05_queries.sql`

## Data generation (large)
1. Install Python deps:
   `pip install faker psycopg2-binary`
2. Generate CSV files:
   `python scripts/generate_data.py`
3. Load via `scripts/load_data.sh` (edit DB connection details)

## Deliverables
- ERD (docs/erd.puml)
- SQL schema and sample data
- Views and queries for top posts and trends
- Report (reports/report.pdf)
