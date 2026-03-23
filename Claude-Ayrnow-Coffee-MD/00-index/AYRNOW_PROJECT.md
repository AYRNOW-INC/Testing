---
name: AYRNOW MVP project state
description: Current build state, task completion, git state, blockers, and infrastructure for the AYRNOW MVP project
type: project
---

# AYRNOW MVP — Project State

_Last verified: 2026-03-23_

## Build Completion
- **PO Agent tasks:** 80 total tasks (TASK-01 to TASK-80)
- **Completed:** 73 tasks across 5 waves + 2 audit rounds
- **Blocked:** 7 tasks need external credentials (TASK-02, 04, 05, 06, 10, 31, 32)
- **Subtasks:** ~436/493 done (88.4%)
- **Commits:** 33+ on `main` branch

## What's Built
- **Backend:** Spring Boot 3.4.4, 60+ Java files, 48+ API endpoints, all tested
- **Frontend:** Flutter 3.41.4, 35 Dart screen files, 0 compile errors
- **Database:** PostgreSQL 16, 16 tables via Flyway migrations (V1-V4 applied)
- **Tests:** 87 backend unit tests (7 classes), 69 frontend tests, 57 live API tests
- **Docs:** 18+ documentation files, 5 scripts
- **Security:** Full audit done, 6 vulns fixed, security_monitor.sh created

## Uncommitted Changes (as of 2026-03-23)
Several modified and new files exist uncommitted:
- Backend: InvitationController, LeaseResponse, AuthService, InvitationService, LeaseService, application.properties
- New files: EmailService.java, V5/V6 migrations, email templates, e2e scripts
- Frontend: lease_list_screen, lease_ready_screen, signing screens, tenant_lease_screen
- **WARNING:** Duplicate V5 migration files exist (invitation_email_fields AND security_deposit) — needs resolution before backend restart
- Deleted: V4__Add_security_deposit_to_unit_spaces.sql (replaced by V5)

## Blocked Tasks (Need Credentials)
| Task | What's Needed | Status |
|------|--------------|--------|
| TASK-02 | Authgear — Google/Apple sign-in credentials | Code built, needs Authgear config |
| TASK-04 | OpenSign — self-hosted setup + API integration | Server cloned, MongoDB running, needs config |
| TASK-05 | Email provider — AWS SES credentials | EmailService built, templates created, needs SMTP creds |
| TASK-06 | Invite resend — depends on email | Backend endpoint built |
| TASK-10 | Integration tests — needs all services running | Test framework ready |
| TASK-31 | OpenSign signing flow | Backend client ready |
| TASK-32 | Email notifications | Wired to EmailService |

## Git State
- **Branch:** `main`
- **Remote:** `git@github.com:AYRNOW-INC/AYRNOW-MVP.git`
- **Last commit:** `4a82881` — wireframe audit report + QA audit
- **Tags:** v1.0.0, v1.0.1
- **Status:** Has uncommitted changes (needs commit)

## Key Files
- PO task board: `alwaysOnProductOwnerAgent/MASTER_TODO.md`
- PO agent config: `alwaysOnProductOwnerAgent/CLAUDE.md`
- Wireframe audit: `WIREFRAME_AUDIT_REPORT.md`
- Mr Coffee handoff: `.mr-coffee/HANDOFF.md`
- Security scanner: `scripts/security_monitor.sh`

## OpenSign Setup
- Cloned at: `/Users/imranshishir/Documents/claude/AYRNOW/opensign/`
- MongoDB running via brew on port 27017
- Server port: 1337 (to avoid conflict with Spring Boot 8080)
- Config: APP_ID=opensign, MASTER_KEY=AyrnowOpenSign2026

**Why:** This is the current state snapshot for session continuity.
**How to apply:** Use this to understand what's done vs what's remaining. Always verify git status and uncommitted changes at session start.
