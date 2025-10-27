#!/usr/bin/env bash
# Update DB connection variables as needed
DB="realestate_db"
USER="postgres"
HOST="localhost"

# Requires that tables already exist
psql -U $USER -d $DB -c "\copy agents(name,contact_no,email,agency_name) FROM 'data/agents.csv' CSV HEADER"
psql -U $USER -d $DB -c "\copy buyers(name,contact_no,email,budget,preferred_location) FROM 'data/buyers.csv' CSV HEADER"
psql -U $USER -d $DB -c "\copy properties(agent_id,title,location,city,state,price,area_sqft,type,listed_date,status,metadata) FROM 'data/properties.csv' CSV HEADER"
psql -U $USER -d $DB -c "\copy transactions(property_id,buyer_id,agent_id,sale_date,sale_price,commission) FROM 'data/transactions.csv' CSV HEADER"

# Refresh materialized view (if created)
psql -U $USER -d $DB -c "SELECT fn_refresh_price_trend_mv();"
