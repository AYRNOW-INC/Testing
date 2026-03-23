# AYRNOW MVP — Master Test Plan

**Version:** 1.0
**Date:** 2026-03-23
**Total Test Cases:** 68
**Total Scenarios:** 13

---

## How to Use This Checklist

After each test run, update the Status column:
- `PASS` — Test case passed
- `FAIL` — Test case failed (add note)
- `SKIP` — Skipped (precondition not met)
- `BLOCK` — Blocked by dependency or bug

---

## TC-01: Landlord Registration Flow

**File:** `01_landlord_registration_test.dart`
**Type:** UI Automation
**Simulator:** iPhone 17 Pro (Sim 1)
**Preconditions:** No prior session, backend running

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-01-01 | Splash screen loads | "Login" and "Create Account" buttons visible | | |
| TC-01-02 | Tap Create Account | Register Step 1 loads with "Personal Information" header | | |
| TC-01-03 | Fill personal info | First name, last name, email, password fields accept input | | |
| TC-01-04 | Tap Next: Account Type | Step 2 loads with "How will you use AYRNOW?" | | |
| TC-01-05 | Landlord selected + Continue | Landlord Dashboard loads with bottom nav | | |

---

## TC-02: Tenant Registration Flow

**File:** `02_tenant_registration_test.dart`
**Type:** UI Automation
**Simulator:** iPhone 16e (Sim 2)
**Preconditions:** No prior session, backend running

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-02-01 | Splash → Create Account | Register Step 1 loads | | |
| TC-02-02 | Fill tenant personal info | All fields accept input | | |
| TC-02-03 | Select Tenant role | "Invite Code (optional)" field appears | | |
| TC-02-04 | Tap Continue | Tenant Dashboard loads (Home, Lease, Pay, Docs, Account) | | |

---

## TC-03: Login Flow

**File:** `03_login_flow_test.dart`
**Type:** UI Automation
**Simulator:** Either
**Preconditions:** Existing accounts (landlord@ayrnow.app, tenant@ayrnow.app)

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-03-01 | Splash → Login screen | "Welcome back" header, email/password fields visible | | |
| TC-03-02 | Valid landlord login | Landlord Dashboard loads with "Dashboard" text | | |
| TC-03-03 | Logout from Account tab | Returns to Splash/Login screen | | |
| TC-03-04 | Valid tenant login | Tenant Dashboard loads with "Home" text | | |
| TC-03-05 | Invalid credentials | Error shown, stays on login screen | | |
| TC-03-06 | Empty fields + Sign In | "Valid email required" validation message | | |

---

## TC-04: Add Property Flow

**File:** `04_add_property_flow_test.dart`
**Type:** UI Automation
**Simulator:** iPhone 17 Pro (Sim 1)
**Preconditions:** Logged in as landlord

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-04-01 | Login as landlord | Dashboard loads | | |
| TC-04-02 | Navigate to Properties tab | Properties screen visible | | |
| TC-04-03 | Tap Add Property | Step 1 "Basic Information" loads | | |
| TC-04-04 | Fill property details | Name, address, city, state, zip accepted | | |
| TC-04-05 | Next: Property Structure | Step 2 loads with unit/floor fields | | |
| TC-04-06 | Verify defaults → Review | Units=1, Floors=1; Step 3 review loads | | |
| TC-04-07 | Review shows correct data | Property name and address displayed | | |
| TC-04-08 | Save & Create Property | "Property Created!" success screen | | |

**Known Issue:** Property type buttons (Residential/Commercial/Industrial/Other) overflow by 20px on smaller screens.

---

## TC-05: Unit Management Flow

**File:** `05_unit_management_flow_test.dart`
**Type:** API-driven
**Preconditions:** Landlord with at least one property

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-05-01 | Login + get properties | Token received, properties list returned | | |
| TC-05-02 | Get property with units | Property detail includes unitSpaces array | | |
| TC-05-03 | Update unit (name, type, rent) | PUT returns updated unit data | | |
| TC-05-04 | Verify update persisted | GET returns same updated values | | |
| TC-05-05 | Verify unit status=VACANT | New units default to VACANT | | |

---

## TC-06: Lease Settings Flow

**File:** `06_lease_settings_flow_test.dart`
**Type:** API-driven
**Preconditions:** Landlord with property

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-06-01 | Get current settings | Returns defaults (term, rent, deposit) | | |
| TC-06-02 | Update all settings | PUT accepts new values | | |
| TC-06-03 | Verify persistence | GET returns updated values | | |
| TC-06-04 | Verify grace period + late fee | Values saved correctly | | |

---

## TC-07: Tenant Invite Flow

**File:** `07_tenant_invite_flow_test.dart`
**Type:** API-driven
**Preconditions:** Landlord with vacant unit (name, type, rent set)

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-07-01 | Find vacant unit | At least one VACANT unit found | | |
| TC-07-02 | Send invitation | POST /invitations succeeds | | |
| TC-07-03 | Verify PENDING status | Invitation status=PENDING or SENT | | |
| TC-07-04 | Verify invite code generated | Non-empty alphanumeric code | | |
| TC-07-05 | Duplicate invite attempt | Server handles gracefully | | |

---

## TC-08: Tenant Accept Invite Flow

**File:** `08_tenant_accept_invite_test.dart`
**Type:** API-driven
**Preconditions:** Invite code from TC-07

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-08-01 | Fetch invitation by code | Returns property/unit details | | |
| TC-08-02 | Verify PENDING status | Status is PENDING/SENT/OPENED | | |
| TC-08-03 | Accept invitation | POST changes status | | |
| TC-08-04 | Verify status → ACCEPTED | Status updated after accept | | |
| TC-08-05 | Register with invite code | Tenant account created | | |
| TC-08-06 | Verify tenant linked to unit | Tenant assigned to correct unit | | |

---

## TC-09: Lease Creation Flow

**File:** `09_lease_creation_flow_test.dart`
**Type:** API-driven
**Preconditions:** Landlord with property, unit, and tenant

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-09-01 | Find property with unit | Property and unit exist | | |
| TC-09-02 | Create lease | POST /leases returns lease object | | |
| TC-09-03 | Verify DRAFT status | New lease starts as DRAFT | | |
| TC-09-04 | Send for signing | Status → SENT_FOR_SIGNING | | |
| TC-09-05 | Verify lease details | Term, rent, dates are correct | | |

---

## TC-10: Document Upload Flow

**File:** `10_document_upload_flow_test.dart`
**Type:** API-driven
**Preconditions:** Tenant account exists
**Note:** Actual file upload requires manual testing (FilePicker)

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-10-01 | Login as tenant | Token received | | |
| TC-10-02 | Get document list | Returns list (may be empty) | | |
| TC-10-03 | Verify supported types | ID, PROOF_OF_INCOME, BACKGROUND_CHECK | | |
| TC-10-04 | Verify endpoint reachable | HTTP 200 response | | |

---

## TC-11: Rent Payment Flow

**File:** `11_rent_payment_flow_test.dart`
**Type:** API-driven
**Preconditions:** Tenant with active lease and pending payment
**Note:** Stripe checkout opens external browser (cannot automate)

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-11-01 | Get tenant payments | Returns payment list | | |
| TC-11-02 | Verify payment fields | Amount, dueDate, status present | | |
| TC-11-03 | Initiate checkout | POST returns checkoutUrl | | |
| TC-11-04 | Verify Stripe URL | URL contains "stripe" | | |
| TC-11-05 | Payment status after webhook | Status → SUCCESSFUL | | |

---

## TC-12: Move-Out Request Flow

**File:** `12_move_out_flow_test.dart`
**Type:** API-driven
**Preconditions:** Tenant with active lease

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-12-01 | Tenant creates request | POST /move-out succeeds | | |
| TC-12-02 | Verify SUBMITTED status | Status=SUBMITTED or DRAFT | | |
| TC-12-03 | Landlord views requests | GET /move-out/landlord returns list | | |
| TC-12-04 | Landlord approves | PUT review → APPROVED | | |
| TC-12-05 | Verify APPROVED status | Status=APPROVED | | |

---

## TC-13: Dashboard Navigation Flow

**File:** `13_dashboard_navigation_test.dart`
**Type:** UI Automation
**Simulator:** Either
**Preconditions:** Both accounts exist

| ID | Test Case | Expected Behavior | Status | Notes |
|----|-----------|-------------------|--------|-------|
| TC-13-01 | Landlord Dashboard tab | "Dashboard" text visible | | |
| TC-13-02 | Properties tab | Properties screen loads | | |
| TC-13-03 | Leases tab | Leases screen loads | | |
| TC-13-04 | Payments tab | Payments screen loads | | |
| TC-13-05 | Account tab | Account screen loads | | |
| TC-13-06 | Tenant tabs (Home/Lease/Pay/Docs/Account) | All 5 tabs load correctly | | |

---

## Summary

| Scenario | Test Cases | Type | Dependency |
|----------|-----------|------|------------|
| TC-01 Landlord Registration | 5 | UI | None |
| TC-02 Tenant Registration | 4 | UI | None |
| TC-03 Login Flow | 6 | UI | TC-01 or existing accounts |
| TC-04 Add Property | 8 | UI | Landlord account |
| TC-05 Unit Management | 5 | API | Property exists |
| TC-06 Lease Settings | 4 | API | Property exists |
| TC-07 Tenant Invite | 5 | API | Vacant unit exists |
| TC-08 Tenant Accept Invite | 6 | API | TC-07 invite code |
| TC-09 Lease Creation | 5 | API | Property + tenant |
| TC-10 Document Upload | 4 | API | Tenant account |
| TC-11 Rent Payment | 5 | API | Active lease + payment |
| TC-12 Move-Out | 5 | API | Active lease |
| TC-13 Dashboard Navigation | 6 | UI | Both accounts |
| **TOTAL** | **68** | | |

### Recommended Execution Order
1. TC-01 → TC-02 → TC-03 (Auth flows, independent)
2. TC-04 → TC-05 → TC-06 (Property flows, sequential)
3. TC-07 → TC-08 (Invite flows, sequential)
4. TC-09 → TC-10 → TC-11 (Lease + payment, sequential)
5. TC-12 (Move-out, needs active lease)
6. TC-13 (Navigation, independent)
