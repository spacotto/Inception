# Developer Documentation

This document provides a comprehensive technical guide for developers working on the Inception project. Its purpose is to explain the underlying architecture (which relies on **Alpine Linux 3.19** containers), detail the steps required to set up the environment from scratch, describe the build and launch processes using Docker Compose, and provide the necessary commands to effectively manage containers, volumes, and persistent data.

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

## Building and launching the project

This project relies on a custom `Makefile` at the root of the repository to wrap Docker Compose commands for ease of use.

- **To build and start all containers in the background:**
  ```bash
  make build
  ```
- **To stop the project without deleting volumes:**
  ```bash
  make down
  ```
- **To completely tear down the project (including all images, containers, and volumes):**
  ```bash
  make fclean
  ```
  
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
