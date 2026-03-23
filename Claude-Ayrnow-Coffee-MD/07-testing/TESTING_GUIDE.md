# AYRNOW — Testing Guide

## Quick Smoke Test

### 1. Start services
```bash
./scripts/run_all_local.sh
# Or manually: start PostgreSQL, backend, then frontend
```

### 2. API smoke test
```bash
# Health
curl http://localhost:8080/api/health

# Register landlord
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"landlord@test.com","password":"Test123!","firstName":"John","lastName":"Smith","role":"LANDLORD"}'

# Register tenant
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"tenant@test.com","password":"Test123!","firstName":"Jane","lastName":"Doe","role":"TENANT"}'

# Login (save token)
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"landlord@test.com","password":"Test123!"}' | python3 -c "import sys,json; print(json.load(sys.stdin)['accessToken'])")

# Create property
curl -X POST http://localhost:8080/api/properties \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Property","propertyType":"RESIDENTIAL","address":"123 Main St","city":"Austin","state":"TX","postalCode":"78701","initialUnitCount":2}'

# Dashboard
curl http://localhost:8080/api/dashboard/landlord -H "Authorization: Bearer $TOKEN"
```

## Frontend Testing

### Flutter analyze (static analysis)
```bash
cd frontend
flutter analyze
# Expected: 0 errors
```

### Widget tests
```bash
cd frontend
flutter test
```

### Manual testing checklist
1. App opens to Welcome screen with "Login" + "Create Account"
2. Register as Landlord (2-step: personal info → role selection)
3. Login with registered credentials
4. Dashboard shows empty state with "Add My First Property"
5. Navigate to Properties tab → empty state
6. Add property (3-step wizard) → Success screen
7. View property detail → unit list visible
8. Add/edit unit → save works
9. Navigate to Leases tab → empty state
10. Create lease (3-step wizard)
11. Log out, register as Tenant
12. Tenant dashboard shows pre-active or active state
13. Tenant lease tab shows lease details
14. Document upload works (file picker → API call)
15. Move-out request form submits correctly
16. Notifications screen shows entries
17. Account screen shows correct role-based sections

## Backend Testing

### Unit tests (not yet implemented)
```bash
cd backend
/opt/homebrew/bin/mvn test
```

### Database verification
```bash
psql ayrnow -U ayrnow -c "\dt"
# Should list 16 tables
```

### API authorization test
```bash
# Should return 403 (no token)
curl -o /dev/null -w "%{http_code}" http://localhost:8080/api/properties

# Should return 200 (with token)
curl -o /dev/null -w "%{http_code}" http://localhost:8080/api/properties -H "Authorization: Bearer $TOKEN"
```

## End-to-End Test Flows

### Flow 1: Landlord Registration and Property Setup

| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | Open app | Welcome/splash screen with Login and Create Account |
| 2 | Tap "Create Account" | Registration form (name, email, password) |
| 3 | Fill form, select LANDLORD role, submit | Success, redirected to landlord dashboard |
| 4 | Verify dashboard | Empty state with "Add My First Property" prompt |
| 5 | Tap "Add Property" | Property wizard (name, type, address) |
| 6 | Fill property details, set type to Residential, set 3 units | Property created with 3 units |
| 7 | Tap property in list | Property detail with unit list |
| 8 | Tap a unit | Unit detail screen |

### Flow 2: Tenant Invitation

| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | As landlord, go to a property unit | Unit detail |
| 2 | Tap "Invite Tenant" | Invite form (email/phone/code) |
| 3 | Enter tenant email, submit | Invitation created, status PENDING |
| 4 | Check invitations list | New invite visible |

### Flow 3: Tenant Registration and Onboarding

| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | Open app (new session or logout first) | Welcome screen |
| 2 | Tap "Create Account" | Registration form |
| 3 | Fill form, select TENANT role, enter invite code | Account created, linked to unit |
| 4 | Verify tenant dashboard | Shows assigned property/unit info |

### Flow 4: Lease Creation and Signing

| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | As landlord, go to Leases tab | Lease list (may be empty) |
| 2 | Tap "Create Lease" | Lease wizard (select property, unit, tenant) |
| 3 | Fill lease details (term, rent, deposit), submit | Lease created in DRAFT status |
| 4 | Tap "Send for Signing" | Status changes to SENT_FOR_SIGNING |
| 5 | As landlord, sign lease | Status changes to LANDLORD_SIGNED |
| 6 | As tenant, view lease and sign | Status changes to FULLY_EXECUTED |

### Flow 5: Document Upload

| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | As tenant, go to Documents screen | Document list with required types (ID, paycheck, background) |
| 2 | Tap "Upload" on a document type | File picker opens |
| 3 | Select a file (PDF, JPG, PNG, under 10MB) | Upload succeeds, status changes to UPLOADED |
| 4 | As landlord, view tenant documents | Uploaded documents visible with review options |
| 5 | Approve or reject a document | Status updates accordingly |

### Flow 6: Rent Payment (requires Stripe test keys)

| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | As tenant, go to payment screen | Shows amount due |
| 2 | Tap "Pay" | Stripe checkout page opens |
| 3 | Enter test card `4242 4242 4242 4242`, any future date, any CVC | Payment succeeds |
| 4 | Check payment status | SUCCESSFUL with paid_at timestamp |
| 5 | As landlord, check payment ledger | Payment reflected in ledger |

### Flow 7: Move-Out Request

| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | As tenant, go to move-out screen | Move-out request form |
| 2 | Select move-out date, add optional note, submit | Request created, status SUBMITTED |
| 3 | As landlord, view move-out requests | New request visible |
| 4 | Approve or reject | Status updates, both parties see result |

## Known Test Limitations
- Backend unit tests not yet written (test directory exists but is empty)
- Stripe checkout requires real/test Stripe keys to fully test payment flow
- Social login buttons show 'Coming Soon' (native OAuth deferred)
- OpenSign signing integration is stubbed — lease signing uses internal API
- Document download requires file to exist at stored path
