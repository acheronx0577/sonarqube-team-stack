#!/usr/bin/env bash
echo "==================================================="
echo "  SonarQube Local Stack - Status"
echo "==================================================="

docker compose ps

echo ""
PORT_MAPPING=$(docker compose port sonarqube 9000 2>/dev/null || echo "")

if [ -z "$PORT_MAPPING" ]; then
  echo "[STATUS] SonarQube container is not currently exposing port 9000."
  echo "         Run ./start.sh to start the stack."
else
  PORT_NUM=$(echo "$PORT_MAPPING" | awk -F: '{print $NF}')
  echo "[MAPPING] SonarQube is accessible at: http://localhost:${PORT_NUM}"
  echo "[CHECK]   Querying system status endpoint..."
  curl -s -m 5 "http://127.0.0.1:${PORT_NUM}/api/system/status" || echo "Starting up..."
  echo ""
  echo ""
  echo "Default credentials:"
  echo "  Username: admin"
  echo "  Password: admin"
  echo "  (SonarQube will prompt to set a new password on first login)"
fi
