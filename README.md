# 🐳 Inception Project

A comprehensive Docker containerization project focused on building a small infrastructure composed of multiple services.

## 📋 Project Overview

The Inception project challenges you to create a virtualized infrastructure using Docker containers. This project will help you master Docker containerization, build custom images, understand Docker's internal workings, and implement a complete multi-service architecture.

### Key Requirements

- Set up virtualized infrastructure with multiple containers
- Build custom Docker images (using only Alpine/Debian base images)
- Create a Docker Compose file to orchestrate everything
- Configure persistent volumes for data retention
- Implement secure networking between containers
- Establish proper service dependencies and startup sequences

## 🚀 Quick Start

```bash
# Clone the repo
git clone https://github.com/ys4ber/42-inception.git && cd 42-inception

# Set up the environment
make setup

# Build and start containers
make

# Check running containers
make ps

# Stop all containers
make down
```

## 🏗️ Project Architecture

The Inception project implements the following architecture:

- **NGINX Container**: Web server with TLS/SSL support
- **WordPress Container**: PHP-FPM implementation
- **MariaDB Container**: Database service
- **Redis Container**: Caching service

### Bonus Services

- **Adminer**: Database management
- **FTP Server**: File transfer access
- **Static Website**: Simple HTML site
- **Portainer**: Docker management UI

### Network Architecture

```
                 ┌─────────────┐
                 │    NGINX    │ :443 (HTTPS)
                 │  Front-end  │◄──── User Traffic
                 └──────┬──────┘
                        │
                        ▼
                 ┌─────────────┐
                 │  WordPress  │
                 │   + PHP-FPM │
                 └──┬───────┬──┘
                    │       │
           ┌────────┘       └─────────┐
           ▼                          ▼
    ┌─────────────┐             ┌─────────────┐
    │   MariaDB   │             │    Redis    │
    │  Database   │             │    Cache    │
    └─────────────┘             └─────────────┘
```

## 🔧 Docker Components

### Docker Client Side

#### Basic Commands

- `docker run`: Run a container
- `docker build`: Build an image
- `docker-compose up`: Start services defined in docker-compose.yml
- `docker exec`: Execute commands in running containers

#### Image Building Process

1. Define a Dockerfile
2. Run docker build
3. Get a docker image
4. Optional: Upload to container registry (like Docker Hub)

### Docker Server Side (Docker Daemon - dockerd)

The daemon:
- Is a container runtime
- Listens to requests from the Docker client
- Manages objects (images, containers, networks, volumes)

Important concepts:
- **Docker image**: Read-only template for running containers
- **Container**: Runnable instance of an image

## 📝 Docker-Compose Guide

```yaml
version: "[version]"  # Specify compose format (e.g., '3.8')

services:             # Define containers
  [service_name]:
    container_name: string
    image: string    # Use existing image
    build:           # Build custom image
      context: path  # Build context directory
      dockerfile: string
      args:          # Build arguments
        - key=value
    ports:           # Port mapping
      - "host:container"
    volumes:         # Data persistence
      - [volume_name]:[container_path]
      - [host_path]:[container_path]
    environment:     # Environment variables
      - KEY=value
    env_file:        # Load from .env file
      - path
    depends_on:      # Start dependencies first
      - [service_name]
    networks:        # Connect to networks
      - [network_name]
    restart: string  # Restart policy
                    # no|always|on-failure|unless-stopped

volumes:             # Define named volumes
  [volume_name]:
    driver: string   # Volume driver type
    driver_opts:     # Driver-specific options
      type: string
      o: string
      device: path

networks:            # Define custom networks
  [network_name]:
    driver: string   # Network driver type
                    # bridge|host|overlay|macvlan|none
    driver_opts:     # Driver-specific options
    ipam:           # IP Address Management
      config:
        - subnet: string
        - gateway: string
```

## 🛠️ Inception Project Implementation Guide

### 1. Setting Up the Environment

Start by preparing your host machine:

```bash
# Create necessary directories for persistent data
mkdir -p /home/$(USER)/data/wordpress
mkdir -p /home/$(USER)/data/mariadb
```

### 2. Creating Service Dockerfiles

For each service, create a Dockerfile focusing on:

#### NGINX Container

- Base on Alpine/Debian
- Configure with SSL/TLS support
- Set up reverse proxy to WordPress
- Redirect HTTP to HTTPS

```dockerfile
FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

# SSL certificate generation
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=XX/ST=State/L=City/O=Organization/OU=Unit/CN=domain.tld"

# Configuration
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
```

#### WordPress Container

- Base on Alpine/Debian
- Install PHP-FPM and extensions
- Configure to connect to MariaDB
- Set up with Redis caching

#### MariaDB Container

- Base on Alpine/Debian
- Configure secure database access
- Set up initialization scripts
- Configure persistent storage

### 3. Docker Compose Configuration

Structure your docker-compose.yml file with:
- Clear service dependencies
- Persistent volume mapping
- Proper network configuration
- Environment variable management

### 4. Testing and Debugging

Common troubleshooting approaches:

```bash
# Check container logs
docker-compose logs [service_name]

# Enter a running container
docker exec -it [container_name] /bin/bash

# Check WordPress connection to MariaDB
docker exec -it wordpress wp db check

# Verify network connectivity
docker exec -it [container_name] ping [other_container_name]
```

## 🔍 Docker Implementation Details

### 1. The Container Building Blocks

Docker uses Linux kernel features:

- **Namespaces**: Container isolation
  - Separates processes, networks, and file systems
  - Like giving each container its own private room

- **Cgroups**: Resource control
  - Controls CPU, memory, and resource usage
  - Like setting house rules

### 2. The Image System

Docker images are built in layers:
- Bottom layer: Basic operating system
- Middle layers: Added programs and dependencies
- Top layer: Your specific application
- Each layer is read-only except the top container layer

### 3. Container Runtime Process

When starting a container, Docker:
1. Takes your image recipe
2. Creates a new writable layer
3. Sets up isolated environment (namespaces)
4. Applies resource limits (cgroups)
5. Starts your application

### 4. Storage System

Features:
- Uses "copy-on-write" system
- Shares base layers between containers
- Only stores container-specific changes
- Optimizes space and startup time

### 5. Networking

Capabilities:
- Creates virtual network interfaces
- Assigns container IP addresses
- Enables container communication
- Provides external connectivity

## 🧠 ContainerD Deep Dive

ContainerD serves as a container manager between Docker and the Linux OS.

### Core Functions

**Container Operations**:
- Downloads and stores images
- Manages container lifecycle (start, stop, pause)
- Sets up networking
- Manages storage
- Handles low-level tasks

### Background

- Originally part of Docker
- Now independent
- Managed by CNCF
- Used by various container tools

### Architecture

- Runs as a daemon
- Simple, focused design
- Provides APIs
- Uses runc for container creation

### Advantages

- More stable than Docker Engine
- Independent usage possible
- Industry standard
- Simpler maintenance

### Docker Integration

- Used internally by Docker
- Docker adds features on top
- Can run independently
- Popular in cloud platforms

## 🔄 Complete Docker Implementation Summary

### Layer Structure (Bottom to Top)

**Core Linux Features (Foundation)**:
- Linux Kernel (namespaces, cgroups)
- Basic container building blocks
- Process/network/filesystem separation
- Resource control

**Container Runtime (Engine Room)**:
- runc at lowest level
- Direct kernel interaction
- Container environment creation
- Isolation and resource management

**Container Supervisor (Manager)**:
- containerd layer
- Lifecycle management
- Image and storage handling
- Network management
- Daemon process operation

**Docker Engine (Control Center)**:
- dockerd process
- API request handling
- Service management
- Network and storage control

**Docker Interface (User Layer)**:
- CLI interface
- Dockerfile processing
- Docker Compose functionality
- Docker Hub integration

### Container Execution Flow

1. User enters docker command
2. CLI sends to Docker daemon
3. Daemon delegates to containerd
4. containerd uses runc
5. runc configures system
6. Application launches

### Container Layer Structure

1. Base OS (read-only)
2. Dependencies (read-only)
3. Application (read-only)
4. Container (writable)

## 🚀 Inception Advanced Concepts

### 1. Multi-Stage Builds

Optimize your Dockerfiles using multi-stage builds to reduce image size:

```dockerfile
# Build stage
FROM debian:bullseye AS builder
RUN apt-get update && apt-get install -y build-dependencies
# Build application...

# Runtime stage
FROM debian:bullseye
COPY --from=builder /app/binary /usr/local/bin/
# Only runtime dependencies...
```

### 2. Health Checks

Implement health checks to ensure services are truly ready:

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
```

### 3. Security Best Practices

- Run processes as non-root users
- Use read-only file systems where possible
- Implement proper secrets management
- Scan images for vulnerabilities

### 4. Resource Management

Configure appropriate resource limits:

```yaml
services:
  wordpress:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
```

## 📚 Further Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose File Reference](https://docs.docker.com/compose/compose-file/)
- [ContainerD Project](https://containerd.io/)
- [docker docs again](https://docs.docker.com/engine/security/userns-remap/)
- [42 School Inception Project](https://github.com/ys4ber/42-inception)

For more information, visit: https://www.docker.com/blog/
