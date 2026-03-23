# AYRNOW Open Blockers

## Active — Requires User Input

### 1. Stripe Test Keys — BLOCKS live payment test
- Need: `sk_test_...` from Stripe Dashboard (Test Mode → API Keys)
- Need: `whsec_...` from `stripe listen` CLI output
- Impact: Cannot complete end-to-end payment verification without these
- Everything else is built and wired

### 2. GitHub Settings — BLOCKS security baseline completion
- Need: User to manually apply settings in GitHub web UI
- Checklist in `docs/GITHUB_SETTINGS_CHECKLIST.md`
- Priority: Set repo Private, enable secret scanning + push protection

## Resolved
- Secret audit: CLEAN
- Git push protection: RESOLVED (pushed successfully)
- React examples: CATALOGED
- All 12 docs: CREATED
- All 5 scripts: CREATED
- 7 major wireframe gaps: FIXED
- .gitignore: HARDENED
- Frontend config: DART-DEFINE ready

## Minor (Not Blocking)
- 5 minor wireframe refinements pending
- Backend unit tests not written
- go_router migration not done
- Authgear/OpenSign credentials not configured (stubs ready)
