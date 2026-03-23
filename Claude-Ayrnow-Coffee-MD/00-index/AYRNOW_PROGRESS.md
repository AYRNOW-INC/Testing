# AYRNOW MVP — Progress & Memory File for Claude Desktop

_Last synced: 2026-03-18_

---

## 1. Who Am I Working With

| Who | Role |
|-----|------|
| **Shishir** (Imran Shishir) | Founder/CEO, AYRNOW INC (Delaware C-Corp). Primary decision maker. Email: ayrnowinc@gmail.com |

---

## 2. What Is AYRNOW

A **landlord-tenant property management & rent collection platform** for the U.S. market. Guided, mobile-friendly workflows for homeowners and landlords (age 30–65). Related but separate product: **Porishodh** (Bangladesh market, Code Nexas).

---

## 3. Tech Stack (Non-Negotiable)

| Layer | Tech |
|-------|------|
| Frontend | Flutter (Dart) |
| Backend | Java Spring Boot (JDK 21) |
| Database | PostgreSQL 16 + Flyway migrations |
| Auth | Authgear (planned), currently JWT |
| Payments | Stripe (test mode verified) |
| Lease signing | OpenSign (planned, stubs ready) |
| Architecture | **Monolithic — NO DOCKER** |

---

## 4. Repository & Local Paths

| Item | Location |
|------|----------|
| Repo | `git@github.com:ayrnowinc-jpg/AYRNOW-MVP.git` |
| Local root | `/Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp` |
| Backend | `ayrnow-mvp/backend/` |
| Frontend | `ayrnow-mvp/frontend/` |
| PO Agent | `ayrnow-mvp/alwaysOnProductOwnerAgent/` |
| OpenSign (cloned) | `/Users/imranshishir/Documents/claude/AYRNOW/opensign` |
| AyrnowPlanB | `/Users/imranshishir/Documents/claude/AyrnowPlanB` |
| Build Memory | `ayrnow-mvp/AYRNOW/_build_memory/` |
| Git tags | `v1.0.0` (f44f577), `v1.0.1` (f091f5e) |

---

## 5. PO Agent System

The project uses an **autonomous Product Owner Agent** (`alwaysOnProductOwnerAgent/`). It's a bash script that:

1. Reads `MASTER_TODO.md` (34 core tasks + 23 round-2/3/4 tasks = 57 total, 180+ subtasks)
2. Picks the next incomplete task by priority
3. Spawns a developer sub-agent via `claude --print`
4. Verifies compilation (`mvn compile` + `flutter analyze`)
5. Commits passing changes
6. Loops until all tasks are done

### PO Agent Commands
```bash
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp
./alwaysOnProductOwnerAgent/po_agent.sh           # Start fresh
./alwaysOnProductOwnerAgent/po_agent.sh continue   # Resume
./alwaysOnProductOwnerAgent/po_agent.sh status     # Progress dashboard
./alwaysOnProductOwnerAgent/po_agent.sh task 07    # Run specific task
```

### PO Agent Files
- `CLAUDE.md` — System prompt for Claude agents
- `MASTER_TODO.md` — Execution board (source of truth)
- `po_agent.sh` — Launcher script
- `logs/` — Session logs (14 sessions recorded on 2026-03-17)

---

## 6. Current Status: ALL NON-BLOCKED TASKS COMPLETE

### Completed Waves (as of 2026-03-17)

| Wave | Tasks | Count | Status |
|------|-------|-------|--------|
| Wave 1 — Production Blockers | TASK-01, 03, 07, 08, 09 | 5/10 done | 5 blocked |
| Wave 2 — Public Beta | TASK-11–22 | 12/12 done | All done |
| Wave 3 — Store Launch | TASK-23–28 | 6/6 done | All done |
| Hidden Gaps | TASK-29, 30, 33, 34 | 4/7 done | 3 blocked |
| Round 2 — R1 (Immediate) | TASK-35–43 | 9/9 done | All done |
| Round 2 — R2 (Beta) | TASK-44–51 | 8/8 done | All done |
| Round 2 — R3 (Polish) | TASK-52–55 | 4/4 done | All done |
| Round 3 — Smart Invite | TASK-56 | 1/1 done | All done |
| Round 4 — S3 Storage | TASK-57 | 1/1 done | All done |
| **TOTAL** | | **50/57 done** | **7 blocked** |

### What Is Fully Built
- **Backend:** Spring Boot 3.4.4 — 60+ Java files, 48+ API endpoints, 75 backend tests, all verified
- **Frontend:** Flutter — 54/54 wireframe screens, 30+ screen files, 67 frontend tests, 0 compile errors
- **Database:** PostgreSQL 16 — 16 tables via 3 Flyway migrations (V1 core + V2 Stripe fields + V3 audit)
- **Stripe:** Checkout + webhook + idempotency + reconciliation built & tested
- **S3 Storage:** Abstraction layer (local dev + S3 prod) with pre-signed URLs, 21 tests
- **Security:** Deep auth audit done, ownership checks, @PreAuthorize on all endpoints
- **Docs:** 18+ documentation files
- **Scripts:** 5 executable Mac scripts for local dev
- **Smart Invite:** Guided wizard flow for unit completion before inviting tenants

---

## 7. Blocked Tasks (Need External Credentials/Decisions)

| Task | What | Blocked On |
|------|------|-----------|
| TASK-02 | Replace auth stubs with real Authgear | Authgear credentials |
| TASK-04 | OpenSign lease document delivery | OpenSign credentials |
| TASK-05 | Real email delivery | Email provider decision (SES / SendGrid / Resend) |
| TASK-06 | Invite resend end-to-end | TASK-05 (email) |
| TASK-10 | End-to-end production verification | TASK-02 + 04 + 05 |
| TASK-31 | OpenSign source-of-truth sync | OpenSign credentials |
| TASK-32 | Email delivery fallback/retry | Email provider |

---

## 8. Next Actions (Priority Order)

1. **Decide email provider** (SES / SendGrid / Resend) — unblocks TASK-05, 06, 32
2. **Set up Authgear** — get credentials, unblocks TASK-02
3. **Set up OpenSign** — get credentials, unblocks TASK-04, 31
4. **GitHub security settings** (manual, 5 min) — Private repo, secret scanning, branch protection
5. **Full E2E verification** (TASK-10) — after above 3 are done
6. **Replace Flutter default icons** with AYRNOW logo
7. **Capture App Store / Play Store screenshots**
8. **Deploy backend to AWS** — deploy runbook exists
9. **Tag v1.1.0** and push

---

## 9. Quick Restart Commands

```bash
# Start everything
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp
./scripts/run_all_local.sh

# Or individually:
brew services start postgresql@16

# Backend
cd backend
export JAVA_HOME=/opt/homebrew/Cellar/openjdk@21/21.0.10/libexec/openjdk.jdk/Contents/Home
$JAVA_HOME/bin/java -jar target/ayrnow-backend-1.0.0-SNAPSHOT.jar

# Frontend
cd frontend
flutter run -d 2620A3BC-3BE4-458B-9914-5DCCF40DD747

# PO Agent
./alwaysOnProductOwnerAgent/po_agent.sh status
```

---

## 10. Key Rules (Never Violate)

- `lib/main.dart` owns `/`, `/login`, `/home` routes — **NEVER override**
- `buildRoutes()` must NOT override `/login`
- Never recreate Login, Register, Property List, or Add Property screens
- No hardcoded secrets in source code
- No Docker anywhere
- Monolithic architecture only
- Small, scoped branches/PRs
- Fix wiring before rebuilding

---

## 11. Terms & Glossary

| Term | Meaning |
|------|---------|
| AYRNOW | U.S. property management MVP product |
| Porishodh | Bangladesh-market counterpart (Code Nexas) — keep separate |
| PO Agent | Autonomous Product Owner Agent in `alwaysOnProductOwnerAgent/` |
| Vertical slice | End-to-end feature (UI + API + DB + tests) |
| Smart Invite | TASK-56 guided wizard flow for unit setup before tenant invite |
| Guided Unit Card | 5-step workflow on property detail: Setup → Invite → Lease → Sign → Active |
| StorageService | Abstraction for file storage (local dev / S3 prod) |
| Wave 1 | Production blockers (TASK-01–10) |
| Wave 2 | Public beta requirements (TASK-11–22) |
| Wave 3 | Store launch quality (TASK-23–28) |
