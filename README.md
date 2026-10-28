# SonarQube Team Stack

[![SonarQube](https://img.shields.io/badge/SonarQube-Community%20Build-4B9FD5?logo=sonarqube&logoColor=white)](https://www.sonarsource.com/products/sonarqube/)
[![Docker](https://img.shields.io/badge/Docker-Compose%20v2-2496ED?logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL%2016-4169E1?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A turnkey, self-hosted local **SonarQube Community Build** stack packaged with **PostgreSQL 16** and persistent volume storage. Designed for development teams to clone, run locally in one command, and analyze codebases before pushing to GitHub or CI/CD pipelines.

---

## Features

- **One-Command Setup:** Automated scripts (`start.bat` / `start.sh`) with auto-generating `.env`.
- **Persistent Storage:** Named Docker volumes protect code inspection history, quality gate metrics, and database records across container restarts.
- **Production-Grade DB:** Uses PostgreSQL 16 Alpine instead of the ephemeral embedded H2 engine.
- **Port Conflict Protection:** Configurable host port in `.env` (default `9000`, customizable to `9005`, `9002`, etc.).
- **Zero-Install Scanning:** Run scans using the built-in dockerized scanner CLI (`scan.bat` / `scan.sh`) or standard `npx @sonar/scan`.
- **Cross-Platform:** Out-of-the-box support for Windows (Docker Desktop / PowerShell / CMD), macOS, and Linux.

---

## Architecture

```
                   +----------------------------------+
                   |           Host Machine           |
                   |      http://localhost:9000       |
                   +-----------------+----------------+
                                     |
                          +----------v----------+
                          |   Docker Network    |
                          |  (sonarqube_net)    |
                          +----------+----------+
                                     |
               +---------------------+---------------------+
               |                                           |
    +----------v----------+                     +----------v----------+
    |  sonarqube-server   |                     |     sonarqube-db    |
    | (sonarqube:community|<------------------->| (postgres:16-alpine)|
    +----------+----------+                     +----------+----------+
               |                                           |
    +----------v----------+                     +----------v----------+
    | Persistent Volumes: |                     | Persistent Volume:  |
    |  - sonarqube_data   |                     |  - sonarqube_db_data|
    |  - sonarqube_ext    |                     +---------------------+
    |  - sonarqube_logs   |
    +---------------------+
```

---

## Quick Start (3 Steps)

### 1. Clone the Repository

```bash
git clone https://github.com/acheronx0577/sonarqube-team-stack.git
cd sonarqube-team-stack
```

### 2. Start the Stack

**On Windows:**
```cmd
start.bat
```

**On macOS / Linux:**
```bash
chmod +x *.sh
./start.sh
```

*(Alternatively, run `docker compose up -d` directly).*

### 3. Open in Browser

- URL: **[http://localhost:9000](http://localhost:9000)** (or the port defined in `.env`)
- Default Credentials:
  - **Username:** `admin`
  - **Password:** `admin`
- On first login, SonarQube will prompt you to set a new password.

> **Note:** On the very first launch, SonarQube takes 30-60 seconds to perform database schema migrations and initialize Elasticsearch indexes.

---

## Managing the Stack

| Action | Windows | macOS / Linux | Raw Docker Compose |
| :--- | :--- | :--- | :--- |
| **Start** | `start.bat` | `./start.sh` | `docker compose up -d` |
| **Check Status** | `status.bat` | `./status.sh` | `docker compose ps` |
| **Stop** | `stop.bat` | `./stop.sh` | `docker compose down` |
| **View Logs** | `docker compose logs -f sonarqube` | `docker compose logs -f sonarqube` | `docker compose logs -f sonarqube` |

---

## Configuration (`.env`)

Copy `.env.example` to `.env` to override configuration:

```bash
cp .env.example .env
```

| Variable | Default | Description |
| :--- | :--- | :--- |
| `SONAR_PORT` | `9000` | Port mapped to host machine. Change if port `9000` is already in use. |
| `POSTGRES_USER` | `sonar` | Database user for SonarQube |
| `POSTGRES_PASSWORD` | `sonar_secure_dev_pass` | Database user password |
| `POSTGRES_DB` | `sonar` | Database name |
| `SONAR_SEARCH_JAVAADDITIONALOPTS` | `-Dnode.store.allow_mmap=false` | Ensures Elasticsearch runs stably on Docker Desktop |
| `SONAR_TOKEN` | *(empty)* | Optional authentication token created in SonarQube UI |

---

## How to Scan Your Projects

### Method 1: Using `npx @sonar/scan` (Recommended for Node / TypeScript / React)

Inside your project root:

1. Create a `sonar-project.properties` file (see [sonar-project.properties.example](./sonar-project.properties.example)):
   ```properties
   sonar.projectKey=my-web-app
   sonar.projectName=My Web App
   sonar.sources=src
   sonar.exclusions=**/node_modules/**,**/dist/**,**/.next/**
   ```

2. Run the scanner:
   ```bash
   npx @sonar/scan -Dsonar.host.url=http://localhost:9000 -Dsonar.login=YOUR_SONAR_TOKEN
   ```

---

### Method 2: Using the Included Dockerized Scanner (Zero Local Tool Installs)

You can scan any folder without installing Node or Java:

**On Windows:**
```cmd
scan.bat C:\path\to\your\project
```

**On macOS / Linux:**
```bash
./scan.sh /path/to/your/project
```

---

### Method 3: Official SonarScanner CLI

If you have `sonar-scanner` installed globally:

```bash
sonar-scanner \
  -Dsonar.projectKey=my-app \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=YOUR_SONAR_TOKEN
```

---

## Troubleshooting

### Port Collision (Port 9000 is already in use)
If port 9000 is occupied by another tool (e.g. MinIO, Portainer, or another service):
1. Open `.env`
2. Change `SONAR_PORT=9005` (or any available port)
3. Run `start.bat` / `./start.sh`
4. Access SonarQube at `http://localhost:9005`

### Linux `vm.max_map_count` Error
If Elasticsearch fails to start on Linux hosts:
```bash
sudo sysctl -w vm.max_map_count=262144
```
To persist this across reboots, add to `/etc/sysctl.conf`:
```
vm.max_map_count=262144
```

### Resetting All Data
To completely reset database and volume state (clean slate):
```bash
docker compose down -v
```

---

## License

This repository configuration and helper scripts are distributed under the [MIT License](LICENSE). SonarQube Community Build is licensed under the GNU LGPL v3.
