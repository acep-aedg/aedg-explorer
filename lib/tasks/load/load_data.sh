#!/bin/bash

# Dig into directories and run load.sql scripts for CSV data
echo "Searching for load.sql files in directory: $SCRIPT_DIR"
find "$SCRIPT_DIR" -type f -name "load.sql" | sort | while read sql_file; do

    echo "Loading data into $(basename $(dirname "$sql_file"))"

    # Execute the SQL file using psql
    PGPASSWORD=$PG_PASS psql -h "$PG_HOST" -U "$PG_USER" -d "$PG_DB" -f "$sql_file"
    
    # Check if psql executed successfully
    if [ $? -ne 0 ]; then
        echo "Error running $sql_file"
        exit 1
    else
        echo "Ran $(basename $(dirname "$sql_file")) without errors, check if loaded"
    fi
done


# Find and run each load.sh script
echo "Searching for load.sh files in directory: $SCRIPT_DIR"
find "$SCRIPT_DIR" -type f -name "load.sh" | sort | while read shell_file; do

    echo "Running load script: $shell_file"
    
    # Execute the load.sh script
    bash "$shell_file"
    
    # Check if the load.sh ran successfully
    if [ $? -ne 0 ]; then
        echo "Error running $shell_file"
        exit 1
    else
        echo "Ran $(basename $(dirname "$shell_file")) without errors, check if loaded"
    fi
done


# # Define the PostgreSQL connection string (assuming .pgpass handles password)
# PG="dbname=$PG_DB host=$PG_HOST port=$PG_PORT user=$PG_USER"

# # Works great! Don't change!
# for filename in data/raw/*.geojson; do

#     tablename="$(basename "${filename%.geojson}")"

#     ogr2ogr -f "PostgreSQL" \
#         PG:"$PG" \
#         "$filename" \
#         -nln "$tablename" \
#         -overwrite

#     echo $filename
#     echo "written as $tablename"
    
# done
