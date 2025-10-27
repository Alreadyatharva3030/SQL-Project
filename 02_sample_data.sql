-- 02_sample_data.sql
-- Insert small sample dataset. Safe to run multiple times if IDs don't conflict.

-- Agents
INSERT INTO agents (name, contact_no, email, agency_name) VALUES
('Ravi Sharma','9876543210','ravi@primeprop.com','Prime Properties'),
('Sneha Patel','9123456780','sneha@urbanreal.com','Urban Real Estate'),
('Amit Verma','9988776655','amit@homefinders.com','HomeFinders');

-- Buyers
INSERT INTO buyers (name, contact_no, email, budget, preferred_location) VALUES
('Asha Rao','9012345678','asha@example.com',7500000,'Mumbai'),
('Rahul Singh','9023456789','rahul@example.com',5000000,'Pune'),
('Kavita Desai','9034567890','kavita@example.com',10000000,'Bangalore');

-- Properties
INSERT INTO properties (agent_id, title, location, city, state, price, area_sqft, type, listed_date, status, metadata) VALUES
(1,'2BHK Apartment near lake','Sector 21, Powai','Mumbai','Maharashtra',15000000,980,'Apartment','2025-01-10','Available','{"tags":"lakeview,2bhk"}'),
(2,'3BHK Builder Floor, near metro','Kharadi Road','Pune','Maharashtra',8500000,1250,'Apartment','2024-11-20','Available','{"tags":"metro,3bhk"}'),
(3,'Independent Villa with garden','Whitefield','Bangalore','Karnataka',25000000,2400,'Villa','2024-12-05','Available','{"tags":"garden,villa"}'),
(1,'1BHK Studio near market','Dadar','Mumbai','Maharashtra',6000000,420,'Apartment','2025-02-15','Available','{"tags":"studio"}');

-- Transactions (some sold)
INSERT INTO transactions (property_id, buyer_id, agent_id, sale_date, sale_price, commission) VALUES
(2,2,2,'2025-03-10',8200000,82000),
(4,1,1,'2025-04-01',5900000,59000);

-- Update status for sold properties
UPDATE properties SET status='Sold' WHERE property_id IN (2,4);
