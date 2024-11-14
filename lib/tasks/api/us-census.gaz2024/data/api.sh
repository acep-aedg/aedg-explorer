#!/usr/bin/env bash

# Set the working directory to the location of this script
SCRIPT_DIR=$(cd $(dirname $BASH_SOURCE[0]) > /dev/null; pwd) 
cd $SCRIPT_DIR

# Define the base name for the file
BASE_NAME="2024_gaz_place_02"

# Check if the file already exists, delete if it does
if [ -f "$BASE_NAME.csv" ]; then
  echo "File exists, deleting"
  rm "$BASE_NAME.csv"
else
  echo "File not found, skipping purge"
fi

# wget the CSV, save to disk
# Note: URL pulled from file BASE_NAME.url
if [ ! -f "$BASE_NAME.csv" ]; then
  echo "Downloading $BASE_NAME"
  wget -O "$BASE_NAME.csv" "$(cat "$BASE_NAME.url")"
  if [ $? -eq 0 ]; then
    echo "Download successful!"
  else
    echo "Error: unable to wget $BASE_NAME.csv"
    exit 1
  fi
else
  echo "File exists, check purge"
fi



# verify the checksum
if [ ! -f "$BASE_NAME.sha256" ]; then
  echo "No checksum found, assuming this download is valid and assigning checksum to disk"
  
  # run checksum, write to file
  DOWNLOAD_CHECKSUM=$(sha256sum "$BASE_NAME.csv" | awk '{ print $1 }')
  echo "$DOWNLOAD_CHECKSUM" > "$BASE_NAME.sha256"
else
  echo "Checksum found, verifying..."
  
  # read the expected checksum from the file
  EXPECTED_CHECKSUM=$(cat "$BASE_NAME.sha256")
  
  # calculate the checksum of the downloaded file
  DOWNLOAD_CHECKSUM=$(sha256sum "$BASE_NAME.csv" | awk '{ print $1 }')

  # compare the expected checksum with the downloaded file's checksum
  if [ "$EXPECTED_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
    echo "Checksum matches! File is valid."
  else
    echo "Checksum does not match! There may have been an error with the download."
    exit 1
  fi
fi
