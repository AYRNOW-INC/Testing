# CLAUDE.md — AYRNOW App Project Context

_Last updated: 2026-03-15_

This file is a high-context operating document for Claude Code / terminal agents / coding copilots working on **AYRNOW**.

It is intended to make a new execution agent productive quickly without losing project intent, scope boundaries, architecture rules, UX direction, and current operational knowledge.

---

## 1. Project Summary

**Product:** AYRNOW  
**Market:** United States  
**Company context:** AYRNOW is the U.S.-market property management and rent collection platform under a Delaware C-Corp startup structure.  
**Related product:** Porishodh is the Bangladesh-market counterpart under Code Nexas. Keep AYRNOW and Porishodh clearly separated in branding, product logic, and market positioning.  
**Working logo:** Simplified minimal house + dollar + checkmark logo. This is the approved current working AYRNOW mark.

### Mission
AYRNOW is a landlord-tenant rental and property management platform built to simplify rental operations for homeowners and landlords with guided, mobile-friendly workflows.

### MVP outcome
The MVP must allow landlords to:
- register/login
- manage properties and rentable spaces
- invite tenants
- configure lease defaults
- create leases
- send leases for signing
- review tenant documents
- collect rent
- handle move-out requests

The MVP must allow tenants to:
- accept invitations
- register/login
- review lease details
- sign leases
- upload onboarding documents
- pay rent
- request move-out
- view status/history

---

## 2. Non-Negotiable Engineering Rules

These rules are authoritative for AYRNOW work:

1. **No Docker anywhere** in the AYRNOW workflow, dev setup, or core architecture.
2. **Monolithic architecture only** for the MVP.
3. **Frontend must be Flutter.**
4. **Backend must be Java Spring Boot.**
5. **Database must be PostgreSQL.**
6. **Flyway** is the approved migration system.
7. All core flows must work locally before handoff.
8. Local iOS simulator support is required.
9. Code should be production-minded, not demo-only.
10. Do not stop at scaffolding, placeholders, TODO-only delivery, or partial flows.
11. Keep commits clean and meaningful.
12. Documentation must be included in-repo.
13. AWS migration/deployment path must be documented.
14. If an external credential blocks a fully live integration test, implement everything else fully and document the remaining hookup clearly.

---

## 3. Product Scope

### In scope for MVP
- Landlord registration and login
- Tenant registration and login
- Invitation-based tenant onboarding
- Landlord portal
- Tenant portal
- Property creation and management
- Support for residential, commercial, and “other” property types
- Unit / apartment / store / land-block / rentable-space management
- Tenant invite flow tied to a specific rentable space
- Property-level lease settings
- Prefilled lease generation
- Lease signing
- Tenant document upload
- Rent payment via Stripe
- Move-out request flow
- Basic dashboards
- Basic notifications / status visibility

### Explicitly out of scope for current MVP
- Contractor module
- Maintenance workflows
- Security guard / visitor management
- Community/social features
- Advanced analytics
- AI features
- Full accounting suite
- Complex marketplace features
- Multi-stakeholder owner-investor management

### Backlog / future ideas already noted
- AYRNow Pay
- AYRNow Lease
- AYRNow Rent
- AYRNow Homes
- AYRNow PM
- AYRNow Collect
- AYRNow Portal
- Investor Guide materials
- Security Guard role for guest approval/logging

---

## 4. User Roles

### Primary MVP roles
#### Landlord
Landlord can:
- register/login
- manage profile
- create properties
- add apartments, units, stores, land blocks, and other rentable spaces
- invite tenants
- configure property-level lease defaults
- generate lease drafts
- send leases for signing
- sign leases
- review tenant documents
- review payment history / rent status
- review and approve/reject move-out requests

#### Tenant
Tenant can:
- receive and accept invite
- register/login
- view assigned property and space
- review lease
- sign lease
- upload required documents
- pay rent
- request move-out
- view payment history and lease status

### Future / backlog roles
- Contractor
- Security guard
- Investor
- Property manager

---

## 5. UX and Product Design Direction

Design direction is already decided and should remain stable:

- simple
- clean
- guided
- trustworthy
- tech-enabled
- professional but approachable
- flat, scalable, app-friendly
- optimized for homeowners / landlords age **30–65**
- avoid drastic redesigns
- avoid visual churn
- maintain consistency across flows

### Branding use cases
Use the AYRNOW brand/logo consistently in:
- splash/loading screen
- login screen
- app headers / app bars
- documentation / README branding where reasonable
- app icon base prep if practical

Do **not** redesign the AYRNOW identity into something unrelated.

---

## 6. Approved Architecture

### Core stack
- **Frontend:** Flutter
- **Backend:** Java Spring Boot
- **Database:** PostgreSQL
- **Migration:** Flyway
- **Architecture:** Monolithic

### Core principle
Do not rebuild commodity systems from scratch. Use mature tools where appropriate, but keep AYRNOW-specific business logic inside the AYRNOW backend.

### System of record
**PostgreSQL is the source of truth** for AYRNOW business data.
External services must not become the only place where landlord/tenant roles, property relationships, lease state, or payment history exist.

---

## 7. Approved Dependency Stack and Boundaries

### 7.1 Authgear
**Use for:**
- registration
- login
- password flows
- Google sign-in
- Apple sign-in
- session/token issuance

**Authgear owns:**
- identity
- authentication
- password reset / auth flows
- social auth connections
- session and token issuance

**AYRNOW owns:**
- landlord vs tenant role mapping
- internal authorization
- profile ownership
- property access rules
- business permissions
- app-specific status / onboarding state

**Rule:** Authgear proves who the user is. AYRNOW decides what the user can do.

### 7.2 OpenSign
**Use for:**
- self-hosted lease signing workflow
- signer routing
- signature capture
- signature-status callbacks/webhooks

**OpenSign owns:**
- signing workflow
- signer links / routing
- signature capture lifecycle
- callback / webhook notifications

**AYRNOW owns:**
- lease drafting
- lease settings
- lease lifecycle
- tenant assignment
- final internal lease state
- signed document references / metadata

**Rule:** OpenSign is a signing engine, not AYRNOW’s lease database.

### 7.3 Stripe
**Use for:**
- payment execution
- payment method handling
- transaction processing
- webhook event delivery

**Stripe owns:**
- network/payment execution
- transaction state
- payment events

**AYRNOW owns:**
- rent obligations
- internal ledger
- lease/property/unit/tenant linkage
- user-facing payment history
- receipt/status views

**Rule:** Final payment state in AYRNOW must come from backend webhook processing, not only client-side success screens.

### 7.4 Spring Boot + PostgreSQL + Flyway
This is the AYRNOW orchestration core.

**Spring Boot owns:**
- internal APIs
- role enforcement
- validation
- orchestration
- webhook endpoints
- integration clients
- dashboard aggregation
- audit trail writing

**PostgreSQL owns:**
- users
- roles
- profiles
- properties
- units/spaces
- invitations
- leases
- lease settings
- documents metadata
- payments
- move-out requests
- notifications
- audit logs

**Flyway owns:**
- schema migrations
- versioned database evolution

---

## 8. Core Internal Modules to Build

These modules belong inside the AYRNOW monolith:

- `auth-integration`
- `user-profile`
- `property`
- `unit-space`
- `invite`
- `lease`
- `lease-settings`
- `document`
- `payment`
- `move-out`
- `dashboard`
- `webhook`
- `audit`
- `notification`

Suggested API groupings:
- Auth API
- User/Profile API
- Property API
- Unit/Space API
- Tenant Invite API
- Lease API
- Lease Settings API
- Lease Signature API
- Document Upload API
- Payment API
- Stripe Webhook API
- Move-Out Request API
- Dashboard API
- Notification API

---

## 9. Core Data Model

Suggested / approved entity set:

- `User`
- `Role`
- `LandlordProfile`
- `TenantProfile`
- `Property`
- `UnitSpace`
- `Invitation`
- `Lease`
- `LeaseSignature`
- `LeaseSettings`
- `TenantDocument`
- `Payment`
- `PaymentTransaction`
- `MoveOutRequest`
- `Notification`
- `AuditLog`

### Important relationship rules
- A property can contain one or more rentable spaces.
- A rentable space must belong to a property.
- An invitation should point to a specific unit/space.
- A lease must tie together landlord, tenant, property, and unit/space.
- Payments should link to tenant, lease, property, and unit/space where relevant.
- Move-out requests should link to current lease and tenant occupancy context.

---

## 10. Property Model and Supported Types

### Property types
- Residential
- Commercial
- Other

### Examples
**Residential:** apartment, flat, room, unit  
**Commercial:** store, office, shop, warehouse unit  
**Other:** land block, lot, parcel, leaseable outdoor space

### Property creation requirement
When a landlord adds a property, the system should prompt for initial structure setup.

Examples:
- Residential: ask how many apartments/units to add now
- Commercial: ask how many stores/offices/spaces to add now
- Other: ask whether land blocks/parcels/spaces should be created

### Recommended property fields
- property name
- property type
- address
- city
- state
- postal code
- country
- description
- status
- optional image

### Requirements
- add/edit/delete properties
- add/edit/delete units/spaces
- occupancy status tracking
- assign tenant to specific space
- support one property with multiple spaces
- reduce manual entry with bulk initial unit count during onboarding

---

## 11. Core User Flows

### 11.1 Landlord onboarding
1. Register / log in
2. Create or resolve landlord profile
3. Enter landlord dashboard

### 11.2 Property onboarding
1. Create property
2. Select property type
3. Add address and metadata
4. Enter initial unit/store/space count
5. Create spaces

### 11.3 Tenant invite flow
1. Landlord selects a specific unit/space
2. Invite tenant by email, phone, or short key / invite code
3. System creates invite
4. Tenant receives invite
5. Tenant opens link or enters code
6. Tenant creates or links account
7. Tenant becomes attached to the correct unit/space

### 11.4 Lease flow
1. Landlord configures property-level lease settings
2. Landlord creates lease draft
3. AYRNOW generates prefilled lease agreement
4. AYRNOW sends lease package to OpenSign
5. Landlord and tenant sign
6. OpenSign calls back AYRNOW via webhook
7. AYRNOW stores signed document reference and updates internal status

### 11.5 Tenant document flow
Tenant uploads:
- ID
- paycheck / proof of income
- background clearance

Landlord can review status and comments.

### 11.6 Rent payment flow
1. Tenant views amount due
2. Tenant pays via Stripe
3. Stripe sends webhook to backend
4. AYRNOW updates payment ledger and dashboards

### 11.7 Move-out flow
1. Tenant requests move-out date
2. Optional note/reason submitted
3. Landlord reviews
4. Landlord approves or rejects
5. Status is visible to both sides

---

## 12. Status Models

### Invitation statuses
- pending
- sent
- opened
- accepted
- expired
- cancelled

### Lease statuses
- draft
- sent for signing
- landlord signed
- tenant signed
- fully executed
- expired
- terminated

### Document statuses
- missing
- uploaded
- under review
- approved
- rejected

### Payment statuses
- pending
- successful
- failed
- overdue
- optional refunded

### Move-out statuses
- draft
- submitted
- under review
- approved
- rejected
- completed

### Account statuses
- active
- invited
- suspended
- pending

---

## 13. Lease Settings Requirements

Each property should have **one-tap access** to lease settings from the property list/card/row or equivalent property details action.

Property-level lease defaults should support:
- default lease term
- default monthly rent
- default security deposit
- payment due day
- grace period
- late fee rules
- template / clause settings
- special terms

These defaults should prefill downstream lease creation for spaces under that property.

---

## 14. Document Handling Requirements

Supported document types include:
- tenant ID
- paycheck / proof of income
- background clearance
- generated lease PDFs
- signed lease references

Supported file types:
- PDF
- JPG
- JPEG
- PNG

Document handling requirements:
- upload
- replace
- preview / download when appropriate
- metadata persistence
- file type validation
- file size validation
- role-based access control
- landlord review status
- optional review comments
- secure storage approach
- clear local-dev strategy
- AWS-ready future storage path

**Rule:** Store files outside PostgreSQL when possible. PostgreSQL should store metadata and references.

---

## 15. Payment Rules

- Stripe is the approved payment processor.
- Tenant must be able to see due amount, due date, status, and payment history.
- AYRNOW must maintain internal payment history and ledger state.
- Final internal payment state should be webhook-driven.
- Payments should be connected to tenant, lease, property, and unit/space.
- Basic payment types for MVP:
  - rent payment
  - optional deposit payment
  - basic late fee support

---

## 16. Security and Non-Functional Requirements

### Security
- secure authentication
- password hashing / secure identity handling via Authgear
- JWT or session protection
- role-based authorization
- input validation
- upload validation
- sensitive document protection
- audit logging for lease signing, payments, and move-out actions

### Performance
- key screens should load in acceptable time
- standard API operations should be stable and responsive

### Reliability
- proper error handling
- graceful expired invite handling
- graceful failed payment handling
- stable CRUD operations
- clear empty/loading/error/success states

### Scalability
- start as a monolith
- keep code modular enough for future service separation if needed

### Usability
- low-friction invite-to-lease-to-document-to-payment journey
- mobile-first guided UX

---

## 17. Build Order and Delivery Strategy

### Recommended high-level build order
1. Authentication and role management
2. Property and unit/space management
3. Lease settings + lease creation + signing
4. Tenant document upload
5. Stripe rent payment integration
6. Move-out workflow
7. Dashboard polish and notifications

### Current authoritative AYRNOW slice order
1. Auth
2. Properties / Units / Leases
3. Tenant invites / onboarding
4. Rent payments (basic Stripe)
5. Notifications + deep links

### Definition of done for each vertical slice
Each slice must include:
- loading state
- empty state
- error state
- success state
- backend validation
- correct HTTP codes
- meaningful logs/errors
- minimal tests
- works on Android and iOS simulators

---

## 18. Routing and Existing-Code Guardrails

These are authoritative project rules from prior AYRNOW work:

1. Never recreate Login, Register, Property List, or Add Property if they already exist.
2. First inspect route wiring and entry points.
3. Core route ownership must remain in `main.dart`.
4. `buildRoutes()` must **not** override `/login`.

### Known restored routing state
- `lib/main.dart` owns:
  - `/` -> `AuthGate`
  - `/login` -> `LoginScreen`
  - `/home` -> `AppShell`
- `lib/navigation/routes.dart` should not define `/login`
- Existing feature routes include:
  - `/register`
  - `/L-20` (Add Property)
  - `/L-25` (Property List)

### Core flow expectations
- app launch -> AuthGate -> Login
- Login -> Register
- landlord dashboard -> My Properties
- landlord dashboard -> Add Property

### Practical rule
If a screen exists but is unreachable, **restore navigation wiring instead of rebuilding the feature**.

---

## 19. Testing Expectations

Before handoff or major merge, verify at minimum:

- landlord registration/login flow
- tenant invite acceptance flow
- property creation flow
- initial unit/store/space setup flow
- lease settings access from property
- lease creation flow
- lease signing integration callback path
- tenant document upload flow
- Stripe webhook update path
- move-out request create/review path
- dashboard load behavior
- route reachability
- role-based access behavior

### Existing regression protection context
Known tests referenced in prior project state:
- `test/core_routes_regression_test.dart`
- `test/widget_test.dart`
- `test/auth_phase1_test.dart`

Do not remove route safety checks around login/register/property navigation.

---

## 20. Operational Status and Known Blockers

### Current known status
- Safe to continue development: **yes**
- Safe to push: **no**, until secret-history / push-protection issue is resolved
- Safe to deploy to AWS: **no**, deploy runbook + env verification still needed
- Safe to submit to stores: **no**, store runbooks/listings/signing steps still needed

### Known blockers
1. Resolve git push protection / secret-in-history issue
2. Complete AWS deploy runbook and production env verification
3. Complete iOS bundle ID/signing confirmation and App Store submission runbook
4. Complete Play Store submission runbook/listing steps
5. Align Android `key.properties` path with build logic and docs
6. Rotate Stripe test secret before pushing if old secret exposure is still relevant
7. Confirm / set real production API host for release builds

### Important operational warnings
- Protect core auth/property flows from regression.
- Keep changes small and scoped.
- Avoid broad refactors that disconnect working screens.

---

## 21. Environment Variables

### Required production env vars
- `SPRING_DATASOURCE_URL`
- `SPRING_DATASOURCE_USERNAME`
- `SPRING_DATASOURCE_PASSWORD`
- `JWT_SECRET`
- `CORS_ALLOWED_ORIGINS`
- `STRIPE_SECRET_KEY`
- `STRIPE_WEBHOOK_SECRET`

### Optional env vars
- `JWT_ACCESS_MINUTES`
- `JWT_REFRESH_DAYS`
- `STRIPE_SUCCESS_URL`
- `STRIPE_CANCEL_URL`

### Integration-related config that should stay environment-driven
- Authgear endpoints/keys
- OpenSign base URL / API token
- Stripe API keys
- Stripe webhook secret
- callback URLs
- signing URLs
- CORS allowlists
- storage bucket / file path config
- app environment mode

---

## 22. AWS Direction

AYRNOW needs an AWS migration / deployment path that respects the no-Docker rule for the AYRNOW core workflow.

Documentation should cover:
- Spring Boot backend hosting approach
- PostgreSQL hosting approach
- file/document storage
- signed lease storage strategy
- secrets/configuration management
- SSL / domain strategy
- logging / monitoring
- CI/CD approach
- staging vs production path
- cost-conscious MVP deployment
- future scale path

### General AWS intent
- Keep backend as packaged Spring Boot app
- Keep PostgreSQL managed separately
- Treat Authgear/OpenSign as integrated supporting services
- Treat Stripe as managed external dependency
- Keep secrets and callback URLs environment-driven

---

## 23. Repo / Documentation Expectations

Recommended documentation set for the repo:
- `README.md`
- `CLAUDE.md`
- `knowledge.md`
- architecture overview
- setup guide
- local run guide
- environment variable guide
- dependency integration guide
- AWS deployment guide
- testing guide
- known issues / blockers document
- release readiness checklist

### README should clearly cover
- what AYRNOW is
- approved stack
- how to run frontend locally
- how to run backend locally
- required env vars
- local integration caveats
- no-Docker rule
- core flows supported

---

## 24. Preferred Execution Style for Agents

An execution agent working on AYRNOW should behave like:
- lead full-stack engineer
- mobile engineer
- backend engineer
- QA lead
- DevOps owner
- release manager
- technical writer

### Expected behavior
- execute, do not only plan
- finish end-to-end slices where possible
- do not hand over broken partials without clearly labeling them
- keep implementation practical and maintainable
- preserve existing working flows when possible
- prioritize reachability and correctness over flashy redesign
- document assumptions and credential-blocked steps clearly

### Strong preference from project history
Use **small, scoped branches / PRs** to avoid feature loss and UI drift.

---

## 25. Acceptance Criteria Summary

AYRNOW MVP is acceptable when the following are true:

- A landlord can register and log in.
- A landlord can add a property with residential, commercial, or other type.
- A landlord can enter the number of apartments/units/spaces during property setup.
- A landlord can add a rentable space such as an apartment, store, or land block.
- A landlord can invite a tenant by email, phone, or short key.
- A tenant can accept an invite and create an account.
- A landlord can create and send a lease.
- Landlord and tenant can sign a lease digitally.
- Landlord can access lease settings directly from the property in one tap.
- Tenant can upload ID, paycheck/proof of income, and background clearance.
- Tenant can pay rent through Stripe.
- Tenant can request move-out and landlord can approve/reject it.
- Landlord and tenant each have separate portal/dashboard experiences.
- Backend runs on Spring Boot monolith with PostgreSQL.
- Frontend is Flutter.
- No Docker is used anywhere in the architecture.

---

## 26. Quick Reference Links

### GitHub target repo
- `git@github.com:AYRNOW-INC/AYRNOW-MVP.git`

### Authgear
- Website: https://www.authgear.com/
- GitHub: https://github.com/authgear/authgear-server
- Docs repo: https://github.com/authgear/docs

### OpenSign
- Website: https://www.opensignlabs.com/
- GitHub: https://github.com/OpenSignLabs/OpenSign
- Docs: https://docs.opensignlabs.com/
- API docs: https://docs.opensignlabs.com/docs/API-docs/v1/opensign-api-v-1/
- Self-host intro: https://docs.opensignlabs.com/docs/self-host/intro/

### Stripe
- Website: https://stripe.com/
- Docs: https://docs.stripe.com/
- API: https://docs.stripe.com/api
- Webhooks: https://docs.stripe.com/webhooks

### Spring Boot
- Project: https://spring.io/projects/spring-boot
- GitHub: https://github.com/spring-projects/spring-boot
- Docs: https://docs.spring.io/spring-boot/docs/current/reference/html/

### Flutter
- Website: https://flutter.dev/
- Docs: https://docs.flutter.dev/
- GitHub: https://github.com/flutter/flutter

### PostgreSQL
- Website: https://www.postgresql.org/
- Docs: https://www.postgresql.org/docs/
- GitHub mirror: https://github.com/postgres/postgres

### Flyway
- GitHub: https://github.com/flyway/flyway
- Docs: https://documentation.red-gate.com/fd

---

## 27. Final Reminder for Any Coding Agent

Do not drift from the AYRNOW product intent:
- This is not a generic property app.
- This is not a social platform.
- This is not a maintenance-first platform for the MVP.
- This is a **guided landlord-tenant rent collection and lease workflow app**.

Build the shortest path to a reliable, production-minded MVP with:
- strong role separation
- clear onboarding
- property-to-space mapping
- invite-driven tenant attachment
- lease settings + lease execution
- document collection
- Stripe-backed rent payment
- move-out workflow
- simple dashboards

Preserve existing working routes/screens when they already exist. Fix wiring before rebuilding. Keep the stack exact. Keep the scope disciplined.
