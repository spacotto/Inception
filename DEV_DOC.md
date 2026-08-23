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

### Configuring MariaDB

## Building and launching the project
*(Describe how to build and launch the project using the Makefile and Docker Compose here.)*

## Managing containers and volumes
*(List relevant Docker commands to manage the containers, networks, and volumes here.)*

## Data storage and persistence
*(Identify where the project data is stored on the host machine and how it persists using Docker named volumes here.)*
