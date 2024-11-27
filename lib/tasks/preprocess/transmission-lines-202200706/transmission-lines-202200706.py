import geopandas as gpd

load = 'api/aea.transmission-lines-202200706/aea.transmission-lines-202200706.shp'
save = 'preprocess/transmission-lines-202200706/data/transmission-lines-202200706.geojson'
target_crs = '3338'

# import
raw = gpd.read_file(load)

# clean
reprojected = raw.to_crs(target_crs)
out = reprojected

# export
out.to_file(save, driver='GeoJSON')