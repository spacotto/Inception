# User Documentation

This document serves as a straightforward guide for end users and administrators interacting with the Inception project. Its purpose is to explain the services provided by the infrastructure in simple terms, provide clear instructions on how to start and stop the project, demonstrate how to access the website and administration panels, and detail the procedures for managing credentials and verifying service health.

> [!NOTE]
> 
> The entire infrastructure is built on ultra-lightweight Alpine Linux 3.23 containers to maximize performance and minimize resource usage on the host machine.*

## Services provided by the stack

This infrastructure consists of three main components working together:

- **MariaDB (Database):** The backend storage system. It securely stores all website data, including posts, users, passwords, and settings.
- **WordPress (Application):** The Content Management System (CMS). It provides the interface to write articles, manage users, and dynamically generate website pages by querying the database.
- **NGINX (Web Server):** The front door of the system. It handles incoming web traffic securely (using HTTPS/TLS), serves static files directly, and forwards dynamic PHP requests to WordPress.

## Starting and stopping the project

Administrators can control the entire infrastructure using a simplified set of Makefile commands from the root of the project:

- **`make`** or **`make all`**: The default command to start the entire system in the background.
- **`make down`**: Gracefully stops the services without deleting any data.
- **`make clean`** / **`make fclean`** / **`make reset`**: Various levels of cleaning the environment, ranging from clearing unused images to a total wipe of all persistent data.
- **`make help`**: Run this command at any time to see a full, detailed list of all available commands and what they do.
  
  ## Accessing the website and administration panel
  
  Since the web server is configured to route traffic securely to your local domain, you must access the site using your `login.42.fr` (e.g., `https://spacotto.42.fr`).
- **Main Website:** Navigate to `https://spacotto.42.fr` in your web browser. (Your browser may display a security warning because the SSL certificate is self-signed; this is expected and safe to bypass).
- **Administration Panel:** Navigate to `https://spacotto.42.fr/wp-admin` to log in and manage the website.

## Locating and managing credentials

All sensitive passwords and usernames are strictly isolated and never hardcoded into the source code.

- **Environment Variables:** High-level configuration is managed in `srcs/.env` (which is git-ignored). 
- **Secrets:** Passwords for the database and WordPress users are defined in plain text files inside the `secrets/` directory (also git-ignored). 
- To manage or update credentials, an administrator must edit the files in `.env` and `secrets/` and restart the infrastructure. (Templates can be found in `srcs/.env.example` and `secrets_example/`).

## Checking that the services are running correctly

To ensure the infrastructure is healthy:

1. Open a terminal on the host machine.
2. Run `docker ps`. You should see three containers listed (`nginx`, `wordpress`, and `mariadb`) with a status of **Up**.
3. If a service is misbehaving, you can check its logs by running `docker logs <container_name>` (e.g., `docker logs wordpress`).
