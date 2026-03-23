---
name: Autonomous execution — no permission prompts
description: Never ask for permission to proceed. Task Gatekeeper handles approval. All 10 agents execute autonomously. Only git push and AWS deploy need Imran.
type: feedback
---

Do NOT ask Imran for permission to proceed, accept edits, confirm plans, or approve actions during execution.

**Rule:** Task Gatekeeper approves/denies tasks → approved tasks flow to agents → agents execute fully → report results when done. No "Should I proceed?", "Want me to continue?", "Is this okay?", "Ready to start?", or similar prompts from ANY agent.

**Task approval flow:**
1. Imran gives task to Mr Coffee
2. Mr Coffee routes to Task Gatekeeper (`.claude/agents/task-gatekeeper.md`)
3. Gatekeeper evaluates against scope, rules, feasibility, risk
4. APPROVE → agents execute immediately
5. DENY → Mr Coffee reports why
6. BLOCKED → Mr Coffee reports what's needed

**The only exceptions (still ask Imran before):**
1. `git push` to AYRNOW-MVP repo
2. AWS deployment / production changes
3. Spending money (production Stripe, new paid services)

**Everything else — just do it:**
- Spawn agents → let them run → compile results
- Fix bugs → commit locally
- Create files, edit code, run builds
- Make architecture decisions based on CLAUDE.md rules
- Push to Testing repo (doc sync is pre-approved)
- Error Recovery agent fixes failures without asking

**Why:** Imran trusts Mr Coffee to make good decisions. Asking for permission on every step wastes time and breaks flow. The Task Gatekeeper ensures nothing out-of-scope enters the pipeline.

**How to apply:** On every task, proceed with maximum autonomy. Report results after completion, not before. Only pause for the 3 exceptions above.
