#!/bin/bash

# Connect to the database and drop all tables
echo "Dropping all tables from $PG_DB..."

psql -h $PG_HOST -U $PG_USER -d $PG_DB <<EOF
-- Drop all tables in the public schema (with CASCADE to handle foreign keys)
DO \$\$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        BEGIN
            -- Attempt to drop the table with CASCADE
            EXECUTE 'DROP TABLE IF EXISTS public.' || r.tablename || ' CASCADE';
            -- Optionally log success (in case you need to track)
            RAISE NOTICE 'Successfully dropped table: %', r.tablename;
        EXCEPTION
            WHEN OTHERS THEN
                -- Log the error if we can't drop the table
                RAISE NOTICE 'Failed to drop table: % - %', r.tablename, SQLERRM;
        END;
    END LOOP;
END;
\$\$;
EOF


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
    else
        echo "Successfully created $sql_file"
    fi
done

