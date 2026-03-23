# AYRNOW MVP — Production Audit Report

**Date:** 2026-03-23
**Auditors:** 6 specialized agents (Backend, Frontend, Wireframe, Integration, Data Model, E2E)
**Scope:** Full production readiness for real users
**Verdict:** NOT READY — 10 critical/high items must be fixed before launch

---

## Executive Summary

| Area | Grade | Key Finding |
|------|-------|-------------|
| Backend API & Security | **B+** | 5 critical security gaps, strong architecture |
| Frontend Flows & UX | **A-** | All flows work, minor polish needed |
| Wireframe Fidelity | **C+** | 46% full match, 48% partial, 6% missing |
| Integrations & Deployment | **A-** | All integrations coded, credential setup needed |
| Data Model & Business Logic | **B** | 5 critical logic gaps, solid entity model |
| E2E Flow Completeness | **B+** | All 6 flows work, credential blockers remain |

**Overall: B+ — Production-capable code, needs security hardening + credential setup**

---

## CRITICAL ISSUES (Must Fix Before Launch)

### C1: OpenSign Webhook Has No Signature Verification
**Found by:** Backend audit, Data audit, E2E audit (3 agents flagged this)
**Location:** `WebhookController.java:104-124`
**Risk:** Attackers can forge lease signatures, mark unsigned leases as fully executed
**Fix:** Implement HMAC-SHA256 signature verification or restrict to known IPs
**Effort:** 2 hours

### C2: Duplicate Payment — No Period-Based Constraint
**Found by:** Data model audit
**Location:** `PaymentService.java`, `PaymentRepository.java`
**Risk:** Tenant pays twice for same month; landlord gets double payment
**Fix:** Add unique constraint on `(lease_id, due_date)` + check before creating payment
**Effort:** 1 hour

### C3: Unit Occupancy Race Condition
**Found by:** Data model audit
**Location:** `InvitationService.java:113-120`, `AuthService.java:67-74`
**Risk:** Two tenants can be assigned to the same unit simultaneously
**Fix:** Check `unitSpace.status == OCCUPIED` before allowing new invitation
**Effort:** 30 minutes

### C4: Property Delete Cascades Active Leases
**Found by:** Data model audit, Backend audit
**Location:** `PropertyService.java`, schema `V1__Initial_schema.sql`
**Risk:** Landlord accidentally deletes property → all leases, payments, docs cascade-deleted
**Fix:** Block deletion if any lease is FULLY_EXECUTED, SENT_FOR_SIGNING, or LANDLORD_SIGNED
**Effort:** 1 hour (note: previous TASK-40 may have addressed this — verify)

### C5: Missing Stripe Event ID Unique Constraint in DB
**Found by:** Data model audit
**Location:** `Payment` entity, schema
**Risk:** Code-level idempotency check can be bypassed; duplicate webhook processing
**Fix:** Add `UNIQUE(stripe_event_id)` constraint (allow NULL)
**Effort:** 15 minutes

---

## HIGH ISSUES (Must Fix Before Real Users)

### H1: No Rate Limiting on Payment/Upload/Signing Endpoints
**Found by:** Backend audit
**Location:** `SecurityConfig.java:27`
**Risk:** Brute-force, spam signature requests, file upload bombs
**Fix:** Extend rate limiting to `/payments/*/checkout`, `/documents`, `/leases/*/send`
**Effort:** 2 hours

### H2: Two Lease Signing Paths May Race
**Found by:** E2E audit
**Location:** `LeaseService.java`, `LeaseSigningScreen`
**Risk:** App signing + OpenSign webhook fire simultaneously → inconsistent state
**Fix:** For MVP, use app-only signing path; disable OpenSign forwarding or add mutex
**Effort:** 1 hour

### H3: Unit Status Not Updated on Move-Out Approval
**Found by:** E2E audit
**Location:** `MoveOutService.java:88-95`
**Risk:** After move-out approved, unit stays OCCUPIED → landlord can't re-invite
**Fix:** Set unit.status = VACANT when move-out approved
**Effort:** 30 minutes

### H4: No Lease Auto-Expiration
**Found by:** Data model audit
**Location:** `LeaseService.java` — missing scheduled task
**Risk:** Leases remain FULLY_EXECUTED past end_date; dashboard shows stale data
**Fix:** Add @Scheduled job to transition expired leases
**Effort:** 2 hours

### H5: Missing CSRF Protection / Request Size Limits
**Found by:** Backend audit
**Location:** `SecurityConfig.java:39`, `application.properties`
**Risk:** Cross-origin attacks, large JSON payload memory exhaustion
**Fix:** Add Origin header validation + `server.tomcat.max-http-post-size=1048576`
**Effort:** 1 hour

---

## MEDIUM ISSUES (Fix Soon After Launch)

### M1: Move-Out Date Validation Missing
Backend allows past dates for move-out requests. Add `requestedDate >= today` validation.

### M2: No Late Fee Auto-Calculation
Late fees shown in UI but never auto-deducted. Add daily scheduled job.

### M3: Email Retry Blocks Request Thread
`EmailService.java` synchronous retry with Thread.sleep(). Use async path consistently.

### M4: Raw Exception Strings in Some Error Messages
A few screens show "Error: $e" instead of user-friendly messages.

### M5: Lease Editing Not Implemented
Lease edit marked "coming soon". Users must delete and recreate.

### M6: Missing Audit Logging for Failed Operations
Failed uploads, webhooks, and OpenSign calls not logged to audit trail.

### M7: Document Upload Without Lease Reference Can Orphan
Tenant can upload document without leaseId. Consider making it required.

### M8: No Secrets Rotation Strategy Documented
JWT, Stripe, OpenSign keys need documented rotation procedure.

---

## CREDENTIAL BLOCKERS (Environmental — Not Code Issues)

| Service | Status | Action Needed |
|---------|--------|---------------|
| Authgear | Credentials found in `.env.local` | Wire into running app and test |
| OpenSign | Dev keys configured, instance running locally | Deploy self-hosted for production |
| Stripe | Placeholder keys only | Generate live keys, rotate test keys |
| AWS SES | No SMTP credentials | Set up SES, exit sandbox mode |
| AWS S3 | Not configured | Create bucket, set IAM credentials |

---

## WIREFRAME FIDELITY SUMMARY

| Category | Full Match | Partial | Missing |
|----------|-----------|---------|---------|
| Auth & Onboarding (4) | 4 | 0 | 0 |
| Landlord Dashboard (5) | 1 | 4 | 0 |
| Property Management (9) | 5 | 3 | 1 |
| Tenant Screens (4) | 1 | 3 | 0 |
| Invite Flow (6) | 4 | 2 | 0 |
| Lease Management (11) | 1 | 8 | 2 |
| Signing Flow (5) | 5 | 0 | 0 |
| Payments (5) | 2 | 3 | 0 |
| Documents (2) | 0 | 2 | 0 |
| Move-Out (2) | 1 | 1 | 0 |
| Notifications (1) | 1 | 0 | 0 |
| **TOTAL (54)** | **25 (46%)** | **26 (48%)** | **3 (6%)** |

### Corrections from Previous Audit
These were previously flagged as missing but ARE actually implemented:
- Notification date grouping (TODAY/YESTERDAY headers) — DONE
- Relative timestamps ("2h ago") — DONE
- Lease Settings screens (overview + edit) — DONE
- Business & Finance section in account settings — DONE
- Search bars on list screens (code exists, UI functional)

---

## PASSED CHECKS (What's Working)

- All 6 critical user flows complete end-to-end
- 48+ backend endpoints with proper @PreAuthorize
- JWT implementation correct (BCrypt, HMAC-SHA, refresh tokens)
- Stripe webhook signature verification correct
- SQL injection prevented (Spring Data JPA parameterized queries)
- Document storage isolated by tenant
- Transaction handling with proper rollback
- Connection pool tuned for AWS t3.micro
- CORS configured per environment
- Actuator locked down (health-only in production)
- Global exception handler returns proper HTTP status codes
- All sensitive values use environment variable substitution
- No secrets found in codebase
- Flyway migrations safe (no DROP TABLE, idempotent constraints)
- 87 backend tests + 69 frontend tests
- Comprehensive deployment documentation

---

## ESTIMATED FIX EFFORT

| Priority | Items | Estimated Hours |
|----------|-------|----------------|
| Critical (C1-C5) | 5 | ~5 hours |
| High (H1-H5) | 5 | ~7 hours |
| Medium (M1-M8) | 8 | ~10 hours |
| **Total** | **18** | **~22 hours** |

---

## RECOMMENDATION

**Fix C1-C5 and H1-H5 (10 items, ~12 hours) before any real user touches the app.**
Medium items can ship as fast-follow within first week.
Credential setup (Stripe live keys, SES, S3) is parallel work.

After fixes: deploy to staging, run full E2E with both simulators, then production.
