#!/bin/bash

# Define the GeoJSON file and the table name
GEOJSON_FILE="../api/ak-dol.places2020/data/ak-dol.places2020.geojson"
TABLENAME="places2020"

echo "GeoJSON file: $GEOJSON_FILE"

# Run ogr2ogr to load the GeoJSON into PostgreSQL/PostGIS
ogr2ogr -f "PostgreSQL" PG:"host=$PG_HOST user=$PG_USER dbname=$PG_DB " \
        "$GEOJSON_FILE" \
        -nln "$TABLENAME" \
        -overwrite
