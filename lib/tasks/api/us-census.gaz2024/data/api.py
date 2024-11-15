import os
import hashlib
import requests

# Set the working directory to the location of this script
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
os.chdir(SCRIPT_DIR)

# Define the base name for the file
BASE_NAME = "us-census.gaz2024"

# Check if the file already exists, delete if it does
csv_file = f"{BASE_NAME}.csv"
if os.path.isfile(csv_file):
    print("File exists, deleting")
    os.remove(csv_file)
else:
    print("File not found, skipping purge")

# Download the CSV file if it doesn't exist
if not os.path.isfile(csv_file):
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
        with open(csv_file, "wb") as f:
            f.write(response.content)
        print("Download successful!")
    except requests.RequestException as e:
        print(f"Error: unable to download {BASE_NAME}.csv - {e}")
        exit(1)
else:
    print("File exists, check purge")

# Verify the checksum
sha256_file = f"{BASE_NAME}.sha256"
if not os.path.isfile(sha256_file):
    print(f"No checksum found, assuming this download is valid and assigning checksum to disk as {BASE_NAME}.sha256sum")
    
    # Calculate the checksum
    sha256_hash = hashlib.sha256()
    with open(csv_file, "rb") as f:
        # Read in chunks to avoid memory issues with large files
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
    with open(csv_file, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    
    download_checksum = sha256_hash.hexdigest()

    # Compare the checksums
    if expected_checksum == download_checksum:
        print("Checksum matches! File is valid.")
    else:
        print("Checksum does not match! There may have been an error with the download.")
        exit(1)
