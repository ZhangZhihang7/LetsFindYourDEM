#!/bin/bash

# Base URL
base_url="https://srtm.csi.cgiar.org/wp-content/uploads/files/srtm_5x5/TIFF/srtm_"

# Create download directory and log file
mkdir -p global_dem_tif
failed_log="failed_downloads.log"
> "$failed_log"  # Clear the log file

# Loop through row and column indices
for i in $(seq -f "%02g" 29 72); do
  for j in $(seq -f "%02g" 1 24); do
    file_url="${base_url}${i}_${j}.zip"
    output_file="global_dem_tif/SRTM_${i}_${j}.zip"
    
    # Use wget to download the file, skip on failure
    wget -q --show-progress --tries=3 --timeout=10 "${file_url}" -O "${output_file}"
    
    # If download fails, remove empty file and log the failure
    if [ $? -ne 0 ]; then
      echo "Failed to download ${file_url}, logging."
      echo "${file_url}" >> "$failed_log"
      rm -f "${output_file}"
    fi
  done
done

echo "Download completed. Failed downloads are listed in ${failed_log}."
