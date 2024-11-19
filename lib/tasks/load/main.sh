#!/bin/bash

# Set the working directory to the location of this script
SCRIPT_DIR=$(cd $(dirname $BASH_SOURCE[0]) > /dev/null; pwd) 
cd $SCRIPT_DIR

# Set PostgreSQL credentials and target database name (password stored in .pgpass)
export PG_HOST="localhost"      
export PG_PORT="5432"           
export PG_USER="dev"     
export PG_DB="aedg"    # Database name to delete tables from

# Ensure the .pgpass file exists and has correct permissions
if [ ! -f "$HOME/.pgpass" ]; then
  echo "Error: .pgpass file not found in your home directory."
  exit 1
fi


# Set up postgres database and create user `dev`
# Note: nothing here yet
./setup_postgres.sh

# Drop all tables, then create from inddividual DDL scripts
source ./create_tables.sh

# Copy data into empty tables
source ./load_data.sh
