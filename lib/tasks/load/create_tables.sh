#!/bin/bash

# Set the working directory to the location of this script
SCRIPT_DIR=$(cd $(dirname $BASH_SOURCE[0]) > /dev/null; pwd) 
cd $SCRIPT_DIR


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


# Dig into directories and run ddl.sql scripts
echo "Searching for ddl.sql files in directory: $SCRIPT_DIR"
find "$SCRIPT_DIR" -type f -name "ddl.sql" | sort | while read sql_file; do
    echo "Executing: $sql_file"
    
    # Execute the SQL file using psql
    PGPASSWORD=$PG_PASS psql -h "$PG_HOST" -U "$PG_USER" -d "$PG_DB" -f "$sql_file"
    
    # Check if psql executed successfully
    if [ $? -ne 0 ]; then
        echo "Error executing $sql_file"
        exit 1
    fi
done

echo "All DDL files executed successfully."