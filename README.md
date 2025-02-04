# Docker Guide - From Implementation to Usage

This project focuses on learning Docker: building custom images, understanding Docker's internal workings, and container storage mechanisms.

## Quick Start Commands
```bash
# Build an image
docker build -t test_nginx .

# Run a container
docker run -d -p 443:443 test_nginx
```

## Docker Client Side Components

### Basic Commands
- `docker run`: Run a container
- `docker build`: Build an image
- `docker pull`: Pull an image from registry

### Image Building Process
1. Define a Dockerfile
2. Run docker build
3. Get a docker image
4. Optional: Upload to container registry (like Docker Hub)

## Docker Server Side (Docker Daemon - dockerd)

The daemon:
- Is a container runtime
- Listens to requests from the Docker client
- Manages objects (images, containers, networks, volumes)

Important concepts:
- Docker image: Read-only template for running containers
- Container: Runnable instance of an image

## Docker-Compose Guide

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

## Docker Implementation Details

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
- Takes your image recipe
- Creates a new writable layer
- Sets up isolated environment (namespaces)
- Applies resource limits (cgroups)
- Starts your application

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

## ContainerD Deep Dive

ContainerD serves as a container manager between Docker and the Linux OS.

### Core Functions
1. **Container Operations**
   - Downloads and stores images
   - Manages container lifecycle (start, stop, pause)
   - Sets up networking
   - Manages storage
   - Handles low-level tasks

2. **Background**
   - Originally part of Docker
   - Now independent
   - Managed by CNCF
   - Used by various container tools

3. **Architecture**
   - Runs as a daemon
   - Simple, focused design
   - Provides APIs
   - Uses runc for container creation

4. **Advantages**
   - More stable than Docker Engine
   - Independent usage possible
   - Industry standard
   - Simpler maintenance

5. **Docker Integration**
   - Used internally by Docker
   - Docker adds features on top
   - Can run independently
   - Popular in cloud platforms

## Complete Docker Implementation Summary

### Layer Structure (Bottom to Top)

1. **Core Linux Features (Foundation)**
   - Linux Kernel (namespaces, cgroups)
   - Basic container building blocks
   - Process/network/filesystem separation
   - Resource control

2. **Container Runtime (Engine Room)**
   - runc at lowest level
   - Direct kernel interaction
   - Container environment creation
   - Isolation and resource management

3. **Container Supervisor (Manager)**
   - containerd layer
   - Lifecycle management
   - Image and storage handling
   - Network management
   - Daemon process operation

4. **Docker Engine (Control Center)**
   - dockerd process
   - API request handling
   - Service management
   - Network and storage control

5. **Docker Interface (User Layer)**
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



## https://www.docker.com/blog/ ##
for more informations
