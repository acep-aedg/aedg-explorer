# AEDG Explorer

Welcome to the AEDG Explorer! This project is designed to... (TBD)

## Getting Started

To start, we recommend reading through the [ACEP DevOps Rails Applications Guide](https://wiki.acep.uaf.edu/en/devops/rails-applications-from-scratch) for a comprehensive understanding of the setup and best practices.

TODO: Add ruby install instructions

### Dependencies

Ensure you have the following dependencies installed:

- **Ruby**: 3.2.3+
- **Yarn**: 1.22.21
- **Node.js**: v21.6.1
- **asdf**: https://asdf-vm.com/
- **PostgreSQL**

---
### Running the Application

1. Install asdf nodejs/yarn dependencies - https://asdf-vm.com/
    ```bash
    asdf plugin add yarn
    asdf install
    # verify tool versions
    asdf current
    ```

1. Install ruby/gem dependencies - https://wiki.acep.uaf.edu/en/devops/rails-applications-from-scratch

    ```bash
    # install ruby using chruby

    # install ruby gems
    bundle install
    ```

1. Install yarn/npm dependencies

    ```bash
    yarn install
    ```

1. Setup the Database

    To start the PostgreSQL/PostGIS database, use Docker Compose:

    ```bash
    docker compose up -d
    # Create .env with the database credentials
    echo "DATABASE_URL=postgis://postgres@localhost:5433" > .env
    rails db:setup
    ```

    If you get an error about `pg_dump` see the troubleshooting directions below

1. Start the Web Server

    To start the web server on port 3001, run:

    ```bash
    bin/dev -p 3001
    ```
---
### Static Content
Most static content is located in their respective files in `config/data/`
- [FAQ](https://aedg-dev.camio.acep.uaf.edu/user-guide#faq)
  -  Answers Supports Markdown 
- [AEDG Timeline](https://aedg-dev.camio.acep.uaf.edu/about#history)
  -  Descriptions Supports Markdown 
- [Data Creation Steps](https://aedg-dev.camio.acep.uaf.edu/user-guide#data-creation-process)
  -  Descriptions Supports Markdown 
- [Partners](https://aedg-dev.camio.acep.uaf.edu/about#partners)

**Notes:**
- **Markdown**: Descriptions & Answers in the YAML files for the [FAQ](https://aedg-dev.camio.acep.uaf.edu/user-guide#faq), [AEDG Timeline](https://aedg-dev.camio.acep.uaf.edu/about#history), [Data Creation Steps](https://aedg-dev.camio.acep.uaf.edu/user-guide#data-creation-process) can use Markdown for basic formatting (e.g., bold, italics, links, lists).
- **Opening links in a new tab**: Add `{:target='_blank'}` after the link in Markdown to make it open in a new tab.

### 📂 Importing Data

#### Pull Data from Github
1. **Set up Github Repository URL**
    - Before pulling data files from GitHub, ensure you have the correct repository URL and tag configured in your `.env` by adding:

        ```sh
        GH_DATA_REPO_URL=https://github.com/acep-aedg/aedg-data-pond
        GH_DATA_REPO_TAG=v0.1
        ```
        **Note**: See [data-pond releases](https://github.com/acep-aedg/aedg-data-pond/releases) for latest versions.

1. **Run the Rake Task**
    - Use the following command to pull files from Github Repository into the `db/imports/` directory:
        ```sh
        rails import:pull_gh_data
        ```
1. **Verify Files**
    - After running the task, check the `db/imports/` directory to ensure the files have successfully downloaded

#### Run a Full Database Import
To **reset the database**, pull **latest** data files and import **all** data in the **correct** order, use:

```bash
rails import:all
```
**Important**: The GitHub repository URL (`GH_DATA_REPO_URL`) must be set in `.env` before running the full import. Otherwise, the data pull will fail.

 **Note**: Importing **GeoJSON** files with **Polygons/Multipolygons** (e.g., `Borough`, `RegionalCorporation`) can take longer due to the complexity of the spatial data.

#### Importing Individual Models/Tables

We haven’t yet implemented a reliable way to import specific models individually, due to **foreign key constraints and associations**. Some models depend on others, making it difficult to import them individually without breaking data integrity. If you need to import a specific model manually, you will need to clear the table first but be sure to always check model relationships before running individual imports as it may not be possible.

---

### Testing
1. **Prepare the Test Database**
    ```
    rails db:create RAILS_ENV=test
    ```

1. **Run the test suite**
    ```
    rails test
    ```
1. **View Code Coverage**

    Code coverage is tracked using [simplecov](https://github.com/simplecov-ruby/simplecov). After running the tests, a `coverage/` directory will be generated. To view the coverage report, open it in your browser:
    ```
    open coverage/index.html
    ```

# Toubleshooting

## Local Dev Docker Database Setup Issues

### Docker Credentials Error for PostGIS version 16-3.5.

```bash
error getting credentials - err:
```

If you get this error you may need to pull the image manually.

```bash
docker pull postgis/postgis:16-3.5
```

### `rails db:migrate` fails because of missing pg_dump or wrong version of `pg_dump`

Metadata searching uses a `tsvector` field which is not fully supported by the default schema dumper for rails. To work around this the schema is dumped using the `:sql` format instead of the deafult.

This approach requires the correct version of `pg_dump` that matches the PostgreSQL database (Currently v16)

#### To resolve:

Install the correct pg_dump version for the postgresql database. Instructions https://www.postgresql.org/download/linux/

For example on Ubuntu:

```bash
sudo apt install -y postgresql-common
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
sudo apt install postgresql-client-16
```

### **Collation Version Mismatch**

#### **What is a Collation Version Mismatch?**
A collation version mismatch occurs when the collation library version (`glibc`) inside the PostGIS Docker container is newer than the one used when the database was created. This can cause PostgreSQL to issue warnings like the following:
```text
WARNING: database "aedg_explorer_development" has a collation version mismatch
DETAIL: The database was created using collation version X.X, but the operating system provides version Y.Y.
HINT: Rebuild all objects in this database that use the default collation and run ALTER DATABASE ... REFRESH COLLATION VERSION.
```

Collation defines how strings are compared and sorted, and this mismatch needs to be resolved to avoid inconsistencies.

---

#### **Steps to Resolve Manually**

If the warning appears and isn’t resolved automatically:

1. **Log into the Database Container**:
   Use the following command to access the PostgreSQL instance running inside the Docker container:
   ```bash
   docker exec -it aedg_explorer_db psql -U postgres -d aedg_explorer_development
   ```

2. **Refresh the Collation Version**:
   Update the collation metadata for the database to match the current `glibc` version:
   ```sql
   ALTER DATABASE aedg_explorer_development REFRESH COLLATION VERSION;
   ```

3. **Reindex the Database**:
   Rebuild all indexes to align with the updated collation version:
   ```sql
   REINDEX DATABASE aedg_explorer_development;
   ```

4. **Exit the Database**:
   Use `\q` to exit the PostgreSQL prompt.

---

#### **Why is This Necessary?**
The collation mismatch occurs when the database was created with a different version of the collation library than what the container currently uses. This is common after upgrading the PostGIS Docker image.

---

#### **Does This Affect My Data?**
No. This process only updates the collation metadata and rebuilds indexes. Your data remains safe and unchanged.

---

#### **Important Notes**
- These steps are needed only if you encounter the collation warning.
- For fresh setups or newly initialized databases, this issue typically won’t occur.

---

