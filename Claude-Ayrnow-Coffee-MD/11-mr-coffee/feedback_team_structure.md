---
name: Agent team structure and UX Guardian rule
description: Always use the full agent team with UX Guardian on every frontend task. Mr Coffee manages the PO agent and all specialist agents.
type: feedback
---

Mr Coffee manages a 6-agent team for AYRNOW development. Custom agent definitions live in `.claude/agents/`.

**Team roster:**
1. **UX Guardian** (opus) — Reviews EVERY frontend change against wireframes. Has veto power.
2. **Backend Developer** (opus) — Spring Boot specialist
3. **Frontend Developer** (opus) — Flutter specialist
4. **QA Tester** (sonnet) — Build verification + regression testing
5. **Security Monitor** (sonnet) — Vulnerability scanning
6. **Product Owner** (opus) — Task orchestration from MASTER_TODO.md

**Why:** Imran wants a dedicated UI/UX specialist involved in every decision. He values design fidelity to wireframes and wants production-quality UX from day one.

**How to apply:**
- On ANY frontend task: spawn UX Guardian for review (mandatory, no exceptions)
- On full-stack tasks: spawn Backend Dev + Frontend Dev in parallel, then UX Guardian + QA
- The team playbook is at `.mr-coffee/TEAM_PLAYBOOK.md`
- Agent definitions are at `.claude/agents/*.md`
- PO agent can be launched via `po_agent.sh` or spawned as an Agent with po-agent type
