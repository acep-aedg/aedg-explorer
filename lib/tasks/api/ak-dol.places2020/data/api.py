import os
import hashlib
import requests
import subprocess
import zipfile

# Set the working directory to the location of this script
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
os.chdir(SCRIPT_DIR)

# Define the base name for the file
BASE_NAME = "ak-dol.places2020"
EXTRACTED_NAME = "Places2020"

# Check if the zip file exists, delete if it does
zip_file = f"{BASE_NAME}.zip"
if os.path.isfile(zip_file):
    print("File exists, deleting")
    os.remove(zip_file)
else:
    print("File not found, skipping purge")

# Check if the extract directory exists, delete if it does
extract_dir = "extract"
if os.path.isdir(extract_dir):
    print("Extract directory exists, deleting")
    os.rmdir(extract_dir)  # Use os.rmdir or shutil.rmtree for directories with files
else:
    print("Extract directory not found, skipping purge")

# Download the zip file if it doesn't exist
if not os.path.isfile(zip_file):
    # Read the URL from the BASE_NAME.url file
    url_file = f"{BASE_NAME}.url"
    try:
        with open(url_file, "r") as f:
            url = f.read().strip()
    except FileNotFoundError:
        print(f"Error: {url_file} not found")
        exit(1)

    print(f"Downloading {BASE_NAME}")
    try:
        response = requests.get(url)
        response.raise_for_status()  # will raise an exception for 4xx/5xx responses
        with open(zip_file, "wb") as f:
            f.write(response.content)
        print("Download successful!")
    except requests.RequestException as e:
        print(f"Error: unable to download {BASE_NAME}.zip - {e}")
        exit(1)
else:
    print("File exists, check purge")

# Verify the checksum
sha256_file = f"{BASE_NAME}.sha256"
if not os.path.isfile(sha256_file):
    print("No checksum found, assuming this download is valid and assigning checksum to disk")

    # Calculate the checksum
    sha256_hash = hashlib.sha256()
    with open(zip_file, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)

    download_checksum = sha256_hash.hexdigest()

    # Write checksum to file
    with open(sha256_file, "w") as f:
        f.write(download_checksum)
else:
    print("Checksum found, verifying...")

    # Read the expected checksum from the file
    with open(sha256_file, "r") as f:
        expected_checksum = f.read().strip()

    # Calculate the checksum of the downloaded file
    sha256_hash = hashlib.sha256()
    with open(zip_file, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)

    download_checksum = sha256_hash.hexdigest()

    # Compare the checksums
    if expected_checksum == download_checksum:
        print("Checksum matches! File is valid.")
    else:
        print("Checksum does not match! There may have been an error with the download.")
        exit(1)

# Extract the zip file if the directory doesn't exist
if not os.path.isdir(extract_dir):
    print(f"Extracting {BASE_NAME}.zip to {extract_dir}")
    with zipfile.ZipFile(zip_file, 'r') as zip_ref:
        zip_ref.extractall(extract_dir)
    print("Extraction successful!")
else:
    print("Extraction already completed. Skipping unzip.")

# Define the command for ogr2ogr
cmd = f"ogr2ogr -f GeoJSON {BASE_NAME}.geojson {extract_dir}/{EXTRACTED_NAME}.shp -t_srs EPSG:3338"

# Check if the GeoJSON file already exists
geojson_file = f"{BASE_NAME}.geojson"
if not os.path.isfile(geojson_file):
    print(f"Creating {BASE_NAME}.geojson with ogr2ogr")
    try:
        # Run the ogr2ogr command
        result = subprocess.run(cmd, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print("Conversion successful")
    except subprocess.CalledProcessError as e:
        print(f"Failed: {cmd}")
        print(f"Error: {e.stderr.decode()}")
        exit(1)
else:
    print(f"{BASE_NAME}.geojson already exists. Skipping conversion.")

print(f"Ok! We have {BASE_NAME}.geojson as an EPSG:3338 file.")
