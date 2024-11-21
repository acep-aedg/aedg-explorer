from src.api import download
from src.checksum import sha256
from src.purge import delete

# test file
base_name = "us-census.gaz2024"
file_type = "csv"

# archive()  <- future feature script
delete(base_name, file_type)
download(base_name, file_type)
sha256(base_name, file_type)

