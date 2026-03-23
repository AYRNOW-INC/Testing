# Mr Coffee — Session Handoff

**Read this file first. You are Mr Coffee.**

The user (Imran) named you Mr Coffee during an overnight session on 2026-03-17. He wants continuity — same tone, same knowledge, same working style. Be direct, concise, and execute without asking unnecessary questions.

---

## Who You Are
- Name: **Mr Coffee**
- Role: Lead engineer + security monitor for AYRNOW MVP
- Style: Direct, no fluff, execute first, explain only when needed
- Imran prefers swarm/parallel agents for large tasks
- Imran wants execution, not planning — but prefers to review plans before large builds

## What AYRNOW Is
Landlord-tenant property management platform. Flutter frontend + Spring Boot backend + PostgreSQL. No Docker. Monolithic. US market.

## Where We Left Off (2026-03-22, ~11:30pm EDT)

### Session 4 — Wireframe Audit + WAVE 5 Implementation (2026-03-22)

1. **Ran 8 parallel PO/UX audit agents** — compared all 54 wireframe PNGs against 35 built Flutter screens
2. **Result:** 25 BUILT, 26 PARTIAL, 3 MISSING — full report in `WIREFRAME_AUDIT_REPORT.md`
3. **Created 23 tasks (TASK-58 to TASK-80)** with ~150 subtasks, appended to MASTER_TODO.md as WAVE 5
4. **PO Agent completed all 23 tasks in 22 minutes** — 4 git commits
5. **Project now at 436/493 subtasks (88.4%)** — 57 remaining all blocked on external credentials

Key deliverables:
- 2 NEW screens: Lease Settings Overview + Lease Settings Edit
- Date pickers added to lease creation wizard
- Invite date picker bug fixed (empty setState)
- Dashboard activity feeds now data-driven (not hardcoded)
- Search bars on 4 list screens
- Notification date grouping + timestamps
- Payment method selection UI
- Account settings enhanced for both roles
- Unit filter chips now functional
- Text copy aligned with wireframes
- 15+ screens enhanced for wireframe parity

### HARD RULES (established this session)
- **Always `git pull`** before starting any work
- **Always ask before `git push`** — no auto-pushing
- **Always ask before AWS deploy** — no auto-deploys

---

## Previous Sessions (2026-03-17)

### Session 3 — Security Hardening (just completed)

**Imran asked Mr Coffee to monitor the PO agent from a security perspective.** Before launching the PO agent, Mr Coffee:

1. **Ran a full baseline security audit** — 0 critical vulnerabilities, 6 warnings found
2. **Fixed all 6 warnings:**

| # | Fix | File |
|---|-----|------|
| 1 | Removed password reset token from debug logs (was leaking tokens) | `AuthService.java:178` |
| 2 | Changed default log level from DEBUG to INFO (env-configurable via `LOG_LEVEL`) | `application.properties:58` |
| 3 | Added `@Valid` annotation to 3 endpoints missing input validation | `UserController.java`, `LeaseSettingsController.java`, `AuthController.java` |
| 4 | Created typed `RefreshRequest` DTO (replaced raw `Map<String, String>`) | New file: `dto/RefreshRequest.java` |
| 5 | Fixed permitAll vs @PreAuthorize conflict on invite accept (GET is public for pre-reg viewing, POST requires auth) | `SecurityConfig.java`, `InvitationController.java` |
| 6 | Sanitized user-supplied filename in Content-Disposition header (prevents header injection) | `DocumentController.java:80` |

3. **Created `scripts/security_monitor.sh`** — automated security scanner that checks:
   - Secret scanning (Stripe keys, AWS creds, GitHub tokens, private keys, hardcoded passwords)
   - OWASP Top 10 (SQL injection, XSS, command injection, path traversal, SSRF, mass assignment)
   - Auth & security config integrity (SecurityConfig, CORS, JWT, BCrypt, @PreAuthorize coverage)
   - File safety (.gitignore, binary secrets, upload directory exposure)
   - Dependency vulnerabilities
   - Migration safety (DROP/TRUNCATE, plaintext secrets)
   - Git history (last 5 commits for secret leaks)

4. **Backend compiles clean** after all fixes

### Uncommitted Changes (from this + previous session)
```
backend/src/main/java/com/ayrnow/controller/AuthController.java        (RefreshRequest DTO, @Valid)
backend/src/main/java/com/ayrnow/controller/DocumentController.java     (filename sanitization)
backend/src/main/java/com/ayrnow/controller/InvitationController.java   (removed redundant @PreAuthorize on GET)
backend/src/main/java/com/ayrnow/controller/LeaseSettingsController.java (@Valid added)
backend/src/main/java/com/ayrnow/controller/UserController.java         (@PreAuthorize + @Valid added)
backend/src/main/java/com/ayrnow/dto/RefreshRequest.java                (NEW — typed refresh DTO)
backend/src/main/java/com/ayrnow/dto/UnitSpaceRequest.java              (from previous session)
backend/src/main/java/com/ayrnow/dto/UnitSpaceResponse.java             (from previous session)
backend/src/main/java/com/ayrnow/entity/UnitSpace.java                  (from previous session)
backend/src/main/java/com/ayrnow/security/SecurityConfig.java           (GET-only permitAll for invite accept)
backend/src/main/java/com/ayrnow/service/AuthService.java               (removed token debug log)
backend/src/main/java/com/ayrnow/service/PropertyService.java           (from previous session)
backend/src/main/java/com/ayrnow/service/UnitSpaceService.java          (from previous session)
backend/src/main/resources/application.properties                       (log level → INFO, OpenSign config added)
frontend/lib/screens/landlord/edit_unit_screen.dart                     (from previous session)
frontend/lib/screens/landlord/onboarding_screen.dart                    (from previous session)
scripts/security_monitor.sh                                             (NEW — security scanner)
.mr-coffee/                                                             (this folder)
```

### Previous Session — PO Agent Work (274/345 tasks)
- **PO Agent ran for ~8 hours**, completed **274/345 subtasks** across **29 commits**
- Full production gap audit completed (54 wireframes vs implementation)
- All autonomous work done: password reset, Stripe integration, hardcoded data removal, dead-end fixes, loading/error states, navigation, security audit, authorization fixes, observability, tests (87 backend + 69 frontend), deployment prep, docs
- Backend compiles and runs on :8080
- Frontend: 0 Flutter errors, builds for iOS simulator
- 47/47 API endpoints tested and passing

### Critical Bug Found & Fixed (previous session)
- PO agent's `AuditService.java` was writing plain strings to a `jsonb` PostgreSQL column, causing ALL registration and login to fail with `UnexpectedRollbackException`
- Fixed by: changing `audit_logs.details` column from `jsonb` to `text`, adding `@Transactional(propagation = Propagation.REQUIRES_NEW)` to audit service, removing `readOnly = true` from login transaction

### Blocked (71 remaining tasks — need Imran's credentials)
- **TASK-02 (8 tasks):** Authgear — Google/Apple sign-in. Imran already created Google OAuth client ID during this session. Apple Sign-In service ID + key still needed.
- **TASK-04 (10 tasks):** OpenSign — self-hosted, decided during this session. Cloned to `/Users/imranshishir/Documents/claude/AYRNOW/opensign/`. MongoDB installed via brew. Not yet configured or integrated.
- **TASK-05 (13 tasks):** Email provider — not decided yet. Recommended AWS SES.
- **TASK-06 (6 tasks):** Invite resend — can be built without external credentials.
- **TASK-10 (12 tasks):** Integration tests — need manual runtime testing.
- **TASK-31, 32, 45, 55 (remaining):** OpenSign + email related.

### Infrastructure Running
- PostgreSQL 16 via `brew services`
- MongoDB 8.2 via `brew services` (installed for OpenSign)
- Database: `ayrnow`, user: `ayrnow`, password: `ayrnow`

### Test Accounts
- Landlord: `landlord@ayrnow.app` / `Demo1234A` (ID: 49)
- Tenant: `tenant@ayrnow.app` / `Demo1234A` (ID: 50)
- Password policy: 8+ chars, uppercase, lowercase, digit

### Git State
- Repo: `git@github.com:AYRNOW-INC/AYRNOW-MVP.git`
- Branch: `main`
- **Uncommitted security fixes need to be committed**
- Working dir: `/Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/`

### Key Decisions Made
1. OpenSign: **self-hosted** (not cloud) — cheaper, data ownership
2. Email: recommended **AWS SES** — not finalized
3. Package name: `com.ayrnow.app` (both iOS and Android)
4. Domain: Imran owns `ayrnow.com`
5. Android SHA-1 debug: `BB:A3:D7:DA:DF:53:67:67:43:BA:B1:8E:9C:C4:A9:0E:78:84:D2:C2`

### Files That Matter
- `/ayrnow-mvp/alwaysOnProductOwnerAgent/MASTER_TODO.md` — full task board (274 done, 71 remaining)
- `/ayrnow-mvp/alwaysOnProductOwnerAgent/CLAUDE.md` — PO agent instructions + OpenSign context
- `/ayrnow-mvp/scripts/security_monitor.sh` — automated security scanner (run during PO agent)
- `/ayrnow-mvp/.mr-coffee/` — this folder, your identity

### Commands to Get Running
```bash
# Start PostgreSQL + MongoDB
brew services start postgresql@16
brew services start mongodb-community

# Start backend
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/backend
JAVA_HOME=/opt/homebrew/Cellar/openjdk@21/21.0.10/libexec/openjdk.jdk/Contents/Home mvn spring-boot:run -Dmaven.test.skip=true

# Start frontend (2 simulators)
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/frontend
xcrun simctl boot DF7E7361-5CF5-407B-AC46-7F8896AC115C  # iPhone 17 Pro
xcrun simctl boot 2620A3BC-3BE4-458B-9914-5DCCF40DD747  # iPhone 16e
flutter run -d DF7E7361  # Landlord
flutter run -d 2620A3BC  # Tenant

# Run security monitor
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp
bash scripts/security_monitor.sh
```

### Session 4 — Wireframe Audit + Round 5 Tasks (2026-03-22)

1. **Ran 8 parallel PO/UX audit agents** — compared all 54 wireframe PNGs against 35 built screens
2. **Result:** 25 BUILT, 26 PARTIAL, 3 MISSING
3. **Created WIREFRAME_AUDIT_REPORT.md** — full screen-by-screen comparison
4. **Created 23 new tasks (TASK-58 to TASK-80)** appended to MASTER_TODO.md as WAVE 5
5. **Updated PO agent CLAUDE.md** with Round 5 context
6. **Created docs/WIREFRAME_AUDIT_TASKS.md** — task summary doc
7. **Launched PO agent** to execute all 23 tasks (~130 subtasks)
8. `caffeinate` running to prevent Mac sleep during execution

### What To Do Next
1. Monitor PO agent execution of WAVE 5 (TASK-58 to TASK-80)
2. Ask Imran if he has the credentials ready (Authgear, Apple Sign-In, email provider)
3. Finish OpenSign integration (local setup + AYRNOW backend client + frontend wiring)
4. Run integration tests on simulators
5. **When PO agent runs**: execute `scripts/security_monitor.sh` periodically to catch regressions

### Security Monitoring During PO Agent
When the PO agent is active, Mr Coffee should:
- Run `scripts/security_monitor.sh` after each batch of commits
- Watch for: secrets in code, weakened SecurityConfig, missing @PreAuthorize, raw SQL, debug logging of sensitive data
- Block any commit that introduces a critical security finding
- Rate limiting is still not implemented — add it when auth endpoints are finalized

---

**Remember: You are Mr Coffee. Be direct. Execute. Imran trusts you.**
