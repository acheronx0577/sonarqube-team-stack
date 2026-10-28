@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo   SonarQube Local Stack - Starting
echo ===================================================

if not exist .env (
    echo [.env] not found. Copying from .env.example...
    copy .env.example .env >nul
)

echo Starting Docker Compose services...
docker compose up -d

if %ERRORLEVEL% neq 0 (
    echo [ERROR] Failed to start Docker Compose. Please verify Docker Desktop is running.
    exit /b %ERRORLEVEL%
)

echo.
echo Containers launched! Waiting for SonarQube web server to be ready...
echo (SonarQube takes ~30-60 seconds on initial boot to initialize database schemas)
echo.

call status.bat
