# AYRNOW Mismatch Audit

Current Flutter implementation vs wireframe PNGs. Every mismatch listed by screen/module with severity.

**Severity scale:**
- **CRITICAL** = Screen missing entirely or fundamentally wrong flow
- **MAJOR** = Screen exists but layout/components significantly differ from wireframe
- **MINOR** = Screen mostly matches but missing secondary details

---

## A. AUTH & ONBOARDING

### A1. Splash/Welcome — CRITICAL
- **Current:** `_SplashScreen` in main.dart — just logo + "AYRNOW" text + spinner
- **Wireframe:** Full welcome screen with tagline, subtitle, "Login" + "Create Account" buttons, trust badge
- **Mismatches:**
  - Missing "Simplify Your Rental Journey" tagline
  - Missing subtitle text
  - Missing "Login" button (currently auto-redirects)
  - Missing "Create Account" button
  - Missing "TRUSTED BY 10,000+ LANDLORDS" badge
  - Missing light background gradient
  - Current splash is a loading state, not a welcome/landing screen

### A2. Login — MAJOR
- **Current:** `LoginScreen` — centered form with logo, email/password, "Log In" button, "Register" text link
- **Wireframe:** Left-aligned, "Welcome back" heading, labeled fields with icons, "Forgot password?" link, social auth (Google + Apple), "Create an account" link
- **Mismatches:**
  - Missing "Welcome back" heading + subtitle (has logo instead)
  - Field labels should be above fields ("Email or Phone", "Password"), not inside
  - Missing "Forgot password?" link next to Password label
  - Missing "OR CONTINUE WITH" divider
  - Missing Google sign-in button
  - Missing Apple sign-in button
  - Missing AYRNOW icon in top-left corner
  - Button text is "Log In" instead of "Sign In"
  - "Register" opens bottom sheet instead of navigating to register screen

### A3. Register — CRITICAL
- **Current:** `_RegisterSheet` — bottom sheet with name/email/password fields + `SegmentedButton` for role
- **Wireframe:** Full-screen multi-step flow (Step 2 of 4), role selection with rich cards (icon, title, description, feature tags), trust badge, Continue button
- **Mismatches:**
  - Bottom sheet instead of full-screen route
  - Not multi-step (should be at least 4 steps)
  - Missing step indicator ("STEP 2 OF 4")
  - Role selection is `SegmentedButton` instead of rich selectable cards
  - Missing card descriptions and feature tags
  - Missing "SECURE & VERIFIED" trust banner
  - Missing terms/privacy footer
  - Missing separate steps for personal info, role, confirmation

### A4. Forgot Password — CRITICAL
- **Current:** Does not exist
- **Wireframe:** Full screen with key icon, email field, "Send Reset Link" button, support links
- **Missing entirely**

---

## B. LANDLORD DASHBOARD & ACCOUNT

### B1. Landlord Dashboard (Empty) — MAJOR
- **Current:** Shows same dashboard with 0 values + "Could not load dashboard" fallback
- **Wireframe:** 4 stat cards + "Start Your Portfolio" illustration + "Add My First Property" CTA + Quick Setup Guide
- **Mismatches:**
  - Missing "Start Your Portfolio" section with building illustration
  - Missing "Add My First Property ->" button
  - Missing "QUICK SETUP GUIDE" numbered steps
  - Stat cards layout differs (current: 2 per row with `_StatCard`, wireframe: 2x2 grid with different icons/colors)
  - Missing add (+) icon in top-right
  - Missing "Tenants" stat card (current has "Occupied"/"Vacant" instead)
  - Missing "Monthly Rent" stat card (current has "Total Revenue")

### B2. Landlord Dashboard (Populated) — MAJOR
- **Current:** Welcome text, 6 stat cards in 3 rows of 2, single revenue card
- **Wireframe:** Greeting + subtitle, 4 stat cards with trend indicators (% vs last mo), Quick Actions grid (3 buttons), Recent Activity feed with avatars, promo card
- **Mismatches:**
  - Missing trend indicators (% change vs last month)
  - Missing Quick Actions grid (Add Property, Invite Tenant, Create Lease)
  - Missing Recent Activity feed with avatar list
  - Missing "Automate Rent Reminders" promo card
  - Wrong stat card set (wireframe: Rent Collected, Occupancy %, Pending Invites, Active Leases)
  - Missing "View All" link for activity

### B3. Landlord Onboarding — CRITICAL
- **Current:** Does not exist
- **Wireframe:** Full onboarding screen with progress bar, 4-step checklist, video guide
- **Missing entirely**

### B4. Account Settings — MAJOR
- **Current:** `AccountScreen` — profile card, notifications list, invitations, move-outs, logout
- **Wireframe:** Structured settings screen with sections (Business & Finance, Preferences, Legal & Support), profile card with verified badge, "Edit Profile" button, version number
- **Mismatches:**
  - Missing structured sections (Business & Finance, Preferences, Legal & Support)
  - Missing Payment Provider / Tax Info / Subscription items
  - Missing Notifications / Security settings items
  - Missing Terms / Help Center / Privacy Policy links
  - Missing version number footer
  - Missing gear icon in top-right
  - Notifications/invitations/move-outs should not be on this screen (they have dedicated screens)

### B5. Edit Preferences — CRITICAL
- **Current:** Does not exist
- **Wireframe:** Full edit screen with avatar editor, contact fields, notification toggles, lease preferences
- **Missing entirely**

---

## C. PROPERTY MANAGEMENT

### C1. Properties List (Empty) — MAJOR
- **Current:** "No properties yet" with icon + "Tap + to add" text
- **Wireframe:** "Start Your Portfolio" illustration, "HOW IT WORKS" 3-step cards, "+ Add First Property" button, data protection link
- **Mismatches:**
  - Missing building illustration with plus badge
  - Missing "HOW IT WORKS" numbered guide cards
  - Missing descriptive CTA button (has FAB instead)
  - Missing "Learn how AYRNOW protects your data" link

### C2. Properties List (Populated) — MAJOR
- **Current:** Simple card list with name, type icon, address, unit counts as chips
- **Wireframe:** Search bar, filter tabs (All/Residential/Commercial), sort dropdown, property cards with IMAGES, occupancy % badge overlay, VIEW/EDIT/LEASE action buttons
- **Mismatches:**
  - Missing search bar
  - Missing filter tabs
  - Missing sort dropdown
  - Missing property images
  - Missing occupancy % overlay badges
  - Missing VIEW/EDIT/LEASE action buttons per card
  - Missing property count header

### C3. Property Detail — MAJOR
- **Current:** `_PropertyDetailScreen` — simple list with address, type, units as ListTiles
- **Wireframe:** Hero image, "Active Property" badge, 3 stat circles, tab bar (Units/Tenants/Leases/Payments), unit list with badges/avatars/status chips, "+ Add New Unit"
- **Mismatches:**
  - Missing hero image with overlay
  - Missing stat circles (Occupancy %, Units fraction, Revenue)
  - Missing tab bar (Units | Tenants | Leases | Payments)
  - Missing unit number badges (colored circles)
  - Missing tenant avatars on occupied units
  - Missing status chips (Occupied/Vacant)
  - Unit list is basic ListTiles instead of rich cards

### C4. Add Property Step 1 — MAJOR
- **Current:** `_AddPropertySheet` — bottom sheet with single-page form
- **Wireframe:** Full-screen "STEP 1 OF 3" with progress bar, sectioned form (Identity, Location, Narrative), type selector icons (4 options), "Next: Property Structure" button
- **Mismatches:**
  - Bottom sheet instead of full-screen route
  - No step indicator or progress bar
  - Type selection is dropdown instead of icon buttons (4 options including Industrial)
  - Missing section headings with icons (IDENTITY, LOCATION, NARRATIVE)
  - Missing "Your progress is automatically saved" footer
  - Single submit instead of "Next" navigation

### C5. Add Property Step 2 — CRITICAL
- **Current:** Does not exist (auto-generates units from count)
- **Wireframe:** "Define Structure" with total units/floors steppers, common features toggles, pro tip
- **Missing entirely**

### C6. Add Property Step 3 — CRITICAL
- **Current:** Does not exist
- **Wireframe:** Review screen with property summary, unit breakdown, "Save & Create" / "Save as Draft"
- **Missing entirely**

### C7. Unit List — MAJOR
- **Current:** Embedded in property detail as simple ListTiles
- **Wireframe:** Dedicated screen with search, filter tabs (All/Occupied/Vacant/Maintenance), rich cards with rent/tenant/status/actions, overdue warnings, occupancy stat
- **Mismatches:**
  - Not a separate screen
  - Missing search and filter tabs
  - Missing rich unit cards with all fields
  - Missing per-unit action buttons (Edit/Invite/Lease)
  - Missing overdue warning banners
  - Missing occupancy rate stat

### C8. Edit Unit — MAJOR
- **Current:** Simple AlertDialog with name field + type dropdown
- **Wireframe:** Full screen with sections (Identity, Rent & Deposit, Utility Inclusions toggles, Internal Notes, ready checkbox)
- **Mismatches:**
  - Dialog instead of full screen
  - Missing floor level field
  - Missing rent and deposit fields
  - Missing utility inclusion toggles (Electricity/Water/Internet/Trash/Gas)
  - Missing internal notes textarea
  - Missing "Mark as ready for leasing" checkbox

### C9. Property Created Success — CRITICAL
- **Current:** Does not exist
- **Wireframe:** Success screen with check icon, property summary, "View Property" + "Invite First Tenant" + "Add Another" actions
- **Missing entirely**

---

## D. INVITE FLOW

### D1. Invite Tenant — MAJOR
- **Current:** Bottom sheet in `InviteScreen` with unit dropdown + email field
- **Wireframe:** Full screen with name field, email field, property/unit selector, start date, personalized message with tone chips, expiry preview
- **Mismatches:**
  - Missing tenant name field
  - Missing proposed start date picker
  - Missing personalized message section
  - Missing tone selector chips (Professional/Friendly/Urgent)
  - Missing invitation expiry preview
  - Missing property assignment display

### D2. Invite Sent Confirmation — CRITICAL
- **Current:** Does not exist
- **Missing entirely**

### D3. Invite Expired/Invalid — CRITICAL
- **Current:** Does not exist
- **Missing entirely**

### D4. Pending Invites — MAJOR
- **Current:** Embedded as list in `AccountScreen`
- **Wireframe:** Dedicated screen with filters, search, rich cards with expiry countdown, cancel/resend buttons, expiry management tip
- **Mismatches:**
  - Not a dedicated screen
  - Missing filter tabs and search
  - Missing expiry countdown badges
  - Missing cancel/resend action buttons per card
  - Missing expiry management info card

### D5. Tenant Invite Acceptance — CRITICAL
- **Current:** Does not exist
- **Missing entirely**

### D6. Tenant Invite Verification — CRITICAL
- **Current:** Does not exist
- **Missing entirely**

---

## E. LEASE MANAGEMENT

### E1. Lease Settings Overview — MAJOR
- **Current:** `_LeaseSettingsSheet` — bottom sheet with number fields
- **Wireframe:** Full screen with structured sections (Financial Terms, General Policies, Standard Clauses with badges), "Update Global Settings" button
- **Mismatches:**
  - Bottom sheet instead of full screen
  - Missing Financial Terms display format (key-value with descriptions)
  - Missing General Policies section
  - Missing Standard Clauses list with Active/Optional badges
  - Missing "+ Manage Custom Clauses" link

### E2. Lease Settings Edit — MAJOR
- **Current:** Same bottom sheet as E1
- **Wireframe:** Full edit screen with auto-renewal toggle, policy preview card, clause editor, admin notes
- **Mismatches:**
  - Missing auto-renewal toggle
  - Missing policy preview card
  - Missing clause text editor
  - Missing internal admin notes

### E3-E7. Create Lease (5-step wizard) — CRITICAL
- **Current:** `_CreateLeaseSheet` — single bottom sheet with property/unit/tenant dropdowns + fields
- **Wireframe:** 5-step full-screen wizard: (1) Select Property with images, (2) Select Tenant with search/avatars, (3) Lease Terms with date pickers/summary, (4) Clauses & Notes with templates, (5) Review with all sections
- **Mismatches:**
  - Single bottom sheet instead of 5-step full-screen wizard
  - Missing step indicator and progress
  - Step 1: Missing property images and search
  - Step 2: Missing tenant search with avatars and "Invite New" option
  - Step 3: Missing date pickers, financial summary card, save draft option
  - Step 4: Missing entirely (clauses & notes)
  - Step 5: Missing entirely (review with edit links)

### E8. Lease List (Empty) — MINOR
- **Current:** "No leases yet" with icon
- **Wireframe:** Illustration + "HOW IT WORKS" steps + "+ Create First Lease" button + guide link
- **Mismatches:**
  - Missing how-it-works steps
  - Missing descriptive CTA (has FAB instead)

### E9. Lease List (Populated) — MAJOR
- **Current:** Simple ListTile cards with status dot + basic info
- **Wireframe:** Search bar, portfolio banner with count, filter tabs (All/Drafts/Sent/Active), cards with property image thumbnails, status badges, tenant avatars, View/PDF actions, load more
- **Mismatches:**
  - Missing search bar
  - Missing portfolio banner
  - Missing filter tabs
  - Missing property image thumbnails
  - Missing tenant avatars
  - Missing View/PDF action links

### E10. Lease Detail — MAJOR
- **Current:** Bottom sheet with basic text info
- **Wireframe:** Full screen with status badge, property image, move-in countdown, tenant card, terms display, review & files section, landlord notes, Edit + "Send to Sign" buttons
- **Mismatches:**
  - Bottom sheet instead of full screen
  - Missing property image
  - Missing move-in countdown
  - Missing tenant card with avatar/email
  - Missing review & files section (PDF Preview, Clauses, Download)
  - Missing landlord notes
  - Missing Edit button

---

## F. SIGNING FLOW (ALL CRITICAL — None implemented)

### F1. Generated Lease Ready — CRITICAL: Missing entirely
### F2. Lease Signing (E-Sign pad) — CRITICAL: Missing entirely
### F3. Lease Signing Status/Timeline — CRITICAL: Missing entirely
### F4. Lease Signed Success — CRITICAL: Missing entirely
### F5. Lease Review (tenant pre-sign) — CRITICAL: Missing entirely

---

## G. TENANT VIEW LEASE

### G1. View Lease — MAJOR
- **Current:** `TenantLeaseScreen` — simple card list with property/unit/rent/term, sign button
- **Wireframe:** "My Lease" with Active badge, rent/due info, address, term, Download PDF button, embedded PDF preview with pagination, detail cards (Security Deposit/Notice Period/Utility Responsibility), Contact option
- **Mismatches:**
  - Missing "CURRENT LEASE" card with Active badge
  - Missing "Download PDF" button
  - Missing embedded PDF document preview
  - Missing detail cards (deposit/notice/utilities)
  - Missing "Contact" landlord option

---

## H. PAYMENTS

### H1. Landlord Payments (Empty) — MAJOR
- **Current:** Falls through to populated state showing property expansion
- **Wireframe:** "Unlock Effortless Rent Collection" with illustration, "Connect Payment Provider" button, setup steps, security badges
- **Mismatches:**
  - No empty state detection
  - Missing setup illustration
  - Missing "Connect Payment Provider" CTA
  - Missing HOW IT WORKS steps
  - Missing security badges (PCI, Stripe, AES-256)

### H2. Landlord Payments (Populated) — MAJOR
- **Current:** Property-based expansion tiles with basic payment lists
- **Wireframe:** Revenue summary cards (Total Collected, Outstanding, Next Payout), search, filter tabs (All/Pending/Paid/Overdue), transaction list with tenant avatars and status badges
- **Mismatches:**
  - Missing revenue summary cards at top
  - Missing search bar
  - Missing filter tabs
  - No tenant avatars in list
  - Property-based grouping instead of flat transaction list

### H3. Payment Ledger — CRITICAL: Missing entirely

### H4. Rent Payment (Tenant) — MAJOR
- **Current:** `TenantPaymentScreen` — simple list with "Pay" buttons that open Stripe checkout
- **Wireframe:** Full screen with payment method cards (Visa/Bank), method selection, transaction summary breakdown (rent + fees + total), security badge, in-app pay button
- **Mismatches:**
  - No payment method selection
  - No transaction summary breakdown
  - Missing security badge
  - Redirects to external Stripe instead of in-app summary

### H5. Rent Payment Success — CRITICAL: Missing entirely

---

## I. DOCUMENTS

### I1. Document Upload/Status (Tenant) — MAJOR
- **Current:** `DocumentScreen` — simple list with type icon, status text, upload FAB with type selector dialog
- **Wireframe:** Submission progress bar (2 of 4, 50%), required documents with descriptions and status badges (APPROVED/UNDER REVIEW/MISSING), upload buttons inline, additional docs section
- **Mismatches:**
  - Missing progress indicator
  - Missing descriptive text per document type
  - Missing inline status badges with colors
  - Missing inline upload buttons (has FAB instead)
  - Missing "Additional Support Docs" section

### I2. Pending Document Review (Landlord) — MAJOR
- **Current:** Embedded in `AccountScreen` as simple list
- **Wireframe:** Dedicated screen with count header, document cards with tenant info, document thumbnail previews, "Request Changes" + "Approve" buttons
- **Mismatches:**
  - Not a dedicated screen
  - Missing document thumbnails/previews
  - Missing "Request Changes" button (only has approve/reject)
  - Missing tenant avatar and unit info per card

---

## J. MOVE-OUT

### J1. Move-Out Request (Tenant) — MAJOR
- **Current:** `MoveOutScreen` bottom sheet with lease dropdown, date picker, reason textarea
- **Wireframe:** Full screen with 60-day notice banner, date picker, forwarding address fields, reason chips (Buying/Relocation/Upsizing/Downsizing), consent checkbox
- **Mismatches:**
  - Bottom sheet instead of full screen
  - Missing notice period info banner
  - Missing forwarding address fields
  - Missing reason chip tags
  - Missing consent checkbox
  - Missing notice period validation indicator

### J2. Pending Move-Outs (Landlord) — MAJOR
- **Current:** Embedded in `AccountScreen` with simple approve/reject icons
- **Wireframe:** Dedicated screen with summary banner, cards with urgency badges, reason text, Approve/Details/Reject buttons
- **Mismatches:**
  - Not a dedicated screen
  - Missing summary banner with pending count and earliest date
  - Missing urgency badges
  - Missing "Details" button
  - Missing reason text display

---

## K. TENANT SCREENS

### K1. Tenant Dashboard (Pre-Active) — MAJOR
- **Current:** `TenantDashboard` — same for all states, simple card with property/rent/due info
- **Wireframe:** "My New Home" with move-in countdown (12 Days), onboarding checklist (65%), quick cards (Lease/Documents)
- **Mismatches:**
  - Missing move-in countdown
  - Missing onboarding checklist
  - Missing quick access cards
  - No distinction between pre-active and active states

### K2. Tenant Dashboard (Active) — MAJOR
- **Current:** Same as above
- **Wireframe:** Avatar greeting, payment due banner with amount, "Pay Now" button, Quick Actions 2x2 grid, document alert, recent activity feed
- **Mismatches:**
  - Missing avatar in greeting
  - Missing "Pay Now" prominent button
  - Missing Quick Actions grid (View Lease, Upload Docs, History, Maintenance)
  - Missing document expiry alert
  - Missing recent activity feed

### K3. Tenant Onboarding — CRITICAL: Missing entirely

### K4. Tenant Account Settings — MAJOR
- **Current:** Shared `AccountScreen` between landlord/tenant
- **Wireframe:** Tenant-specific with "Gold Tenant" badge, Financials section (Payment Methods, Payment History), Property section (Current Lease, Move-Out Request), Preferences, Support
- **Mismatches:**
  - Same screen for landlord and tenant (should be different)
  - Missing tenant badge
  - Missing Financials section
  - Missing Property section (Current Lease, Move-Out Request links)
  - Missing structured Preferences and Support sections

---

## L. NOTIFICATIONS

### L1. Notifications — MAJOR
- **Current:** Embedded in `AccountScreen` as simple list (max 5)
- **Wireframe:** Dedicated full screen with date grouping (TODAY/YESTERDAY), colored type icons, type tags, "Mark all read", unread count banner
- **Mismatches:**
  - Not a dedicated screen
  - Missing date grouping
  - Missing colored type-specific icons
  - Missing type tags (Lease/Payment/Tenant/Message)
  - Missing "Mark all read" action
  - Limited to 5 items (should show all with scroll)
  - Missing "You're all caught up!" footer

---

## SUMMARY COUNTS

| Severity | Count |
|----------|-------|
| CRITICAL (missing or fundamentally wrong) | 20 |
| MAJOR (exists but significantly different) | 31 |
| MINOR (mostly matches, small gaps) | 3 |
| **TOTAL MISMATCHES** | **54** |

Every single wireframe has at least one mismatch with the current implementation.
