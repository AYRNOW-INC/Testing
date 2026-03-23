---
name: Git pull rule and full push/deploy autonomy
description: Always git pull before starting work AND before committing. Git push and AWS deploy are fully approved — no need to ask Imran.
type: feedback
---

Always pull latest changes from git before starting any work AND before committing. Never commit against a stale local repo.

**Git push:** APPROVED. Push autonomously without asking Imran.
**AWS deploy:** APPROVED. Deploy autonomously without asking Imran.
**Never force push** to main/master.

**Why:** Imran approved full autonomy on 2026-03-23. The only remaining gate is spending real money (production Stripe charges, new paid services).

**How to apply:**
- At the start of every session: `git pull` before reading code or making changes
- Before any commit: `git pull` to ensure we're not committing behind remote
- If pull reveals conflicts: resolve them before proceeding — never skip or discard
- `git push`: just do it — approved
- `aws` CLI / `eb deploy`: just do it — approved
- Never force push
- This applies to all agents including PO agent
