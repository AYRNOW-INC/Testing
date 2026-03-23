# AYRNOW Team Audit — Merged Findings

Date: 2026-03-15 | 3-Agent Parallel Audit

---

## CONSOLIDATED 54-ROW TABLE

| # | Wireframe | File | Type | Reachable | Status | Key Gap |
|---|-----------|------|------|-----------|--------|---------|
| 1 | Splash & Welcome | splash_welcome_screen.dart | DEDICATED | Yes (app entry) | COMPLETE | — |
| 2 | Login | login_screen.dart | DEDICATED | Yes (splash→login) | COMPLETE | Social buttons placeholder (Authgear) |
| 3 | Register / Account Type | register_screen.dart | DEDICATED | Yes (splash/login→register) | COMPLETE | 2-step vs wireframe 4-step |
| 4 | Forgot Password | forgot_password_screen.dart | DEDICATED | Yes (login→forgot) | COMPLETE | — |
| 5 | Landlord Dashboard (Empty) | landlord_dashboard.dart | STATE (_buildEmptyDashboard) | Yes (login→dashboard tab) | COMPLETE | — |
| 6 | Landlord Dashboard (Populated) | landlord_dashboard.dart | STATE (_buildPopulatedDashboard) | Yes (login→dashboard tab) | PARTIAL | Missing trend % indicators, hardcoded activity items, "View All" empty callback |
| 7 | Landlord Account Setup | onboarding_screen.dart | DEDICATED | Yes (account→setup guide) | PARTIAL | Hardcoded name "Michael", FAB empty callback, checklist actions empty |
| 8 | Landlord Account Settings | account_screen.dart | DEDICATED | Yes (bottom nav→account) | COMPLETE | — |
| 9 | Landlord Account Edit | edit_preferences_screen.dart | DEDICATED | Yes (account→edit profile) | PARTIAL | Photo upload decorative, template "Change" placeholder |
| 10 | Properties List (Empty) | property_list_screen.dart | STATE (_buildEmpty) | Yes (bottom nav→properties) | COMPLETE | — |
| 11 | Properties List (Populated) | property_list_screen.dart | STATE (_buildPopulated) | Yes (bottom nav→properties) | PARTIAL | Icon placeholders instead of property images, EDIT/LEASE buttons empty |
| 12 | Property Details | property_detail_screen.dart | DEDICATED | Yes (property card→detail) | PARTIAL | Gradient not photo, tabs show same unit content, "View All" empty |
| 13 | Add Property: Basic Info | add_property_screen.dart | STATE (step 1) | Yes (properties→add) | COMPLETE | — |
| 14 | Add Property: Structure Setup | add_property_screen.dart | STATE (step 2) | Yes (step 1→next) | COMPLETE | — |
| 15 | Add Property: Review & Save | add_property_screen.dart | STATE (step 3) | Yes (step 2→review) | PARTIAL | No unit type breakdown, "Save as Draft" placeholder |
| 16 | Unit / Space List | property_detail_screen.dart | SECTION (embedded) | Yes (property detail→units) | PARTIAL | Not dedicated screen, missing filter tabs/search/per-unit actions |
| 17 | Add / Edit Unit or Space | edit_unit_screen.dart | DEDICATED | Yes (property detail→unit) | COMPLETE | — |
| 18 | Property Created Success | add_property_screen.dart | STATE (step 4) | Yes (step 3→save) | COMPLETE | — |
| 19 | Invite Tenant | invite_screen.dart (_InviteTenantScreen) | PRIVATE CLASS | Yes (invite→FAB) | PARTIAL | Missing start date picker, message preview textarea |
| 20 | Invite Sent Confirmation | invite_screen.dart (_buildSent) | STATE (inside private class) | Yes (send→success) | PARTIAL | Missing "Resend Invitation" and "Copy Direct Link" cards |
| 21 | Invite Expired/Invalid | invite_accept_screen.dart | STATE (_buildExpired) | PARTIAL* | COMPLETE | *Reachable only if InviteAcceptScreen is navigated to — no UI entry point |
| 22 | Pending Invites | invite_screen.dart | DEDICATED | Yes (dashboard→invite) | PARTIAL | Missing search bar, expiry countdown badges, "Resend" empty |
| 23 | Tenant Invite Acceptance | invite_accept_screen.dart | STATE (_buildAcceptance) | PARTIAL* | PARTIAL | *No UI entry point (deep link needed). Missing landlord avatar, rent, move-in date |
| 24 | Tenant Invite Verification | invite_accept_screen.dart | NOT SEPARATE | PARTIAL* | PARTIAL | No dedicated verification screen. Register handles invite code |
| 25 | Lease Settings Overview | property_detail_screen.dart (_LeaseSettingsScreen) | PRIVATE CLASS | Yes (property→menu) | PARTIAL | Missing clause list with Active/Optional badges |
| 26 | Lease Settings: Edit | property_detail_screen.dart (_LeaseSettingsScreen) | PRIVATE CLASS (toggle) | Yes (settings→edit) | PARTIAL | Missing auto-renewal toggle, policy preview, clause editor |
| 27 | Create Lease: Select Property | lease_list_screen.dart (_CreateLeaseWizard) | PRIVATE CLASS (step 1) | Yes (leases→FAB) | PARTIAL | Missing property images, search bar |
| 28 | Create Lease: Tenant Information | lease_list_screen.dart (_CreateLeaseWizard) | PRIVATE CLASS (step 2) | Yes (step 1→next) | PARTIAL | Plain text ID input instead of tenant search with avatars |
| 29 | Create Lease: Lease Terms | lease_list_screen.dart (_CreateLeaseWizard) | PRIVATE CLASS (step 3) | Yes (step 2→next) | PARTIAL | Missing date pickers, rent due day dropdown |
| 30 | Create Lease: Clauses & Notes | lease_list_screen.dart (_CreateLeaseWizard) | PRIVATE CLASS (step 4) | Yes (step 3→next) | COMPLETE | Clause templates, active clauses, internal notes present |
| 31 | Create Lease: Review | lease_list_screen.dart (_CreateLeaseWizard) | PRIVATE CLASS (step 5) | Yes (step 4→review) | COMPLETE | Review sections with edit links, step dots, send button |
| 32 | Leases List (Empty) | lease_list_screen.dart | STATE (_buildEmpty) | Yes (bottom nav→leases) | COMPLETE | — |
| 33 | Leases List (Populated) | lease_list_screen.dart | STATE (_buildPopulated) | Yes (bottom nav→leases) | PARTIAL | Missing property image thumbnails, tenant avatars on cards |
| 34 | Lease Details (Draft) | lease_list_screen.dart (_showDetail) | BOTTOM SHEET | Yes (lease card→tap) | PARTIAL | Bottom sheet not full screen. Missing property image, PDF/Clauses/Notes |
| 35 | Generated Lease Ready | lease_ready_screen.dart | DEDICATED | Yes (lease detail→preview) | COMPLETE | — |
| 36 | Lease Signing | lease_signing_screen.dart | DEDICATED | Yes (lease ready→sign) | COMPLETE | Signature pad, consent, API wired |
| 37 | Lease Signing Status | signing_status_screen.dart | DEDICATED | Yes (lease detail→status) | PARTIAL | "Send Reminder" and "Download/View" buttons empty |
| 38 | Lease Signed Success | lease_signing_screen.dart (_LeaseSignedSuccess) | PRIVATE CLASS | Yes (sign→success) | COMPLETE | — |
| 39 | Lease Review (tenant pre-sign) | tenant_lease_review_screen.dart | DEDICATED | Yes (tenant lease→review) | COMPLETE | — |
| 40 | View Lease (tenant) | tenant_lease_screen.dart | DEDICATED | Yes (bottom nav→lease) | PARTIAL | Missing PDF preview, "Download PDF" and "Contact" empty |
| 41 | Landlord Payments (Empty) | payment_list_screen.dart | STATE (_buildEmpty) | Yes (bottom nav→payments) | COMPLETE | — |
| 42 | Landlord Payments (Populated) | payment_list_screen.dart | STATE (_buildPopulated) | Yes (bottom nav→payments) | PARTIAL | Property-grouped instead of flat list. Missing search bar |
| 43 | Payment Ledger | payment_ledger_screen.dart | DEDICATED | Yes (payments→view ledger) | COMPLETE | — |
| 44 | Rent Payment (tenant) | tenant_payment_screen.dart | DEDICATED | Yes (bottom nav→pay) | PARTIAL | Missing payment method cards, transaction summary. External Stripe redirect |
| 45 | Rent Payment Success | payment_success_screen.dart | DEDICATED | Yes (payment→view receipt) | PARTIAL | Only reachable for already-paid. Not shown after Stripe return |
| 46 | Document Upload/Status | document_screen.dart | DEDICATED | Yes (bottom nav→docs) | COMPLETE | — |
| 47 | Pending Documents Review | pending_document_review_screen.dart | DEDICATED | Yes (account→doc reviews) | COMPLETE | — |
| 48 | Move-Out Request | move_out_screen.dart (_MoveOutForm) | PRIVATE CLASS | Yes (move-out→FAB) | COMPLETE | — |
| 49 | Pending Move-Out Requests | move_out_screen.dart | STATE (isLandlord=true) | Yes (landlord account→move-outs) | PARTIAL | Missing urgency badges |
| 50 | Tenant Dashboard (Pre-Active) | tenant_dashboard.dart | STATE (_buildPreActive) | Yes (login→home tab) | PARTIAL | "Coming soon" instead of actual countdown, quick actions empty |
| 51 | Tenant Dashboard (Active) | tenant_dashboard.dart | STATE (_buildActive) | Yes (login→home tab) | PARTIAL | Quick action buttons empty (View Lease/Upload Docs/History/Maintenance) |
| 52 | Tenant Onboarding | tenant_onboarding_screen.dart | DEDICATED | Yes (account→onboarding) | PARTIAL | Hardcoded 25% progress, "Continue" just pops, step actions empty |
| 53 | Tenant Account/Settings | account_screen.dart | STATE (role=TENANT) | Yes (bottom nav→account) | COMPLETE | — |
| 54 | Notifications | notifications_screen.dart | DEDICATED | Yes (bell icons, account) | COMPLETE | — |

---

## REAL COMPLETION COUNT

| Status | Count | Screens |
|--------|-------|---------|
| COMPLETE | 28 | #1,2,3,4,5,8,10,13,14,17,18,30,31,32,35,36,38,39,41,43,46,47,48,53,54 + #21 (ui complete, routing partial) |
| PARTIAL | 26 | #6,7,9,11,12,15,16,19,20,22,23,24,25,26,27,28,29,33,34,37,40,42,44,45,49,50,51,52 |
| MISSING | 0 | — |
| FAKE-COMPLETE | 0 | — |

---

## OVERCOUNTED IN PRIOR CLAIM

The prior "54/54 complete" was overcounted because:
1. 26 screens are PARTIAL — they exist and are reachable but have UI gaps (empty callbacks, missing wireframe elements, placeholder content)
2. #21, #23, #24 (invite flow) — InviteAcceptScreen has no UI entry point (needs deep link)
3. Multiple screens have 20+ empty `onPressed: () {}` callbacks for secondary actions

---

## ROUTING ISSUES (from Flow Guardian)

### Unreachable:
- **InviteAcceptScreen** — exists but no navigation path from any screen. Needs deep link handler

### Dead-End Callbacks (20+ total, key ones):
- Dashboard "View All" activity
- Property EDIT/LEASE card buttons
- Lease filter/search icons
- Lease clause "Edit Clause" buttons
- SigningStatus "Send Reminder" / "Download" / "View"
- Tenant quick actions (View Lease/Upload Docs/History/Maintenance)
- Tenant "Download PDF" / "Contact" on lease
- Onboarding step actions / FAB
- Various settings/gear icons

---

## BACKEND FINDINGS (from Release Readiness)

### API Alignment: 100% (44/44 frontend calls have backend endpoints)
### Stripe: Production-ready architecture, needs test keys
### External Blockers:
1. Stripe test keys (sk_test_ + whsec_) — BLOCKS payment testing
2. Authgear credentials — BLOCKS social auth (MVP can work without)
3. OpenSign credentials — BLOCKS e-signing integration (MVP uses internal signing)

### iOS Issues:
- Missing camera/photo library permission declarations in Info.plist
- Will cause runtime crash if user tries to upload photos

### Build Issues:
- `go_router` in pubspec.yaml but never used (dependency bloat)
- No backend-specific .gitignore (covered by root .gitignore)

---

## ACTION PLAN

### Tier 1: Must Fix (breaks functionality)
1. Add iOS permissions to Info.plist (NSCameraUsageDescription, NSPhotoLibraryUsageDescription)
2. Wire InviteAcceptScreen reachability (either from register flow or as a route)

### Tier 2: Should Fix (empty callbacks users will tap)
3. Wire tenant dashboard quick actions (View Lease → tab 1, Upload Docs → tab 3, History → tab 2)
4. Wire property card EDIT button to property detail edit mode
5. Wire onboarding step actions to relevant screens
6. Wire "Download PDF" on tenant lease to a placeholder/toast
7. Wire signing status "Send Reminder" to a toast/confirmation

### Tier 3: Polish (nice-to-have for fidelity)
8. Dynamic onboarding progress (query actual completion state)
9. Tenant dashboard actual countdown calculation
10. Property images (requires image upload API)
11. Lease tenant search with avatars (requires user search API)
12. Remove unused `go_router` from pubspec.yaml
