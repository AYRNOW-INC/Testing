# AYRNOW Wireframe Map

Every wireframe PNG mapped to feature, Flutter screen, route, UI purpose, functionality, components, and state variants.

---

## A. AUTH & ONBOARDING

### A1. Splash _ Welcome.png
- **Feature/Module:** Auth
- **Flutter Screen:** `SplashWelcomeScreen`
- **Route:** `/` (initial route)
- **UI Purpose:** App entry point, brand impression, route to login or register
- **Required Functionality:**
  - Display AYRNOW logo (blue rounded square with lightning bolt)
  - Show tagline: "Simplify Your Rental Journey"
  - Show subtitle: "Lease, manage, and pay with the most trusted platform for landlords and tenants."
  - Two full-width buttons: "Login" (blue filled) + "Create Account" (grey outlined)
  - Footer: "TRUSTED BY 10,000+ LANDLORDS"
  - Light background with subtle top-right circle gradient
- **Key Components:** Logo image, tagline text, 2 CTA buttons, trust badge
- **State Variants:** Single state (no loading/empty)

### A2. Login.png
- **Feature/Module:** Auth
- **Flutter Screen:** `LoginScreen`
- **Route:** `/login`
- **UI Purpose:** Credential entry for returning users
- **Required Functionality:**
  - Small AYRNOW icon top-left
  - "Welcome back" heading + "Enter your credentials to manage your properties and leases." subtitle
  - "Email or Phone" field with mail icon prefix
  - "Password" field with lock icon prefix + visibility toggle + "Forgot password?" link aligned right
  - "Sign In" full-width blue button
  - "OR CONTINUE WITH" divider
  - Google button (outlined, icon + text)
  - Apple button (outlined, icon + text)
  - "New to AYRNOW?" + "Create an account" link at bottom
- **Key Components:** Icon, heading, 2 form fields, primary button, social auth buttons, navigation links
- **State Variants:** Default, loading (button spinner), error (field validation)

### A3. Register _ Account Type.png
- **Feature/Module:** Auth
- **Flutter Screen:** `RegisterScreen` (multi-step, this is step 2 of 4)
- **Route:** `/register`
- **UI Purpose:** Role selection during registration
- **Required Functionality:**
  - App bar: back arrow + "Create Account" + "STEP 2 OF 4"
  - "How will you use AYRNOW?" heading
  - "We'll customize your experience based on your role." subtitle
  - Landlord card (selected state): building icon in blue circle, "I am a Landlord" title, description, feature tags (Unlimited Properties, Lease Automation, Rent Collection), "SELECTED ROLE >" indicator
  - Tenant card: person icon, "I am a Tenant" title, description, feature tags (Easy Rent Payments, Digital Leases, Maintenance Requests)
  - "SECURE & VERIFIED" trust banner with shield icon at bottom
  - "Continue >" blue button
  - Terms/privacy footer text
- **Key Components:** Step indicator, 2 selectable role cards with icons and tags, trust banner, continue button
- **State Variants:** Landlord selected (blue border), Tenant selected (blue border)
- **Note:** Full register flow is 4 steps. Step 1 = name/email/password (not wireframed separately but implied). Step 2 = this screen. Steps 3-4 not wireframed.

### A4. Forgot Password.png
- **Feature/Module:** Auth
- **Flutter Screen:** `ForgotPasswordScreen`
- **Route:** `/forgot-password`
- **UI Purpose:** Password recovery
- **Required Functionality:**
  - App bar: back arrow + "Reset Password"
  - Key icon in light blue circle
  - "Forgot Password?" heading
  - Subtitle about entering email/phone for recovery link
  - "Email or Phone Number" field with mail icon
  - "Send Reset Link ->" blue button
  - "Having trouble? Contact Support" link
  - "OR" divider
  - "Return to Login" link
  - Bottom: "Don't have an account? Register" link
- **Key Components:** Icon, heading, email field, CTA button, support/navigation links
- **State Variants:** Default, success (link sent confirmation), error

---

## B. LANDLORD DASHBOARD & ACCOUNT

### B1. Landlord Dashboard (Empty).png
- **Feature/Module:** Landlord Dashboard
- **Flutter Screen:** `LandlordDashboardScreen`
- **Route:** `/dashboard` (landlord home)
- **UI Purpose:** Empty state onboarding for new landlords
- **Required Functionality:**
  - Top bar: AYRNOW icon left + add (circle plus) icon right
  - 4 stat cards in 2x2 grid: Properties (0), Tenants (0), Active Leases (0), Monthly Rent ($0) — each with colored icon
  - "Start Your Portfolio" section: building illustration with green plus badge, heading, subtitle about adding first property
  - "Add My First Property ->" blue button
  - "QUICK SETUP GUIDE" section: numbered steps (1. Create Property Record, 2. Configure Lease Rules) with descriptions and chevrons
  - Bottom nav: Dashboard | Properties | Leases | Payments | Account
- **Key Components:** Stat grid, empty state illustration, CTA button, setup guide list, bottom nav
- **State Variants:** Empty only (this wireframe)

### B2. Landlord Dashboard (Populated).png
- **Feature/Module:** Landlord Dashboard
- **Flutter Screen:** `LandlordDashboardScreen`
- **Route:** `/dashboard`
- **UI Purpose:** Active landlord overview with stats and quick actions
- **Required Functionality:**
  - Top bar: "Dashboard" title with AYRNOW icon, add + notification icons
  - "Welcome back, [Name]" greeting + "Here's what's happening today." subtitle
  - 2x2 stat cards: $18,420 RENT COLLECTED (green $ icon, "12% vs last mo."), 94% OCCUPANCY (building icon, "2% vs last mo."), 03 PENDING INVITES (people icon), 18 ACTIVE LEASES (document icon)
  - "Quick Actions" section: 3 square buttons in row — Add Property (green +), Invite Tenant (blue person+), Create Lease (purple document)
  - "Recent Activity" section with "View All" link: list items with avatars, descriptions, timestamps (e.g., "Rent Received - Unit 4B - Sarah Jenkins - 2 hours ago")
  - Promo card: "Automate Rent Reminders" with "Learn how >" link
  - Bottom nav: Dashboard | Properties | Leases | Payments | Account
- **Key Components:** Greeting, stat cards with trend indicators, quick action buttons, activity feed, promo card
- **State Variants:** Populated (this wireframe), see B1 for empty

### B3. Landlord Account Setup.png
- **Feature/Module:** Landlord Onboarding
- **Flutter Screen:** `LandlordOnboardingScreen`
- **Route:** `/onboarding`
- **UI Purpose:** Guided first-time setup checklist
- **Required Functionality:**
  - AYRNOW icon top-left, notification bell top-right
  - "Welcome, [Name]!" heading + "Let's get your first property ready."
  - "SETUP PROGRESS" bar: "1 of 3 steps completed" + 33% progress bar
  - "Onboarding Checklist" with "Step 1 of 3" label
  - Checklist items with icons and status:
    1. Account Verified (green check) — completed
    2. Add Your First Property (building icon) — "Start Now >" link — incomplete
    3. Invite Your Tenants (people icon) — incomplete
    4. Setup Digital Leases (document icon) — incomplete
  - "Need help setting up?" info card with "Watch Video Guide" button
  - Bottom nav: Home | Properties | Leases | Payments | Account
  - Blue FAB (+) button
- **Key Components:** Progress bar, checklist with completion states, help card, FAB
- **State Variants:** Progress at various completion levels (0-100%)

### B4. Landlord Account Settings.png
- **Feature/Module:** Account
- **Flutter Screen:** `AccountSettingsScreen`
- **Route:** `/account`
- **UI Purpose:** Landlord account management and preferences
- **Required Functionality:**
  - "Account Settings" title + gear icon
  - Profile card: avatar (circular), name with verified badge, email, "Edit Profile" button
  - BUSINESS & FINANCE section:
    - Payment Provider: "Stripe connected" + "Active" green badge + chevron
    - Tax Information: "W-9 and 1099-K records" + chevron
    - Subscription Plan: "Pro Tier - Renews Oct 24" + chevron
  - PREFERENCES section:
    - Notifications: "Push, email, and SMS alerts" + chevron
    - Security: "Password and 2FA settings" + chevron
  - LEGAL & SUPPORT section:
    - Terms of Service + chevron
    - Help Center + chevron
    - Privacy Policy + chevron
  - "Sign Out" button (red icon + text)
  - "VERSION 2.4.1 (BUILD 882)" footer
  - Bottom nav: (partial visible) Leases | Payments | Account
- **Key Components:** Profile card, sectioned settings list with icons and chevrons, sign out button
- **State Variants:** Single state

### B5. Landlord Account Edit.png
- **Feature/Module:** Account
- **Flutter Screen:** `EditPreferencesScreen`
- **Route:** `/account/edit`
- **UI Purpose:** Edit landlord profile and preferences
- **Required Functionality:**
  - App bar: back arrow + "Edit Preferences" + "Save" link (blue)
  - Avatar with camera overlay icon
  - Name + "PREMIUM LANDLORD" subtitle
  - CONTACT INFORMATION section: Full Name field, Email Address field (with mail icon), Phone Number field (with phone icon)
  - NOTIFICATIONS section: Push Notifications toggle (on), Email Summaries toggle (on), SMS Reminders toggle (off)
  - LEASE PREFERENCES section:
    - Default Lease Template: "Standard_Residentia" + "Change" link + last updated date
    - Payment Provider Settings: chevron
  - "Save All Changes" blue button
  - "Discard Changes" text link
  - Bottom nav: Home | Payments | Leases | Account
- **Key Components:** Avatar editor, form fields, toggle switches, template selector, save/discard buttons
- **State Variants:** Default (viewing), editing (changed fields)

---

## C. PROPERTY MANAGEMENT

### C1. Properties List (Empty).png
- **Feature/Module:** Properties
- **Flutter Screen:** `PropertyListScreen`
- **Route:** `/properties`
- **UI Purpose:** Empty state encouraging first property creation
- **Required Functionality:**
  - "Properties" title + notification bell icon
  - Building illustration with green plus badge
  - "Start Your Portfolio" heading
  - Subtitle about managing units, leases, payments
  - "HOW IT WORKS" section with 3 numbered cards:
    1. Property Details: "Enter address, type, and basic info..." (location icon)
    2. Define Units: "Set up individual units or spaces..." (building icon)
    3. Invite & Lease: "Bring tenants on board, create digital leases..." (people icon)
  - "+ Add First Property" full-width blue button
  - "Learn how AYRNOW protects your data >" link
  - Bottom nav: Dashboard | Properties | Leases | Payments | Account
- **Key Components:** Illustration, how-it-works cards, CTA button
- **State Variants:** Empty only

### C2. Properties List (Populated).png
- **Feature/Module:** Properties
- **Flutter Screen:** `PropertyListScreen`
- **Route:** `/properties`
- **UI Purpose:** Browse and manage all properties
- **Required Functionality:**
  - "Properties" title + add (+) icon
  - Search bar: "Search by name or address..."
  - Filter tabs: All (selected) | Residential | Commercial | (more)
  - "3 PROPERTIES FOUND" count + "Sort by: Recent" dropdown
  - Property cards, each with:
    - Property IMAGE (full width)
    - Occupancy % badge overlay (e.g., "95% Occupied" green, "70%" yellow, "100%" green)
    - Property name + type tag (Residential/Commercial)
    - Address with location icon
    - Stats row: units icon + total units, person icon + occupancy %, dollar icon
    - Bottom action row: VIEW | EDIT | LEASE buttons
  - Bottom nav: Dashboard | Properties | Leases | Payments | Account
- **Key Components:** Search bar, filter tabs, sort dropdown, property cards with images and stats
- **State Variants:** Populated, filtered by type

### C3. Property Details.png
- **Feature/Module:** Properties
- **Flutter Screen:** `PropertyDetailScreen`
- **Route:** `/properties/:id`
- **UI Purpose:** Single property overview with units, tenants, financials
- **Required Functionality:**
  - App bar: back arrow + property name + 3-dot menu
  - Hero image with "Active Property" green badge, property name overlay, address overlay
  - 3 stat circles in row: 92% Occupancy, 11/12 Units, $18,450 Revenue
  - Tab bar: Units | Tenants | Leases | Payments
  - UNIT INVENTORY section with "View All >" link
  - Unit list items:
    - Unit number badge (colored circle, e.g., "101")
    - Unit name + tenant name (with avatar) or "VACANT"
    - Rent amount
    - Status chip: "Occupied" (teal) or "Vacant" (orange)
  - "+ Add New Unit" row at bottom
  - Bottom nav: Dashboard | Properties | Leases | Payments | Account
- **Key Components:** Hero image, stat circles, tab bar, unit list with status chips
- **State Variants:** With units, empty units

### C4. Add Property: Basic Info.png
- **Feature/Module:** Properties
- **Flutter Screen:** `AddPropertyScreen` (step 1)
- **Route:** `/properties/add`
- **UI Purpose:** Step 1 of 3: enter property identity and location
- **Required Functionality:**
  - App bar: back arrow + "Add Property"
  - "STEP 1 OF 3" label + "Basic Information" heading + "33% Complete" + progress bar (blue, 1/3)
  - IDENTITY section (building icon):
    - Property Name field with placeholder "e.g. Sunset Heights Apartments" + helper text
    - Property Type: 4 selectable icon buttons — Residential (house, selected=blue), Commercial (store), Industrial (warehouse), Other (+)
  - LOCATION section (pin icon):
    - Street Address field
    - City + State fields (side by side)
    - Zip Code field
  - NARRATIVE section (info icon):
    - Description (Optional) textarea with placeholder
  - "Next: Property Structure >" blue button (full width)
  - Footer: "Your progress is automatically saved as you go."
- **Key Components:** Step progress, form sections with icons, type selector buttons, navigation button
- **State Variants:** Empty form, partially filled, validation errors

### C5. Add Property: Structure Setup.png
- **Feature/Module:** Properties
- **Flutter Screen:** `AddPropertyScreen` (step 2)
- **Route:** `/properties/add` (step 2 state)
- **UI Purpose:** Step 2 of 3: define property structure
- **Required Functionality:**
  - App bar: back arrow + "Setup Structure" + help icon
  - "Step 2: Define Structure" + "66% Complete" + progress bar (2/3)
  - PROPERTY SELECTION card: property name + type + "Change" link
  - "How is it divided?" heading
  - Division Details section:
    - Total Units: number input with +/- steppers
    - Total Floors: number input with +/- steppers
  - Common Features toggles:
    - Designated Parking Spaces (toggle)
    - Extra Storage Units (toggle)
    - Shared Amenity Areas (toggle)
  - Info card: "Defining the structure accurately helps AYRNOW automatically generate rent ledgers and unit identifiers in the next step."
  - PRO TIP: "You can add specific unit numbers (like Apt 4B or Suite 102) in the next step. For now, just focus on the total counts."
  - "Review Property >" blue button
  - "Back to Basic Info" link
- **Key Components:** Progress bar, property summary card, number steppers, feature toggles, info cards
- **State Variants:** Default, with values entered

### C6. Add Property: Review & Save.png
- **Feature/Module:** Properties
- **Flutter Screen:** `AddPropertyScreen` (step 3)
- **Route:** `/properties/add` (step 3 state)
- **UI Purpose:** Step 3 of 3: review and confirm property creation
- **Required Functionality:**
  - App bar: back arrow + "Review & Save" + close (X) icon
  - Progress bar (3/3, "Step 3 of 3")
  - Property image (if uploaded) with "Ready to Publish" badge
  - Property name + description
  - Location Details section: Property Type, Full Address, Tax Identifier (APN)
  - Unit Composition section: count + "12 Total Units" badge, breakdown by type (1-Bedroom: 6, 2-Bedroom: 4, Studio: 2), "Edit Layout >" link
  - Final Confirmation info text
  - "Save & Create Property" blue button
  - "Save as Draft" link
- **Key Components:** Property summary, unit breakdown, confirmation actions
- **State Variants:** Complete review, draft save

### C7. Unit _ Space List.png
- **Feature/Module:** Properties / Units
- **Flutter Screen:** `UnitManagementScreen`
- **Route:** `/properties/:id/units`
- **UI Purpose:** Manage all units within a property
- **Required Functionality:**
  - App bar: back arrow + "Unit Management" (truncated) + search + "+ Unit" button
  - Property name + address subtitle
  - Filter tabs: All (count) | Occupied (count) | Vacant (count) | Maintenance
  - Unit cards, each with:
    - Unit name/number + type (e.g., "Standard Studio")
    - MONTHLY RENT with dollar amount
    - TENANT with name + avatar (or "Unassigned")
    - Status chip: Occupied (teal), Vacant (orange), Maintenance (grey)
    - Warning banner if applicable (e.g., "Rent is overdue for this unit" red)
    - Action buttons row: Edit (pencil) | Invite (person+) | Lease (document)
  - Occupancy Rate stat at bottom with percentage + "Full Report >" link
  - Blue FAB (+) button
  - Bottom nav: Dashboard | Properties | Leases | Payments | Account
- **Key Components:** Filter tabs, unit cards with tenant info and actions, occupancy stat, FAB
- **State Variants:** All units, filtered by status

### C8. Add _ Edit Unit or Space.png
- **Feature/Module:** Properties / Units
- **Flutter Screen:** `EditUnitScreen`
- **Route:** `/properties/:id/units/:unitId/edit`
- **UI Purpose:** Create or edit individual unit details
- **Required Functionality:**
  - App bar: back arrow + "Edit Unit [number]" + help icon
  - Unit Identity section (lock icon):
    - "Specify how this unit is identified in the property."
    - Unit Name / Number field
    - Floor Level field
  - Rent & Deposit section ($ icon):
    - "Monthly pricing and security requirements."
    - Monthly Rent Amount field ($ prefix)
    - Security Deposit field ($ prefix)
  - Utility Inclusions section:
    - "Select utilities that are included in the base rent."
    - Toggle chips: Electricity (INCLUDED, teal), Water (INCLUDED, teal), Internet (EXCLUDED, grey), Trash (INCLUDED, teal), Gas/Heating (EXCLUDED, grey)
  - Internal Notes textarea with existing notes
  - "Mark as ready for leasing" checkbox with helper text
  - "Save Unit Details" black button (full width)
  - Footer: "All changes are synced with your property dashboard instantly."
- **Key Components:** Form sections, utility toggle chips, notes textarea, ready checkbox, save button
- **State Variants:** Create (empty), Edit (pre-filled)

### C9. Property Created Success.png
- **Feature/Module:** Properties
- **Flutter Screen:** `PropertyCreatedScreen`
- **Route:** `/properties/created` (or dialog/overlay)
- **UI Purpose:** Confirmation after successful property creation
- **Required Functionality:**
  - Green circle check icon at top
  - "Property Created!" heading
  - "[Property name] has been successfully added to your portfolio." subtitle
  - PROPERTY SUMMARY section:
    - "NEWLY REGISTERED" label
    - Property name with building icon
    - Address with location icon
    - Tags: property type + unit count
  - Info card: "Your property is now live. You can start creating leases and processing rent payments immediately."
  - "View Property ->" blue button
  - "Invite Your First Tenant" outlined button with person+ icon
  - "+ Add Another Property" text link
- **Key Components:** Success icon, property summary card, 3 action options
- **State Variants:** Single state

---

## D. INVITE FLOW

### D1. Invite Tenant.png
- **Feature/Module:** Invitations
- **Flutter Screen:** `InviteTenantScreen`
- **Route:** `/invite`
- **UI Purpose:** Send a secure invitation to a prospective tenant
- **Required Functionality:**
  - App bar: back arrow + circle icon + "Invite Tenant"
  - RECIPIENT DETAILS section (blue left border):
    - Tenant Full Name field (person icon)
    - Email Address field (mail icon)
  - PROPERTY ASSIGNMENT section (blue left border):
    - Property & Unit dropdown (e.g., "Sunset Heights - Unit 4B")
    - Proposed Start Date (calendar, e.g., "September 1, 2024")
  - PERSONALIZED MESSAGE section with "Customizable" link:
    - Tone chips: Professional (selected) | Friendly | Urgent
    - MESSAGE PREVIEW: editable text area with pre-filled message
  - Invitation Expiry Preview: warning card "This link will remain active for 7 days..."
  - Info footer about tenant receiving secure link
  - "Send Secure Invitation" blue button (full width)
- **Key Components:** Form with recipient/property/message sections, tone selector chips, expiry warning, send button
- **State Variants:** Empty form, filled form, sending state

### D2. Invite Sent Confirmation.png
- **Feature/Module:** Invitations
- **Flutter Screen:** `InviteSentScreen`
- **Route:** `/invite/sent`
- **UI Purpose:** Confirmation after invite sent
- **Required Functionality:**
  - "LeaseFlow" header with X close (note: should be AYRNOW branding)
  - Blue circle check icon
  - "Invite Sent Successfully!" heading
  - "We've sent an invitation link to the tenant." subtitle
  - Tenant card: avatar, name, email, "Pending" status badge
  - PROPERTY & UNIT + EXPIRES IN info
  - "View Invite Status" blue button
  - OTHER ACTIONS section: "Resend Invitation" (with icon + chevron), "Copy Direct Link" (with icon + chevron)
  - "Return to Leases" outlined button
  - Bottom nav: Home | Leases | Payments | Settings
- **Key Components:** Success icon, tenant info card, status info, action buttons
- **State Variants:** Single state

### D3. Invite Expired_Invalid.png
- **Feature/Module:** Invitations
- **Flutter Screen:** `InviteExpiredScreen`
- **Route:** `/invite/expired`
- **UI Purpose:** Show when tenant opens expired/invalid invite link
- **Required Functionality:**
  - App bar: back arrow + "Access Denied"
  - Red shield icon with clock overlay
  - "Invitation Expired" heading
  - "Security Protocol: Link Timed Out" badge
  - Explanation text about 48-hour validity
  - PROPERTY DETAILS card: property + unit name
  - Landlord info: avatar + name + "(Landlord)" + message icon
  - "Request New Invitation" red button
  - "Contact Landlord Directly ->" outlined button
  - Footer: error contact info
- **Key Components:** Error icon, property/landlord info, recovery action buttons
- **State Variants:** Expired, Invalid/already used

### D4. Pending Invites.png
- **Feature/Module:** Invitations
- **Flutter Screen:** `PendingInvitesScreen`
- **Route:** `/invitations`
- **UI Purpose:** Landlord view of all pending invitations
- **Required Functionality:**
  - App bar: back arrow + "Pending Invites" + notification + search icons
  - Filter tabs: "3 Pending" | "1 Expiring Soon" + "Sort by: Newest"
  - Search bar: "Search by name, email or unit..."
  - Invite cards, each with:
    - Tenant avatar + name + email
    - Property name + unit
    - Sent date + days left badge (e.g., "1 day left" orange, "4 days left" green)
    - Action buttons: "Cancel" (red outlined) + "Resend" (blue filled)
  - Info card at bottom: "Managing Expiry" tip about 7-day auto-expiry
  - Blue FAB (person+ icon)
  - Bottom nav: Leases | Payments | Invites | Account
- **Key Components:** Filter tabs, search, invite cards with expiry countdown, cancel/resend actions
- **State Variants:** With invites, empty, filtered

### D5. Tenant Invite Acceptance.png
- **Feature/Module:** Invitations (Tenant-facing)
- **Flutter Screen:** `TenantInviteAcceptScreen`
- **Route:** `/invite/accept/:code`
- **UI Purpose:** Tenant views and accepts invitation
- **Required Functionality:**
  - Back arrow + home icon
  - Property hero image
  - "You're Invited!" heading (blue gradient text)
  - "Join the resident portal for your new home."
  - INVITATION FOR card: property name + unit + "Pending" status
  - Landlord info: avatar + name + "Property Manager"
  - Monthly Rent amount + Move-in Date
  - "Accept Invitation" section with explanation text
  - "Accept & Create Account ->" blue button
  - "ALREADY HAVE AN ACCOUNT?" + "Log In to Existing Account" link
  - Trust badges: Secure Data | Verified Host | Easy Comms
  - Terms footer
- **Key Components:** Property image, invitation details, landlord info, accept/login buttons, trust badges
- **State Variants:** Valid invitation, loading

### D6. Tenant Invite Verification.png
- **Feature/Module:** Invitations (Tenant-facing)
- **Flutter Screen:** `TenantInviteVerifyScreen`
- **Route:** `/invite/verify/:code`
- **UI Purpose:** Tenant sets up account credentials after accepting invite
- **Required Functionality:**
  - AYRNOW icon + "Verify Invite" title
  - "Welcome to your new home!" heading + subtitle
  - Property image with "Assigned Unit" badge
  - Property name + unit + address
  - Landlord + Move-in Date info
  - Security Setup section:
    - Invitation Email field (pre-filled, read-only)
    - Create Password field with visibility toggle
    - Confirm Password field
    - Password requirements list (8+ chars, 1 Uppercase, 1 Number, Matches)
  - "Accept Invite & Continue" blue button
  - Terms footer with links
- **Key Components:** Property summary, password setup form with requirements, accept button
- **State Variants:** Default, password validation states

---

## E. LEASE MANAGEMENT

### E1. Lease Settings Overview.png
- **Feature/Module:** Lease Settings
- **Flutter Screen:** `LeaseSettingsScreen`
- **Route:** `/properties/:id/lease-settings`
- **UI Purpose:** View global/property-level lease defaults
- **Required Functionality:**
  - App bar: back arrow + "Lease Settings" + settings/bookmark icons
  - "Global Lease Defaults" header with info text + "Edit Defaults" link
  - Financial Terms section:
    - Rent Due Day: "1st of month"
    - Security Deposit: "1.5x Rent"
    - Late Fee: "5% of Rent"
  - General Policies section:
    - Grace Period: "3 Days"
    - Occupancy Limit: "2 Per Room"
  - Standard Clauses section:
    - Clause list items with Active/Optional badges (Maintenance Responsibilities, Right of Entry, Pet Policy, Subletting Prohibition)
    - "+ Manage Custom Clauses" link
  - "Update Global Settings" blue button
  - Footer: "Changes will not affect signed leases, only new drafts created after saving."
  - Bottom nav: Dashboard | Properties | Leases | Payments | Account
- **Key Components:** Settings display with values, clause list with badges, update button
- **State Variants:** View mode (this), edit mode (E2)

### E2. Lease Settings: Edit.png
- **Feature/Module:** Lease Settings
- **Flutter Screen:** `LeaseSettingsEditScreen`
- **Route:** `/properties/:id/lease-settings/edit`
- **UI Purpose:** Edit lease defaults for a property
- **Required Functionality:**
  - App bar: back arrow + "Edit Defaults" + "Save" link
  - "Lease Configuration" heading + description
  - General Terms: Default Lease Term input (12) + "Months" label, auto-renewal checkbox
  - Rent & Deposit: Base Rent ($1200), Deposit ($1200) side by side, Rent Due Day selector
  - Late Fee Settings: Grace Period (Days) input (3), Late Fee Amount ($50), POLICY PREVIEW card ("Late after 3 days, $50 flat fee.")
  - Standard Clauses: numbered clause blocks with editable text, "Edit Clause" links, "+ Add Custom Clause"
  - Internal Admin Notes textarea
  - "Save Global Defaults" blue button
- **Key Components:** Editable form fields, policy preview card, clause editor, notes, save button
- **State Variants:** Editing with validation

### E3. Create Lease: Select Property.png
- **Feature/Module:** Leases
- **Flutter Screen:** `CreateLeaseScreen` (step 1 of 5)
- **Route:** `/leases/create`
- **UI Purpose:** Step 1: select property and unit for new lease
- **Required Functionality:**
  - App bar: back arrow + "New Lease" + info icon
  - "STEP 1 OF 5" + "Lease Creation" label
  - "Select Property & Unit" heading + subtitle
  - Search bar + filter icon
  - Property cards with: image, address overlay, property name, unit count + available count badge
  - "Next: Tenant Information" blue button
- **Key Components:** Step indicator, search, property selection cards with images
- **State Variants:** No selection, property selected

### E4. Create Lease: Tenant Information.png
- **Feature/Module:** Leases
- **Flutter Screen:** `CreateLeaseScreen` (step 2 of 5)
- **Route:** `/leases/create` (step 2)
- **UI Purpose:** Step 2: select or invite tenant
- **Required Functionality:**
  - App bar with step info "Step 2 of 5" + "40% Complete"
  - "Select Tenant" heading + subtitle
  - Search bar: "Search by name, email, or phone..." + filter icon
  - "SUGGESTED TENANTS" label + count
  - Tenant list: avatar + name + verified badge + email + phone + radio button selection
  - "Invite a New Tenant" section: person+ icon, "Can't find them? Send a secure invitation...", "Create new profile ->" link
  - "Back" + "Next Step ->" buttons
- **Key Components:** Search, tenant list with radio selection, invite new option, nav buttons
- **State Variants:** No selection, tenant selected

### E5. Create Lease: Lease Terms.png
- **Feature/Module:** Leases
- **Flutter Screen:** `CreateLeaseScreen` (step 3 of 5)
- **Route:** `/leases/create` (step 3)
- **UI Purpose:** Step 3: define financial terms and dates
- **Required Functionality:**
  - "STEP 3 OF 5" + "60%" progress
  - "Lease Terms" heading + subtitle
  - LEASE PERIOD: Start Date picker + End Date picker + "Typically 12 months" helper
  - FINANCIALS: Monthly Rent Amount ($2400 + "MONTHLY" tag), Security Deposit ($2400 + "ONE-TIME" tag)
  - BILLING DETAILS: Rent Due Day dropdown ("1st of the month"), Pro-rated Rent info card
  - Lease Summary card: "Total Annual Rent: $28,800"
  - "Continue to Clauses ->" blue button
  - "Save Progress as Draft" link with save icon
- **Key Components:** Date pickers, financial inputs with tags, billing dropdown, summary card, save draft
- **State Variants:** Empty, filled with summary calculated

### E6. Create Lease: Clauses & Notes.png
- **Feature/Module:** Leases
- **Flutter Screen:** `CreateLeaseScreen` (step 4 of 5)
- **Route:** `/leases/create` (step 4)
- **UI Purpose:** Step 4: add legal clauses and internal notes
- **Required Functionality:**
  - "CREATE LEASE" header with step circles (4 highlighted)
  - "Clauses & Notes" heading + subtitle
  - CLAUSE TEMPLATES: horizontal scroll cards (Pet Policy, Late Fees) with "+Add" buttons
  - ACTIVE CLAUSES (3): numbered list with expandable text, "+ Add Custom" button, "Edit Clause" links
  - INTERNAL NOTES: textarea for private landlord notes (not visible to tenant)
  - "Back" + "Review Lease ->" blue button
- **Key Components:** Template cards, clause list editor, private notes, navigation
- **State Variants:** No clauses, with clauses

### E7. Create Lease: Review.png
- **Feature/Module:** Leases
- **Flutter Screen:** `CreateLeaseScreen` (step 5 of 5)
- **Route:** `/leases/create` (final step)
- **UI Purpose:** Final review before generating lease
- **Required Functionality:**
  - "Review Lease" title + "FINAL STEP" label + 3-dot menu
  - Step progress circles (5 filled)
  - "Lease Agreement Ready" badge with version + date
  - Sections with "Edit" links: Property & Unit, Tenant Details, Lease Terms, Clauses & Notes
  - "Send for Signature" blue button with checkmark icon
  - Bottom actions: "PDF Preview" + "Save Draft"
- **Key Components:** Review sections with edit links, generate/send button, preview option
- **State Variants:** Complete review

### E8. Leases List (Empty).png
- **Feature/Module:** Leases
- **Flutter Screen:** `LeaseListScreen`
- **Route:** `/leases`
- **UI Purpose:** Empty state for lease management
- **Required Functionality:**
  - "Lease" title
  - Document illustration with green plus badge
  - "No active leases yet" heading
  - Subtitle about creating first lease
  - HOW IT WORKS: 3 items (Configure Terms, Digital E-Signing, Secure Management) with icons
  - "+ Create First Lease" blue button
  - "Need help? View our Leasing Guide" link
  - Bottom nav: Dashboard | Properties | Leases | Payments | Account
- **Key Components:** Illustration, how-it-works items, CTA button
- **State Variants:** Empty only

### E9. Leases List (Populated).png
- **Feature/Module:** Leases
- **Flutter Screen:** `LeaseListScreen`
- **Route:** `/leases`
- **UI Purpose:** Browse all leases with status filtering
- **Required Functionality:**
  - AYRNOW icon + "Leases" title + notification bell + filter icon
  - Search bar: "Search properties or tenants..."
  - "LEASE PORTFOLIO" banner with document icon + "12 Active Leases" count
  - Filter tabs: All | Drafts | Sent | Active
  - Lease cards, each with:
    - Property image thumbnail (small square)
    - Status badge (Executed=green, Sent=blue, Draft=grey, Signed=teal)
    - Property name + unit
    - Tenant avatar + name + 3-dot menu
    - MONTHLY RENT + LEASE TERM
    - "View" + "PDF" action links + chevron
  - "Showing 4 of 12 leases" + "Load more" link
  - Blue FAB (+) button
  - Bottom nav: Home | Leases | Payments | Account
- **Key Components:** Search, portfolio banner, filter tabs, lease cards with images and status
- **State Variants:** All, filtered by status

### E10. Lease Details (Draft).png
- **Feature/Module:** Leases
- **Flutter Screen:** `LeaseDetailScreen`
- **Route:** `/leases/:id`
- **UI Purpose:** View full lease details
- **Required Functionality:**
  - App bar: back arrow + "Lease Details" + 3-dot menu
  - "Draft Mode" green badge + property image + address + "Move-in starts in 12 days"
  - PRIMARY TENANT section: avatar + name + email + "Edit Contact" link
  - LEASE TERMS: Monthly Rent ($2,850) + Security Deposit ($2,850), Start Date + Lease Duration
  - REVIEW & FILES: PDF Preview link, Clauses & Rules (count), Download Assets
  - LANDLORD NOTES: yellow card with note text
  - Bottom buttons: "Edit" (outlined) + "Send to Sign" (red/coral filled)
- **Key Components:** Status badge, property image, tenant card, terms display, files section, notes, action buttons
- **State Variants:** Draft, Sent, Signed, Executed (different action buttons per status)

---

## F. SIGNING FLOW

### F1. Generated Lease Ready.png
- **Feature/Module:** Leases / Signing
- **Flutter Screen:** `LeaseReadyScreen`
- **Route:** `/leases/:id/ready`
- **UI Purpose:** Show generated lease PDF ready for signatures
- **Required Functionality:**
  - App bar: back arrow + "Lease Ready" + "Agreement #L-99203" + green info icon
  - "Generated" green badge
  - PDF file card: filename + "READY FOR SIGNATURE" + file size + "Preview Full PDF" link
  - LEASE DETAILS: property name + unit + address, Monthly Rent, Start Date, Lease Term, Deposit
  - REQUIRED SIGNERS: landlord entry (name + email + "Verified" badge), tenant entry (name + email + "Verified" badge)
  - Disclaimer text about "Send for Signature"
  - "Edit" link + "Send to Sign" coral/red button
- **Key Components:** PDF info card, lease summary, signer list with verification, send button
- **State Variants:** Ready to send

### F2. Lease Signing.png
- **Feature/Module:** Leases / Signing
- **Flutter Screen:** `LeaseSigningScreen`
- **Route:** `/leases/:id/sign`
- **UI Purpose:** Electronic signature capture
- **Required Functionality:**
  - App bar: back arrow + "E-Sign Lease" + help/share icons
  - DOCUMENT SUMMARY: property name + unit + address, Term + Monthly Rent
  - SIGNER IDENTITY: avatar + name + email + "Primary Tenant" badge + "ID VERIFIED BY AYRNOW"
  - E-SIGNATURE section: "Clear" link, signature pad area ("Draw your signature here. Use your finger or a stylus."), "END OF DOCUMENT SIGNATURE AREA" label
  - Consent checkboxes: "I have read and agree to the Lease Agreement, Rules & Regulations, and Privacy Policy." + "I consent to receive all legal communications and notices electronically..."
  - "Sign & Confirm Lease" blue button
  - Footer: "A SECURE COPY OF THIS DOCUMENT WILL BE SENT TO YOUR EMAIL AFTER SIGNING."
- **Key Components:** Document summary, signer identity card, signature pad, consent checkboxes, confirm button
- **State Variants:** Empty signature, signature drawn, submitting

### F3. Lease Signing Status.png
- **Feature/Module:** Leases / Signing
- **Flutter Screen:** `SigningStatusScreen`
- **Route:** `/leases/:id/signing-status`
- **UI Purpose:** Track signing progress timeline
- **Required Functionality:**
  - App bar: "Signing Status" + "LEASE #L-99231" + 3-dot menu
  - Property image + name + unit info
  - "Overall Progress" bar: "3 of 4 Steps Complete" + 75%
  - Status badge: "Awaiting tenant signature"
  - TIMELINE TRACKING with "Real-time" toggle:
    - Lease Drafted (check, date/time, by whom)
    - Sent for Signature (check, date/time, to whom)
    - Landlord Signed (check, date/time, by whom)
    - Tenant Signature Required (current, waiting icon, "Send Reminder" button)
    - Fully Executed (future, greyed)
  - CURRENT DOCUMENT: PDF card with Download + View links
  - "View Metadata" + "Update Lease" buttons
- **Key Components:** Progress bar, timeline with statuses, reminder action, document card
- **State Variants:** Various progress states (1/4 through 4/4)

### F4. Lease Signed Success.png
- **Feature/Module:** Leases / Signing
- **Flutter Screen:** `LeaseSignedScreen`
- **Route:** `/leases/:id/signed`
- **UI Purpose:** Confirmation after lease fully signed
- **Required Functionality:**
  - Blue circle check icon
  - "Lease Signed!" heading + "Congratulations!" subtitle with unit/property info
  - YOUR SIGNED COPY: PDF filename + size + "PDF DOCUMENT" tag
  - FINALIZE ONBOARDING section:
    - Setup Rent Payments (Required badge, chevron)
    - Upload Remaining Docs (Required badge, chevron)
  - "Go to Dashboard" blue button with grid icon
  - Footer: "You can access your lease and all documents anytime from your profile."
- **Key Components:** Success icon, PDF info, onboarding next steps with required badges, dashboard button
- **State Variants:** Single state

### F5. Lease Review.png
- **Feature/Module:** Leases / Signing (tenant pre-sign)
- **Flutter Screen:** `TenantLeaseReviewScreen`
- **Route:** `/leases/:id/review`
- **UI Purpose:** Tenant reviews lease highlights before signing
- **Required Functionality:**
  - App bar: back arrow + "Review Lease" + "Draft" badge
  - Lease Highlights: 4 cards in 2x2 — Monthly Rent ($2,450), Lease Term (12 Months), Security Deposit ($2,450), Move-in Date (Oct 01, 2024)
  - Lease Agreement PDF viewer: embedded PDF preview with "Page 1 of 12" + "Tap to view all 12 pages"
  - Required Actions checklist:
    - Confirm personal details (circle)
    - Review security deposit terms (circle)
    - Read and accept house rules + "Start" link
  - Legal disclaimer text
  - "Ready to finalize?" + "Step 3 of 4" indicator
  - "Go to Lease Signing ->" blue button
- **Key Components:** Highlight cards, PDF viewer, action checklist, sign button
- **State Variants:** Actions incomplete, all complete

---

## G. TENANT VIEW LEASE

### G1. View Lease.png
- **Feature/Module:** Tenant / Lease
- **Flutter Screen:** `TenantViewLeaseScreen`
- **Route:** `/lease` (tenant tab)
- **UI Purpose:** Tenant views their active lease details
- **Required Functionality:**
  - AYRNOW icon + "My Lease" title + info icon
  - CURRENT LEASE card: "Active" green badge, "$1,850.00 per month - Due on the 1st", address, term dates
  - "Download PDF" button + external link icon
  - "Document Preview" section: embedded PDF preview with "Page 1 of 12" + "Zoom"
  - Lease Details cards:
    - Security Deposit: $1,850.00 + "Held in Escrow" badge
    - Notice Period: 60 Days + "End Lease ->" link
    - Utility Responsibility: "Tenant Paid" + "Water/Trash Incl."
  - "Need to make a change?" + "Contact" button
  - Bottom nav: Home | Lease | Pay | Docs | Account
- **Key Components:** Lease summary card, PDF preview, detail cards with actions, contact option
- **State Variants:** Active lease, no lease

---

## H. PAYMENTS

### H1. Landlord Payments (Empty).png
- **Feature/Module:** Payments (Landlord)
- **Flutter Screen:** `LandlordPaymentsScreen`
- **Route:** `/payments` (landlord)
- **UI Purpose:** Empty state for payment setup
- **Required Functionality:**
  - AYRNOW icon + "Payments" title + gear icon
  - Shield/wallet illustration
  - "Unlock Effortless Rent Collection" heading
  - Subtitle about connecting payment provider
  - "Connect Payment Provider ->" blue button
  - HOW IT WORKS: 3 numbered steps (Secure Connection, Set Billing Rules, Start Collecting)
  - Security badges: "PCI COMPLIANT" + "STRIPE VERIFIED" + "AES-256 BIT"
  - "Need help? Read our Payments Guide" link
  - Bottom nav: (partial) Leases | Payments | Documents | Account
- **Key Components:** Illustration, CTA button, setup steps, security badges
- **State Variants:** Empty/not connected

### H2. Landlord Payments (Populated).png
- **Feature/Module:** Payments (Landlord)
- **Flutter Screen:** `LandlordPaymentsScreen`
- **Route:** `/payments` (landlord)
- **UI Purpose:** Active payment overview with transactions
- **Required Functionality:**
  - AYRNOW icon + "Payments" title + notification bell
  - TOTAL COLLECTED (MAY) card: $12,450.00 + green trend badge (+12.5%)
  - OUTSTANDING ($1,200.00) + NEXT PAYOUT ($8,340.20) side by side
  - Search bar: "Search tenants or units..."
  - Filter tabs: All | Pending | Paid | Overdue
  - "RECENT TRANSACTIONS" + "View Ledger" link
  - Transaction list: tenant avatar + name + property/unit + amount + status badge (Paid=green, Overdue=red, Pending=yellow)
  - Blue FAB (arrow up icon)
  - Bottom nav: Leases | Units | Payments | Account
- **Key Components:** Revenue stats, search, filter tabs, transaction list with status badges
- **State Variants:** Populated, filtered

### H3. Payment Ledger.png
- **Feature/Module:** Payments
- **Flutter Screen:** `PaymentLedgerScreen`
- **Route:** `/payments/ledger/:id`
- **UI Purpose:** Detailed tenant payment ledger
- **Required Functionality:**
  - App bar: back arrow + "Ledger Detail" + unit badge + filter icon
  - Running Balance card (blue): $2,450.00 Credit
  - PAID THIS MONTH ($3,200) + OUTSTANDING ($0.00) side by side
  - Statement Period with date range
  - "Export PDF" button
  - Tenant info: avatar + name + "24 Month Lease" + "Signed" badge
  - Recent Activity with "View All":
    - Transaction entries: icon + description + date + amount + status (Paid=green, Overdue=red)
    - Types: Monthly Rent Payment, Water & Sewage Utility, Security Deposit Refund, Late Payment Surcharge
  - Totals: Total Invoiced (YTD) + Total Received (YTD) + Outstanding Balance
  - Blue FAB (+)
  - Bottom nav: Leases | Payments | Ledger | Settings
- **Key Components:** Balance card, transaction history, export, totals summary
- **State Variants:** With transactions, empty period

### H4. Rent Payment.png
- **Feature/Module:** Payments (Tenant)
- **Flutter Screen:** `RentPaymentScreen`
- **Route:** `/pay`
- **UI Purpose:** Tenant selects payment method and pays rent
- **Required Functionality:**
  - App bar: back arrow + "Rent Payment"
  - PAYMENT METHOD section:
    - Visa card (selected, blue border): "Visa .... 4242" + "Expires 12/26" + check icon
    - Bank account (unselected): "Chase Bank .... 8891" + "Personal Checking" + "VERIFIED"
    - "+ Add New Payment Method" link
  - TRANSACTION SUMMARY:
    - October Rent: $1,850.00
    - Maintenance Fee: $12.00
    - Convenience Fee: $3.50
    - Total to Pay: $1,865.50 (bold)
  - Info card: "A transaction receipt will be sent to your registered email..."
  - "SECURE SSL ENCRYPTED TRANSACTION" badge with shield
  - "Pay $1,865.50" blue button
  - Disclaimer about authorization
- **Key Components:** Payment method cards with selection, transaction breakdown, security badge, pay button
- **State Variants:** Method selected, no method, processing

### H5. Rent Payment Success.png
- **Feature/Module:** Payments (Tenant)
- **Flutter Screen:** `PaymentSuccessScreen`
- **Route:** `/pay/success`
- **UI Purpose:** Payment confirmation
- **Required Functionality:**
  - Green circle check icon
  - "Payment Successful!" heading
  - "Your rent for October 2023 has been processed." subtitle
  - TRANSACTION ID + "COMPLETED" badge
  - Details: Property, Unit, Date & Time, Payment Method
  - PAYMENT SUMMARY: Base Rent + Utility Surcharge + Total Paid (bold)
  - "Save PDF" + "Share" buttons side by side
  - "Go to Dashboard" blue button
  - "View Lease Agreement" link
  - Footer: confirmation email notice
- **Key Components:** Success icon, transaction details, payment breakdown, save/share actions
- **State Variants:** Single state

---

## I. DOCUMENTS

### I1. Document Upload_Status.png
- **Feature/Module:** Documents (Tenant)
- **Flutter Screen:** `TenantDocumentsScreen`
- **Route:** `/docs` (tenant tab)
- **UI Purpose:** Tenant manages required document uploads
- **Required Functionality:**
  - AYRNOW icon + "My Documents" title
  - SUBMISSION PROGRESS card: "2 of 4 Verified documents" + 50% progress bar + "50% Complete"
  - Required Documents list:
    - Government Issued ID: description, last updated date, "APPROVED" green badge, "View" link
    - Proof of Income: description, last updated date, "UNDER REVIEW" yellow badge, "View" link
    - Renters Insurance: description, "MISSING" red badge, "Upload" blue button
    - Pet Vaccinations: "Optional" label, "Upload" outlined button
  - Additional Support Docs section: "+ Add Extra File" button
  - "Need help with your documents? Contact Landlord Support" link
  - Bottom nav: Home | Lease | Pay | Docs | Account
- **Key Components:** Progress indicator, document list with status badges, upload buttons
- **State Variants:** Various completion levels

### I2. Pending Documents Review.png
- **Feature/Module:** Documents (Landlord)
- **Flutter Screen:** `PendingDocumentReviewScreen`
- **Route:** `/documents/review`
- **UI Purpose:** Landlord reviews tenant-submitted documents
- **Required Functionality:**
  - App bar: back arrow + "Pending Reviews" + notification icon
  - "TOTAL PENDING" count + document icon
  - "AWAITING APPROVAL" label + filter icon
  - Document cards, each with:
    - Tenant avatar + name + "Awaiting Review"/"Under Review" badge
    - Unit info
    - Document type tag (Insurance, Income Proof, Gov ID)
    - Document thumbnail/preview image
    - Filename + upload time
    - "Request Changes" (orange) + "Approve" (green) buttons
  - Bottom nav: Leases | Payments | Docs | Profile
- **Key Components:** Document cards with thumbnails, tenant info, review action buttons
- **State Variants:** With pending docs, empty

---

## J. MOVE-OUT

### J1. Move-Out Request.png
- **Feature/Module:** Move-Out (Tenant)
- **Flutter Screen:** `MoveOutRequestScreen`
- **Route:** `/move-out`
- **UI Purpose:** Tenant submits formal move-out request
- **Required Functionality:**
  - App bar: back arrow + "Move-Out Request"
  - Notice info banner (blue): "60-Day Notice Required" with lease reference
  - PLANNED TIMELINE: "REQUESTED MOVE-OUT DATE" date picker (calendar)
  - Notice period met indicator (green check)
  - FORWARDING ADDRESS: Street Address, City, Zip Code fields
  - REASON FOR MOVING: chip tags (Buying a Home, Relocation, Upsizing, Downsizing), Additional Comments textarea
  - Consent checkbox: "I understand that submitting this request initiates my move-out process..."
  - "Request Move-Out" blue button
- **Key Components:** Notice banner, date picker, address form, reason chips + textarea, consent checkbox
- **State Variants:** Empty form, filled, submitted

### J2. Pending Move-Out Requests.png
- **Feature/Module:** Move-Out (Landlord)
- **Flutter Screen:** `PendingMoveOutsScreen`
- **Route:** `/move-outs`
- **UI Purpose:** Landlord reviews pending move-out requests
- **Required Functionality:**
  - AYRNOW icon + "Move-Outs" title + refresh icon
  - Summary banner: "3 Pending Requests" + "Earliest move-out in 14 days" chevron
  - "PENDING REVIEW" label + "Most Recent" sort
  - Request cards, each with:
    - Tenant avatar + name + property + unit
    - PROPOSED DATE with calendar icon
    - Urgency badge (e.g., "URGENT" red)
    - Reason text
    - Action buttons: "Approve" (blue) + "Details" (outlined) + reject (red X icon)
  - "End of List" footer
  - Bottom nav: Leases | Payments | Requests | Account
- **Key Components:** Summary banner, request cards with urgency, approve/details/reject actions
- **State Variants:** With requests, empty

---

## K. TENANT SCREENS

### K1. Tenant Dashboard (Pre-Active).png
- **Feature/Module:** Tenant Dashboard
- **Flutter Screen:** `TenantDashboardScreen`
- **Route:** `/home` (tenant, pre-move-in state)
- **UI Purpose:** Pre-move-in dashboard with countdown and onboarding
- **Required Functionality:**
  - AYRNOW icon + "My New Home" title
  - COUNTDOWN TO MOVE-IN card: "12 Days to go" with icon, "Keys available starting [date]"
  - UNIT ADDRESS: property name + unit + full address
  - Onboarding Checklist with "65% Complete":
    - Verify Identity (check, completed)
    - Review & Sign Lease (check, completed)
    - Set Up Auto-Pay (chevron, incomplete)
    - Utilities Transfer (chevron, incomplete)
  - Quick cards: "Lease" (Active) + "Documents" (Updated) - side by side
  - "Need help moving? Contact your landlord directly ->" link
  - Bottom nav: Home | Lease | Pay | Docs | Account
- **Key Components:** Countdown card, address info, onboarding checklist, quick access cards
- **State Variants:** Pre-active with countdown

### K2. Tenant Dashboard (Active).png
- **Feature/Module:** Tenant Dashboard
- **Flutter Screen:** `TenantDashboardScreen`
- **Route:** `/home` (tenant, active state)
- **UI Purpose:** Active tenant dashboard with payment and quick actions
- **Required Functionality:**
  - AYRNOW icon + "Dashboard" title + notification icon
  - Greeting: "Hello, [Name]" with avatar, unit + property subtitle
  - NEXT PAYMENT DUE banner: date + "$1,450.00" + "Standard Monthly Rent + Utilities"
  - "Pay Now" green button (full width)
  - Quick Actions 2x2 grid: View Lease (document icon), Upload Docs (upload icon), History (clock icon), Maintenance (wrench icon)
  - Required Documents alert: "Renters Insurance Policy" + "Expires in 5 days" + chevron
  - RECENT ACTIVITY list: payment, lease addendum, maintenance entries with amounts/dates
  - Bottom nav: Home | Lease | Pay | Docs | Account
- **Key Components:** Greeting with avatar, payment banner, pay button, quick actions grid, activity feed
- **State Variants:** Active with upcoming payment

### K3. Tenant Onboarding.png
- **Feature/Module:** Tenant Onboarding
- **Flutter Screen:** `TenantOnboardingScreen`
- **Route:** `/onboarding` (tenant)
- **UI Purpose:** Guided tenant onboarding checklist
- **Required Functionality:**
  - AYRNOW icon + "Onboarding" title
  - YOUR JOURNEY section: "Almost there, [Name]!" + 25% COMPLETE + progress bar + "1 of 4 tasks completed"
  - REQUIRED STEPS checklist:
    - Complete Profile (person icon) — DONE (green)
    - Upload Documents (upload icon) — "Start >" link
    - Add Payment Method (card icon) — "Start >" link
    - Review Lease (document icon) — incomplete (circle)
  - Pro-tip info card: "Having your government ID and latest bank statements ready..."
  - "Continue to Lease Review ->" blue button
- **Key Components:** Progress bar, checklist with step statuses, pro-tip card, continue button
- **State Variants:** Various completion levels (0-100%)

### K4. Tenant Account_Settings.png
- **Feature/Module:** Account (Tenant)
- **Flutter Screen:** `TenantAccountScreen`
- **Route:** `/account` (tenant)
- **UI Purpose:** Tenant account management
- **Required Functionality:**
  - AYRNOW icon + "Account Settings" title
  - Avatar + name + "Gold Tenant" badge + email + "Edit Profile" button
  - FINANCIALS section: Payment Methods ("Visa ending in 4242"), Payment History ("View all past rent receipts")
  - PROPERTY section: Current Lease ("Unit 402 - Active until Dec 2024"), Move-Out Request ("Start the formal end of tenancy")
  - PREFERENCES section: Push Notifications toggle (on), Security & Privacy link
  - SUPPORT section: Help Center ("FAQs and tenant guidelines"), Contact Support ("Direct chat with property manager")
  - "Sign Out" red button + "AYRNOW V2.4.0 - BUILD 882" version
  - Bottom nav: Home | Lease | Pay | Docs | Account
- **Key Components:** Profile card with badge, sectioned settings list, sign out button
- **State Variants:** Single state

---

## L. NOTIFICATIONS

### L1. Notifications.png
- **Feature/Module:** Notifications
- **Flutter Screen:** `NotificationsScreen`
- **Route:** `/notifications`
- **UI Purpose:** Centralized notification feed
- **Required Functionality:**
  - App bar: back arrow + "Notifications" + settings + 3-dot icons
  - "You have 2 unread notifications" banner + "Mark all read" link
  - Grouped by date: TODAY, YESTERDAY
  - Notification cards with:
    - Colored icon (blue=lease/document, green=payment, orange=message)
    - Title text (bold)
    - Time ago label
    - Description text
    - Type tag (Lease, Payment, Tenant, Message)
  - "You're all caught up!" footer
  - Blue FAB (+) button
- **Key Components:** Date-grouped list, notification cards with type icons, mark-read actions
- **State Variants:** With unread, all read, empty
