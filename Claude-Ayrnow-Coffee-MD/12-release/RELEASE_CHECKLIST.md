# AYRNOW MVP v1.0.0 Release Checklist (Updated)

## PASSED (was 30, now 42)

- [x] Backend compiles and starts
- [x] All 48+ API endpoints respond correctly
- [x] JWT auth + role-based access
- [x] Property/Unit/Invitation/Lease/Document/Payment/MoveOut CRUD
- [x] Stripe checkout + webhook handler
- [x] Dashboard stats (landlord + tenant)
- [x] Notification CRUD with read/unread
- [x] Flutter compiles with 0 errors
- [x] 25 Flutter screens (was 20, +5 new)
- [x] iOS simulator build + install + launch
- [x] Auth flow: Welcome → Login → Register → Forgot Password
- [x] Landlord/Tenant shells with correct bottom nav
- [x] Empty/populated states for all list screens
- [x] Git committed + pushed + tagged v1.0.0
- [x] **README.md** ← NEW
- [x] **backend/.env.example** ← NEW
- [x] **frontend/.env.example** ← NEW
- [x] **12 documentation files** ← NEW
- [x] **5 setup/run scripts** ← NEW
- [x] **Dependency alignment report** ← NEW
- [x] **LeaseSigningScreen with signature pad** ← NEW
- [x] **SigningStatusScreen with timeline** ← NEW
- [x] **LeaseReadyScreen with signer list** ← NEW
- [x] **InviteAcceptScreen with expired state** ← NEW
- [x] **TenantOnboardingScreen with checklist** ← NEW

## NEEDS NEXT ITERATION (reduced from 21 to 14)

- [ ] Stripe end-to-end testing with real test keys
- [ ] Landlord account edit screen (B5)
- [ ] Create Lease steps 4-5 (clauses + review)
- [ ] Payment ledger screen (H3)
- [ ] Payment success screen (H5)
- [ ] Landlord pending document review screen (I2)
- [ ] OpenSign webhook endpoint
- [ ] Backend unit tests
- [ ] Authgear credential configuration
- [ ] OpenSign credential configuration
- [ ] Stripe live key rotation
- [ ] App Store submission prep
- [ ] Play Store submission prep
- [ ] go_router migration
