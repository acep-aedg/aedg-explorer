# AEDG Explorer

Welcome to the AEDG Explorer! This project is designed to... (TBD)

## Getting Started

To start, we recommend reading through the [ACEP DevOps Rails Applications Guide](https://wiki.acep.uaf.edu/en/devops/rails-applications-from-scratch) for a comprehensive understanding of the setup and best practices.

### Dependencies

Ensure you have the following dependencies installed:

- **Ruby**: 3.2.3+
- **Yarn**: 1.22.21
- **Node.js**: v21.6.1
- **asdf**: https://asdf-vm.com/
- **PostgreSQL**

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
    docker compose up
    rails db:setup
    ```

1. Start the Web Server

    To start the web server on port 3001, run:

    ```bash
    bin/dev -p 3001
    ```

