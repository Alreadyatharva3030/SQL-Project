-- ==============================
-- Export Data to CSV
-- ==============================

-- Export price trends to CSV (PostgreSQL)
\copy (SELECT * FROM Properties) TO 'C:/exports/properties.csv' DELIMITER ',' CSV HEADER;
\copy (SELECT * FROM HighDemandRegions) TO 'C:/exports/high_demand_regions.csv' DELIMITER ',' CSV HEADER;
\copy (SELECT * FROM PropertySalesSummary) TO 'C:/exports/sales_summary.csv' DELIMITER ',' CSV HEADER;
