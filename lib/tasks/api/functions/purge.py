
import os

def delete(base_name: str, file_type: str, dir="api/"):
    """Delete the file in preparation for download/replace.
    :param base_name: Name of file without extension. This name is chosen by you and not dependent on the data itself. Must correspond to directory name and URL file name. 
    :param file_type: Extension type of raw data (geojson, csv, xlsx, zip).
    """

    filename = f"{base_name}.{file_type}"
    partial_path = f"{dir}/{base_name}/data/"
    filepath = f"{partial_path}{filename}"

    # Check if the file already exists, delete if it does
    if os.path.isfile(filepath):
        print("File exists, deleting")
        os.remove(filepath)
    else:
        print("File not found, skipping purge")
