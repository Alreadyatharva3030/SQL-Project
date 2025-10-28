-- ==============================
-- Views for analytics and high-demand areas
-- ==============================

-- View: high-demand regions (average price above overall mean)
CREATE VIEW HighDemandRegions AS
SELECT region, ROUND(AVG(price),2) AS avg_region_price
FROM Properties
GROUP BY region
HAVING AVG(price) > (SELECT AVG(price) FROM Properties);

-- View: property sales summary
CREATE VIEW PropertySalesSummary AS
SELECT 
    p.property_name,
    p.region,
    a.agent_name,
    COUNT(t.transaction_id) AS total_sales,
    ROUND(AVG(t.sale_price),2) AS avg_sale
FROM Properties p
JOIN Agents a ON p.agent_id = a.agent_id
LEFT JOIN Transactions t ON p.property_id = t.property_id
GROUP BY p.property_name, p.region, a.agent_name;
