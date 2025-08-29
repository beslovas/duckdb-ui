# DuckDB Helm Chart

A Helm chart for deploying DuckDB with UI support, configurable extensions, and persistent storage on Kubernetes.

## Features

- **DuckDB UI**: Web-based interface accessible through nginx proxy on port 80
- **Nginx Proxy**: Reverse proxy sidecar container for better load balancing
- **Configurable Extensions**: Install and load DuckDB extensions automatically
- **Persistent Storage**: Configurable persistent volume for data storage
- **Custom Configuration**: ConfigMap-based duckdbrc configuration
- **Kubernetes Native**: Full Kubernetes integration with health checks

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- PV provisioner support in the underlying infrastructure

## Installation

### Add the Helm repository

```bash
helm repo add beslovas https://beslovas.github.io/duckdb-ui
helm repo update
```

### Install the chart

```bash
helm install duckdb-ui beslovas/duckdb --version 0.5.0
```

### Install with custom values

```bash
helm install duckdb-ui beslovas/duckdb-ui \
  --set persistence.size=20Gi \
  --set duckdb.extensions[0]=httpfs \
  --set duckdb.extensions[1]=parquet
```

## Configuration

The following table lists the configurable parameters of the DuckDB chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Docker image repository | `ghcr.io/beslovas/duckdb-ui` |
| `image.tag` | Docker image tag | `1.3.2` |
| `image.pullPolicy` | Docker image pull policy | `IfNotPresent` |

| `duckdb.extensions` | List of extensions to install | `["httpfs", "parquet", "json", "sqlite"]` |
| `duckdb.databaseFile` | Database file name | `duckdb.db` |
| `duckdb.config.memory_limit` | Memory limit for DuckDB | `1GB` |
| `duckdb.config.threads` | Number of threads | `4` |
| `persistence.enabled` | Enable persistent storage | `true` |
| `persistence.size` | Size of persistent volume | `10Gi` |
| `persistence.storageClass` | Storage class for PVC | `""` |
| `persistence.path` | Mount path for data | `/duckdb/data` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `4213` |
| `ingress.enabled` | Enable ingress | `false` |
| `auth.enabled` | Enable basic authentication | `false` |
| `auth.username` | Username for basic auth | `admin` |
| `auth.password` | Password for basic auth | `changeme` |
| `resources.limits.cpu` | CPU resource limit | `1000m` |
| `resources.limits.memory` | Memory resource limit | `1Gi` |
| `resources.requests.cpu` | CPU resource request | `100m` |
| `resources.requests.memory` | Memory resource request | `128Mi` |

### Available Extensions

DuckDB supports many extensions. Here are some popular ones:

- `httpfs`: HTTP file system support
- `parquet`: Parquet file format support
- `json`: JSON functions and operators
- `sqlite`: SQLite compatibility
- `postgres`: PostgreSQL compatibility
- `mysql`: MySQL compatibility
- `excel`: Excel file support
- `arrow`: Apache Arrow support

### Custom Configuration

You can add custom DuckDB configuration through the `configMap.additionalConfig` value:

```yaml
configMap:
  additionalConfig: |
    # Custom DuckDB settings
    .mode csv
    .headers on
    SET enable_progress_bar=true;
```

### Environment Variables

The chart supports additional environment variables:

```yaml
env:
  DUCKDB_LOG_LEVEL: "INFO"
  DUCKDB_TEMP_DIR: "/tmp"
  CUSTOM_VAR: "custom_value"
  
  # MinIO S3 Configuration
  S3_ENDPOINT: "minio.monitoring:9000"
  S3_USE_SSL: "false"
  S3_URL_STYLE: "path"
  S3_REGION: "us-east-1"
  S3_ACCESS_KEY_ID: "your-access-key"
  S3_SECRET_ACCESS_KEY: "your-secret-key"
```

**Note:** This adds additional environment variables without overriding the existing DuckDB configuration.

## Usage

### Accessing DuckDB UI

After installation, the DuckDB UI will be available on port 4213. You can access it by:

1. **Port Forwarding** (recommended for development):
   ```bash
   kubectl port-forward svc/my-duckdb 4213:4213
   ```
   Then open http://localhost:4213 in your browser.

2. **LoadBalancer** (if enabled):
   ```bash
   kubectl get svc my-duckdb
   ```

3. **Ingress** (if enabled):
   ```bash
   kubectl get ingress my-duckdb
   ```

### Connecting via CLI

```bash
# Connect to DuckDB CLI
kubectl exec -it deployment/my-duckdb -- duckdb

# Or with port forwarding
kubectl port-forward svc/my-duckdb 4213:4213 &
duckdb -ui
```

### Managing Data

```bash
# Check persistent storage
kubectl get pvc my-duckdb

# View logs
kubectl logs deployment/my-duckdb

# Execute SQL commands
kubectl exec -it deployment/my-duckdb -- duckdb -c "SELECT version();"
```

## Persistence

The chart creates a PersistentVolumeClaim for storing DuckDB data. The data is stored in `/duckdb/data` inside the container and persists across pod restarts.

## Security

- The chart creates a dedicated ServiceAccount
- Pod security contexts can be configured
- Network policies can be applied for additional security

## Troubleshooting

### Common Issues

1. **Pod not starting**: Check if the storage class is available
2. **UI not accessible**: Verify the service and port configuration
3. **Extensions not loading**: Check the extension names and syntax

### Debug Commands

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/name=duckdb

# View pod events
kubectl describe pod <pod-name>

# Check configmap
kubectl get configmap my-duckdb-config -o yaml

# View logs
kubectl logs <pod-name>
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the Apache License 2.0.

## Support

For support, please open an issue in the repository or contact the maintainers.
