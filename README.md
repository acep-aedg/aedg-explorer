# AEDG Explorer

Welcome to the AEDG Explorer! This project is designed to... (TBD)

## Getting Started

To start, we recommend reading through the [ACEP DevOps Rails Applications Guide](https://wiki.acep.uaf.edu/en/devops/rails-applications-from-scratch) for a comprehensive understanding of the setup and best practices.

### Dependencies

Ensure you have the following dependencies installed:

- **Ruby**: 3.2.3+
- **Yarn**: 1.22.21
- **Node.js**: v21.6.1
- **PostgreSQL**

### Running the Application

#### 1. Start the Database

To start the PostgreSQL database, use Docker Compose:

```bash
docker compose up
```

#### 2. Start the Web Server

To start the web server on port 3001, run:

```bash
bin/dev -p 3001
```

