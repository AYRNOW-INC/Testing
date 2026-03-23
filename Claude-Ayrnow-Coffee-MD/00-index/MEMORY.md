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

## Dev Environment
- Java 21 at `/opt/homebrew/Cellar/openjdk@21/21.0.10/libexec/openjdk.jdk/Contents/Home`
- Maven at `/opt/homebrew/bin/mvn` (must set JAVA_HOME to JDK 21, NOT 25)
- Flutter 3.41.4, PostgreSQL 16, MongoDB 8.2, CocoaPods 1.16.2
- iOS Simulators: iPhone 17 Pro (DF7E7361) + iPhone 16e (2620A3BC) — iOS 26
- PostgreSQL: `brew services start postgresql@16` — DB: `ayrnow` / user: `ayrnow` / pass: `ayrnow`
- MongoDB: `brew services start mongodb-community`

## Build State (as of 2026-03-23)
- **73/80 PO tasks completed** — 7 blocked on external credentials
- **~436/493 subtasks (88.4%)** across 33+ commits
- **Uncommitted changes exist** — several backend/frontend files modified + new migration files
- **WARNING:** Duplicate V5 migration files need resolution
- Backend: compiles, 48+ endpoints, all passing
- Frontend: 0 errors, 35 screen files, builds for iOS simulator

## Test Accounts
- Landlord: `landlord@ayrnow.app` / `Demo1234A` (ID=49)
- Tenant: `tenant@ayrnow.app` / `Demo1234A` (ID=50)
- Password policy: 8+ chars, uppercase, lowercase, digit

## User Preferences
- Wants execution, not just planning
- Prefers to review plans before large builds
- **ALWAYS use swarm/agent mode**: [feedback_swarm_mode.md](./feedback_swarm_mode.md)
- User tests on 2 simulators simultaneously (landlord + tenant)
- User owns ayrnow.com domain
- **Git/AWS rules**: [feedback_git_aws.md](./feedback_git_aws.md) — always `git pull` first, never `git push` or deploy to AWS without asking
