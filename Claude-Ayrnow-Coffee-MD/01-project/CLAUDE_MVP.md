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

## Agent System — 10 Autonomous Agents
This project uses a 10-agent autonomous system. Agent definitions: `.claude/agents/`. Playbook: `.mr-coffee/TEAM_PLAYBOOK.md`.

### Permission Architecture (3 layers)
1. **`.claude/settings.json`** — 84 allow rules for interactive sessions (auto-allows all tools, git, mvn, flutter, bash). Denies: `git push`, `aws`.
2. **Agent spawn mode** — ALL agents MUST be spawned with `mode: "bypassPermissions"`. No exceptions.
3. **`po_agent.sh`** — Uses `--dangerously-skip-permissions` for CLI-launched PO sessions.

### PO Agent (CLI)
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

## Autonomy Rule (MANDATORY — ALL AGENTS)
- NEVER ask "do you want to proceed?", "shall I continue?", "would you like me to?", "ready?", or ANY confirmation/approval question
- All agents execute fully and autonomously once a task is given
- Task approval is handled by the **Task Gatekeeper** agent (`.claude/agents/task-gatekeeper.md`) — if a task reaches an agent, it's already approved
- Only exceptions that warrant stopping: git push (needs Imran), AWS deploy (needs Imran), missing external credentials, 3+ consecutive failures

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
