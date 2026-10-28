@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo   SonarQube Local Stack - Status
echo ===================================================

docker compose ps

echo.
for /f "tokens=*" %%i in ('docker compose port sonarqube 9000 2^>nul') do set PORT_MAPPING=%%i

if "%PORT_MAPPING%"=="" (
    echo [STATUS] SonarQube container is not currently exposing port 9000.
    echo          Run start.bat to start the stack.
) else (
    for /f "tokens=2 delims=:" %%p in ("%PORT_MAPPING%") do set PORT_NUM=%%p
    if "!PORT_NUM!"=="" set PORT_NUM=9000
    echo [MAPPING] SonarQube is accessible on host: http://localhost:!PORT_NUM!
    echo [CHECK]   Querying system status endpoint...
    curl.exe -s -m 5 "http://127.0.0.1:!PORT_NUM!/api/system/status"
    echo.
    echo.
    echo Default credentials:
    echo   Username: admin
    echo   Password: admin
    echo   (SonarQube will prompt to set a new password on first login)
)
