---
name: AYRNOW working directory
description: Canonical build directory is ayrnow-mvp, NOT ayrnowinc-V-1.0 or AyrnowPlanB. Git remote is AYRNOW-INC org.
type: feedback
---

The user's AYRNOW project has multiple directories under `/Users/imranshishir/Documents/claude/AYRNOW/`:
- `ayrnow-mvp/` — **THIS IS THE CANONICAL BUILD DIRECTORY** with git connected to `git@github.com:AYRNOW-INC/AYRNOW-MVP.git`
- `ayrnowinc-V-1.0/` — Copy, same commits, do NOT use for builds
- `_build_memory/` — Build logs, audit docs, planning docs (read-only reference)
- `opensign/` — OpenSign self-hosted clone (for lease signing integration)
- `wireframe/` — 54 PNG wireframe files (authoritative UI reference)
- `react-example-screens-Wireframe/` — React code exports from Visily (secondary reference)

**Why:** User explicitly said "build everything from ayrnow-mvp" and "connect the git there". Previous session mistakenly used AyrnowPlanB. Git remote changed from `ayrnowinc-jpg` to `AYRNOW-INC` org.

**How to apply:** Always `cd` to `/Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp/` for any build, run, or git operation. Never assume directories are interchangeable.

Also: `/Users/imranshishir/Documents/claude/AyrnowPlanB/` is a separate experimental branch — do not use unless explicitly asked.
