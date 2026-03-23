# AYRNOW — Project Knowledge Summary

AYRNOW is a landlord-tenant rent collection and property management platform for the U.S. market, built as an MVP under a Delaware C-Corp startup.

---

## Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (Dart) |
| Backend | Java Spring Boot (JDK 21) |
| Database | PostgreSQL 16 |
| Migrations | Flyway |
| Auth | Authgear (identity/session), AYRNOW backend (roles/permissions) |
| Lease Signing | OpenSign (self-hosted signing engine) |
| Payments | Stripe (execution, webhooks) |
| Architecture | Monolithic — no Docker anywhere |

---

## Key Architectural Decisions

1. **No Docker.** All services run natively in dev and deploy as packaged JARs or native processes.
2. **Monolith-first.** Single Spring Boot app with modular internal packages. No microservices for MVP.
3. **Authgear for identity only.** Authgear handles authentication and session tokens. AYRNOW owns all role mapping, authorization, and business permissions.
4. **OpenSign for signing only.** OpenSign is a signing engine. AYRNOW owns lease drafting, lifecycle, and state. Signed document references are stored in PostgreSQL.
5. **Stripe for payment execution only.** Final payment state comes from backend webhook processing, not client-side confirmation. AYRNOW owns the internal ledger and payment history.
6. **PostgreSQL is the system of record.** All business data (users, roles, properties, leases, payments) lives in PostgreSQL. External services must not be the sole source of truth.
7. **Flyway manages all schema changes.** Versioned migrations, no manual DDL.
8. **Invite-driven tenant onboarding.** Tenants join via landlord invitation tied to a specific rentable space.

---

## Backend Modules

- `auth-integration` — Authgear token verification, session handling
- `user-profile` — Landlord and tenant profile management
- `property` — Property CRUD (residential, commercial, other)
- `unit-space` — Apartments, stores, land blocks, rentable spaces
- `invite` — Tenant invitation lifecycle
- `lease` — Lease creation, state machine, signing integration
- `lease-settings` — Property-level lease defaults
- `document` — Tenant document upload, metadata, review status
- `payment` — Rent obligations, Stripe integration, internal ledger
- `move-out` — Move-out request workflow
- `dashboard` — Aggregated views for landlord and tenant
- `webhook` — Stripe and OpenSign callback endpoints
- `audit` — Audit logging for sensitive actions
- `notification` — Status visibility and alerts

---

## Important Conventions

- **Route ownership:** `lib/main.dart` owns `/`, `/login`, `/home`. Never override these in feature route files.
- **No screen rebuilds:** If a screen exists but is unreachable, fix the navigation wiring rather than recreating it.
- **Secrets:** Never hardcode API keys or credentials. All secrets are environment-driven.
- **File storage:** Documents and signed leases stored outside PostgreSQL (local filesystem for dev, S3 for production). PostgreSQL stores metadata and references only.
- **Commits:** Small, scoped, meaningful. Each vertical slice must include loading, empty, error, and success states.
- **Testing:** Backend tests via Maven. Frontend tests via Flutter. Regression tests protect auth and property routes.
- **Build order:** Auth, Properties/Units/Leases, Tenant invites, Rent payments, Notifications.

---

## Quick Commands

```bash
# Backend
cd backend && mvn compile -q
cd backend && mvn package -DskipTests
cd backend && mvn test

# Frontend
cd frontend && flutter analyze
cd frontend && flutter test
cd frontend && flutter run
```
