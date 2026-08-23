# Developer Documentation

This document provides a comprehensive technical guide for developers working on the Inception project. Its purpose is to explain the underlying architecture, detail the steps required to set up the environment from scratch, describe the build and launch processes using Docker Compose, and provide the necessary commands to effectively manage containers, volumes, and persistent data.

## Setting up the environment from scratch

### Download the ISO

### Allocate Resources (VM Settings)
| Resource | Allocation |
| :--- | :--- |
| **CPU** | 2 Cores (1 core can work, but compiling software during docker build will be painfully slow). |
| **RAM** | 2 GB to 4 GB (4 GB is ideal so the MariaDB database has plenty of breathing room). |
| **Storage** | 15 GB to 20 GB (Dynamically allocated). Docker images can take up a few gigabytes, so 8GB is often too tight. |
| **Network** | Set the network adapter to Bridged Adapter (or NAT with port forwarding for ports 443 and 22). This ensures you can access the VM from your local browser later. |

### Configuring MariaDB

## Building and launching the project
*(Describe how to build and launch the project using the Makefile and Docker Compose here.)*

## Managing containers and volumes
*(List relevant Docker commands to manage the containers, networks, and volumes here.)*

## Data storage and persistence
*(Identify where the project data is stored on the host machine and how it persists using Docker named volumes here.)*
