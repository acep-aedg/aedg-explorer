# `api/`

This directory contains scripting to kick off the pipeline. Functions are loaded from `functions/` directory. 

<br>

Specifically we want to: 
- delete existing data files (`purge.py`)
- downloaded them from API endpoints (`api.py`)
- and check their sha256sum hash for validity (`checksum.py`)

<br>

Data should be unmodified from the source server, any processing should take place in the next step, `preprocess/`.