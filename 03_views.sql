-- 03_views.sql

-- View: Average price by city
CREATE OR REPLACE VIEW avg_price_by_city AS
SELECT city, COUNT(*) AS num_listings, ROUND(AVG(price)::numeric,2) AS avg_price, MIN(price) AS min_price, MAX(price) AS max_price
FROM properties
GROUP BY city
ORDER BY avg_price DESC;

-- View: High demand areas (top cities by number of listings)
CREATE OR REPLACE VIEW high_demand_areas AS
SELECT city, COUNT(*) AS listings, ROUND(AVG(price)::numeric,2) AS avg_price
FROM properties
GROUP BY city
ORDER BY listings DESC;

-- View: Properties with latest transaction if sold
CREATE OR REPLACE VIEW property_sales AS
SELECT p.property_id, p.title, p.city, p.price AS listed_price, t.sale_price, t.sale_date, b.name AS buyer_name, a.name AS agent_name
FROM properties p
LEFT JOIN transactions t ON p.property_id = t.property_id
LEFT JOIN buyers b ON t.buyer_id = b.buyer_id
LEFT JOIN agents a ON t.agent_id = a.agent_id;

-- Materialized View: engagement-like summary for price trends (refreshable)
CREATE MATERIALIZED VIEW IF NOT EXISTS price_trend_mv AS
SELECT city, date_trunc('month', COALESCE(t.sale_date, p.listed_date))::date AS month,
       COUNT(p.property_id) AS listings_count,
       ROUND(AVG(COALESCE(t.sale_price, p.price))::numeric,2) AS avg_price
FROM properties p
LEFT JOIN transactions t ON p.property_id = t.property_id
GROUP BY city, month
WITH DATA;

CREATE INDEX IF NOT EXISTS idx_price_trend_city ON price_trend_mv (city);
