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

## Agent System — 10 Agents, Gatekeeper Authority
This project uses a 10-agent system. Agent definitions: `.claude/agents/`. Playbook: `.mr-coffee/TEAM_PLAYBOOK.md`.

### Permission Architecture
- **Task Gatekeeper** is the ONLY agent with `bypassPermissions`
- **All other 9 agents** run with `mode: "default"` — authorized by Gatekeeper's approval
- **Every task** activates ALL 10 agents — no partial teams
- **Gatekeeper can PAUSE** for Imran on high-risk/emergency situations

### PO Agent (CLI)
```bash
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp
./alwaysOnProductOwnerAgent/po_agent.sh
```

## Git Workflow (MANDATORY)
- **Always `git pull` before starting any work.**
- **Always `git pull` before committing.**
- **Never force push.**
- If pull reveals conflicts, resolve them before proceeding.

## Task Execution Rule (MANDATORY)
- Every task MUST go through Task Gatekeeper first
- Gatekeeper approves → ALL 10 agents activate
- Gatekeeper pauses → wait for Imran (high-risk/emergency only)
- ALL 10 agents kick in on every task — hard rule, no exceptions

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
