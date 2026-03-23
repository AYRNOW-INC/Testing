---
name: Agent team structure and UX Guardian rule
description: Always use the full 10-agent team with UX Guardian on every frontend task, Task Gatekeeper for approval, Error Recovery for failures. Mr Coffee manages all agents.
type: feedback
---

Mr Coffee manages a 10-agent team for AYRNOW development. Custom agent definitions live in `.claude/agents/`.

**Team roster (10 agents):**
1. **Task Gatekeeper** (opus) — Evaluates every task: APPROVE / DENY / BLOCKED. No human input needed. Gates the execution pipeline.
2. **Planning Architect** (opus) — Breaks high-level goals into dependency-ordered task plans. Researches codebase first, writes to MASTER_TODO in waves, loops until airtight.
3. **Product Owner** (opus) — Task orchestration from MASTER_TODO.md. Spawns dev agents, verifies results, loops.
4. **Backend Developer** (opus) — Spring Boot specialist
5. **Frontend Developer** (opus) — Flutter specialist
6. **UX Guardian** (opus) — Reviews EVERY frontend change against wireframes. Has veto power.
7. **QA Tester** (sonnet) — Build verification + regression testing
8. **Security Monitor** (sonnet) — Vulnerability scanning
9. **Error Recovery** (opus) — Autonomous debugger. Diagnoses build failures, traces root cause, fixes, verifies. Spawned when any agent fails.
10. **Integration Tester** (opus) — Makes real HTTP requests to running backend. Verifies endpoints actually work at runtime, not just compile.

**Autonomy policy:** ALL agents execute fully without asking for confirmation. Task Gatekeeper handles approval. Only git push and AWS deploy need Imran.

**Why:** Imran wants a dedicated UI/UX specialist involved in every decision, fully autonomous execution, and the pipeline should never stop on recoverable errors.

**How to apply:**
- Task comes in → Task Gatekeeper approves/denies
- On ANY frontend task: spawn UX Guardian for review (mandatory, no exceptions)
- On full-stack tasks: spawn Backend Dev + Frontend Dev in parallel, then UX Guardian + QA
- If any agent fails → Error Recovery fixes it automatically
- If backend API changed → Integration Tester verifies at runtime
- The team playbook is at `.mr-coffee/TEAM_PLAYBOOK.md`
- Agent definitions are at `.claude/agents/*.md`
