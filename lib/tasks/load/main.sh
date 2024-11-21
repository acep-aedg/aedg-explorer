#!/bin/bash

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
source ./load/setup_postgres.sh

# Drop all tables, then create from inddividual DDL scripts
source ./load/create_tables.sh

# Copy data into empty tables
source ./load/load_data.sh
