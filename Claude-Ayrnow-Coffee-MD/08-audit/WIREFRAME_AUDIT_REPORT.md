# AYRNOW MVP -- Wireframe vs Build Audit Report

_Generated: 2026-03-22 | Audited by: Mr Coffee PO Agent Team (8 parallel auditors)_
_Wireframes: 54 screens | Built Screens: 35 dart files_

---

## Executive Summary

| Category | Total Wireframes | BUILT | PARTIAL | MISSING |
|----------|:---:|:---:|:---:|:---:|
| Auth & Onboarding | 4 | 4 | 0 | 0 |
| Landlord Dashboard & Account | 5 | 1 | 4 | 0 |
| Property Management | 9 | 5 | 3 | 1 |
| Tenant Screens | 4 | 1 | 3 | 0 |
| Invite Flow | 6 | 4 | 2 | 0 |
| Lease Management | 11 | 1 | 8 | 2 |
| Signing Flow | 5 | 5 | 0 | 0 |
| Payments | 5 | 2 | 3 | 0 |
| Documents | 2 | 0 | 2 | 0 |
| Move-Out | 2 | 1 | 1 | 0 |
| Notifications | 1 | 1 | 0 | 0 |
| **TOTAL** | **54** | **25** | **26** | **3** |

**Overall: 46% Fully Built | 48% Partially Built | 6% Missing**

---

## Critical Gaps (Blockers for MVP)

| # | Gap | Impact | Wireframe(s) |
|---|-----|--------|-------------|
| 1 | **Lease Settings screens entirely missing** | Landlords cannot configure global lease defaults (rent due day, deposit, late fee, grace period, clauses) | Lease Settings Overview, Lease Settings: Edit |
| 2 | **Property Created Success screen missing** | No confirmation after property creation | Property Created Success |
| 3 | **Payment method management missing** | Tenants cannot select/add payment methods -- Stripe hosted checkout used instead | Rent Payment |
| 4 | **Landlord Stripe onboarding missing** | No "Connect Payment Provider" flow for first-time landlords | Landlord Payments (Empty) |
| 5 | **Embedded PDF preview missing** | No in-app lease document viewing | View Lease, Lease Review |
| 6 | **Date pickers missing in lease creation** | Start/end dates auto-calculated from term months only | Create Lease: Lease Terms |

---

## Screen-by-Screen Audit

### 1. AUTH & ONBOARDING (4 wireframes)

| # | Wireframe | Built File | Status | Missing Functionality |
|---|-----------|-----------|--------|----------------------|
| 1.1 | Splash / Welcome | `screens/auth/splash_welcome_screen.dart` | BUILT | Subtitle copy differs ("all in one" vs "most trusted"); footer text differs ("SMART RENT COLLECTION" vs "TRUSTED BY 10,000+"); extra background gradient blobs not in wireframe |
| 1.2 | Login | `screens/auth/login_screen.dart` | BUILT | Google/Apple button labels say "Continue with..." vs just icon+name; Google icon uses Material `g_mobiledata` not branded G logo; extra "Have an invite code?" link not in wireframe |
| 1.3 | Register / Account Type | `screens/auth/register_screen.dart` | BUILT | Step count "2 of 2" vs wireframe "2 of 4" (wireframe implies 4-step registration); tenant tag says "Document Uploads" vs wireframe "Maintenance Requests"; selection indicator uses text badge vs wireframe radio circle |
| 1.4 | Forgot Password | `screens/auth/forgot_password_screen.dart` | BUILT | Field label says "Email Address" vs wireframe "Email or Phone Number" -- phone reset not supported; extra `reset_password_screen.dart` built (no wireframe for it) |

### 2. LANDLORD DASHBOARD & ACCOUNT (5 wireframes)

| # | Wireframe | Built File | Status | Missing Functionality |
|---|-----------|-----------|--------|----------------------|
| 2.1 | Landlord Dashboard (Empty) | `screens/landlord/landlord_dashboard.dart` | BUILT | Minor: AppBar shows "Dashboard" title + add/bell icons not in wireframe; wireframe shows only logo |
| 2.2 | Landlord Dashboard (Populated) | `screens/landlord/landlord_dashboard.dart` | PARTIAL | **No "% vs last mo." trend badges on stat cards**; activity feed is hardcoded/static (2 generic items vs 3 real items with names/timestamps); "Automate Rent Reminders" promo banner missing; user avatar missing |
| 2.3 | Landlord Account Setup | `screens/landlord/onboarding_screen.dart` | PARTIAL | Greeting says "Welcome to AYRNOW!" vs personalized "Welcome, Michael!"; user avatar missing; "Need help?" section + "Watch Video Guide" button missing; step count 4 vs wireframe 3 |
| 2.4 | Landlord Account Settings | `screens/landlord/account_screen.dart` | PARTIAL | **BUSINESS & FINANCE section entirely missing** (Payment Provider/Stripe status, Tax Info, Subscription Plan); Security settings missing; Help Center missing; uses initials avatar not photo |
| 2.5 | Landlord Account Edit | `screens/landlord/edit_preferences_screen.dart` | PARTIAL | No profile photo upload; no "PREMIUM LANDLORD" badge; lease template not interactive (no "Change" button); "Payment Provider Settings" row missing |

### 3. PROPERTY MANAGEMENT (9 wireframes)

| # | Wireframe | Built File | Status | Missing Functionality |
|---|-----------|-----------|--------|----------------------|
| 3.1 | Properties List (Empty) | `screens/landlord/property_list_screen.dart` | BUILT | "HOW IT WORKS" label missing; numbered step circles (1,2,3) missing; "Learn how AYRNOW protects your data" privacy link missing |
| 3.2 | Properties List (Populated) | `screens/landlord/property_list_screen.dart` | BUILT | No real property photos (placeholder icons); wireframe has "+" in AppBar, build uses FAB; filter funnel icon missing |
| 3.3 | Add Property: Basic Info | `screens/landlord/add_property_screen.dart` | BUILT | "Select one" hint next to Property Type missing; Industrial and Other both map to 'OTHER' (potential bug) |
| 3.4 | Add Property: Structure Setup | `screens/landlord/add_property_screen.dart` | BUILT | AppBar title "Setup Structure" not matching; info/help icon missing; "Multi-Family Residential" subtype label missing; PRO TIP callout box missing |
| 3.5 | Add Property: Review & Save | `screens/landlord/add_property_screen.dart` | PARTIAL | Tax Identifier/APN field missing; unit bedroom breakdown chips missing; "Edit Layout" link missing; "Save as Draft" link missing; "Final Confirmation" section missing |
| 3.6 | Property Details | `screens/landlord/property_detail_screen.dart` | BUILT | No real property photo; edit/camera icons missing on hero; "UNIT INVENTORY" header missing; tenant names not shown in unit rows; unit filter chips non-functional (hardcoded); "Edit Property" menu handler not implemented |
| 3.7 | Property Created Success | `screens/landlord/add_property_screen.dart` | PARTIAL | "PROPERTY SUMMARY" label missing; building icon next to name missing; helper text paragraph missing; "View Property" navigates to list not detail |
| 3.8 | Unit / Space List | `screens/landlord/property_detail_screen.dart` (tab) | PARTIAL | **Not a standalone screen** -- embedded as tab in Property Detail; no search, no AppBar, no FAB; "Maintenance" filter missing; unit cards are compact rows not rich cards; per-unit EDIT/INVITE/LEASE buttons missing; tenant names/avatars missing; occupancy rate summary bar missing |
| 3.9 | Add / Edit Unit or Space | `screens/landlord/edit_unit_screen.dart` | BUILT | Settings/gear icon in AppBar missing; extra Unit Type dropdown added (good addition not in wireframe) |

### 4. TENANT SCREENS (4 wireframes)

| # | Wireframe | Built File | Status | Missing Functionality |
|---|-----------|-----------|--------|----------------------|
| 4.1 | Tenant Dashboard (Pre-Active) | `screens/tenant/tenant_dashboard.dart` | PARTIAL | "Keys available starting [date]" line missing; full street address missing; checklist items differ (wireframe: Verify ID, Sign Lease, Auto-Pay, Utilities vs build: Profile, Docs, Lease, Payment); no subtitles on checklist items; no status badges on quick cards |
| 4.2 | Tenant Dashboard (Active) | `screens/tenant/tenant_dashboard.dart` | PARTIAL | Profile photo avatar missing; "Maintenance" quick action replaced with "Move Out"; **"Required Documents" section missing** (expiring docs warnings); recent activity is generic placeholders not real data with transaction IDs/amounts |
| 4.3 | Tenant Onboarding | `screens/tenant/tenant_onboarding_screen.dart` | BUILT | Step order differs: wireframe has "Add Payment Method" as step 3, build has "Make First Payment" as step 4; "documents verified" note text missing |
| 4.4 | Tenant Account/Settings | `screens/landlord/account_screen.dart` (shared) | PARTIAL | **FINANCIALS section missing** (Payment Methods with "Visa ending in 4242"); "Gold Tenant" badge missing; Security & Privacy row missing; Help Center missing; Contact Support missing; push notification inline toggle missing (navigates to separate screen) |

### 5. INVITE FLOW (6 wireframes)

| # | Wireframe | Built File | Status | Missing Functionality |
|---|-----------|-----------|--------|----------------------|
| 5.1 | Invite Tenant | `screens/shared/invite_screen.dart` | PARTIAL | "Customizable" toggle missing; message preview box based on tone missing; date picker broken (setState empty); detailed expiry preview missing |
| 5.2 | Invite Sent Confirmation | `screens/shared/invite_screen.dart` | BUILT | Subtitle truncated; tenant photo missing; minor branding gap |
| 5.3 | Pending Invites | `screens/shared/invite_screen.dart` | BUILT | **Search bar missing**; search/filter icons missing; "Sent on [date]" not shown; "X days left" countdown per card missing; sort non-functional |
| 5.4 | Tenant Invite Acceptance | `screens/tenant/invite_accept_screen.dart` | BUILT | Landlord name/avatar missing; monthly rent display missing; move-in date missing; property photo placeholder |
| 5.5 | Tenant Invite Verification | `screens/tenant/invite_accept_screen.dart` | BUILT | Property photo placeholder; full address missing; landlord name/avatar missing; move-in date missing; password not forwarded to registration |
| 5.6 | Invite Expired/Invalid | `screens/tenant/invite_accept_screen.dart` | BUILT | Landlord "Managed by" info missing; support footer text missing; "Request New Invitation" only shows dialog |

### 6. LEASE MANAGEMENT (11 wireframes)

| # | Wireframe | Built File | Status | Missing Functionality |
|---|-----------|-----------|--------|----------------------|
| 6.1 | Lease Settings Overview | **MISSING** | MISSING | **Entire screen absent**: no global lease defaults view (rent due day, deposit, late fee, grace period, occupancy limit, standard clauses) |
| 6.2 | Lease Settings: Edit | **MISSING** | MISSING | **Entire screen absent**: no lease defaults editing (term, auto-renewal, rent, deposit, due day, grace period, late fee, clauses, admin notes) |
| 6.3 | Create Lease: Select Property | `screens/landlord/lease_list_screen.dart` | PARTIAL | No search bar; no property photos; no filter icon; no address on cards |
| 6.4 | Create Lease: Tenant Info | `screens/landlord/lease_list_screen.dart` | PARTIAL | Uses dropdown vs wireframe card-based selection with avatars; no search bar; no "Invite a New Tenant" section |
| 6.5 | Create Lease: Lease Terms | `screens/landlord/lease_list_screen.dart` | PARTIAL | **No start/end date pickers**; no rent due day dropdown; no pro-rated rent info; no "MONTHLY"/"ONE-TIME" badges; no "Save as Draft" |
| 6.6 | Create Lease: Clauses & Notes | `screens/landlord/lease_list_screen.dart` | PARTIAL | No real clause content (shows "Standard clause text..."); no "Edit Clause" links; no "View All" for templates; no "Required" badge |
| 6.7 | Create Lease: Review | `screens/landlord/lease_list_screen.dart` | PARTIAL | No per-section "Edit" links; no PDF Preview button; no "Save Draft" link; no version/date on badge; no payment day or start date fields |
| 6.8 | Lease Details (Draft) | `screens/landlord/lease_list_screen.dart` | PARTIAL | No property image; no "move-in in X days" countdown; no Review & Files section (PDF preview, clauses, download); no landlord notes yellow section |
| 6.9 | Leases List (Empty) | `screens/landlord/lease_list_screen.dart` | BUILT | "Need help? View our Leasing Guide" link missing |
| 6.10 | Leases List (Populated) | `screens/landlord/lease_list_screen.dart` | PARTIAL | No search bar; no property photos; no tenant avatars; no address lines; no pagination text |
| 6.11 | View Lease (Tenant) | `screens/tenant/tenant_lease_screen.dart` | PARTIAL | **No embedded PDF preview/viewer**; Download PDF disabled/non-functional; no page navigation controls |

### 7. SIGNING FLOW (5 wireframes)

| # | Wireframe | Built File | Status | Missing Functionality |
|---|-----------|-----------|--------|----------------------|
| 7.1 | Generated Lease Ready | `screens/shared/lease_ready_screen.dart` | BUILT | Agreement number subtitle missing; file size missing; signer emails missing; "Edit" button missing (only Send to Sign) |
| 7.2 | Lease Review | `screens/tenant/tenant_lease_review_screen.dart` | BUILT | PDF preview is placeholder icon not blurred document; page pagination missing; "Start" link on house rules checkbox missing |
| 7.3 | Lease Signing | `screens/shared/lease_signing_screen.dart` | BUILT | Signer's actual name missing (shows "Your Signature"); signer email missing; "Primary Tenant" role badge missing; consent text not hyperlinked |
| 7.4 | Lease Signing Status | `screens/shared/signing_status_screen.dart` | BUILT | Timestamps on timeline steps missing; lease number missing; property photo missing; "View Metadata" + "Update Lease" buttons missing |
| 7.5 | Lease Signed Success | `screens/shared/lease_signing_screen.dart` | BUILT | File size missing; download icon missing; onboarding step descriptions missing; footer text missing |

### 8. PAYMENTS (5 wireframes)

| # | Wireframe | Built File | Status | Missing Functionality |
|---|-----------|-----------|--------|----------------------|
| 8.1 | Rent Payment | `screens/tenant/tenant_payment_screen.dart` | PARTIAL | **Payment method selection UI entirely missing** (no Visa/bank cards, no radio buttons, no "Add New Method"); no multi-line-item breakdown (maintenance fee, convenience fee); uses list+bottom sheet vs dedicated payment page |
| 8.2 | Rent Payment Success | `screens/tenant/payment_success_screen.dart` | BUILT | No month-specific text; no utility surcharge line item; "Save PDF" and "Share" buttons missing (replaced with "Copy Receipt") |
| 8.3 | Payment Ledger | `screens/landlord/payment_ledger_screen.dart` | BUILT | No filter icon; no statement period/date range; no "Export PDF" button; no diverse transaction types (utility, refund, surcharge); no "View All" link |
| 8.4 | Landlord Payments (Empty) | `screens/landlord/payment_list_screen.dart` | PARTIAL | **"Connect Payment Provider" CTA missing**; "How It Works" 3-step guide missing; security badges (PCI, Stripe, AES-256) missing; 3D illustration missing |
| 8.5 | Landlord Payments (Populated) | `screens/landlord/payment_list_screen.dart` | PARTIAL | No growth % badge; "NEXT PAYOUT" stat missing; **search bar missing**; uses property-grouped expandable view vs flat tenant transaction list; tenant names/avatars missing in rows |

### 9. DOCUMENTS (2 wireframes)

| # | Wireframe | Built File | Status | Missing Functionality |
|---|-----------|-----------|--------|----------------------|
| 9.1 | Document Upload/Status | `screens/tenant/document_screen.dart` | PARTIAL | Renters Insurance + Pet Vaccinations doc types missing (build has Background Check instead); no "Optional" badge concept; no document thumbnails; no "ACTION REQUIRED" label |
| 9.2 | Pending Documents Review | `screens/landlord/pending_document_review_screen.dart` | PARTIAL | No filter button; no document thumbnail previews; no tenant photo avatars; no sort controls |

### 10. MOVE-OUT (2 wireframes)

| # | Wireframe | Built File | Status | Missing Functionality |
|---|-----------|-----------|--------|----------------------|
| 10.1 | Move-Out Request | `screens/shared/move_out_screen.dart` | BUILT | "Notice period requirements met" green validation missing; section header icons missing; unit-specific notice text missing |
| 10.2 | Pending Move-Out Requests | `screens/shared/move_out_screen.dart` | PARTIAL | "Details" button missing (only Approve/Reject); "Earliest move-out in X days" subtitle missing; tenant photo avatars missing; FAB missing; end-of-list footer missing |

### 11. NOTIFICATIONS (1 wireframe)

| # | Wireframe | Built File | Status | Missing Functionality |
|---|-----------|-----------|--------|----------------------|
| 11.1 | Notifications | `screens/shared/notifications_screen.dart` | BUILT | **No TODAY/YESTERDAY date group headers**; no relative timestamps ("2h ago"); blue unread dot uses background tint instead; bell icon missing from AppBar; FAB missing |

---

## Cross-Cutting Gaps (Affect Multiple Screens)

| Gap | Screens Affected | Priority |
|-----|-----------------|----------|
| **No profile photo support** -- all screens use initials-only CircleAvatar, never actual photos | ALL screens with avatars (15+) | Medium |
| **No real property/building images** -- all use placeholder icons | Property List, Property Detail, Lease Cards, Invite screens (8+) | Medium |
| **Search bars missing** -- wireframes show search on multiple list screens | Pending Invites, Lease List, Landlord Payments, Tenant selector (4) | High |
| **Recent Activity is static/hardcoded** -- not data-driven | Landlord Dashboard, Tenant Dashboard (2) | High |
| **Bottom nav handled by shell** -- not a real gap, just architecture difference | All screens | N/A (not a gap) |
| **No PDF viewer/preview** -- wireframes show embedded PDF viewing | Lease Review, View Lease, Lease Details (3) | High |
| **Export/Share/Save PDF missing** | Payment Ledger, Payment Success, View Lease (3) | Medium |
| **Landlord info missing from tenant screens** -- name, avatar, role | Invite Accept, Invite Verify, Invite Expired (3) | Medium |

---

## Priority Fix List (Recommended Order)

### P0 -- Must Fix for MVP

1. **Build Lease Settings screens** (2 missing screens) -- core CLAUDE.md requirement
2. **Add date pickers to lease creation** -- start/end date selection critical
3. **Fix invite date picker bug** -- setState is empty, selected date never stored
4. **Connect Stripe onboarding flow** for landlord empty payments state
5. **Make Recent Activity data-driven** -- replace hardcoded items on both dashboards

### P1 -- Important for UX Parity

6. Add search bars to: Pending Invites, Lease List, Landlord Payments
7. Build payment method selection UI for tenant rent payment
8. Add date grouping + timestamps to Notifications screen
9. Add "Save as Draft" to lease creation flow
10. Add per-section "Edit" links on lease review step
11. Add "Details" button to Pending Move-Out cards
12. Make unit filter chips functional on Property Detail
13. Add "days left" countdown to pending invite cards
14. Add property image upload support

### P2 -- Polish & Fidelity

15. Add embedded PDF preview (or at minimum in-app PDF viewer)
16. Add Export PDF to payment ledger
17. Add trend badges ("% vs last mo.") to dashboard stat cards
18. Add profile photo upload
19. Add landlord info to tenant-facing invite screens
20. Add "Required Documents" section to tenant active dashboard
21. Add BUSINESS & FINANCE section to Account Settings
22. Fix text copy mismatches (subtitles, footers, labels)
23. Add onboarding step descriptions and video guide link
24. Add PRO TIP callout to property structure setup

---

## Extra Screens Built (No Wireframe)

| Built Screen | Purpose | Notes |
|-------------|---------|-------|
| `reset_password_screen.dart` | Enter reset code + new password | Good addition, extends Forgot Password flow |
| `unit_invite_wizard_screen.dart` | Multi-step unit setup + invite | Alternative to single invite form, not in wireframes |
| `tenant_lease_review_screen.dart` | Tenant pre-signing review | Extends Lease Review wireframe concept |

---

_End of Audit Report_
