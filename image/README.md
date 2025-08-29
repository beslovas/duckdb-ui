# DuckDB Docker Image

This directory contains the Docker image configuration for DuckDB with integrated nginx proxy and authentication.

## Overview

The image provides a single container solution that runs:
- **DuckDB** with web UI on port 4213
- **Nginx** reverse proxy on port 80
- **Supervisord** for process management
- **Basic authentication** (optional)

## Files

- **`Dockerfile`** - Main image definition
- **`entrypoint.sh`** - Startup script that configures auth and starts services
- **`supervisord.conf`** - Process management configuration
- **`nginx.conf`** - Nginx configuration template
- **`.dockerignore`** - Files to exclude from build context

## Building the Image

```bash
# Build for current architecture
docker build -t duckdb:latest .

# Build multi-architecture
docker buildx build --platform linux/amd64,linux/arm64 -t duckdb:latest .
```

## Environment Variables

- **`AUTH_ENABLED`** - Enable basic authentication (default: false)
- **`AUTH_USERNAME`** - Username for authentication
- **`AUTH_PASSWORD`** - Password for authentication

## Usage

### Basic Usage (No Auth)
```bash
docker run -p 80:80 duckdb:latest
```

### With Authentication
```bash
docker run -p 80:80 \
  -e AUTH_ENABLED=true \
  -e AUTH_USERNAME=admin \
  -e AUTH_PASSWORD=secret \
  duckdb:latest
```

## Ports

- **80** - Nginx proxy (external access)
- **4213** - DuckDB web UI (internal)

## Architecture

The container uses supervisord to manage multiple processes:
1. **DuckDB** starts first (priority 100)
2. **Nginx** starts second (priority 200)
3. All logs are redirected to stdout/stderr for Kubernetes compatibility

## Integration

This image is designed to work with the Helm chart in the `charts/` directory, which handles:
- Kubernetes deployment
- Persistent storage
- Configuration management
- Service exposure
