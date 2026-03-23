# CLAUDE.md — AYRNOW Testing Repository

## Purpose
This repo holds ALL testing assets for AYRNOW. The app source code lives in `AYRNOW-INC/AYRNOW-MVP`.

## Rules
- Only test-related files belong here: integration tests, test scripts, QA reports, test documentation
- NO app source code, NO Docker, NO deployment configs
- Test files reference the AYRNOW app via imports — they must be copied to the app's `frontend/integration_test/` directory to run
- Keep QA reports up to date after each audit cycle

## Structure
- `integration_test/` — Flutter E2E tests (Dart)
- `scripts/` — Shell scripts for test orchestration
- `docs/` — QA audit reports, test plans, release validation

## Quick Commands
```bash
# Run full E2E suite
./scripts/run_e2e.sh

# Copy tests to app repo for execution
cp -r integration_test/ /path/to/ayrnow-mvp/frontend/integration_test/
```
