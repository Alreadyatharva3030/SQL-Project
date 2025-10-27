-- 01_schema.sql
-- Run on PostgreSQL

-- Optional extensions
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS unaccent;

-- Agents
CREATE TABLE IF NOT EXISTS agents (
  agent_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  contact_no VARCHAR(20),
  email VARCHAR(100),
  agency_name VARCHAR(100)
);

-- Buyers
CREATE TABLE IF NOT EXISTS buyers (
  buyer_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  contact_no VARCHAR(20),
  email VARCHAR(100),
  budget DECIMAL(15,2),
  preferred_location VARCHAR(150)
);

-- Properties
CREATE TABLE IF NOT EXISTS properties (
  property_id SERIAL PRIMARY KEY,
  agent_id INT REFERENCES agents(agent_id) ON DELETE SET NULL,
  title VARCHAR(255),
  location VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(100),
  price DECIMAL(15,2),
  area_sqft DECIMAL(10,2),
  type VARCHAR(50),  -- Apartment, Villa, Plot, etc.
  listed_date DATE,
  status VARCHAR(50), -- Available, Sold, Pending
  metadata JSONB
);

-- Transactions (sales)
CREATE TABLE IF NOT EXISTS transactions (
  transaction_id SERIAL PRIMARY KEY,
  property_id INT REFERENCES properties(property_id) ON DELETE CASCADE,
  buyer_id INT REFERENCES buyers(buyer_id) ON DELETE SET NULL,
  agent_id INT REFERENCES agents(agent_id) ON DELETE SET NULL,
  sale_date DATE,
  sale_price DECIMAL(15,2),
  commission DECIMAL(10,2)
);

-- Helpful indexes
CREATE INDEX IF NOT EXISTS idx_properties_city ON properties(city);
CREATE INDEX IF NOT EXISTS idx_properties_state ON properties(state);
CREATE INDEX IF NOT EXISTS idx_properties_price ON properties(price);
CREATE INDEX IF NOT EXISTS idx_transactions_sale_date ON transactions(sale_date);

-- Full-text search support on title + metadata->>'tags' if used
ALTER TABLE properties ADD COLUMN IF NOT EXISTS tsv tsvector;
CREATE FUNCTION properties_tsv_trigger() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.tsv := to_tsvector('english', coalesce(NEW.title,'') || ' ' || coalesce(NEW.metadata->>'tags',''));
  RETURN NEW;
END; $$;
CREATE TRIGGER trg_properties_tsv BEFORE INSERT OR UPDATE ON properties
FOR EACH ROW EXECUTE FUNCTION properties_tsv_trigger();

CREATE INDEX IF NOT EXISTS idx_properties_tsv ON properties USING GIN (tsv);
CREATE INDEX IF NOT EXISTS idx_properties_title_trgm ON properties USING gin (title gin_trgm_ops);
