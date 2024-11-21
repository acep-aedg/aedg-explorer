#!/bin/bash

# Set the working directory to the location of this script
SCRIPT_DIR=$(cd $(dirname $BASH_SOURCE[0]) > /dev/null; pwd) 
cd $SCRIPT_DIR

# api (purge, api, checksum)
# source ./api/main.sh

# preprocess
# source ./preprocess/main.sh

# load
# source ./main.sh

# transform
# Set the working directory to the location of this script
cd transform
dbt seed
dbt run
# dbt docs generate
# dbt docs serve

# dump (to be loaded by Rails)