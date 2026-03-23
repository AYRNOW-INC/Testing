# Known Blockers and Next Steps — Auth

Purpose: Tracks what is working, what is deferred, and what needs to be built next for AYRNOW auth.

---

## What Is Working

- **Registration**: Landlord and tenant registration with BCrypt password hashing.
- **Login**: Email/password login returning JWT access + refresh token pair.
- **Token refresh**: Refresh endpoint issues new token pairs.
- **Identity check**: `/api/auth/me` returns authenticated user with roles.
- **Role assignment**: LANDLORD and TENANT roles stored in `roles` table at registration.
- **Role enforcement**: Backend checks role on protected endpoints (properties, leases, invitations, etc.).
- **Flyway migrations**: V1 (core schema) and V3 (auth hardening) applied cleanly.
- **Flutter integration**: Login, register, token storage, and auth gate all functional.
- **Stateless JWT**: No server-side session storage. Tokens are self-contained.

## What Is Deferred

### Social Auth (Google/Apple Sign-In)

- **Status**: Not implemented. Deferred to a future phase.
- **Approach**: Will use native OAuth (Spring Security OAuth2 client + Flutter oauth packages), NOT an external provider like Authgear.
- **Schema ready**: `external_id` column on `users` and `idx_users_external_id` index exist for future OAuth provider IDs.
- **No timeline set.**

### Email Verification

- **Status**: Schema ready, send logic not implemented.
- **Schema**: `email_verified` boolean column added in V3 migration, defaults to `FALSE`.
- **Next step**: Implement email sending (via AWS SES or similar), verification endpoint, and enforce verification on sensitive actions.
- **Current behavior**: Users can operate without verifying email.

### Password Reset

- **Status**: Schema ready, endpoint not implemented.
- **Schema**: `password_reset_tokens` table added in V3 migration with token, expiry, and used flag.
- **Next step**: Implement `POST /api/auth/forgot-password` (generates token, sends email) and `POST /api/auth/reset-password` (validates token, updates password).
- **Depends on**: Email sending infrastructure.

## Known Blockers (Non-Auth)

These affect the project but are not auth-specific:

1. **Git push protection / secret-in-history**: A previously committed secret triggers GitHub push protection. The secret must be removed from git history (via `git filter-repo` or BFG Repo Cleaner) and rotated before pushing to the remote.
2. **AWS deploy runbook and env verification**: The deployment plan exists (see [AWS_DEPLOYMENT_PLAN_v2.md](./AWS_DEPLOYMENT_PLAN_v2.md)) but production environment variables, RDS provisioning, and EB configuration have not been verified end-to-end. A dry-run deploy must be completed before go-live.
3. **iOS bundle ID / signing and App Store submission**: The iOS bundle ID (`com.ayrnow.app`) must be confirmed in Xcode, Apple Developer certificates and provisioning profiles created, and the App Store Connect listing completed. See [APP_STORE_SUBMISSION.md](./APP_STORE_SUBMISSION.md) for the full runbook.
4. **Play Store submission**: The Google Play Console listing must be created, store listing assets prepared, data safety declaration completed, and the first AAB uploaded. See [PLAY_STORE_SUBMISSION.md](./PLAY_STORE_SUBMISSION.md) for the full runbook.
5. **Android key.properties alignment**: The `storeFile` path in `key.properties` must resolve correctly relative to `frontend/android/app/build.gradle.kts`. The `key.properties.example` template has been updated. Verify the actual keystore file location matches before building a release.
6. **Stripe test secret rotation**: If the old Stripe test secret (`sk_test_*`) was ever committed to the repo, it must be rotated in the Stripe Dashboard before pushing the cleaned history. Generate a new test key and update the local environment variable.
7. **Production API host configuration**: The Flutter app must point to the correct production API base URL for release builds. This value should be environment-driven (build flavor or compile-time constant), not hardcoded. The production URL depends on the AWS deployment (e.g., `https://api.ayrnow.com`).

## Recommended Next Steps (Auth)

1. Implement password reset endpoints (schema already exists).
2. Implement email verification flow (schema already exists).
3. Add rate limiting to `/api/auth/login` and `/api/auth/register`.
4. Add token blacklist or short-lived refresh tokens for logout.
5. Implement native Google OAuth (Spring Security OAuth2 + Flutter `google_sign_in`).
6. Implement native Apple Sign-In (Spring Security + Flutter `sign_in_with_apple`).
7. Add account lockout after repeated failed login attempts.
