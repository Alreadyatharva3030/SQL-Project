-- ==============================
-- Analytical Queries
-- ==============================

-- 1. Average price by region
SELECT region, ROUND(AVG(price),2) AS avg_price
FROM Properties
GROUP BY region
ORDER BY avg_price DESC;

-- 2. Top 5 most expensive properties
SELECT property_name, price, region
FROM Properties
ORDER BY price DESC
LIMIT 5;

-- 3. Property price trends using window functions
SELECT 
    region,
    property_name,
    listing_date,
    price,
    AVG(price) OVER (PARTITION BY region ORDER BY listing_date) AS moving_avg_price,
    RANK() OVER (PARTITION BY region ORDER BY price DESC) AS rank_in_region
FROM Properties;

-- 4. Most active agents (based on transactions)
SELECT 
    a.agent_name,
    COUNT(t.transaction_id) AS total_sales,
    ROUND(AVG(t.sale_price),2) AS avg_sale_price
FROM Transactions t
JOIN Properties p ON t.property_id = p.property_id
JOIN Agents a ON p.agent_id = a.agent_id
GROUP BY a.agent_name
ORDER BY total_sales DESC;
