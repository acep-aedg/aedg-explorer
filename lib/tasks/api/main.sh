#!/usr/bin/env bash

# Set the working directory to the location of this script
SCRIPT_DIR=$(cd $(dirname $BASH_SOURCE[0]) > /dev/null; pwd) 
cd $SCRIPT_DIR

./ak-dol.places2020/data/api.sh
./us-census.gaz2024/data/api.sh