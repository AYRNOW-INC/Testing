# AYRNOW MVP — End-to-End Flow Audit & UI Polish Report

**Date:** 2026-03-18
**Auditor:** Claude (Full codebase review — frontend, backend, routing, API contracts)
**Scope:** Complete E2E flow from property creation through lease signing to tenant payment
**Files reviewed:** 39 Dart screens, 8 Java controllers, 2 Java services, routing/config files

---

## EXECUTIVE SUMMARY

The AYRNOW MVP has **50/57 PO Agent tasks completed** with a solid backend and clean UI design language. However, the **frontend has 6 critical flow breaks** that prevent a continuous end-to-end journey. The backend is properly wired (registration auto-accepts invites, lease creation validates accepted invitations, signing triggers payment creation), but the frontend fails to pass context between screens at key handoff points.

**Verdict:** Backend = production-ready. Frontend = needs 6 targeted fixes before E2E demo is possible.

---

## SECTION 1: CRITICAL FLOW BLOCKERS (Must Fix)

### BLOCKER 1: Invite Accept → Register — Context Lost
**Severity:** CRITICAL
**File:** `frontend/lib/screens/tenant/invite_accept_screen.dart` line 339-340
**Problem:** When tenant taps "Accept Invite & Continue", the screen navigates to `RegisterScreen()` with NO parameters. The invite code, tenant email, and password the user just entered are all discarded.
**Backend reality:** The backend's `/auth/register` endpoint accepts an `inviteCode` field and auto-accepts the invitation during registration. The RegisterScreen already has `_inviteCodeC` field (line 21). But the handoff never passes the data.
**Fix:** Pass `inviteCode`, `email`, and `password` to RegisterScreen. Add constructor params to RegisterScreen and pre-fill fields. Auto-select TENANT role and skip role selection step when inviteCode is present.

### BLOCKER 2: Lease Settings → Lease Creation — No Connection
**Severity:** CRITICAL
**File:** `frontend/lib/screens/landlord/property_detail_screen.dart`
**Problem:** Lease Settings is accessible via property menu (inline modal), but has no "Create Lease" button. User must close Lease Settings, navigate separately to LeaseListScreen, then re-select the same property in a 5-step wizard. No property context is carried over.
**Fix:** Add a "Create Lease for This Property" CTA at the bottom of Lease Settings. Pass `propertyId` to LeaseListScreen so Step 1 of the wizard is pre-filled.

### BLOCKER 3: Property Detail → Lease List — No Property Context
**Severity:** HIGH
**File:** `frontend/lib/screens/landlord/property_detail_screen.dart` → `lease_list_screen.dart`
**Problem:** When navigating from a property's Lease tab to LeaseListScreen, no propertyId is passed. The Create Lease wizard forces re-selection of property.
**Fix:** Accept optional `propertyId` in LeaseListScreen. If provided, pre-select in wizard Step 1 and auto-load that property's units and accepted tenants.

### BLOCKER 4: Document Screen — Count Mismatch (4 vs 3)
**Severity:** HIGH
**File:** `frontend/lib/screens/tenant/document_screen.dart` line 35
**Problem:** `_total` is hardcoded to `4` with comment "Required: ID, Income, Insurance, Background" but only 3 document types exist in the app (ID, PROOF_OF_INCOME, BACKGROUND_CHECK). Progress bar shows "X of 4 Verified" but max achievable is 3.
**Fix:** Change `_total` to `3`, or add the 4th document type (INSURANCE) to match. Update comment.

### BLOCKER 5: Lease Settings Disconnect from Lease Prefill
**Severity:** HIGH
**File:** `lease_list_screen.dart` `_CreateLeaseWizard`
**Problem:** When creating a lease, the wizard doesn't pull defaults from the property's Lease Settings (rent amount, term, deposit, grace period). User must manually re-enter values they already configured.
**Fix:** When a property is selected in wizard Step 1, fetch its lease settings via `GET /api/properties/{id}/lease-settings` and pre-fill Step 3 (Lease Terms) with those defaults.

### BLOCKER 6: Tenant Payment Checklist — Unreachable Before Lease
**Severity:** MEDIUM
**File:** `frontend/lib/screens/tenant/tenant_onboarding_screen.dart` line 131
**Problem:** "Make First Payment" step has `null` action handler. Tenant sees it as incomplete but cannot click it. Also, payment is impossible before lease is signed (no payment record exists yet), so the step should show "Complete after lease signing" instead of appearing clickable.
**Fix:** Add conditional text: "Available after lease signing" when lease not fully executed. Wire navigation to TenantPaymentScreen when payments exist.

---

## SECTION 2: UI POLISH ISSUES (Should Fix)

### 2.1 Color Inconsistencies
| Location | Issue | Fix |
|----------|-------|-----|
| `landlord_dashboard.dart` line 256 | "Create Lease" quick action uses hardcoded `Color(0xFF7C3AED)` (purple) while other buttons use `AppColors.primary/success` | Use `AppColors.primary` or create a semantic constant |
| Status badges across screens | Capitalization varies: "Pending" vs "PENDING" vs "pending" | Standardize to Title Case or ALL CAPS consistently |
| `signing_status_screen.dart` line 36 | Progress calculation wrong when only tenant signed — shows step 3 but should differentiate TENANT_SIGNED vs LANDLORD_SIGNED correctly | Fix switch mapping |

### 2.2 Hardcoded Values Still Present
| File | Line | Value | Should Be |
|------|------|-------|-----------|
| `invite_accept_screen.dart` | 97 | "48 hours" expiry text | Backend uses 7 days. Text is wrong. |
| `tenant_dashboard.dart` | 225 | "Standard Monthly Rent + Utilities" | Should reflect actual lease terms from API |
| `add_property_screen.dart` | 142 | Both "Industrial" and "Other" map to `OTHER` | Remove duplicate or clarify distinction |
| `payment_success_screen.dart` | 47 | `#ARN-${payment['id']}` transaction ID | Verify this matches backend's actual reference format |

### 2.3 Spacing & Layout Inconsistencies
| Pattern | Locations | Issue |
|---------|-----------|-------|
| Card content padding | PropertyList: 16px, LeaseList: 14px | Should use consistent padding constant |
| SizedBox heights | PropertyDetail mixes 12/16/20/24 | Define spacing scale constants |
| Section headers | Some use icon+title widget, others plain text | Standardize _Section pattern across all screens |

### 2.4 Missing "Unsaved Changes" Warning
No screen warns the user when they tap Back with unsaved edits. Affects:
- AddPropertyScreen (3-step wizard)
- EditUnitScreen
- UnitInviteWizardScreen
- _CreateLeaseWizard (5-step)
**Fix:** Add `WillPopScope` (or `PopScope` in newer Flutter) with confirmation dialog.

---

## SECTION 3: NAVIGATION & DEAD-END ISSUES

### 3.1 Dead-End Buttons
| Screen | Element | Status | Fix |
|--------|---------|--------|-----|
| `tenant_lease_screen.dart` | "Download PDF" button | Disabled (says "Available after signing integration") | Acceptable for MVP (OpenSign blocked) |
| `signing_status_screen.dart` | "Download" / "View" buttons | Disabled with tooltip | Acceptable for MVP |
| `lease_ready_screen.dart` | "Preview Full PDF" | Shows helper text | Acceptable for MVP |
| `property_detail_screen.dart` | Lease tab empty state | Shows text "No leases" but no CTA button | Add "Create Lease" CTA |
| `tenant_onboarding_screen.dart` | "Make First Payment" | No action handler | Wire to TenantPaymentScreen |

### 3.2 Navigation Flow Gaps
| From | To | Gap |
|------|----|-----|
| AddPropertyScreen success | "Invite Your First Tenant" | Pops entire stack with `popUntil(isFirst)` — goes to Dashboard, not to invite screen for the new property |
| LeaseSettings modal | Lease creation | No connection; user must navigate separately |
| UnitInviteWizardScreen complete | Next step | Just pops; no success screen or guidance to "create lease next" |
| LeaseSigningScreen success (tenant) | "Setup Rent Payments" | Navigates to TenantPaymentScreen — but payment may not exist yet if webhook hasn't fired |

### 3.3 Deep Link Support — Missing
The app uses only `Navigator.push()` with no named routes or deep link handling. This means:
- Tenant invite emails cannot deep-link into the app
- Push notifications cannot navigate to specific screens
- "Share" functionality cannot link to specific properties/leases
**Recommendation:** Migrate to `go_router` for named routes and deep link support. This is already noted as a backlog item.

---

## SECTION 4: BACKEND GAPS & MISSING FEATURES

### 4.1 Missing Endpoints
| Endpoint | Purpose | Priority |
|----------|---------|----------|
| Bulk unit creation | Create N units at property setup (CLAUDE.md requirement) | MEDIUM |
| `GET /api/properties/{id}/tenants` | List current occupants for a property | LOW (workaround: use accepted invitations) |
| `POST /api/auth/change-password` | Authenticated password change | MEDIUM |
| Lease PDF download | Tenant/landlord download signed lease PDF | HIGH (blocked on OpenSign) |

### 4.2 Security Gap
| Issue | File | Severity |
|-------|------|----------|
| OpenSign webhook has NO signature verification | `WebhookController.java` | HIGH — allows spoofed webhooks |
| Stripe webhook has proper signature verification | Same file | Good |
**Fix:** Add HMAC signature verification for OpenSign webhooks.

### 4.3 Missing Automation
| Feature | Impact |
|---------|--------|
| Monthly payment auto-creation | Currently only first payment auto-created on lease signing. No recurring job. |
| Move-out finalization | Approving move-out doesn't reset unit to AVAILABLE or terminate lease |
| Invite expiry background job | Expired invites only detected on access, not proactively |

---

## SECTION 5: COMPLETE E2E FLOW MAP

### Happy Path: Property → Tenant → Lease → Sign → Pay

```
LANDLORD FLOW:
1. Register (LANDLORD role) → Dashboard
2. "Add Property" → 3-step wizard → Property created with N units
3. Property Detail → Units tab → Click unit "Invite" button
4. UnitInviteWizardScreen → Complete unit details → Set rent → Send invite
5. [Wait for tenant to accept and register]
6. Lease List → Create Lease wizard:
   Step 1: Select property + unit
   Step 2: Select tenant (from accepted invitations dropdown)
   Step 3: Lease terms (rent, deposit, term, dates)
   Step 4: Clauses & notes
   Step 5: Review → "Create Lease" (status: DRAFT)
7. Lease Detail → "Send to Sign" → status: SENT_FOR_SIGNING
8. [Sign lease when ready]
9. Dashboard shows stats; payment auto-created

TENANT FLOW:
1. Receive invite email with code
2. Open InviteAcceptScreen → See property/unit details
3. "Accept & Create Account" → Set password
4. RegisterScreen → Personal info → Role auto-TENANT → inviteCode auto-filled
   [CURRENTLY BROKEN: inviteCode not passed]
5. Backend: registration auto-accepts invite, unit marked OCCUPIED
6. TenantDashboard (pre-active) → Onboarding checklist
7. "View Lease" → TenantLeaseScreen → "Review & Sign"
8. TenantLeaseReviewScreen → Check 3 boxes → "Go to Signing"
9. LeaseSigningScreen → Draw signature + consent checkboxes → Sign
10. Backend: both signed → FULLY_EXECUTED → first payment created
11. TenantDashboard (active) → "Pay Now" → Stripe checkout
12. Backend: Stripe webhook → payment SUCCESSFUL
13. Upload documents (ID, income proof, background check)
```

### Current Breaks in Happy Path:
- **Step 4:** inviteCode/email/password NOT passed to RegisterScreen
- **Step 6 (landlord):** Property context not carried to lease wizard
- **Step 6 (landlord):** Lease settings not pre-filled in wizard Step 3
- **Step 13:** Document count shows "X of 4" but only 3 types exist

---

## SECTION 6: PRIORITIZED FIX LIST

### Priority 1 — Must Fix for E2E Demo (estimate: 2-3 hours)
1. **Fix InviteAcceptScreen → RegisterScreen handoff** — Pass inviteCode, email, password; auto-select TENANT role
2. **Fix document count** — Change `_total` from 4 to 3
3. **Wire property context to lease creation** — Pass propertyId through navigation

### Priority 2 — Should Fix for Beta (estimate: 4-6 hours)
4. **Pre-fill lease wizard from lease settings** — Fetch and apply property defaults
5. **Add Lease Settings → Create Lease CTA** — Button at bottom of settings modal
6. **Fix invite expiry text** — Change "48 hours" to match backend's 7-day expiry
7. **Fix tenant onboarding payment step** — Show status text and wire action
8. **Add empty-state CTAs** — Property detail lease tab, tenant payment checklist

### Priority 3 — Polish for Launch (estimate: 3-4 hours)
9. **Standardize status badge casing** — Title Case everywhere
10. **Normalize spacing constants** — Create `AppSpacing` class
11. **Add "unsaved changes" dialogs** — All wizard/form screens
12. **Fix signing status progress calculation** — Correct TENANT_SIGNED vs LANDLORD_SIGNED

### Priority 4 — Infrastructure (estimate: variable)
13. **Add OpenSign webhook signature verification** — Security critical
14. **Implement monthly payment auto-creation** — Backend scheduled job
15. **Migrate to go_router** — Deep link support for invite emails

---

## SECTION 7: WHAT WORKS WELL

To be fair, here's what's solid and production-ready:

- **Authentication flow** — Login, register, token refresh, 401 handling, password reset all work
- **Property CRUD** — Full create/edit/delete with cascade protection
- **Unit management** — Smart invite wizard with completeness checks
- **Lease creation backend** — Validates ownership, accepted invitation, no duplicates
- **Stripe integration** — Checkout + 6 webhook event handlers + idempotency
- **S3 storage abstraction** — Local dev / S3 prod switch with pre-signed URLs
- **Security** — @PreAuthorize on all endpoints, ownership checks, CORS hardened
- **Error handling** — Loading/error/empty states on most screens with retry buttons
- **Double-submit protection** — _isSubmitting guards on all 6 critical forms
- **Observability** — Structured logging, audit trails, error logger
- **75 backend tests + 67 frontend tests** — Reasonable coverage for MVP
- **UI design** — Clean, professional, consistent design language
- **Documentation** — 18+ docs including setup, API, security, deployment guides
