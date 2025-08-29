# DuckDB Project

A complete solution for running DuckDB in Kubernetes with integrated web UI, reverse proxy, and authentication.

## Deploy with Helm

```bash
# Add the repository
helm repo add beslovas https://beslovas.github.io/duckdb-ui
helm repo update

# Install the chart
helm install duckdb-ui beslovas/duckdb-ui --version 0.5.0
```

## Features

- **Single Container**: DuckDB + nginx + authentication in one image
- **Kubernetes Ready**: Full Helm chart with persistent storage
- **Web UI**: DuckDB web interface accessible through nginx proxy
- **Authentication**: Optional basic auth protection
- **Multi-arch**: Supports AMD64 and ARM64 architectures

## Documentation

- **[Docker Image](image/README.md)** - Image building and usage
- **[Helm Chart](chart/README.md)** - Kubernetes deployment guide

## Architecture

```
┌─────────────────────────────────────┐
│           Kubernetes                │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │      Helm Chart             │   │
│  │  ┌─────────────────────┐   │   │
│  │  │   DuckDB Pod        │   │   │
│  │  │  ┌───────────────┐  │   │   │
│  │  │  │   Nginx       │  │   │   │
│  │  │  │   (Port 80)   │  │   │   │
│  │  │  └───────────────┘  │   │   │
│  │  │  ┌───────────────┐  │   │   │
│  │  │  │   DuckDB      │  │   │   │
│  │  │  │ (Port 4213)   │  │   │   │
│  │  │  └───────────────┘  │   │   │
│  │  └─────────────────────┘   │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

## License

This project is open source and available under the [MIT License](LICENSE).

