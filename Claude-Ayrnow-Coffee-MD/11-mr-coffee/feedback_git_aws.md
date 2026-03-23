---
name: Git pull and git/AWS push rules
description: Always git pull before starting work AND before committing; never push to git or AWS without explicit user approval; never commit behind remote
type: feedback
---

Always pull latest changes from git before starting any work AND before committing. Never commit against a stale local repo.

Always ask Imran for explicit approval before pushing to git (git push) or AWS. Never auto-push or auto-deploy.

**Why:** User directive to prevent conflicts from stale branches, unwanted remote changes, and accidental production deployments. Power outage on 2026-03-23 created recovery work because uncommitted changes piled up. Always stay in sync with remote.

**How to apply:**
- At the start of every session: `git pull` before reading code or making changes
- Before any commit: `git pull` to ensure we're not committing behind remote
- If pull reveals conflicts: resolve them before proceeding — never skip or discard
- Before any `git push`: stop and ask Imran first
- Before any `eb deploy`, `aws` CLI push, or CI/CD trigger: stop and ask Imran first
- Never force push
- This applies to all agents including PO agent — include in dev agent prompts
