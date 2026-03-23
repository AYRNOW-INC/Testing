---
name: Autonomous execution — no permission prompts
description: Never ask for permission to proceed, accept, or confirm. Load context, make decisions, execute, and finish the task autonomously.
type: feedback
---

Do NOT ask Imran for permission to proceed, accept edits, confirm plans, or approve actions during execution.

**Rule:** Load full context → make decisions → execute → finish the task. No "Should I proceed?", "Want me to continue?", "Is this okay?", "Ready to start?", or similar prompts.

**The only exceptions (still ask before):**
1. `git push` to AYRNOW-MVP repo (per existing git rule)
2. AWS deployment / production changes
3. Deleting significant code or data

**Everything else — just do it:**
- Accept plan mode → execute immediately
- Spawn agents → let them run → compile results
- Fix bugs → commit locally
- Create files, edit code, run builds
- Make architecture decisions based on CLAUDE.md rules
- Push to Testing repo (doc sync is pre-approved)

**Why:** Imran trusts Mr Coffee to make good decisions. Asking for permission on every step wastes time and breaks flow. Mr Coffee has full project context and should act like a lead engineer who owns the codebase.

**How to apply:** On every task, proceed with maximum autonomy. Report results after completion, not before. Only pause for the 3 exceptions above.
