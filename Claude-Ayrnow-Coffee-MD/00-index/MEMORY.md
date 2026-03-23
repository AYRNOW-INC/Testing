# Claude Memory — AYRNOW Workspace

## Identity
- **You are Mr Coffee** — read [mr_coffee.md](./mr_coffee.md) for context
- Full session handoff: `/Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/.mr-coffee/HANDOFF.md`

## Active Project
- **AYRNOW MVP** — Landlord-tenant property management platform
- Detailed project memory: [AYRNOW_PROJECT.md](./AYRNOW_PROJECT.md)
- Working directory context: [ayrnow_workdir.md](./ayrnow_workdir.md)

## Key Facts
- Stack: Flutter + Spring Boot + PostgreSQL + Flyway (monolithic, NO Docker)
- External deps: Authgear (auth), OpenSign (signing), Stripe (payments)
- Target repo: `git@github.com:AYRNOW-INC/AYRNOW-MVP.git`
- **CANONICAL BUILD DIR: `/Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/`** — always work here
- OpenSign self-hosted cloned at: `/Users/imranshishir/Documents/claude/AYRNOW/opensign/`
- Domain: `ayrnow.com` (owned by Imran)
- Package/Bundle ID: `com.ayrnow.app`

## Centralized Documentation
- **All .md files archived at:** `AYRNOW-INC/Testing` repo → `Claude-Ayrnow-Coffee-MD/`
- **Local path:** `/Users/imranshishir/Documents/claude/AYRNOW/Testing/Claude-Ayrnow-Coffee-MD/`
- 77 files in 13 folders — see [centralized_docs.md](./centralized_docs.md) for details

## Dev Environment
- Java 21 at `/opt/homebrew/Cellar/openjdk@21/21.0.10/libexec/openjdk.jdk/Contents/Home`
- Maven at `/opt/homebrew/bin/mvn` (must set JAVA_HOME to JDK 21, NOT 25)
- Flutter 3.41.4, PostgreSQL 16, MongoDB 8.2, CocoaPods 1.16.2
- iOS Simulators: iPhone 17 Pro (DF7E7361) + iPhone 16e (2620A3BC) — iOS 26
- PostgreSQL: `brew services start postgresql@16` — DB: `ayrnow` / user: `ayrnow` / pass: `ayrnow`
- MongoDB: `brew services start mongodb-community`

## Build State (as of 2026-03-23)
- **519/519 subtasks (100%)** — PO agent fully complete (TASK-01 to TASK-83)
- Production hardening done: 33 files changed, 0 compile errors
- Backend: 48+ endpoints, rate limiting, state machine, proper HTTP codes
- Frontend: 0 errors, 35 screens, error handling hardened
- Credentials configured: Authgear, OpenSign, Google OAuth (in .env.local)
- Still needed: AWS SES SMTP creds, Stripe production keys (sk_live_)

## Test Accounts
- Landlord: `landlord@ayrnow.app` / `Demo1234A` (ID=49)
- Tenant: `tenant@ayrnow.app` / `Demo1234A` (ID=50)
- Password policy: 8+ chars, uppercase, lowercase, digit

## GitHub Repos (AYRNOW-INC org)
- `AYRNOW-INC/AYRNOW-MVP` — Main app (Flutter + Spring Boot)
- `AYRNOW-INC/Testing` — E2E tests, QA reports, Claude-Ayrnow-Coffee-MD docs
- `AYRNOW-INC/Ayrnow-v-1.0` — Older version (Firebase-based)

## Agent Team (Mr Coffee's Squad)
- **7 custom agents** defined in `.claude/agents/` — see [feedback_team_structure.md](./feedback_team_structure.md)
- **Planning Architect** — breaks big goals into detailed task plans, loops until airtight
- **UX Guardian** — mandatory review on ALL frontend changes (veto power)
- **Backend Dev** + **Frontend Dev** — specialist implementers
- **QA Tester** — runs after every task
- **Security Monitor** — periodic + after auth/payment changes
- **Product Owner** — batch task execution from MASTER_TODO.md
- Team playbook: `.mr-coffee/TEAM_PLAYBOOK.md`

## User Preferences
- Wants execution, not just planning
- Prefers to review plans before large builds
- **ALWAYS use swarm/agent mode**: [feedback_swarm_mode.md](./feedback_swarm_mode.md)
- User tests on 2 simulators simultaneously (landlord + tenant)
- User owns ayrnow.com domain
- **Git/AWS rules**: [feedback_git_aws.md](./feedback_git_aws.md) — always `git pull` first, never `git push` or deploy to AWS without asking
