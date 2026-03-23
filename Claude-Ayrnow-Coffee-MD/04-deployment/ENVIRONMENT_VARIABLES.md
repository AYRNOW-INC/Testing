# Environment Variables

All environment variables for both backend and frontend, with defaults and descriptions.

---

## Backend Variables

Source: `backend/src/main/resources/application.properties` and `backend/.env.example`

### Database

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `SPRING_DATASOURCE_URL` | Yes | `jdbc:postgresql://localhost:5432/ayrnow` | JDBC connection URL |
| `SPRING_DATASOURCE_USERNAME` | Yes | `ayrnow` | Database user |
| `SPRING_DATASOURCE_PASSWORD` | Yes | `ayrnow` | Database password |

### Authentication (JWT)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `JWT_SECRET` | Yes | — | HMAC-SHA256 signing key. Min 32 characters. |
| `JWT_ACCESS_MINUTES` | No | `30` | Access token lifetime in minutes |
| `JWT_REFRESH_DAYS` | No | `7` | Refresh token lifetime in days |

Generate a secret:
```bash
openssl rand -base64 48
```

### CORS

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CORS_ALLOWED_ORIGINS` | No | `http://localhost:3000,http://localhost:8080` | Comma-separated allowed origins |

### Stripe

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `STRIPE_SECRET_KEY` | Yes* | `sk_test_placeholder` | Stripe API secret key |
| `STRIPE_WEBHOOK_SECRET` | Yes* | `whsec_placeholder` | Stripe webhook signing secret |
| `STRIPE_SUCCESS_URL` | No | `http://localhost:8080/payment/success` | Redirect after successful payment |
| `STRIPE_CANCEL_URL` | No | `http://localhost:8080/payment/cancel` | Redirect if payment cancelled |

*Required when payment flows are active.

### OpenSign (Planned)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `OPENSIGN_BASE_URL` | No | — | OpenSign instance URL (not yet active) |
| `OPENSIGN_API_TOKEN` | No | — | OpenSign API token (not yet active) |

### File Storage

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `FILE_UPLOAD_DIR` | No | `./uploads` | Local directory for uploaded files (used when STORAGE_TYPE=local) |
| `STORAGE_TYPE` | No | `local` | Storage backend: `local` (filesystem) or `s3` (AWS S3) |
| `AWS_S3_BUCKET` | Yes* | — | S3 bucket name (*required when STORAGE_TYPE=s3) |
| `AWS_S3_REGION` | No | `us-east-1` | AWS region for S3 bucket |
| `AWS_S3_PREFIX` | No | — | Optional key prefix for all S3 objects |

*S3 variables are only required when `STORAGE_TYPE=s3`. In local mode (default), files are stored on the filesystem at `FILE_UPLOAD_DIR`.

**S3 Key Structure:**
- Tenant documents: `uploads/{tenantId}/{uuid}.{ext}`
- Lease drafts: `leases/{leaseId}/draft.pdf`
- Signed leases: `leases/{leaseId}/signed.pdf`

**AWS Credentials:** When using S3 storage, the application relies on the AWS SDK default credential chain (environment variables, IAM roles, EC2 instance profiles, etc.). No explicit AWS access key properties are needed in application.properties.

### Server

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `SERVER_PORT` | No | `8080` | HTTP port for backend |

### Spring Boot Profiles

Activate with `SPRING_PROFILES_ACTIVE`:
- `dev` (default) — local development settings
- `staging` — staging environment
- `prod` — production settings

---

## Frontend Variables

Source: `frontend/.env.example`

Pass via `--dart-define` flags:
```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8080/api
```

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `API_BASE_URL` | Yes | `http://localhost:8080/api` | Backend API base URL |
| `STRIPE_PUBLISHABLE_KEY` | No | — | Stripe publishable key (needed for in-app Elements) |

---

## What Is NOT Needed

- No `AUTHGEAR_*` variables — AYRNOW uses native JWT auth.
- No Docker-related variables.
- No external OAuth secrets — social login is deferred.

## Local Development Setup

```bash
cd backend
cp .env.example .env
# Edit .env — set JWT_SECRET at minimum
```

For local dev, database defaults (`ayrnow`/`ayrnow` on localhost:5432) work if PostgreSQL is set up per `docs/SETUP_MAC.md`.

## Production Notes

- Use AWS Secrets Manager or SSM Parameter Store for `JWT_SECRET`, database credentials, and Stripe keys.
- Rotate `JWT_SECRET` periodically — rotation invalidates all existing tokens (users must re-login).
- Never commit real secrets to the repository.
- Update `STRIPE_SUCCESS_URL` and `STRIPE_CANCEL_URL` to production domain.
- Update `CORS_ALLOWED_ORIGINS` to production frontend domain.
