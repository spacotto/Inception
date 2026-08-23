# Developer Documentation

This document provides a comprehensive technical guide for developers working on the Inception project. Its purpose is to explain the underlying architecture, detail the steps required to set up the environment from scratch, describe the build and launch processes using Docker Compose, and provide the necessary commands to effectively manage containers, volumes, and persistent data.

## Setting up the environment from scratch

### Download the ISO
Go to the [Alpine Linux Downloads page](https://alpinelinux.org/downloads/) and download the "Standard" or "Virtual" edition ISO. (Choose `x86_64` if you are on an Intel/AMD machine, or `aarch64` if you are on an Apple Silicon Mac).

### Allocate Resources (VM Settings)
| Resource | Allocation |
| :--- | :--- |
| **CPU** | 2 Cores (Recommended for faster Docker image building). |
| **RAM** | 1 GB to 2 GB (2 GB is plenty for Alpine + MariaDB + WordPress). |
| **Storage** | 10 GB to 15 GB (Dynamically allocated). |
| **Network** | Bridged Adapter (or NAT with port forwarding for `443` and `22`). |

### OS Installation (`setup-alpine`)
Boot up the VM with the ISO attached.

1. When prompted for a login, type `root` (there is no password yet).

2. Type the command to start the installer:

```bash
setup-alpine
```

3. The installer will ask you a series of questions:

| | |
| :--- | :--- |
| **Keyboard Layout** | Select your language/variant. |
| **Hostname** | e.g., `inception`. |
| **Network** | Press `Enter` to use the default `eth0` and `dhcp`. |
| **Root Password** | Set a secure password. |
| **Timezone** | Type `?` to find yours, e.g., `Europe` then `Paris`. |
| **Mirror** | Type `f` or `1` to select the fastest package mirror. |
| **SSH server** | Press `Enter` to use `openssh`. |
| **Disk setup** | This is the most important part! Type `sda` (or whatever your disk is named), and when asked how you want to use it, type `sys`: this installs it permanently to the hard drive. |

4. Once it finishes, type `poweroff`, remove the ISO from your VM settings, and boot it back up!

### Post-Installation Setup (Docker & Users)
Log in as `root` with the password you just created.

1. **Enable Community Packages:** Open `/etc/apk/repositories` with `vi` and uncomment the line ending in `/community`.
2. **Create your user:** run `adduser spacotto` (replace with your login).
3. **Install dependencies:** `apk update && apk add sudo git docker docker-cli-compose`
4. **Enable Docker:** 
   - `rc-update add docker boot`
   - `service docker start`
5. **Permissions:** Add your user to the required groups:
   - `adduser spacotto wheel`
   - `adduser spacotto docker`
   - Run `visudo` and uncomment `%wheel ALL=(ALL:ALL) ALL` to enable sudo.

### Host Machine Configuration
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
