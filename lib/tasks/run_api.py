import os
import yaml

from api.functions.api import download
from api.functions.checksum import compare_hashes
from api.functions.purge import delete

# List of directories containing the 'source.yml' file
directories = [
    "us-census.2024_gaz_place_02",
    "ak-dol.places2020",
    "ak-dol.employment"
]

for dir_name in directories:
    # Build the path to the source.yml file
    source_yml_path = os.path.join('api', dir_name, 'source.yml')

    print(f"{source_yml_path}")


    # Check if the source.yml exists in the current directory
    if os.path.isfile(source_yml_path):
        print(f"Processing {source_yml_path}...")

        # Read the YAML file
        with open(source_yml_path, 'r') as file:
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

        print(f"Finished processing {base_name}.\n")
    else:
        print(f"Error: {source_yml_path} not found in {dir_name}. Skipping...\n")
