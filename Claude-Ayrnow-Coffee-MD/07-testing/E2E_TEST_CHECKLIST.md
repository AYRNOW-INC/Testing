# AYRNOW E2E Test Checklist

Manual verification checklist for testing AYRNOW on iOS simulators.
Run on two simultaneous simulators: iPhone 17 Pro (Landlord) and iPhone 16e (Tenant).

## Prerequisites

- [ ] PostgreSQL 16 running (`brew services start postgresql@16`)
- [ ] Backend running on `localhost:8080` (`cd backend && mvn spring-boot:run`)
- [ ] Both iOS simulators booted
- [ ] Frontend deployed to both sims (`flutter run -d <sim_id>`)

---

## 1. Landlord Registration + Login (TASK-10a)

**Simulator: iPhone 17 Pro**

- [ ] App launches to splash/welcome screen with AYRNOW logo
- [ ] Tap "Sign In" navigates to login screen
- [ ] Tap "Create an account" navigates to register screen
- [ ] Fill in first name, last name, email, password
- [ ] Password requirements indicator shows live feedback
- [ ] Tap "Next: Account Type" goes to role selection
- [ ] Select "I am a Landlord" (card highlights with SELECTED badge)
- [ ] Tap "Continue" completes registration
- [ ] Redirected to landlord dashboard (bottom nav: Dashboard | Properties | Leases | Payments | Account)
- [ ] Logout from Account screen
- [ ] Login again with same credentials
- [ ] Lands back in landlord dashboard
- [ ] Google sign-in button opens Authgear hosted page (requires Authgear credentials)
- [ ] Apple sign-in button opens Authgear hosted page (requires Authgear credentials)

**Error cases:**
- [ ] Invalid email shows validation error
- [ ] Short password shows validation error
- [ ] Wrong password on login shows error SnackBar
- [ ] Duplicate email registration shows error

---

## 2. Property Creation + Unit Setup (TASK-10b)

**Simulator: iPhone 17 Pro (logged in as landlord)**

- [ ] Navigate to Properties tab
- [ ] Empty state shows when no properties exist
- [ ] Tap "Add Property" / FAB
- [ ] Fill in property name, type (Residential), address fields
- [ ] Save property successfully
- [ ] Property appears in list
- [ ] Tap property to view details
- [ ] Property detail screen shows correct information
- [ ] Add unit: tap add unit button
- [ ] Fill in unit name (e.g., "Apt 101"), type, monthly rent
- [ ] Save unit
- [ ] Unit appears in property detail
- [ ] Edit unit: change rent amount
- [ ] Save edit, verify change persists
- [ ] Delete unit (if implemented)
- [ ] Back navigation works from all screens

---

## 3. Lease Settings (TASK-10d)

**Simulator: iPhone 17 Pro**

- [ ] From property detail/list, access lease settings (one-tap access)
- [ ] Lease settings screen loads with default values or empty form
- [ ] Set default lease term (e.g., 12 months)
- [ ] Set default monthly rent
- [ ] Set default security deposit
- [ ] Set payment due day (e.g., 1st)
- [ ] Set grace period (e.g., 5 days)
- [ ] Set late fee amount
- [ ] Save settings
- [ ] Navigate away and return -- settings persist

---

## 4. Tenant Invitation (TASK-10c)

**Simulator: iPhone 17 Pro**

- [ ] From property detail, select a unit
- [ ] Tap invite tenant
- [ ] Enter tenant email address
- [ ] Send invitation
- [ ] Success confirmation shown
- [ ] Invitation appears in invitations list with PENDING status
- [ ] Invite code is visible/copyable
- [ ] Note the invite code for tenant simulator

---

## 5. Tenant Registration + Invite Accept (TASK-10c)

**Simulator: iPhone 16e**

- [ ] App launches to welcome screen
- [ ] Option A: Tap "Have an invite code?" on login screen
  - [ ] Enter invite code in dialog
  - [ ] Invitation details shown (property, unit, landlord)
  - [ ] Tap accept/register
- [ ] Option B: Register as tenant with invite code
  - [ ] Create account, select "I am a Tenant"
  - [ ] Enter invite code in the optional field
  - [ ] Complete registration
- [ ] Tenant lands in tenant dashboard (Home | Lease | Pay | Docs | Account)
- [ ] Assigned property/unit visible in tenant dashboard

---

## 6. Lease Creation + Signing (TASK-10e)

**Simulator: iPhone 17 Pro (Landlord)**

- [ ] Navigate to Leases tab
- [ ] Create new lease
- [ ] Select property and unit
- [ ] Select/confirm tenant
- [ ] Lease details pre-filled from lease settings
- [ ] Adjust terms if needed
- [ ] Save lease draft
- [ ] Lease appears in list with DRAFT status
- [ ] Send lease for signing
- [ ] Status changes to SENT_FOR_SIGNING
- [ ] Sign lease as landlord (signature capture screen)
- [ ] Status changes to LANDLORD_SIGNED

**Simulator: iPhone 16e (Tenant)**

- [ ] Navigate to Lease tab
- [ ] Lease appears with signing required
- [ ] Review lease details
- [ ] Sign lease (signature capture)
- [ ] Status changes to FULLY_EXECUTED

**Verify on both simulators:**

- [ ] Lease status shows FULLY_EXECUTED on both sides
- [ ] Lease details match on both sides

---

## 7. Tenant Document Upload (TASK-10f)

**Simulator: iPhone 16e (Tenant)**

- [ ] Navigate to Docs tab
- [ ] See required document types (ID, Paycheck, Background)
- [ ] Upload ID document (photo or file)
- [ ] Upload paycheck/proof of income
- [ ] Upload background clearance
- [ ] Each document shows UPLOADED status
- [ ] Can preview/view uploaded document

**Simulator: iPhone 17 Pro (Landlord)**

- [ ] Navigate to tenant documents (from lease or property detail)
- [ ] See tenant's uploaded documents
- [ ] Review each document
- [ ] Approve or reject with comments
- [ ] Status changes visible

---

## 8. Rent Payment (TASK-10g)

**Simulator: iPhone 16e (Tenant)**

- [ ] Navigate to Pay tab
- [ ] See current amount due, due date
- [ ] Tap "Pay Now" or equivalent
- [ ] Redirected to Stripe checkout (requires real Stripe test key)
- [ ] Complete payment with test card (4242 4242 4242 4242)
- [ ] Payment success screen shown
- [ ] Payment history updated
- [ ] Status shows PAID/SUCCESSFUL

**Simulator: iPhone 17 Pro (Landlord)**

- [ ] Navigate to Payments tab
- [ ] See tenant's payment in list
- [ ] Payment status matches
- [ ] Payment history is accurate

**Note:** Full Stripe checkout requires a valid Stripe test secret key. If using placeholder, the checkout redirect will fail but the payment record creation should still work.

---

## 9. Move-Out Request (TASK-10h)

**Simulator: iPhone 16e (Tenant)**

- [ ] Find move-out request option (Account screen or dedicated section)
- [ ] Submit move-out request with date and reason
- [ ] Request shows SUBMITTED status
- [ ] Confirmation displayed

**Simulator: iPhone 17 Pro (Landlord)**

- [ ] Move-out request appears in landlord view
- [ ] Review request details
- [ ] Approve (or reject) with comment
- [ ] Status changes to APPROVED

**Simulator: iPhone 16e (Tenant)**

- [ ] Move-out status updated to APPROVED
- [ ] Visible in tenant's move-out section

---

## 10. Notifications (TASK-10i)

- [ ] Landlord receives notifications for: tenant accepted invite, lease signed, payment received, move-out request
- [ ] Tenant receives notifications for: invite received, lease sent, payment due, move-out approved
- [ ] Notification bell/icon shows unread count
- [ ] Tap notification to view details
- [ ] Mark individual notification as read
- [ ] Mark all as read
- [ ] Notification list loads without errors

---

## 11. Dashboard Verification (TASK-10j)

**Landlord Dashboard:**

- [ ] Property count is real (not hardcoded)
- [ ] Active lease count is real
- [ ] Revenue/payment data reflects actual payments
- [ ] Recent activity shows real notifications
- [ ] Occupancy data reflects actual tenant assignments

**Tenant Dashboard:**

- [ ] Assigned property/unit info is real
- [ ] Lease status is current
- [ ] Next payment due date/amount is real
- [ ] Recent activity shows real notifications

---

## 12. Logout + Session (TASK-10j)

- [ ] Logout clears session
- [ ] Navigates back to login/welcome screen
- [ ] Cannot access protected screens after logout
- [ ] Re-login restores correct role and data
- [ ] If Authgear was used, Authgear session is also cleared
- [ ] Token refresh works (stay logged in for > 30 minutes)

---

## 13. Role-Based Access (TASK-10k)

- [ ] Landlord cannot see tenant-only screens (Pay, Docs)
- [ ] Tenant cannot see landlord-only screens (Properties management, lease creation)
- [ ] Tenant cannot create properties
- [ ] Landlord cannot submit move-out requests
- [ ] API returns 403 for cross-role access attempts

---

## 14. Error Handling (TASK-10l)

- [ ] Network error shows user-friendly message (turn off backend)
- [ ] Invalid token causes logout/re-auth prompt
- [ ] Expired invite code shows clear message
- [ ] Failed payment shows retry option
- [ ] Empty states show helpful messages (no properties, no leases, etc.)
- [ ] Loading states shown during API calls
- [ ] Double-tap protection on submit buttons

---

## Automated API Tests

Run the API-level E2E script:
```bash
# Full suite
./scripts/e2e_verification.sh

# Verbose mode (shows request/response details)
./scripts/e2e_verification.sh --verbose

# Run specific section
./scripts/e2e_verification.sh --section auth
./scripts/e2e_verification.sh --section property
./scripts/e2e_verification.sh --section invite
./scripts/e2e_verification.sh --section lease
./scripts/e2e_verification.sh --section document
./scripts/e2e_verification.sh --section payment
./scripts/e2e_verification.sh --section moveout
./scripts/e2e_verification.sh --section notification
./scripts/e2e_verification.sh --section dashboard
./scripts/e2e_verification.sh --section rbac
./scripts/e2e_verification.sh --section error
```

---

## Bug Report Template

If a test fails, file a bug with:

```
**Test:** [checklist item number + description]
**Steps:** [exact steps to reproduce]
**Expected:** [what should happen]
**Actual:** [what happened]
**Simulator:** [which device]
**Screenshots:** [attach if relevant]
**API Response:** [HTTP status + body if applicable]
```
