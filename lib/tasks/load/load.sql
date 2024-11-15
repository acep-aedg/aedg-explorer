LOAD spatial;

CREATE TABLE gaz2024 AS SELECT * FROM '../api/us-census.gaz2024/data/us-census.gaz2024.csv';

-- Don't forget to wrap spatial filepaths in ST_Read()!
CREATE TABLE places2020 AS SELECT * FROM ST_Read('../api/ak-dol.places2020/data/ak-dol.places2020.geojson');