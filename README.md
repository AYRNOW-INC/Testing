# AYRNOW Testing

Central repository for all AYRNOW testing assets: integration tests, E2E automation, QA audit reports, and test documentation.

**App repo:** [AYRNOW-INC/AYRNOW-MVP](https://github.com/AYRNOW-INC/AYRNOW-MVP)

---

## Repository Structure

```
Testing/
  integration_test/       # Flutter E2E integration tests
    helpers.dart           # Shared test utilities (finders, API helpers, coordination)
    landlord_e2e_test.dart # Landlord flow: Register -> Property -> Unit -> Invite
    tenant_e2e_test.dart   # Tenant flow: Accept invite -> Register -> Onboard -> Pay
  scripts/
    run_e2e.sh             # Orchestration script for dual-simulator E2E runs
  docs/
    QA_AUDIT_REPORT.md     # Full QA audit report (frontend + backend + E2E)
  README.md                # This file
```

---

## E2E Integration Tests

### Overview

The E2E tests automate the full AYRNOW user journey across **two iOS simulators** simultaneously:

| Simulator | Role | Flow |
|-----------|------|------|
| iPhone 17 Pro (DF7E7361) | Landlord | Register -> Login -> Add Property -> Add Unit -> Set Rent -> Invite Tenant |
| iPhone 16e (2620A3BC) | Tenant | Accept Invite -> Register -> Onboard -> View Lease -> Pay Rent |

### Prerequisites

1. **Backend running** on `localhost:8080`
2. **PostgreSQL 16** running (`brew services start postgresql@16`)
3. **Both simulators booted** (iOS 26)
4. **Flutter 3.41.4+** installed
5. `integration_test` package in app's `pubspec.yaml`:
   ```yaml
   dev_dependencies:
     integration_test:
       sdk: flutter
   ```

### Running Tests

**Option 1: Full E2E suite (both simulators, sequential)**
```bash
./scripts/run_e2e.sh
```

**Option 2: Individual test on specific simulator**
```bash
# Copy test files to the app's frontend directory first
cp -r integration_test/ /path/to/ayrnow-mvp/frontend/integration_test/

# Run landlord flow on Sim 1
cd /path/to/ayrnow-mvp/frontend
flutter test integration_test/landlord_e2e_test.dart -d DF7E7361

# Run tenant flow on Sim 2
flutter test integration_test/tenant_e2e_test.dart -d 2620A3BC
```

### Cross-Simulator Coordination

The landlord test writes shared data to `/tmp/ayrnow_e2e_*.txt`:
- `landlord_email` — registered landlord email
- `tenant_email` — tenant email used for invite
- `invite_code` — invitation code for tenant to accept

The tenant test reads these files before starting. The `run_e2e.sh` script handles this automatically, including a fallback API lookup for the invite code.

### Test Accounts

| Role | Email | Password |
|------|-------|----------|
| Landlord (existing) | `landlord@ayrnow.app` | `Demo1234A` |
| Tenant (existing) | `tenant@ayrnow.app` | `Demo1234A` |
| E2E (generated) | `e2e_landlord_{timestamp}@test.ayrnow.app` | `Test1234A` |

Password policy: 8+ characters, 1 uppercase, 1 lowercase, 1 digit.

---

## QA Audit Report

Full audit report is at [`docs/QA_AUDIT_REPORT.md`](docs/QA_AUDIT_REPORT.md).

**Summary: 79 issues found**

| Severity | Frontend | Backend | E2E | Total |
|----------|----------|---------|-----|-------|
| Critical | 5 | 6 | 3 | 14 |
| High | 9 | 8 | 4 | 21 |
| Medium | 11 | 8 | 2 | 21 |
| Low | 15 | 8 | 0 | 23 |

---

## Test Coverage Map

### Frontend Screens Tested (E2E)

| Screen | Tested | Notes |
|--------|--------|-------|
| SplashWelcomeScreen | Yes | |
| LoginScreen | Yes | |
| RegisterScreen (Step 1 & 2) | Yes | |
| LandlordDashboard | Yes | Navigation only |
| PropertyListScreen | Yes | Empty + populated states |
| AddPropertyScreen (3 steps) | Yes | All 3 steps |
| PropertyDetailScreen | Yes | Units tab |
| UnitInviteWizardScreen | Partial | Blocked by Stepper widget issue |
| InviteAcceptScreen | Not yet | Blocked by invite code coordination |
| TenantDashboard | Not yet | |
| TenantPaymentScreen | Not yet | Stripe opens external browser |
| DocumentScreen | Not yet | FilePicker can't be automated |
| LeaseSigningScreen | Not yet | |
| MoveOutScreen | Not yet | |

### Backend Endpoints Tested

- 47/47 endpoints compile and respond (verified by existing API test suite)
- See `QA_AUDIT_REPORT.md` for detailed endpoint audit

---

## Contributing

### Adding New Tests

1. Create test files in `integration_test/`
2. Use helpers from `helpers.dart` for common operations
3. Follow the naming convention: `{role}_{flow}_test.dart`
4. Update this README with coverage info
5. Push to this repo

### Reporting Issues

Document QA findings in `docs/` with the naming convention:
- `QA_AUDIT_REPORT.md` — main audit report (update in-place)
- `QA_REGRESSION_{date}.md` — regression test results
- `QA_RELEASE_{version}.md` — release validation results

### Test Data Management

- E2E tests generate unique emails per run (timestamp-based)
- Tests clear `FlutterSecureStorage` before each run for idempotency
- Backend data accumulates — periodically reset test DB if needed

---

## Known Limitations

1. **Stripe payments** open an external browser — cannot be fully automated in-app
2. **File picker** (document upload) requires OS-level interaction — use API for testing
3. **Flutter Stepper widget** renders all step content simultaneously — use widget Keys for reliable field targeting
4. **Authgear social login** requires real OAuth flow — cannot be automated without Authgear test mode

---

*Managed by: AYRNOW QA Team*
*Last updated: 2026-03-23*
