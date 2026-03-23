# AYRNOW Project — Claude Code Configuration

## Project Identity
AYRNOW is a landlord-tenant property management platform MVP.

## Tech Stack
- Frontend: Flutter (Dart)
- Backend: Java Spring Boot (JDK 21)
- Database: PostgreSQL 16 + Flyway migrations
- Auth: Authgear (planned), currently JWT
- Payments: Stripe
- Lease signing: OpenSign (planned)
- NO DOCKER. Monolithic architecture only.

## Agent System
This project uses an autonomous Product Owner Agent system located in `alwaysOnProductOwnerAgent/`.

To start the PO Agent from terminal:
```bash
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp
./alwaysOnProductOwnerAgent/po_agent.sh
```

The PO Agent reads `alwaysOnProductOwnerAgent/MASTER_TODO.md` and autonomously executes all tasks by spawning developer sub-agents via Claude Code CLI.

## Git Workflow (MANDATORY)
- **Always `git pull` before starting any work.** Never code against a stale local repo.
- **Always `git pull` before committing.** If remote has new commits, pull and rebase/merge first.
- **Never push without confirming with the user first.**
- **Never force push.**
- If pull reveals conflicts, resolve them before proceeding — do not skip or discard.

## Critical Rules
- `lib/main.dart` owns `/`, `/login`, `/home` routes — NEVER override
- `buildRoutes()` must NOT override `/login`
- Never recreate Login, Register, Property List, or Add Property screens
- Always check existing routes before adding new ones
- No hardcoded secrets in source code
- Commit after each completed TASK group

## Quick Commands
```bash
# Backend
cd backend && mvn compile -q          # Compile check
cd backend && mvn package -DskipTests # Full build
cd backend && mvn test                # Run tests

# Frontend
cd frontend && flutter analyze        # Lint check
cd frontend && flutter test           # Run tests
cd frontend && flutter run            # Run app

# Agent
./alwaysOnProductOwnerAgent/po_agent.sh                  # Start PO Agent
./alwaysOnProductOwnerAgent/po_agent.sh status           # Check progress
./alwaysOnProductOwnerAgent/po_agent.sh continue         # Resume
./alwaysOnProductOwnerAgent/po_agent.sh task 03          # Run specific task
```
