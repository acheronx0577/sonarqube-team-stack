@echo off
echo ===================================================
echo   SonarQube Local Stack - Stopping
echo ===================================================

docker compose down

echo.
echo SonarQube services have been stopped.
echo Note: PostgreSQL and Sonar data are safely preserved in persistent Docker volumes.
