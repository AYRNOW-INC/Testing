# Mr Coffee's Team Playbook — AYRNOW Agent Team

**Mr Coffee is the team lead. Task Gatekeeper is the sole permission authority.**

---

## Authority Model

**Task Gatekeeper is the ONLY agent with `bypassPermissions`.**

All other 9 agents execute under Gatekeeper's approval. On high-risk or emergency situations, Gatekeeper PAUSES and waits for Imran to review.

| Agent | Permission Level | Authority |
|-------|-----------------|-----------|
| **Task Gatekeeper** | `bypassPermissions` | SOLE authority — approves, denies, pauses |
| All other 9 agents | `default` | Execute only after Gatekeeper approval |

---

## HARD RULE: ALL 10 AGENTS ON EVERY TASK

Every task activates ALL 10 agents. No exceptions. No partial teams.

| Agent | Minimum role on ANY task |
|-------|------------------------|
| Task Gatekeeper | Evaluate + approve + monitor |
| Planning Architect | Verify task breakdown is complete |
| Product Owner | Track on MASTER_TODO, orchestrate |
| Backend Developer | Implement backend (or verify no impact) |
| Frontend Developer | Implement frontend (or verify no impact) |
| UX Guardian | Review UI changes against wireframes |
| QA Tester | Build verification + regression check |
| Security Monitor | Scan changed code for vulnerabilities |
| Error Recovery | Stand by — activate on any failure |
| Integration Tester | Test affected endpoints at runtime |

---

## Task Flow (EVERY task follows this)

```
Imran gives task to Mr Coffee
  |
  v
Mr Coffee spawns Task Gatekeeper (mode: "bypassPermissions")
  |
  v
Gatekeeper evaluates: scope, rules, feasibility, risk
  |
  +---> APPROVE --> Mr Coffee activates ALL 10 agents
  |                   - Planning Architect verifies breakdown
  |                   - Backend Dev + Frontend Dev (parallel)
  |                   - UX Guardian reviews UI
  |                   - QA Tester verifies builds
  |                   - Security Monitor scans
  |                   - Integration Tester hits endpoints
  |                   - Error Recovery stands by
  |
  +---> DENY --> Mr Coffee reports why to Imran
  |
  +---> BLOCKED --> Mr Coffee reports what's needed
  |
  +---> PAUSE FOR IMRAN --> Gatekeeper waits for Imran's review
                            (2+ HIGH risks, data loss, money, irreversible)
```

---

## Spawn Protocol

### Gatekeeper (ONLY agent with bypass)
```python
Agent(
    name="task-gatekeeper",
    description="Evaluate: {task description}",
    mode="bypassPermissions",      # <-- ONLY Gatekeeper gets this
    prompt="..."
)
```

### All other agents (default permissions, Gatekeeper-authorized)
```python
Agent(name="backend-dev",        mode="default", prompt="Gatekeeper APPROVED: ...")
Agent(name="frontend-dev",       mode="default", prompt="Gatekeeper APPROVED: ...")
Agent(name="ux-guardian",         mode="default", prompt="Gatekeeper APPROVED: ...")
Agent(name="qa-tester",           mode="default", prompt="Gatekeeper APPROVED: ...")
Agent(name="security-monitor",    mode="default", prompt="Gatekeeper APPROVED: ...")
Agent(name="error-recovery",      mode="default", prompt="Gatekeeper APPROVED: ...")
Agent(name="integration-tester",  mode="default", prompt="Gatekeeper APPROVED: ...")
Agent(name="planner",             mode="default", prompt="Gatekeeper APPROVED: ...")
Agent(name="po-agent",            mode="default", prompt="Gatekeeper APPROVED: ...")
```

---

## Gatekeeper Pause Triggers

Gatekeeper will PAUSE and wait for Imran when:
- 2+ risk dimensions are HIGH
- Data loss risk is HIGH (any level)
- Task spends real money (production Stripe, new paid services)
- Production deployment touching live user data
- Security risk HIGH + touches auth or payment code
- Irreversible action (DROP TABLE, delete production data)

---

## Team Roster

### Mr Coffee — Team Lead
- Coordinates all agents, routes tasks to Gatekeeper first

### Task Gatekeeper — Sole Permission Authority
- `bypassPermissions` — evaluates, approves, denies, pauses
- Definition: `.claude/agents/task-gatekeeper.md`

### Planning Architect — Task Strategist
- Breaks goals into dependency-ordered plans
- Definition: `.claude/agents/planner.md`

### Product Owner — Task Orchestrator
- Reads MASTER_TODO, orchestrates execution
- Definition: `.claude/agents/po-agent.md`

### Backend Developer — Spring Boot Specialist
- APIs, services, entities, migrations
- Definition: `.claude/agents/backend-dev.md`

### Frontend Developer — Flutter Specialist
- Screens, navigation, state, API wiring
- Definition: `.claude/agents/frontend-dev.md`

### UX Guardian — Design Authority
- Veto power on UI changes
- Definition: `.claude/agents/ux-guardian.md`

### QA Tester — Quality Gate
- Build verification + regression testing
- Definition: `.claude/agents/qa-tester.md`

### Security Monitor — Vulnerability Scanner
- OWASP checks, secret scanning
- Definition: `.claude/agents/security-monitor.md`

### Error Recovery — Autonomous Debugger
- Diagnoses + fixes build failures
- Definition: `.claude/agents/error-recovery.md`

### Integration Tester — Runtime Verifier
- Real HTTP requests to verify endpoints
- Definition: `.claude/agents/integration-tester.md`

---

*Mr Coffee's Team Playbook v2.0 | Updated 2026-03-23*
