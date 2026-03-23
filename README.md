# AYRNOW Testing

Central repository for all AYRNOW testing assets: integration tests, E2E automation, QA audit reports, and test documentation.

**App repo:** [AYRNOW-INC/AYRNOW-MVP](https://github.com/AYRNOW-INC/AYRNOW-MVP)

---

## Repository Structure

```
Testing/
  integration_test/
    helpers.dart                          # Shared test utilities
    test_data.dart                        # Centralized test constants
    01_landlord_registration_test.dart    # TC-01: Landlord signup
    02_tenant_registration_test.dart      # TC-02: Tenant signup
    03_login_flow_test.dart               # TC-03: Login/logout/bad creds
    04_add_property_flow_test.dart        # TC-04: 3-step property wizard
    05_unit_management_flow_test.dart     # TC-05: Unit CRUD (API)
    06_lease_settings_flow_test.dart      # TC-06: Lease defaults (API)
    07_tenant_invite_flow_test.dart       # TC-07: Send invite (API)
    08_tenant_accept_invite_test.dart     # TC-08: Accept invite (API)
    09_lease_creation_flow_test.dart      # TC-09: Create lease (API)
    10_document_upload_flow_test.dart     # TC-10: Document upload (API)
    11_rent_payment_flow_test.dart        # TC-11: Rent payment (API)
    12_move_out_flow_test.dart            # TC-12: Move-out request (API)
    13_dashboard_navigation_test.dart     # TC-13: Tab navigation (UI)
  scripts/
    run_e2e.sh                            # Run full E2E suite
    run_scenario.sh                       # Run single scenario by number
  docs/
    TEST_PLAN.md                          # Master test plan + checklist
    QA_AUDIT_REPORT.md                    # Full QA audit (79 issues)
```

---

## Quick Start

### Run a single scenario
```bash
./scripts/run_scenario.sh 01              # Landlord registration
./scripts/run_scenario.sh 04              # Add property flow
./scripts/run_scenario.sh 13              # Dashboard navigation
```

### Run all scenarios
```bash
./scripts/run_e2e.sh
```

### Prerequisites
1. Backend running on `localhost:8080`
2. PostgreSQL 16 running
3. iOS simulator booted
4. Copy tests to app: `cp -r integration_test/ /path/to/ayrnow-mvp/frontend/integration_test/`

---

## Test Scenarios (68 test cases)

| # | Scenario | Cases | Type | Dependencies |
|---|----------|-------|------|-------------|
| 01 | Landlord Registration | 5 | UI | None |
| 02 | Tenant Registration | 4 | UI | None |
| 03 | Login Flow | 6 | UI | Existing accounts |
| 04 | Add Property | 8 | UI | Landlord account |
| 05 | Unit Management | 5 | API | Property exists |
| 06 | Lease Settings | 4 | API | Property exists |
| 07 | Tenant Invite | 5 | API | Vacant unit |
| 08 | Tenant Accept Invite | 6 | API | TC-07 invite code |
| 09 | Lease Creation | 5 | API | Property + tenant |
| 10 | Document Upload | 4 | API | Tenant account |
| 11 | Rent Payment | 5 | API | Active lease |
| 12 | Move-Out Request | 5 | API | Active lease |
| 13 | Dashboard Navigation | 6 | UI | Both accounts |

### Test Types
- **UI**: Flutter integration test — launches real app, taps buttons, fills forms on simulator
- **API**: Dart HTTP calls — hits real backend API endpoints directly

### Execution Order
```
Independent:  TC-01, TC-02, TC-03, TC-13
Sequential:   TC-04 → TC-05 → TC-06
Sequential:   TC-07 → TC-08
Sequential:   TC-09 → TC-10 → TC-11
After lease:  TC-12
```

---

## Test Accounts

| Role | Email | Password |
|------|-------|----------|
| Landlord (existing) | `landlord@ayrnow.app` | `Demo1234A` |
| Tenant (existing) | `tenant@ayrnow.app` | `Demo1234A` |
| E2E (auto-generated) | `e2e_{role}_{timestamp}@test.ayrnow.app` | `Test1234A` |

---

## Documentation

- **[TEST_PLAN.md](docs/TEST_PLAN.md)** — Master test plan with 68 test cases and pass/fail checklist
- **[QA_AUDIT_REPORT.md](docs/QA_AUDIT_REPORT.md)** — Full QA audit: 79 issues across frontend, backend, and E2E

---

*Managed by: AYRNOW QA Team*
*Last updated: 2026-03-23*
