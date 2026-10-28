#!/usr/bin/env bash
set -e

echo "==================================================="
echo "  SonarQube Docker Scanner Runner"
echo "==================================================="

TARGET_DIR="${1:-$(pwd)}"
echo "Scanning directory: ${TARGET_DIR}"
echo "Target SonarQube URL: http://sonarqube:9000"

docker compose --profile scanner run --rm -v "${TARGET_DIR}:/usr/src" scanner

echo ""
echo "[SUCCESS] Scan complete! Check your project dashboard in SonarQube."
