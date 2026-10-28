@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo   SonarQube Docker Scanner Runner
echo ===================================================

set TARGET_DIR=%1
if "%TARGET_DIR%"=="" set TARGET_DIR=%CD%

echo Scanning directory: %TARGET_DIR%
echo Target SonarQube URL: http://sonarqube:9000

set PROJECT_DIR=%TARGET_DIR%
docker compose --profile scanner run --rm -v "%TARGET_DIR%:/usr/src" scanner

if %ERRORLEVEL% equ 0 (
    echo.
    echo [SUCCESS] Scan complete! Check your project dashboard in SonarQube.
) else (
    echo.
    echo [ERROR] Scanner exited with status %ERRORLEVEL%.
)
