import os
import subprocess

# Set the working directory to the location of this script
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

# Define the base name for the file
BASE_NAME = "ak-dol.employment"
url_file = os.path.join(SCRIPT_DIR, f"{BASE_NAME}.url")
# Define the output file path for GeoJSON
geojson_file = os.path.join(SCRIPT_DIR, f"{BASE_NAME}.geojson")


# Check if the geojson file exists, delete if it does
geojson_file = f"{BASE_NAME}.geojson"
print(f"Checking if {geojson_file} exists.")
if os.path.isfile(geojson_file):
    print(f"{geojson_file} exists, deleting.")
    os.remove(geojson_file)
else:
    print("File not found, skipping purge.")

# Read the URL from the {BASE_NAME}.url file
try:
    with open(url_file, "r") as f:
        url = f.read().strip()
    print(f"URL found: {url}")
except FileNotFoundError:
    print(f"Error: {url_file} not found")
    exit(1)


# Ensure the output directory exists
output_dir = os.path.dirname(geojson_file)
if not os.path.exists(output_dir):
    print(f"Creating output directory: {output_dir}")
    os.makedirs(output_dir)


# Step 3: Use OGR2OGR to directly download and convert the GeoJSON from the URL
cmd = f"ogr2ogr -f GeoJSON {BASE_NAME}.geojson '{url}' -t_srs EPSG:3338"


# Debugging: Print the command being executed
print(f"Running command: {cmd}")

# Run the command
try:
    subprocess.run(cmd, shell=True, check=True)
    print(f"Download successful! Saved as {BASE_NAME}.geojson")
except subprocess.CalledProcessError as e:
    print(f"Error running ogr2ogr: {e}")
    exit(1)
