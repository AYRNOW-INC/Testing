# AYRNOW Knowledge Base

_Last updated: 2026-03-14_

## 1. Project Identity

**Project name:** AYRNOW  
**Company context:** AYRNOW is the U.S.-market property management and rent collection product under a Delaware C-Corp startup structure.  
**Related brand:** Porishodh is the Bangladesh-market version under Code Nexas. The two brands must remain clearly separated.  
**Current working logo:** Simplified minimal house + dollar + checkmark logo, approved as the working AYRNOW logo.

## 2. Product Mission

AYRNOW is a landlord-tenant property management and rent collection platform designed to simplify rental operations for homeowners and landlords. The MVP focuses on practical workflows that allow landlords to manage properties, invite tenants, create leases, collect documents, collect rent, and manage move-out requests in a guided, mobile-friendly way.

## 3. Target Users

### Primary users
- Landlords
- Tenants

### Future/backlog users
- Contractors
- Security guards
- Investors
- Property managers

### UX direction
- UI must remain simple, clean, guided, and approachable
- Primary audience: homeowners and landlords age 30–65
- Avoid drastic redesigns or unnecessary visual churn
- Keep consistency across mobile UI and core flows

## 4. MVP Product Scope

### In scope
- Landlord registration and login
- Tenant registration and login
- Landlord portal
- Tenant portal
- Property listing and property management
- Property types: residential, commercial, other (including land lease / land block)
- Unit / apartment / store / land block management
- Tenant invite flow from a specific rentable space
- Lease settings at property level
- Prefilled lease generation
- Lease signing
- Tenant document upload
- Rent payment via Stripe
- Move-out request flow
- Dashboard summaries
- Notifications / status visibility where needed for core flow

### Out of scope for MVP
- Contractor workflows
- Maintenance module
- Security guard / visitor management in current MVP
- Community/social features
- Advanced analytics
- AI features
- Full accounting suite
- Complex marketplace features

## 5. Approved MVP Dependency Stack

### Frontend
- **Flutter**

### Backend
- **Java Spring Boot**
- **Monolithic architecture only**

### Database
- **PostgreSQL**

### Migrations
- **Flyway**

### Authentication
- **Authgear**
- Use for registration, login, password flows, Google sign-in, Apple sign-in
- Authgear handles identity and authentication
- AYRNOW handles internal roles, permissions, and business authorization

### Lease signing
- **OpenSign**
- Use as self-hosted signing engine
- AYRNOW generates lease documents and owns lease business logic
- OpenSign handles signature workflow and callback/webhook events

### Payments
- **Stripe**
- Stripe handles payment execution
- AYRNOW handles rent ledger, reporting, lease linkage, and payment history

### File / document handling
- AYRNOW owns document metadata, review state, access control, and file linkage
- Storage approach must support local development and future AWS migration

### Hard rule
- **Do not use Docker anywhere in the AYRNOW workflow or dev setup**

## 6. Official Dependency Links

### Authgear
- Website: https://www.authgear.com
- GitHub: https://github.com/authgear/authgear-server

### OpenSign
- Website: https://www.opensignlabs.com/?utm_source=chatgpt.com
- GitHub: https://github.com/OpenSignLabs/OpenSign
- Docs: https://docs.opensignlabs.com
- API docs: https://docs.opensignlabs.com/docs/API-docs/v1/opensign-api-v-1/
- Self-host docs: https://docs.opensignlabs.com/docs/self-host/intro/

### Stripe
- Website: https://stripe.com
- Docs: https://docs.stripe.com
- API: https://docs.stripe.com/api
- Webhooks: https://docs.stripe.com/webhooks

### Flyway
- Website: https://flywaydb.org
- Community page: https://www.red-gate.com/products/flyway/community/
- GitHub: https://github.com/flyway/flyway

### GitHub target repo
- Repo: `git@github.com:ayrnowinc-jpg/AYRNOW-MVP.git`

## 7. Core User Roles

### Landlord
Landlord can:
- register and login
- create and manage profile
- create and manage properties
- add apartments, units, stores, and land blocks
- invite tenants
- configure lease settings
- generate prefilled lease agreements
- send leases for signing
- sign leases
- review tenant documents
- track payments
- review move-out requests

### Tenant
Tenant can:
- accept invite
- register and login
- view assigned property and unit
- review lease
- sign lease
- upload required documents
- pay rent
- request move-out
- view payment history
- view lease details

## 8. Property Model

### Supported property types
- Residential
- Commercial
- Other

### Residential examples
- Apartment
- Flat
- Room
- Unit

### Commercial examples
- Store
- Office
- Shop
- Warehouse unit

### Other examples
- Land block
- Lot
- Parcel
- Outdoor leaseable space

### Property creation requirement
When a landlord adds a property, the system should prompt for initial structure setup.

Examples:
- Residential: ask how many apartments/units to add now
- Commercial: ask how many stores/offices/spaces to add now
- Other: ask whether land blocks/parcels/spaces should be created

## 9. Core MVP Flows

### 9.1 Landlord onboarding
1. Register / login
2. Create profile
3. Enter landlord dashboard

### 9.2 Property onboarding
1. Create property
2. Select property type
3. Add address and metadata
4. Add apartment / unit / store / land block count
5. Create spaces

### 9.3 Tenant invite flow
1. Landlord selects a specific unit/space
2. Invite tenant by email, phone, or short key
3. Tenant receives invite
4. Tenant accepts invite
5. Tenant is mapped to the correct unit/space

### 9.4 Lease flow
1. Landlord configures property-level lease settings
2. Landlord creates lease draft
3. AYRNOW generates prefilled lease agreement
4. AYRNOW sends lease to OpenSign
5. Landlord and tenant sign
6. AYRNOW stores signed lease reference and status

### 9.5 Tenant document flow
Tenant uploads:
- ID
- paycheck / proof of income
- background clearance

Landlord can review and track status.

### 9.6 Payment flow
1. Tenant views rent due
2. Tenant pays via Stripe
3. Stripe webhook updates backend
4. AYRNOW updates payment ledger and dashboards

### 9.7 Move-out flow
1. Tenant requests move-out date
2. Optional note is submitted
3. Landlord accepts or rejects
4. Status is visible to both sides

## 10. Move-Out Status Model

Recommended statuses:
- draft
- submitted
- under review
- approved
- rejected
- completed

## 11. Lease Settings Requirements

Each property should have direct one-tap access to lease settings from the property list/card/row.

Property-level lease settings should support:
- default lease term
- default monthly rent
- default security deposit
- due day
- grace period
- late fee rules
- template / clause settings

These defaults can be reused when generating leases for units/spaces under that property.

## 12. Document Handling Requirements

AYRNOW must support document handling for:
- tenant ID
- paycheck / proof of income
- background clearance
- generated lease PDFs
- signed lease references

Requirements:
- upload
- replace
- metadata persistence
- role-based access control
- file type validation
- file size validation
- landlord review state
- secure storage approach
- clear local-dev strategy and AWS-ready path

## 13. Payment Rules

- Stripe is the approved payment processor for rent collection
- AYRNOW must store internal payment history and ledger state
- Final payment state should be driven by Stripe webhook confirmation
- Payments should be linked to tenant, lease, property, and unit/space

## 14. Current Product and Engineering Rules

### Hard rules
- No Docker
- Monolithic architecture only for MVP
- Build in vertical slices
- Use small scoped branches / PRs
- Avoid redesigning existing core screens if they already exist
- Keep core route ownership in `main.dart`
- `buildRoutes()` must not override `/login`

### Current MVP scope rule
Build MVP in vertical slices with the following priority:
1. Auth
2. Properties / Units / Leases
3. Tenant invites / onboarding
4. Rent payments (basic Stripe)
5. Notifications + deep links

Each slice must meet a definition of done including:
- loading state
- empty state
- error state
- success state
- backend validation
- proper HTTP codes
- minimal tests
- works on Android + iOS simulators

## 15. Current Routing Authority (existing project knowledge)

Authoritative routing rules from prior AYRNOW work:
- Never recreate Login, Register, Property List, or Add Property if those screens/routes already exist
- First inspect route wiring and entry points
- Core route ownership must remain in `main.dart`
- `buildRoutes()` must not override `/login`

### Restored routing state reference
- `lib/main.dart` owns `/` -> AuthGate, `/login` -> LoginScreen, `/home` -> AppShell
- `lib/navigation/routes.dart` should not define `/login`
- Existing feature routes include `/register`, `/L-20` (Add Property), `/L-25` (Property List)

## 16. Current AYRNOW Operational Status Notes

_Updated: 2026-03-15_

### Build Status
- **MVP: 54/54 wireframe screens COMPLETE**
- Backend: Spring Boot 3.4.4 running on port 8080, all 48+ endpoints working
- Frontend: Flutter 3.41.4, 30 screen files, 0 compile errors
- Database: PostgreSQL 16 with 2 Flyway migrations (16 tables)
- Git: pushed to github.com/AYRNOW-INC/AYRNOW-MVP
- iOS simulator: builds and runs successfully

### Safe status
- Safe to continue development: **yes**
- Safe to push: **yes** (push-block resolved, no secrets in history)
- Safe to deploy to AWS: no, runbook/env verification still needed
- Safe to submit to app stores: no, store runbooks/listing/signing steps still needed

### Stripe Integration Status
- **Stripe test keys: CONFIGURED AND VERIFIED**
- Checkout Session creation: verified (real cs_test_ sessions)
- Webhook endpoint: verified (stripe trigger received)
- Stripe CLI listener: tested with forwarding to localhost:8080
- Auto-payment on lease execution: verified
- Payment method: Stripe Checkout (hosted redirect)
- Idempotent webhook handlers: implemented

### Remaining items for production
1. ~~Configure real Stripe test/live credentials~~ DONE (test mode)
2. Switch Stripe to live keys for production
3. Integrate Authgear SDK for social auth (Google/Apple)
4. Integrate OpenSign for PDF lease signing
5. Complete AWS deployment
6. iOS App Store submission prep
7. Play Store submission prep

## 17. Required Production Environment Variables

### Required
- `SPRING_DATASOURCE_URL`
- `SPRING_DATASOURCE_USERNAME`
- `SPRING_DATASOURCE_PASSWORD`
- `JWT_SECRET`
- `CORS_ALLOWED_ORIGINS`
- `STRIPE_SECRET_KEY`
- `STRIPE_WEBHOOK_SECRET`

### Optional
- `JWT_ACCESS_MINUTES`
- `JWT_REFRESH_DAYS`
- `STRIPE_SUCCESS_URL`
- `STRIPE_CANCEL_URL`

## 18. AWS Direction

AYRNOW needs a documented AWS migration/deployment path without Docker.

Documentation should cover:
- Spring Boot backend hosting
- PostgreSQL hosting
- file/document storage
- signed lease storage strategy
- secrets/configuration management
- SSL / domain strategy
- CI/CD approach
- logging / monitoring
- cost-conscious MVP deployment path
- staging vs production path
- future scale path

## 19. Design and Branding Notes

### Brand direction
- modern
- clean
- trustworthy
- tech-enabled
- rental / property / access oriented
- professional but approachable
- flat, scalable, app-friendly

### Use cases for logo system
- login screens
- headers / app bars
- splash
- documents / deck branding
- app icon base

## 20. Future / Backlog Notes

The following are future expansion ideas already approved or noted:
- AYRNow Pay
- AYRNow Lease
- AYRNow Rent
- AYRNow Homes
- AYRNow PM
- AYRNow Collect
- AYRNow Portal
- Investor Guide section
- Security Guard role for guest approval/logging

## 21. Recommended Repo Documentation Set

The AYRNOW repo should eventually include at least:
- `README.md`
- `knowledge.md`
- architecture overview
- setup guide
- local run guide
- iOS simulator guide
- environment variables guide
- Authgear integration doc
- OpenSign integration doc
- Stripe integration doc
- document generation and handling doc
- dependency stack doc
- API overview
- database schema overview
- Flyway migration guide
- AWS migration/deployment plan
- testing guide
- handoff guide
- assumptions and limitations

## 22. Suggested Knowledge File Usage

Use this file as the single-source project context for:
- product direction
- stack decisions
- MVP boundaries
- architecture guardrails
- dependency choices
- documentation onboarding
- terminal-agent / Claude Code prompts
- future handoff notes

## 23. One-Line Summary

**AYRNOW is a Flutter + Spring Boot + PostgreSQL monolithic landlord-tenant property management MVP using Authgear for authentication, OpenSign for lease signing, Stripe for payments, Flyway for migrations, no Docker, and a guided UI focused on practical landlord and tenant workflows.**
