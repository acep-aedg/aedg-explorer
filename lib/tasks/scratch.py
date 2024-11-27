import geopandas as gpd

full_url = 'https://maps.commerce.alaska.gov/server/rest/services/Economics_Related/Economics_Employment_Wages/MapServer/0/query?outFields=*&where=1%3D1&f=geojson'
geojson_tag = '/query?outFields=*&where=1%3D1&f=geojson'



service_layer = 'https://maps.commerce.alaska.gov/server/rest/services/Tribes_Broadband_Status_Web_Map_Template_MIL1/MapServer/0'

test = gpd.read_file(service_layer + geojson_tag)

test.explore()
