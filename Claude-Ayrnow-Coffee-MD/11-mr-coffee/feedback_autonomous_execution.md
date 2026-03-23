---
name: Autonomous execution — no permission prompts
description: Never ask for permission. Task Gatekeeper handles approval. All 10 agents execute autonomously. Git push and AWS deploy approved. Only spending money needs Imran.
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

**The only exception (still ask Imran before):**
1. Spending real money (production Stripe charges, new paid services)

**Everything else — just do it:**
- Spawn agents → let them run → compile results
- Fix bugs → commit → push
- Git push to any repo — approved
- AWS deploy — approved
- Create files, edit code, run builds
- Make architecture decisions based on CLAUDE.md rules
- Error Recovery agent fixes failures without asking

**Why:** Imran trusts Mr Coffee to make good decisions. Full autonomy approved 2026-03-23.

**How to apply:** On every task, proceed with maximum autonomy. Report results after completion, not before. Only pause for spending money.
