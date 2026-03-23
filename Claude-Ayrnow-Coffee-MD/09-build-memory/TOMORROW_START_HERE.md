# AYRNOW — Start Here Tomorrow

## Current Status
AYRNOW MVP is fully built, documented, and pushed. Waiting on two user inputs to complete the final integration test.

## What Is Fully Complete
- Backend: 60+ Java files, 48+ API endpoints, all working
- Frontend: 25 Flutter screens matching wireframes, compiles with 0 errors
- Database: 16 tables via 2 Flyway migrations
- Stripe: checkout + webhook + idempotency built (not yet tested with real keys)
- Docs: 18 files (README, setup, API, schema, integrations, security, governance)
- Scripts: 5 executable Mac scripts
- Security: audit clean, .gitignore hardened, governance docs created
- Git: 5 commits on main, tags v1.0.0 + v1.0.1, pushed to origin

## What Is Partially Complete
- Stripe end-to-end test: code ready, needs real test keys to verify
- GitHub settings: docs created, needs manual application in web UI

## What Must Be Done First Tomorrow

### Step 1: GitHub Settings (user, 5 min)
In browser at https://github.com/ayrnowinc-jpg/AYRNOW-MVP/settings:
1. Set repo to Private
2. Enable Secret scanning + Push protection
3. Enable Dependabot alerts
4. Protect main branch (no force push)

### Step 2: Stripe Keys (user, 5 min)
1. Go to https://dashboard.stripe.com/test/apikeys
2. Copy Secret key (sk_test_...)
3. Provide to Claude or set in backend/.env

### Step 3: Stripe Live Test (Claude, 15 min)
Once keys are provided:
1. Install Stripe CLI: `brew install stripe/stripe-cli/stripe`
2. Login: `stripe login`
3. Listen: `stripe listen --forward-to localhost:8080/api/webhooks/stripe`
4. Set both keys as env vars
5. Restart backend
6. Run full end-to-end payment test
7. Verify DB + dashboards

### Step 4: Final Verification + Release
1. Re-run flutter analyze + backend compile
2. Test all flows on simulator
3. Tag v1.1.0 if all passes
4. Push

## Safest Next Command
```bash
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp
./scripts/run_all_local.sh
```

## Inputs Needed From User Tomorrow
1. **Stripe test secret key**: `sk_test_...` from Stripe Dashboard
2. **Confirmation**: that GitHub repo settings have been applied (private, secret scanning, branch protection)

## Services State
- Backend: may or may not be running (PID 69769 was active at session end)
- PostgreSQL: running via brew services (persists across reboots)
- Restart backend if needed: `./scripts/run_backend.sh`

## Key Files to Read First
- `_build_memory/NEXT_ACTIONS.md` — ordered task list
- `_build_memory/OPEN_BLOCKERS.md` — what's blocking
- `_build_memory/BUILD_STATE.md` — quick restart commands
- `docs/STRIPE_INTEGRATION.md` — Stripe test guide
- `docs/GITHUB_SETTINGS_CHECKLIST.md` — manual settings checklist
