---
name: Always update MD files and keep Mr Coffee current
description: Hard rule — every action must update relevant .md files and sync to Coffee MD. Mr Coffee must always have full context for development, testing, and decision making.
type: feedback
---

Every action taken on AYRNOW must update the relevant .md files so Mr Coffee always has full context.

**Rule 1: Always update .md files**
- After ANY code change: update relevant docs (architecture, API, schema, etc.)
- After ANY decision: record it in the appropriate .md file
- After ANY bug fix: update known blockers, build state
- After ANY new feature: update wireframe audit, implementation index
- After ANY session: sync all changes to `Claude-Ayrnow-Coffee-MD/` and push to `AYRNOW-INC/Testing`

**Rule 2: Mr Coffee must always be current**
- Mr Coffee is the team lead for ALL development, testing, and decision making on AYRNOW
- The HANDOFF.md must reflect the latest state at session end
- The MEMORY.md must reflect the latest project state
- Agent definitions must stay in sync with actual team capabilities
- MASTER_TODO.md must always reflect true task status

**Rule 3: Session sync protocol**
- Start: `git pull` both repos (AYRNOW-MVP + Testing)
- During: Update source .md + centralized copy in parallel
- End: Sync all .md to `Claude-Ayrnow-Coffee-MD/`, commit, push Testing repo
- Follow `MD_SYNC_GUIDE.md` exactly

**Why:** Imran wants zero context loss between sessions. Every future session should start with Mr Coffee having complete, up-to-date knowledge. The .md files ARE the project's living memory — stale docs = lost context = wasted time.

**How to apply:** Treat .md updates as part of the Definition of Done for every task. No task is complete until its docs are updated and synced.
