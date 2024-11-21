# This script should be able to handle CSV, GeoJSON, Zip, XLSX, and (other?) filetypes.
# We want it to read a url from file (ex ak-dol.places2020.url) and download that endpoint.
# We want error handling and verbosity

import os
import requests

def download(base_name: str, file_type: str, dir="api/"):
    """Download a file from the given URL to the specified path.
    :param base_name: Name of file without extension. This name is chosen by you and not dependent on the data itself. Must correspond to directory name and URL file name. 
    :param file_type: Extension type of raw data (geojson, csv, xlsx, zip).
    """

    filename = f"{base_name}.{file_type}"
    partial_path = f"{dir}/{base_name}/data/"
    filepath = f"{partial_path}{filename}"
    url_file = f"{base_name}.url"
    url_filepath = f"{partial_path}{base_name}.url"

    # Download the file if it doesn't exist (shouldn't exist, purged in the step before)
    if not os.path.isfile(filepath):
        # Read the URL from the base_name.url file
        try:
            with open(url_filepath, "r") as f:
                url = f.read().strip()
            print(f"{base_name} URL file found")
        except FileNotFoundError:
            print(f"Error: URL file {url_file} not found. Hint: This file is manually created and populated with the endpoint URL string.")
            print(f"Also, check execution paths. The script is searching for {url_filepath}") 
            exit(1)

        print(f"Downloading {base_name}")
        try:
            response = requests.get(url)
            response.raise_for_status()  # will raise an exception for 4xx/5xx responses
            with open(filepath, "wb") as f:
                f.write(response.content)
            print("Download successful!")
        except requests.RequestException as e:
            print(f"Error: unable to download {base_name}.{file_type} - {e}")
            exit(1)
    else:
        print(f"File exists, skipping download, check purge script")


if __name__ == "__main__":
    base_name = "us-census.gaz2024"  # Example base name
    file_type = "csv"  # Example file type
    download(base_name, file_type)