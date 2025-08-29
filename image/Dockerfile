FROM debian:bookworm-slim

ARG TARGETARCH
ARG DUCKDB_VERSION=v1.3.2

RUN apt-get update && apt-get install -y \
    curl unzip ca-certificates \
    nginx apache2-utils supervisor \
    && rm -rf /var/lib/apt-lists/*

RUN curl -L -o duckdb_cli.zip "https://github.com/duckdb/duckdb/releases/download/${DUCKDB_VERSION}/duckdb_cli-linux-${TARGETARCH}.zip" \
    && unzip duckdb_cli.zip && rm duckdb_cli.zip \
    && mv duckdb /usr/local/bin/duckdb \
    && chmod +x /usr/local/bin/duckdb 

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

COPY entrypoint.sh /entrypoint

EXPOSE 80

ENTRYPOINT ["/entrypoint"]