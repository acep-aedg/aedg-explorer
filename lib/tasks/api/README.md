# `api/`
# Overview
This directory contains scripting to kick off the pipeline. Functions are loaded from `functions/` directory. 

<br>

## Goals
Specifically we want to: 
- delete existing data files (`purge.py`)
- downloaded them from API endpoints (`api.py`)
- and check their sha256sum hash for validity (`checksum.py`)

<br>

Data should be unmodified from the source server, any processing should take place in the next step, `preprocess/`.

## Adding data sources
The repo is structured such that data sources can be added with minimal fuss. 

To add a data source, create a directory in `api/` with the naming structure: `source-name.file` For instance, employment data from Alaska Department of Labor would be named something like `ak-dol.employment` Some deviations are acceptable (ex: `ak-dol.employment-wages2024`), but the results with cascade downstream, so be deliberate and concise. When possible, name the directory the same as the filename from the source.

Once the directory is created, `cd` into it and make a file named `source-name.file.url` This will house the URL string of the API endpoint and will be called when the scripts run.

Now the stage is set for us to add the data source into our pipeline. 



