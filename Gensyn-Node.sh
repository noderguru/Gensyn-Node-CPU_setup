#!/bin/bash
set -e

echo -e "\e[35m
                    __                                
   ____  ____  ____/ /__  _________ ___  _________  __
  / __ \/ __ \/ __  / _ \/ ___/ __ \`/ / / / ___/ / / /
 / / / / /_/ / /_/ /  __/ /  / /_/ / /_/ / /  / /_/ / 
/_/ /_/\____/\__,_/\___/_/   \__, /\__,_/_/   \__,_/  
                            /____/                    

GitHub: https://github.com/noderguru
\e[0m"

echo "=== Cloning rl-swarm repository ==="
git clone https://github.com/gensyn-ai/rl-swarm/
cd rl-swarm || exit 1

echo "=== Creating docker-compose.yaml ==="
cat <<EOF > docker-compose.yaml
version: '3'

services:
  otel-collector:
    image: otel/opentelemetry-collector-contrib:0.120.0
    ports:
      - "4317:4317"
      - "4318:4318"
      - "55679:55679"
    environment:
      - OTEL_LOG_LEVEL=DEBUG

  swarm_node:
    image: europe-docker.pkg.dev/gensyn-public-b7d9/public/rl-swarm:v0.0.2
    command: ./run_hivemind_docker.sh
    environment:
      - OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317
      - PEER_MULTI_ADDRS=/ip4/38.101.215.13/tcp/30002/p2p/QmQ2gEXoPJg6iMBSUFWGzAabS2VhnzuS782Y637hGjfsRJ
      - HOST_MULTI_ADDRS=/ip4/0.0.0.0/tcp/38331
    ports:
      - "38331:38331"
    depends_on:
      - otel-collector

  fastapi:
    build:
      context: .
      dockerfile: Dockerfile.webserver
    environment:
      - OTEL_SERVICE_NAME=rlswarm-fastapi
      - OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317
      - INITIAL_PEERS=/ip4/38.101.215.13/tcp/30002/p2p/QmQ2gEXoPJg6iMBSUFWGzAabS2VhnzuS782Y637hGjfsRJ
    ports:
      - "8080:8000"
    depends_on:
      - otel-collector
      - swarm_node
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/api/healthz"]
      interval: 30s
      retries: 3
EOF

echo "=== Building and starting Docker containers ==="
sudo docker compose up --build -d

echo "=== ✅ Setup complete! ==="
echo "📋 You can check logs using the following commands:"
echo "  docker compose logs -f                # All services"
echo "  docker compose logs -f otel-collector # Only otel-collector"
echo "  docker compose logs -f swarm_node     # Only swarm_node"
echo "  docker compose logs -f fastapi        # Only fastapi"
