-- 04_triggers.sql

-- Function to auto-update property status after a transaction insert
CREATE OR REPLACE FUNCTION fn_update_property_status()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  -- Set property status to Sold when a transaction is inserted
  IF TG_OP = 'INSERT' THEN
    UPDATE properties SET status = 'Sold' WHERE property_id = NEW.property_id;
  END IF;
  RETURN NEW;
END; $$;

DROP TRIGGER IF EXISTS trg_after_transaction_insert ON transactions;
CREATE TRIGGER trg_after_transaction_insert
AFTER INSERT ON transactions
FOR EACH ROW EXECUTE FUNCTION fn_update_property_status();

-- Function to refresh materialized view (concurrent)
CREATE OR REPLACE FUNCTION fn_refresh_price_trend_mv()
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY price_trend_mv;
EXCEPTION WHEN others THEN
  -- fallback to non-concurrent if concurrent refresh not allowed
  REFRESH MATERIALIZED VIEW price_trend_mv;
END;
$$;
