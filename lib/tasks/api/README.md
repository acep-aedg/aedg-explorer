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

Once the directory is created, `cd` into it and make a file named `source.yml` This YAML file should have the following structure:

```
source:
  name: {name of source department or organization}
  url: {url of html reference page (not the API endpoint)}
files:
  - {file name, same as directory name above}:
      file_type: {filetype of data: csv, geojson, xlsx, zip, etc. Please pick one of these examples (Don't write .CSV)}
      url: {url of API endpoint}
      sha256: {output of sha256sum}
```
<br>

Example:
```
source:
  name: Alaska Dept of Labor and Workforce Development
  url: https://live.laborstats.alaska.gov/article/maps-gis-data
files:
  - ak-dol.places2020:
      file_type: zip
      url: https://live.laborstats.alaska.gov/cen/maps/gis/Places2020.zip
      sha256: d6700eb6caa01e5f4f6ff881e5a0d83a805dac30ac64bce65606bed42c2ca36f
```


This YAML file will be read and parsed during the API call, purging the prior data, downloading fresh data, and comparing the checksums. 



