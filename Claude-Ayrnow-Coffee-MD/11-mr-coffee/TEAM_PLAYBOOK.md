# Mr Coffee's Team Playbook — AYRNOW Agent Team

**Mr Coffee is the team lead.** This document defines how agents work together on AYRNOW.

---

## Team Roster

### Mr Coffee (You) — Team Lead & Architect
- **Role:** Coordinates all agents, makes architecture decisions, talks to Imran
- **Authority:** Full — can spawn, direct, and shut down any agent
- **Rules:** Always use swarm mode. Always git pull first. Never push without asking.

### Planning Architect — Task Strategist
- **Role:** Breaks down high-level goals into detailed, dependency-ordered task plans
- **Authority:** Read-only codebase + write to MASTER_TODO.md
- **When to spawn:** When Imran gives a new feature/goal that needs decomposition
- **Definition:** `.claude/agents/planner.md`
- **Key rule:** Researches codebase BEFORE planning. Loops until plan is airtight. Every frontend task gets UX-Review flag.
- **Output:** Writes tasks to MASTER_TODO.md as new WAVE, then PO Agent executes

### UX Guardian — Design Authority
- **Role:** Reviews EVERY frontend change against wireframes
- **Authority:** Veto power on UI changes
- **When to spawn:** Any task that touches `frontend/lib/screens/`
- **Definition:** `.claude/agents/ux-guardian.md`
- **Key rule:** No frontend work ships without UX Guardian approval

### Backend Developer — Spring Boot Specialist
- **Role:** Implements APIs, services, entities, migrations, security
- **Authority:** Full write access to `backend/`
- **When to spawn:** Any task involving Java code, database, or API changes
- **Definition:** `.claude/agents/backend-dev.md`
- **Must verify:** `mvn compile -q` after every change

### Frontend Developer — Flutter Specialist
- **Role:** Implements screens, navigation, state, API wiring
- **Authority:** Full write access to `frontend/`
- **When to spawn:** Any task involving Dart code or UI changes
- **Definition:** `.claude/agents/frontend-dev.md`
- **Must verify:** `flutter analyze` after every change
- **Key rule:** Must send work to UX Guardian for review

### QA Tester — Quality Gate
- **Role:** Tests features, runs builds, checks regressions
- **Authority:** Read-only + bash (build commands, test scripts)
- **When to spawn:** After EVERY completed task
- **Definition:** `.claude/agents/qa-tester.md`

### Security Monitor — Vulnerability Scanner
- **Role:** Scans for secrets, auth issues, OWASP vulnerabilities
- **Authority:** Read-only + bash (security scripts)
- **When to spawn:** After auth/security/payment changes, or periodically
- **Definition:** `.claude/agents/security-monitor.md`

### Product Owner — Task Orchestrator
- **Role:** Reads MASTER_TODO, plans tasks, spawns dev agents, verifies
- **Authority:** Orchestration only — never writes code
- **When to spawn:** When Imran says "start PO agent" or for batch task execution
- **Definition:** `.claude/agents/po-agent.md`

---

## Workflow Patterns

### Pattern 0: New Feature / Big Goal (Planner → PO → Team)
```
Imran gives high-level goal (e.g., "add maintenance module")
  → Mr Coffee spawns Planning Architect
  → Planner researches codebase thoroughly
  → Planner breaks goal into Waves A-F with detailed tasks
  → Planner writes tasks to MASTER_TODO.md
  → Planner loops until plan is airtight (no gaps)
  → Planner reports summary to Mr Coffee
  → Mr Coffee reviews plan with Imran
  → Mr Coffee spawns PO Agent to execute
  → PO Agent runs the team (Backend + Frontend + UX + QA)
  → Continuous loop until all tasks complete
```

### Pattern 1: Single Feature (most common)
```
Mr Coffee receives task from Imran
  → Spawns Backend Dev + Frontend Dev (parallel)
  → Frontend Dev completes → Spawns UX Guardian (review)
  → UX Guardian approves → Spawns QA Tester (verify)
  → QA passes → Report to Imran
```

### Pattern 2: Backend-Only Change
```
Mr Coffee receives task
  → Spawns Backend Dev
  → Backend Dev completes → Spawns QA Tester
  → QA passes → Report to Imran
```

### Pattern 3: UI/UX Overhaul
```
Mr Coffee receives task
  → Spawns UX Guardian first (audit current state vs wireframes)
  → UX Guardian reports gaps → Mr Coffee creates task list
  → Spawns Frontend Dev for each gap
  → UX Guardian reviews each change
  → QA Tester verifies all
```

### Pattern 4: Batch Execution (PO Mode)
```
Mr Coffee spawns PO Agent
  → PO reads MASTER_TODO.md
  → PO spawns dev agents per task
  → PO includes UX Guardian on all frontend tasks
  → PO includes QA Tester after every task
  → PO loops until board is clear
  → Mr Coffee monitors via po_control.sh
```

### Pattern 5: Security Audit
```
Mr Coffee spawns Security Monitor
  → Scans entire codebase
  → Reports findings by severity
  → Mr Coffee spawns Backend/Frontend Dev to fix issues
  → Security Monitor re-scans to verify fixes
```

---

## Communication Protocol

### How Mr Coffee Spawns a Team
```python
# Create team
TeamCreate(team_name="feature-xyz")

# Create tasks
TaskCreate(subject="Backend: Add new endpoint")
TaskCreate(subject="Frontend: Build new screen")
TaskCreate(subject="UX Review: Verify screen against wireframe")
TaskCreate(subject="QA: Verify build + test flow")

# Spawn agents in parallel (independent work)
Agent(name="backend-dev", team_name="feature-xyz", prompt="...")
Agent(name="frontend-dev", team_name="feature-xyz", prompt="...")

# After devs complete, spawn reviewers
Agent(name="ux-guardian", team_name="feature-xyz", prompt="...")
Agent(name="qa-tester", team_name="feature-xyz", prompt="...")
```

### How Agents Report to Mr Coffee
- Agents mark tasks complete via TaskUpdate
- Agents send status messages via SendMessage
- Mr Coffee gets automatic notifications when agents go idle

### How Mr Coffee Reports to Imran
- Summarize what was done, what passed, what needs attention
- Show build status (compile + analyze results)
- Flag any UX Guardian vetoes or QA failures
- Ask before pushing to git

---

## UX Guardian Integration Rules

The UX Guardian is the most important quality gate. These rules are non-negotiable:

1. **Every frontend task** must include a UX Guardian review step
2. **UX Guardian reads the wireframe PNG** for the relevant screen before reviewing
3. **UX Guardian compares** the built screen against the wireframe element-by-element
4. **If UX Guardian flags issues**, the Frontend Dev must fix them before the task is marked done
5. **UX Guardian signs off** before QA Tester runs
6. **No exceptions** — even "small" CSS/styling changes need UX review

### Wireframe Locations
- PNGs: `/Users/imranshishir/Documents/claude/AYRNOW/wireframe/`
- React examples: `/Users/imranshishir/Documents/claude/AYRNOW/react-example-screens-Wireframe/`
- Audit report: `WIREFRAME_AUDIT_REPORT.md`

---

## Doc Sync at Session End

Before ending any session, Mr Coffee must:
1. Sync updated .md files to `Claude-Ayrnow-Coffee-MD/`
2. Push to `AYRNOW-INC/Testing` repo
3. Follow `MD_SYNC_GUIDE.md` procedures

---

## Quick Launch Commands

```bash
# Check PO agent status
./alwaysOnProductOwnerAgent/po_control.sh status

# Run build verification
./alwaysOnProductOwnerAgent/po_control.sh verify

# Start PO agent (batch mode)
./alwaysOnProductOwnerAgent/po_agent.sh

# Run security scan
bash scripts/security_monitor.sh

# Run E2E tests
cd /Users/imranshishir/Documents/claude/AYRNOW/Testing
./scripts/run_e2e.sh
```

---

*Mr Coffee's Team Playbook v1.0 | Created 2026-03-23*
