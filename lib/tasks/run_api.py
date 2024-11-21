import yaml
from src.api.api import download
from src.api.checksum import compare_hashes
from src.api.purge import delete

# # test file
# base_name = "us-census.gaz2024"
# file_type = "csv"

# point towards YAML source file
yaml_file = 'api/us-census.2024_gaz_place_02/source.yml'


# Read the YAML file
with open(yaml_file, 'r') as file:
    data = yaml.safe_load(file)

# Extract the first item in the 'files' list (assuming only one entry)
file_info = data['files'][0]  # There is only one record, so we grab the first item

# Dynamically get the base_name (first key in the dictionary)
base_name = list(file_info.keys())[0]

# Get the file_type for that base_name
file_type = file_info[base_name]['file_type']
url = file_info[base_name]['url']
sha256 = file_info[base_name]['sha256']

# Print out the values
print(f"Base Name: {base_name}")
print(f"File Type: {file_type}")
print(f"URL: {url}")
print(f"sha256: {sha256}")


# # archive()  <- future feature script
delete(base_name, file_type)
download(base_name, file_type, url)
compare_hashes(base_name, file_type, sha256)
