#!/usr/bin/env bash

# Set the working directory to the location of this script
SCRIPT_DIR=$(cd $(dirname $BASH_SOURCE[0]) > /dev/null; pwd) 
cd $SCRIPT_DIR

# Define the base name for the file
BASE_NAME="ak-dol.places2020"
EXTRACTED_NAME="Places2020"

# check if the zip exists, delete if does
if [ -f "$BASE_NAME.zip" ]; then
  echo "File exists, deleting"
  rm "$BASE_NAME.zip"
else
  echo "File not found, skipping purge"
fi

# check if the zip exists, delete if does
if [ -d extract ]; then
  echo "Extract directory exists, deleting"
  rm -r extract
else
  echo "Extract directory not found, skipping purge"
fi

# wget the CSV, save to disk
# Note: URL pulled from file BASE_NAME.url
if [ ! -f "$BASE_NAME.zip" ]; then
  echo "Downloading $BASE_NAME"
  wget -O "$BASE_NAME.zip" "$(cat "$BASE_NAME.url")"
  if [ $? -eq 0 ]; then
    echo "Download successful!"
  else
    echo "Error: unable to wget $BASE_NAME.zip"
    exit 1
  fi
else
  echo "File exists, check purge"
fi

# verify the checksum
if [ ! -f "$BASE_NAME.sha256" ]; then
  echo "No checksum found, assuming this download is valid and assigning checksum to disk"
  
  # run checksum, write to file
  DOWNLOAD_CHECKSUM=$(sha256sum "$BASE_NAME.zip" | awk '{ print $1 }')
  echo "$DOWNLOAD_CHECKSUM" > "$BASE_NAME.sha256"
else
  echo "Checksum found, verifying..."
  
  # read the expected checksum from the file
  EXPECTED_CHECKSUM=$(cat "$BASE_NAME.sha256")
  
  # calculate the checksum of the downloaded file
  DOWNLOAD_CHECKSUM=$(sha256sum "$BASE_NAME.zip" | awk '{ print $1 }')

  # compare the expected checksum with the downloaded file's checksum
  if [ "$EXPECTED_CHECKSUM" == "$DOWNLOAD_CHECKSUM" ]; then
    echo "Checksum matches! File is valid."
  else
    echo "Checksum does not match! There may have been an error with the download."
    exit 1
  fi
fi

# extract .zip file to directory
if [ ! -d extract ]; then
  echo "extracting ${BASE_NAME}.zip to extract"
  unzip "$BASE_NAME.zip" -d extract
else
  echo "extract already completed. skipping unzip"
fi



# define command
CMD="ogr2ogr -f GeoJSON ${BASE_NAME}.geojson extract/${EXTRACTED_NAME}.shp -t_srs EPSG:3338"
# check if the GeoJSON file already exists
if [ ! -f "${BASE_NAME}.geojson" ]; then
  echo "Creating ${BASE_NAME}.geojson with ogr2ogr"
  # run command
  $CMD
  # check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Conversion successful"
  else
    echo "Failed: $CMD"
    echo "Fix this!!"
    exit 1
  fi
else
  echo "${BASE_NAME}.geojson already exists. Skipping conversion."
fi

echo "Ok! We have ${BASE_NAME}.geojson as an EPSG:3338 file."
