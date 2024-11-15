#!/usr/bin/env bash

# Set the working directory to the location of this script
SCRIPT_DIR=$(cd $(dirname $BASH_SOURCE[0]) > /dev/null; pwd) 
cd $SCRIPT_DIR

# set name of database
DB_FILE="source.ddb"

# check if the database exists, delete if does
if [ -f $DB_FILE ]; then
  echo "Database exists, deleting"
  rm $DB_FILE
else
  echo "Database not found, skipping purge"
fi


# create empty database, install spatial plugin
duckdb "$DB_FILE" < setup.sql
echo "Empty database created"

duckdb "$DB_FILE" < load.sql
echo "Data loaded into database"
exit 0

