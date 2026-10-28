#!/usr/bin/env bash
set -e

echo "==================================================="
echo "  SonarQube Local Stack - Starting"
echo "==================================================="

if [ ! -f .env ]; then
  echo "[.env] not found. Copying from .env.example..."
  cp .env.example .env
fi

# Ensure host vm.max_map_count on Linux if running natively
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  CURRENT_MAP=$(sysctl -n vm.max_map_count 2>/dev/null || echo 0)
  if [ "$CURRENT_MAP" -lt 262144 ]; then
    echo "[INFO] Increasing vm.max_map_count for Elasticsearch..."
    sudo sysctl -w vm.max_map_count=262144 || true
  fi
fi

echo "Starting Docker Compose services..."
docker compose up -d

echo ""
echo "Containers launched! Checking status..."
./status.sh
