#!/bin/bash

# Copy the necessary files to a known location
cp deploy-sourcegraph-docker/caddy/builtins/http.Caddyfile /tmp/http.Caddyfile

# Navigate to the Docker Compose directory
cd deploy-sourcegraph-docker

# Run Docker Compose
docker compose -f docker-compose/docker-compose.yaml up -d
exec "$@"
