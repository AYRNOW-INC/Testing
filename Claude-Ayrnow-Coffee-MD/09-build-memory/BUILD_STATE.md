# AYRNOW Build State — End of Day 2026-03-15

## Repository
- Location: `/Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/`
- Remote: `git@github.com:ayrnowinc-jpg/AYRNOW-MVP.git`
- Branch: `main`
- Latest commit: `94b0347`
- Tags: `v1.0.0` (f44f577), `v1.0.1` (f091f5e)
- Clean: yes (only untracked Flutter platform dirs)
- Secrets in history: NONE

## Backend
- Compiles: YES (`mvn package -DskipTests` with JDK 21)
- Starts: YES (port 8080, ~2.4s startup)
- JAVA_HOME: `/opt/homebrew/Cellar/openjdk@21/21.0.10/libexec/openjdk.jdk/Contents/Home`
- Maven: `/opt/homebrew/bin/mvn`
- JAR: `backend/target/ayrnow-backend-1.0.0-SNAPSHOT.jar`
- Migrations: V1 (16 tables) + V2 (payment stripe fields) — both applied

## Frontend
- Compiles: YES (`flutter analyze` — 0 errors, 28 info/warnings)
- iOS build: YES (6.7s)
- Simulator: iPhone 16e (2620A3BC-3BE4-458B-9914-5DCCF40DD747)
- Dart files: 25 screens + theme + config + services + providers + main

## Database
- PostgreSQL 16 running via `brew services`
- Database: `ayrnow`, user: `ayrnow`, password: `ayrnow`
- Tables: 16 (14 app + flyway_schema_history + audit_logs)
- Migrations: V1 + V2 applied

## Quick Restart Commands
```bash
# Start PostgreSQL (if not running)
brew services start postgresql@16

# Start backend
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/backend
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@21/21.0.10/libexec/openjdk.jdk/Contents/Home
$JAVA_HOME/bin/java -jar target/ayrnow-backend-1.0.0-SNAPSHOT.jar

# Start frontend
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/frontend
flutter run -d 2620A3BC-3BE4-458B-9914-5DCCF40DD747

# Or use scripts
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp
./scripts/run_all_local.sh
```
