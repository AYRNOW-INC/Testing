# AYRNOW Rebuild Plan

Rebuild order strictly from wireframes. Vertical slices prioritized. Files marked reuse vs replace.

---

## Guiding Principles
1. Wireframes are the sole UI truth
2. Full-screen routes, not bottom sheets (unless wireframe explicitly shows one)
3. Multi-step wizards where wireframes show step indicators
4. Rich cards with images, avatars, badges — not plain ListTiles
5. Empty, loading, populated, error states per wireframe
6. Backend is solid — no backend changes needed unless new endpoints required
7. Reuse API service layer and auth provider (they work correctly)

---

## Phase 1: Auth & Onboarding
**Wireframes:** A1, A2, A3, A4, B3, K3
**Priority:** Highest — entry point for all users

### Files to CREATE (new):
- `lib/screens/auth/splash_welcome_screen.dart` — A1
- `lib/screens/auth/forgot_password_screen.dart` — A4
- `lib/screens/auth/register_screen.dart` — A3 (full-screen multi-step)
- `lib/screens/landlord/onboarding_screen.dart` — B3
- `lib/screens/tenant/onboarding_screen.dart` — K3

### Files to REPLACE (rewrite):
- `lib/screens/auth/login_screen.dart` — rebuild per A2 (social auth, forgot password link, field layout)
- `lib/main.dart` — update routing to include splash, register as routes (not sheets)

### Files to REUSE (keep):
- `lib/services/api_service.dart` — works correctly
- `lib/providers/auth_provider.dart` — works correctly, may need minor additions

### Backend changes:
- None (auth endpoints already work)

---

## Phase 2: Landlord Dashboard & Account
**Wireframes:** B1, B2, B4, B5
**Priority:** High — landlord home experience

### Files to REPLACE:
- `lib/screens/landlord/landlord_dashboard.dart` — rebuild with Quick Actions, Activity feed, empty/populated states per B1/B2
- `lib/screens/landlord/account_screen.dart` — rebuild as structured settings per B4 (landlord-specific)

### Files to CREATE:
- `lib/screens/landlord/edit_preferences_screen.dart` — B5
- `lib/screens/tenant/account_settings_screen.dart` — K4 (tenant-specific account)

### Files to REUSE:
- None from current (all need rebuild)

### Backend changes:
- May need `/api/dashboard/landlord` to return recent activity items
- May need profile update endpoint refinement

---

## Phase 3: Property Management
**Wireframes:** C1-C9
**Priority:** High — core landlord workflow

### Files to REPLACE:
- `lib/screens/landlord/property_list_screen.dart` — full rebuild with search, filters, images, occupancy per C1/C2

### Files to CREATE:
- `lib/screens/landlord/property_detail_screen.dart` — C3 (currently embedded, needs own file with tabs)
- `lib/screens/landlord/add_property_screen.dart` — C4/C5/C6 (3-step wizard)
- `lib/screens/landlord/property_created_screen.dart` — C9
- `lib/screens/landlord/unit_management_screen.dart` — C7
- `lib/screens/landlord/edit_unit_screen.dart` — C8

### Files to REUSE:
- Backend property/unit APIs work correctly

### Backend changes:
- May need property image upload endpoint
- Unit endpoint may need utility fields added

---

## Phase 4: Invite Flow
**Wireframes:** D1-D6
**Priority:** High — tenant onboarding entry

### Files to REPLACE:
- `lib/screens/shared/invite_screen.dart` — rebuild as full InviteTenantScreen per D1

### Files to CREATE:
- `lib/screens/shared/invite_sent_screen.dart` — D2
- `lib/screens/shared/invite_expired_screen.dart` — D3
- `lib/screens/landlord/pending_invites_screen.dart` — D4
- `lib/screens/tenant/invite_accept_screen.dart` — D5
- `lib/screens/tenant/invite_verify_screen.dart` — D6

### Backend changes:
- Invitation endpoint may need tenant name field
- May need invitation detail endpoint for acceptance flow

---

## Phase 5: Lease Management
**Wireframes:** E1-E10
**Priority:** High — core business flow

### Files to REPLACE:
- `lib/screens/landlord/lease_list_screen.dart` — rebuild with search, filters, images per E8/E9

### Files to CREATE:
- `lib/screens/landlord/lease_settings_screen.dart` — E1 (full screen, not sheet)
- `lib/screens/landlord/lease_settings_edit_screen.dart` — E2
- `lib/screens/landlord/create_lease_screen.dart` — E3-E7 (5-step wizard)
- `lib/screens/landlord/lease_detail_screen.dart` — E10

### Backend changes:
- May need clauses/templates endpoints
- Lease creation endpoint may need clause data support

---

## Phase 6: Signing Flow
**Wireframes:** F1-F5
**Priority:** High — lease execution

### Files to CREATE:
- `lib/screens/shared/lease_ready_screen.dart` — F1
- `lib/screens/shared/lease_signing_screen.dart` — F2 (with signature pad widget)
- `lib/screens/shared/signing_status_screen.dart` — F3
- `lib/screens/shared/lease_signed_screen.dart` — F4
- `lib/screens/tenant/lease_review_screen.dart` — F5

### Dependencies:
- May need a signature pad Flutter package (e.g., `signature`)
- PDF viewer package for lease preview

---

## Phase 7: Tenant Screens
**Wireframes:** K1, K2, G1, K4
**Priority:** High — tenant experience

### Files to REPLACE:
- `lib/screens/tenant/tenant_dashboard.dart` — rebuild with pre-active/active states per K1/K2
- `lib/screens/tenant/tenant_lease_screen.dart` — rebuild per G1 with PDF preview, detail cards

### Files to CREATE:
- `lib/screens/tenant/account_settings_screen.dart` — K4 (if not created in Phase 2)

### Dependencies:
- PDF viewer package for lease document preview

---

## Phase 8: Payments
**Wireframes:** H1-H5
**Priority:** Medium-High — revenue flow

### Files to REPLACE:
- `lib/screens/landlord/payment_list_screen.dart` — rebuild with stats, search, filters per H1/H2
- `lib/screens/tenant/tenant_payment_screen.dart` — rebuild with method selection, summary per H4

### Files to CREATE:
- `lib/screens/landlord/payment_ledger_screen.dart` — H3
- `lib/screens/tenant/payment_success_screen.dart` — H5

### Backend changes:
- May need payment method storage endpoints
- May need ledger/statement endpoints

---

## Phase 9: Documents
**Wireframes:** I1, I2
**Priority:** Medium

### Files to REPLACE:
- `lib/screens/tenant/document_screen.dart` — rebuild with progress, inline uploads per I1

### Files to CREATE:
- `lib/screens/landlord/pending_document_review_screen.dart` — I2

---

## Phase 10: Move-Out & Notifications
**Wireframes:** J1, J2, L1
**Priority:** Medium

### Files to REPLACE:
- `lib/screens/shared/move_out_screen.dart` — rebuild as full screen per J1

### Files to CREATE:
- `lib/screens/landlord/pending_moveouts_screen.dart` — J2
- `lib/screens/shared/notifications_screen.dart` — L1

---

## Phase 11: App Shell & Navigation
**Priority:** Runs throughout — update as screens are built

### Files to REPLACE:
- `lib/main.dart` — rebuild with proper routing for all new screens, updated bottom nav, splash welcome as entry

### New dependencies to add to pubspec.yaml:
- `signature` or `syncfusion_flutter_signaturepad` — for lease signing
- `flutter_pdfview` or `syncfusion_flutter_pdfviewer` — for lease document preview
- `cached_network_image` — for property images
- `shimmer` — for loading states
- `percent_indicator` — for progress bars/circles

---

## File Count Summary

| Action | Count |
|--------|-------|
| Files to CREATE (new) | ~28 |
| Files to REPLACE (rewrite) | ~10 |
| Files to REUSE (keep as-is) | 2 (api_service.dart, auth_provider.dart) |
| Backend files needing changes | 0-3 minor additions |

---

## Execution Order (Vertical Slices)

1. **Slice 1:** Splash → Login → Register → Forgot Password (user can enter app)
2. **Slice 2:** Landlord Dashboard (empty + populated) + Bottom Nav shell
3. **Slice 3:** Property List + Add Property wizard + Property Detail + Units
4. **Slice 4:** Invite Tenant + Pending Invites + Invite Acceptance
5. **Slice 5:** Lease Settings + Create Lease wizard + Lease List + Lease Detail
6. **Slice 6:** Signing flow (Ready → Sign → Status → Success)
7. **Slice 7:** Tenant Dashboard + View Lease + Onboarding
8. **Slice 8:** Payments (landlord + tenant) + Ledger + Success
9. **Slice 9:** Documents (tenant upload + landlord review)
10. **Slice 10:** Move-Out + Notifications + Account screens
