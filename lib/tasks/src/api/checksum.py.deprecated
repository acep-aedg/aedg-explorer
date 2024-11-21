import os
import hashlib

def sha256(base_name: str, file_type: str, dir="api"):
    """Download a file from the given URL to the specified path and verify its checksum.
    If no checksum file exists, calculate and save it.
    
    :param base_name: Name of file without extension (used for creating the checksum file).
    :param file_type: Extension type of the file (geojson, csv, xlsx, zip, etc.).
    :param dir: Directory structure to store the file and checksum.
    """
    
    # Construct the full file paths
    filename = f"{base_name}.{file_type}"
    partial_path = f"{dir}/{base_name}/data/"
    filepath = os.path.join(partial_path, filename)  # Path to the actual file
    sha256_filepath = os.path.join(partial_path, f"{base_name}.sha256")  # Path to the checksum file
    
    # Ensure the directory exists (create it if it doesn't)
    os.makedirs(partial_path, exist_ok=True)
    
    # Check if the checksum file exists
    if not os.path.isfile(sha256_filepath):
        print(f"No checksum found for {base_name}, assuming this download is valid and calculating checksum...")
        
        # Calculate the checksum of the downloaded file
        sha256_hash = hashlib.sha256()
        try:
            with open(filepath, "rb") as f:
                # Read in chunks to avoid memory issues with large files
                for byte_block in iter(lambda: f.read(4096), b""):
                    sha256_hash.update(byte_block)
            download_checksum = sha256_hash.hexdigest()
            
            # Write the checksum to the .sha256 file (create it if it doesn't exist)
            with open(sha256_filepath, "w") as f:
                f.write(download_checksum)
            print(f"Checksum calculated and saved to {sha256_filepath}")
        
        except FileNotFoundError:
            print(f"Error: The file {filepath} does not exist. Cannot calculate checksum.")
            exit(1)
    
    else:
        print(f"Checksum found at {sha256_filepath}, verifying...")

        # Read the expected checksum from the checksum file
        with open(sha256_filepath, "r") as f:
            expected_checksum = f.read().strip()
            print(f"Expected checksum:   {expected_checksum}")

        # Calculate the checksum of the downloaded file to compare
        sha256_hash = hashlib.sha256()
        try:
            with open(filepath, "rb") as f:
                for byte_block in iter(lambda: f.read(4096), b""):
                    sha256_hash.update(byte_block)
            download_checksum = sha256_hash.hexdigest()
            print(f"Calculated checksum: {download_checksum}")

            # Compare the checksums
            if expected_checksum == download_checksum:
                print("Checksum matches! File is valid or unchanged.")
            else:
                print("Checksum does not match! There may have been an error with the download or the data has changed. Please investigate.")
                exit(1)
        
        except FileNotFoundError:
            print(f"Error: The file {filepath} does not exist. Cannot verify checksum.")
            exit(1)


if __name__ == "__main__":
    base_name = "us-census.gaz2024"  # Example base name
    file_type = "csv"  # Example file type
    sha256(base_name, file_type)