# MD Sync Guide — Claude-Ayrnow-Coffee-MD

**This file tells Mr Coffee (and any future agent) how to sync documentation at the start and end of every session.**

---

## At Session Start — PULL

Always pull the latest docs before doing any work.

```bash
# 1. Pull latest docs from Testing repo
cd /Users/imranshishir/Documents/claude/AYRNOW/Testing
git pull origin main

# 2. Pull latest app code
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp
git pull origin main
```

The centralized docs live at:
```
/Users/imranshishir/Documents/claude/AYRNOW/Testing/Claude-Ayrnow-Coffee-MD/
```

Read `Claude-Ayrnow-Coffee-MD/README.md` for the full folder index.

---

## During Session — UPDATE IN PLACE

When you create or modify any .md file during the session, update BOTH copies:

1. **Source copy** — the original location (e.g., `ayrnow-mvp/docs/`, `_build_memory/`, `~/.claude/.../memory/`)
2. **Centralized copy** — `Testing/Claude-Ayrnow-Coffee-MD/<folder>/`

### Folder mapping (source → centralized)

| Source Location | Centralized Folder |
|----------------|-------------------|
| `ayrnow-mvp/CLAUDE.md` | `01-project/CLAUDE_MVP.md` |
| `ayrnow-mvp/README.md` | `01-project/README_MVP.md` |
| `ayrnow-mvp/docs/*` | Map by topic: `02-architecture/`, `03-api/`, `04-deployment/`, `05-integrations/`, `06-security/`, `07-testing/`, `12-release/` |
| `ayrnow-mvp/WIREFRAME_*.md` | `08-audit/` |
| `_build_memory/*` | `09-build-memory/` |
| `ayrnow-mvp/alwaysOnProductOwnerAgent/*.md` | `10-po-agent/` |
| `ayrnow-mvp/.mr-coffee/*` | `11-mr-coffee/` |
| `~/.claude/.../memory/*.md` | `00-index/` (MEMORY, PROJECT) or `11-mr-coffee/` (agent prefs) |
| New docs not in mapping | Pick the best folder, add to README index |

### If you create a NEW .md file

1. Save it in the appropriate source location
2. Copy to the matching `Claude-Ayrnow-Coffee-MD/<folder>/`
3. Update `Claude-Ayrnow-Coffee-MD/README.md` file count if needed

---

## At Session End — COMMIT & PUSH

Before ending any session, sync all doc changes to GitHub.

```bash
# 1. Go to Testing repo
cd /Users/imranshishir/Documents/claude/AYRNOW/Testing

# 2. Pull first (always)
git pull origin main

# 3. Stage doc changes
git add Claude-Ayrnow-Coffee-MD/

# 4. Commit with session context
git commit -m "Update Claude-Ayrnow-Coffee-MD: [brief description of what changed]

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"

# 5. Push
git push origin main
```

### What to include in the commit message
- Which folders were updated (e.g., "updated 04-deployment, 09-build-memory")
- What triggered the update (e.g., "production hardening session", "new deployment docs")
- Any new files added

---

## Quick Sync Script

Run this one-liner to sync all .md files from source to centralized folder:

```bash
# Full re-sync (overwrites centralized copies with latest source copies)
cd /Users/imranshishir/Documents/claude/AYRNOW/Testing

MVP="/Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp"
BM="/Users/imranshishir/Documents/claude/AYRNOW/_build_memory"
MEM="/Users/imranshishir/.claude/projects/-Users-imranshishir-Documents-claude/memory"
D="Claude-Ayrnow-Coffee-MD"

# Sync each folder
cp "$MEM"/{MEMORY,AYRNOW_PROJECT}.md "$D/00-index/"
cp "$MVP/CLAUDE.md" "$D/01-project/CLAUDE_MVP.md"
cp "$MVP/README.md" "$D/01-project/README_MVP.md"
cp "$MVP/docs/NATIVE_AUTH_ARCHITECTURE.md" "$MVP/docs/BACKEND_AUTH_FLOW.md" "$MVP/docs/FRONTEND_AUTH_FLOW.md" "$MVP/docs/SCHEMA_OVERVIEW.md" "$MVP/docs/MODULE_MAP.md" "$MVP/docs/ROUTE_MAP.md" "$D/02-architecture/" 2>/dev/null
cp "$MVP/docs/API_OVERVIEW.md" "$MVP/docs/AUTH_API_ENDPOINTS.md" "$D/03-api/" 2>/dev/null
cp "$MVP/docs/AWS_DEPLOYMENT_PLAN"*.md "$MVP/docs/ENVIRONMENT_VARIABLES.md" "$MVP/docs/PRODUCTION_RUNBOOK.md" "$MVP/docs/POST_LAUNCH_CHECKLIST.md" "$MVP/docs/SETUP_MAC.md" "$D/04-deployment/" 2>/dev/null
cp "$MVP/docs/STRIPE_INTEGRATION.md" "$MVP/docs/OPENSIGN"*.md "$MVP/docs/DEPENDENCY"*.md "$D/05-integrations/" 2>/dev/null
cp "$MVP/docs/GITHUB"*.md "$MVP/docs/GIT_WORKFLOW.md" "$MVP/docs/SECRETS_ROTATION_POLICY.md" "$D/06-security/" 2>/dev/null
cp "$MVP/docs/TESTING"*.md "$MVP/docs/E2E_TEST_CHECKLIST.md" "$MVP/docs/QA_AUDIT_REPORT.md" "$D/07-testing/" 2>/dev/null
cp "$MVP/WIREFRAME_AUDIT_REPORT.md" "$MVP/docs/WIREFRAME_AUDIT_TASKS.md" "$BM/FORENSIC_54_AUDIT.md" "$BM/TEAM_AUDIT_MERGED.md" "$D/08-audit/" 2>/dev/null
cp "$BM"/{BUILD_STATE,BUILD_LOG,BUILD_RULES,WORK_PROGRESS,OPEN_BLOCKERS,NEXT_ACTIONS,TOMORROW_START_HERE}.md "$D/09-build-memory/" 2>/dev/null
cp "$MVP/alwaysOnProductOwnerAgent/MASTER_TODO.md" "$D/10-po-agent/"
cp "$MVP/alwaysOnProductOwnerAgent/CLAUDE.md" "$D/10-po-agent/PO_AGENT_CLAUDE.md"
cp "$MVP/.mr-coffee/HANDOFF.md" "$MEM"/{mr_coffee,feedback_swarm_mode,feedback_git_aws,ayrnow_workdir}.md "$D/11-mr-coffee/" 2>/dev/null
cp "$BM"/{RELEASE_CHECKLIST,FINAL_VERIFICATION}.md "$MVP/docs/RELEASE_POLICY.md" "$MVP/docs/INCIDENT_AND_ROLLBACK.md" "$D/12-release/" 2>/dev/null

echo "Sync complete. Run: git add $D && git commit && git push"
```

---

## Rules for Mr Coffee

1. **ALWAYS pull Testing repo at session start** — before reading any docs
2. **ALWAYS push Testing repo at session end** — after all work is done
3. **Ask Imran before pushing ayrnow-mvp** — but Testing repo pushes for doc sync are pre-approved
4. **Never delete centralized docs** — only add or update
5. **Keep README.md file counts accurate** — update after adding new files
6. **Use descriptive commit messages** — future sessions depend on understanding what changed

---

## Locations Summary

| What | Path |
|------|------|
| Centralized docs (local) | `/Users/imranshishir/Documents/claude/AYRNOW/Testing/Claude-Ayrnow-Coffee-MD/` |
| Centralized docs (GitHub) | `git@github.com:AYRNOW-INC/Testing.git` → `Claude-Ayrnow-Coffee-MD/` |
| App repo (local) | `/Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/` |
| App repo (GitHub) | `git@github.com:AYRNOW-INC/AYRNOW-MVP.git` |
| Build memory | `/Users/imranshishir/Documents/claude/AYRNOW/_build_memory/` |
| Agent memory | `~/.claude/projects/-Users-imranshishir-Documents-claude/memory/` |
| This file | `/Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/.mr-coffee/MD_SYNC_GUIDE.md` |
