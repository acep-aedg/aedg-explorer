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

    To start the PostgreSQL database, use Docker Compose:

    ```bash
    docker compose up -d
    # Create .env with the database credentials
    echo "DATABASE_URL=postgres://postgres@localhost:5433" > .env
    rails db:setup
    ```

1. Start the Web Server

    To start the web server on port 3001, run:

    ```bash
    bin/dev -p 3001
    ```
---

### Importing Data

**Communities**

1. Download the `communities.geojson` file from the AEDG Google Drive and place it in `db/imports/`
2. Run the rake task to import communities into the db: `rails import:communities`

---

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

