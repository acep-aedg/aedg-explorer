#!/bin/bash

# First:
# Create the postgres database
# Configure ~/.pgpass file for credentials
# Install spatial plugin



# Set PostgreSQL credentials and target database name (password stored in .pgpass)
PG_HOST="localhost"      
PG_PORT="5432"           
PG_USER="dev"     
PG_DB="aedg"    # Database name to delete tables from

# Ensure the .pgpass file exists and has correct permissions
if [ ! -f "$HOME/.pgpass" ]; then
  echo "Error: .pgpass file not found in your home directory."
  exit 1
fi

# Connect to the database and drop all tables
echo "Dropping all tables from $PG_DB..."

psql -h $PG_HOST -U $PG_USER -d $PG_DB <<EOF
-- Drop all tables in the public schema (with CASCADE to handle foreign keys)
DO \$\$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP TABLE IF EXISTS public.' || r.tablename || ' CASCADE';
    END LOOP;
END;
\$\$;
EOF

echo "All tables have been dropped from database $PG_DB."

