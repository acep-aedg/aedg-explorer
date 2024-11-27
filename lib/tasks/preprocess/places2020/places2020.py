from zipfile import ZipFile 
import geopandas as gpd

# load the zip and create a zip object 
with ZipFile('api/ak-dol.places2020/data/ak-dol.Places2020.zip', 'r') as zObject: 
    # extract all to path 
    zObject.extractall(path='preprocess/places2020/data/') 

# load data
polys = gpd.read_file('preprocess/places2020/data/Places2020.shp')

# quick regex? do in database instead?
# polys['NAME'] = polys['NAME'].str.replace(r'\b(CDP|city|and|borough|municipality)\b', '', regex=True).str.strip()

polys.to_file('preprocess/places2020/data/places2020.geojson', driver = 'GeoJSON')