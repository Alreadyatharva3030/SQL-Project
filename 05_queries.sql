-- 05_queries.sql
-- Analytics queries to run and record output

-- 1. Average price by city
SELECT * FROM avg_price_by_city;

-- 2. High demand cities
SELECT * FROM high_demand_areas LIMIT 10;

-- 3. Properties sold with buyer & price
SELECT * FROM property_sales WHERE sale_price IS NOT NULL ORDER BY sale_date DESC;

-- 4. Monthly price trend (for a city example)
SELECT * FROM price_trend_mv WHERE city='Mumbai' ORDER BY month;

-- 5. Top 5 expensive properties (listed)
SELECT p.property_id, p.title, p.city, p.price, p.area_sqft, a.name AS agent
FROM properties p
LEFT JOIN agents a ON p.agent_id = a.agent_id
ORDER BY p.price DESC
LIMIT 5;

-- 6. Average price per sqft by city
SELECT city, ROUND(AVG(price/NULLIF(area_sqft,0))::numeric,2) AS avg_price_per_sqft
FROM properties
WHERE area_sqft IS NOT NULL AND area_sqft>0
GROUP BY city
ORDER BY avg_price_per_sqft DESC;

-- 7. 3-month rolling average price by city (use window functions)
WITH monthly AS (
  SELECT city, date_trunc('month', COALESCE(t.sale_date, p.listed_date))::date AS month,
         AVG(COALESCE(t.sale_price, p.price)) AS avg_price
  FROM properties p
  LEFT JOIN transactions t ON p.property_id = t.property_id
  GROUP BY city, month
)
SELECT city, month,
       ROUND(AVG(avg_price) OVER (PARTITION BY city ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)::numeric,2) AS rolling_3mo_avg
FROM monthly
ORDER BY city, month DESC;
