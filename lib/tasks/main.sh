#!/bin/bash

# Set the working directory to the location of this script
# SCRIPT_DIR=$(cd $(dirname $BASH_SOURCE[0]) > /dev/null; pwd) 
# cd $SCRIPT_DIR

# export PYTHONPATH=$(pwd)/scripts:$PYTHONPATH

# api (purge, api, checksum)
# python run_api.py 


# # preprocess
# python preprocess/transmission-lines-202200706/transmission-lines-202200706.py
python preprocess/places2020/places2020.py


# load
# source ./main.sh

# transform
# Set the working directory to the location of this script
# cd transform
# dbt seed
# dbt run
# dbt docs generate
# dbt docs serve

# dump (to be loaded by Rails)