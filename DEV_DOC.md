# Developer Documentation

This document provides a comprehensive technical guide for developers working on the Inception project. Its purpose is to explain the underlying architecture (which relies on **Alpine Linux 3.23** containers), detail the steps required to set up the environment from scratch, describe the build and launch processes using Docker Compose, and provide the necessary commands to effectively manage containers, volumes, and persistent data.

## Alpine vs Debian

For this project, **Alpine Linux 3.23** (the penultimate stable version, as required by the subject) was chosen as the base image for all containers. We intentionally avoid using the `latest` tag to ensure strict reproducibility: relying on a specific, pinned version guarantees that our infrastructure builds deterministically and will not suddenly break due to unexpected upstream updates.

| Feature             | Alpine Linux                                                                                  | Debian                                                           |
| ------------------- | --------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| **Size**            | Extremely small (base image is ~5MB).                                                         | Larger (base image is ~100MB+).                                  |
| **Package Manager** | `apk` (fast and simple).                                                                      | `apt` (feature-rich and widely used).                            |
| **C Library**       | `musl libc` (lightweight but can cause compatibility issues with some pre-compiled binaries). | `glibc` (standard, highly compatible).                           |
| **Security**        | Minimal surface area for attacks due to small footprint.                                      | Larger attack surface, but benefits from rapid security updates. |

> [!IMPORTANT]
> **Why Alpine?** Alpine has been chosen for its minimal footprint, which speeds up build times and reduces overhead, perfectly aligning with the project's performance requirements. While more standard and easier for beginners, Debian is too heavy for the strict resource optimization goals of this setup.

## Prerequisites

- VM

## Setting up the environment from scratch

Before launching the project, you must prepare the host environment and credentials:

1. **Secrets & Environment:**
   - Copy `srcs/.env.example` to `srcs/.env` and fill in the passwords.
   - Copy the `secrets_example/` folder to `secrets/` and replace the placeholder passwords in the `.txt` files.
2. **Automated Host Setup:** 
   The project requires routing `spacotto.42.fr` to `127.0.0.1` and creating the persistent data directories in `/home/spacotto/data/`. 
   To automate this securely, simply use the custom Makefile setup rule:
   
   ```bash
   make setup
   ```
   
   *(This rule is also automatically executed the first time you run `make` or `make all`).*

## Makefile Rules Reference

This project relies on a custom `Makefile` at the root of the repository to wrap Docker Compose commands and environment setup scripts for ease of use. Below is a comprehensive list of all available commands:

- **`make setup`**: Prepares the host machine by creating required data directories (`/home/$(USER)/data/mariadb` and `/home/$(USER)/data/wordpress`) and configuring local domain routing in `/etc/hosts`.
- **`make all`**: The default rule. It runs `setup` and then launches the infrastructure in the background using `docker compose up -d`.
- **`make build`**: Builds or rebuilds the Docker images and launches the containers (`docker compose up -d --build`).
- **`make down`**: Safely stops and removes the running containers and the custom network, but preserves all images and persistent volume data.
- **`make re`**: Restarts the infrastructure by running `down` followed by `build`.
- **`make clean`**: Runs `down` and then removes all unused and dangling Docker images and containers from the system via `docker system prune -a`.
- **`make fclean`**: Performs a deep clean. Stops all running containers across the host, and aggressively prunes all images, containers, networks, and Docker-managed volumes.
- **`make reset`**: Performs a total environment wipe. It completely stops and forcefully removes all Docker entities (containers, images, volumes, networks) and **deletes the host machine data directories** in `/home/$(USER)/data/`.
- **`make help`**: Displays a helpful in-terminal list of all these available rules.
  
  ## Managing containers and volumes

As a developer, you will often need to debug the infrastructure. Here are the most relevant commands:

- **List running containers:** `docker ps`
- **View logs for a specific service:** `docker logs <container_name>` (e.g., `docker logs mariadb`)
- **Open an interactive shell inside a container:** `docker exec -it <container_name> sh`
- **List all volumes:** `docker volume ls`
- **Inspect a specific volume:** `docker volume inspect <volume_name>`
- **View Docker network details:** `docker network inspect inception_network`

## Data storage and persistence

To ensure data survives container restarts and crashes, this project uses Docker Named Volumes configured to behave like bind mounts, adhering strictly to the subject requirements.

- **MariaDB Database Files:** Stored persistently on the host at `/home/spacotto/data/mariadb`. 
- **WordPress Website Files:** Stored persistently on the host at `/home/spacotto/data/wordpress`.

This data persists completely independently of the containers' lifecycle. Even if you run `make down` and completely rebuild the `mariadb` image, the database records and WordPress posts will remain perfectly intact upon the next launch, provided the host directories are not manually deleted.

## Architectural Best Practices

To ensure a robust, secure, and modern containerized infrastructure, the following design principles were strictly implemented:

- **Isolated Custom Networking:** The project explicitly defines and uses a custom bridge network (`inception_network`). Legacy features such as the `--link` flag and `network: host` mode are intentionally avoided to ensure strict network isolation and security between services.
- **Native Foreground Execution & No Infinite Loops:** Containers are configured to run their main processes natively in the foreground (e.g., `mysqld`, `nginx -g "daemon off;"`, `php-fpm82 -F`). This ensures proper Docker lifecycle management. Consequently, there are strictly no infinite loops or artificial keep-alive commands (such as `sleep infinity`, `tail -f /dev/null`, or `tail -f /dev/random`) anywhere in the scripts. The only loop utilized is a standard readiness probe that safely terminates once the database is reachable.
- **Clean Entrypoint Scripts:** The `ENTRYPOINT` scripts are designed to execute their configuration tasks synchronously without throwing any programs into the background. Every script terminates with `exec "$@"` to cleanly replace the shell process with the main application (passed via the Dockerfile's `CMD`). This ensures the container is managed directly by the primary service, completely preventing any dangling or interactive shells (such as `& bash`) from keeping the containers running artificially.
