# AYRNOW Production Runbook

Go-live checklist, launch steps, and rollback procedures for the AYRNOW MVP.

---

## Pre-Launch Checklist

### Environment Variables

All of the following must be configured in AWS Elastic Beanstalk environment properties before deployment:

| Variable | Required | Notes |
|----------|----------|-------|
| `SPRING_DATASOURCE_URL` | Yes | `jdbc:postgresql://<RDS-endpoint>:5432/ayrnow` |
| `SPRING_DATASOURCE_USERNAME` | Yes | RDS master or app-specific user |
| `SPRING_DATASOURCE_PASSWORD` | Yes | RDS password |
| `JWT_SECRET` | Yes | Min 32 chars. Generate: `openssl rand -base64 48` |
| `CORS_ALLOWED_ORIGINS` | Yes | `https://ayrnow.com,https://www.ayrnow.com` |
| `STRIPE_SECRET_KEY` | Yes | Must be `sk_live_*` for production |
| `STRIPE_WEBHOOK_SECRET` | Yes | From Stripe Dashboard webhook endpoint config |
| `MAIL_HOST` | Yes | SES SMTP endpoint (e.g., `email-smtp.us-east-1.amazonaws.com`) |
| `MAIL_USERNAME` | Yes | SES SMTP credentials |
| `MAIL_PASSWORD` | Yes | SES SMTP credentials |
| `JWT_ACCESS_MINUTES` | No | Default: 30 |
| `JWT_REFRESH_DAYS` | No | Default: 7 |
| `STRIPE_SUCCESS_URL` | No | Redirect after successful payment |
| `STRIPE_CANCEL_URL` | No | Redirect after cancelled payment |
| `OPENSIGN_BASE_URL` | Yes | Self-hosted OpenSign instance URL |
| `OPENSIGN_API_TOKEN` | Yes | OpenSign API authentication token |

### Infrastructure

- [ ] RDS PostgreSQL instance provisioned (PostgreSQL 16)
- [ ] RDS security group allows inbound from EB security group on port 5432
- [ ] EB environment created (Java SE platform, not Tomcat)
- [ ] EB instance profile has permissions for S3 (document storage), SES (email), CloudWatch (logs)
- [ ] S3 bucket created for tenant document uploads
- [ ] SSL certificate provisioned via ACM for `ayrnow.com` and `api.ayrnow.com`
- [ ] DNS records configured:
  - `api.ayrnow.com` CNAME -> EB environment URL or ALB DNS
  - `ayrnow.com` as needed for frontend distribution
- [ ] CloudWatch log group created or auto-created by EB

### External Services

- [ ] Stripe production keys obtained (`sk_live_*`, `pk_live_*`)
- [ ] Stripe webhook endpoint registered: `https://api.ayrnow.com/api/webhooks/stripe`
  - Events to subscribe: `checkout.session.completed`, `payment_intent.succeeded`, `payment_intent.payment_failed`
- [ ] OpenSign self-hosted instance deployed and accessible from EB
- [ ] OpenSign webhook callback URL configured: `https://api.ayrnow.com/api/webhooks/opensign`
- [ ] SES domain verification completed for `ayrnow.com`
- [ ] SES SMTP credentials generated and tested
- [ ] SES moved out of sandbox (production sending enabled) OR verified recipient emails for testing

### Verification

- [ ] Health check passes: `GET https://api.ayrnow.com/api/health` returns 200
- [ ] Flyway migrations applied successfully (check application startup logs)
- [ ] At least one test API call succeeds (e.g., POST /api/auth/register)

---

## Launch Steps

Execute in this order:

### 1. Deploy Backend

```bash
# Build the JAR
cd backend
mvn clean package -DskipTests

# Deploy to EB
eb deploy ayrnow-production
```

### 2. Verify Health Check

```bash
curl -s https://api.ayrnow.com/api/health
# Expected: 200 OK with health response
```

### 3. Verify Flyway Migrations

Check EB logs for Flyway output:

```bash
eb logs --all
# Look for: "Successfully applied X migrations to schema"
```

Alternatively, connect to RDS and verify:

```sql
SELECT version, description, success FROM flyway_schema_history ORDER BY installed_rank;
```

All 8 migrations (V1 through V8) should show `success = true`.

### 4. Verify Core API Endpoints

```bash
# Registration
curl -X POST https://api.ayrnow.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@ayrnow.com","password":"Test1234A","firstName":"Test","lastName":"User","role":"LANDLORD"}'

# Login
curl -X POST https://api.ayrnow.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@ayrnow.com","password":"Test1234A"}'
```

### 5. Configure Stripe Webhook

1. Go to Stripe Dashboard > Developers > Webhooks
2. Add endpoint: `https://api.ayrnow.com/api/webhooks/stripe`
3. Select events: `checkout.session.completed`, `payment_intent.succeeded`, `payment_intent.payment_failed`
4. Copy the webhook signing secret
5. Update EB env var `STRIPE_WEBHOOK_SECRET` with the new signing secret
6. EB will restart automatically after env var update

### 6. Test Payment Flow

Use Stripe test card `4242424242424242` to verify the payment path before switching to live keys.

### 7. Switch to Production Stripe Keys

1. Update `STRIPE_SECRET_KEY` to `sk_live_*` in EB env vars
2. Update `STRIPE_WEBHOOK_SECRET` if using a separate production webhook endpoint
3. Verify a small real payment if possible

### 8. Deploy Frontend

- Submit Flutter app to App Store Connect and Google Play Console
- Ensure the app points to `https://api.ayrnow.com` as the API base URL
- Verify end-to-end flows on both iOS and Android

### 9. End-to-End Verification

Run through each critical flow:

1. Landlord registration and login
2. Create property with units
3. Invite tenant
4. Tenant accepts invite and registers
5. Create and send lease
6. Both parties sign lease
7. Tenant uploads documents
8. Tenant pays rent
9. Tenant requests move-out
10. Landlord approves move-out

---

## Rollback Procedure

### Application Rollback

```bash
# Roll back to previous EB version
eb deploy ayrnow-production --version <previous-version-label>

# Or via AWS Console:
# EB > Environments > ayrnow-production > Application versions > Deploy previous
```

### Database Rollback

Flyway migrations are **forward-only**. There is no automatic rollback.

If a migration causes issues:

1. **Do NOT** delete rows from `flyway_schema_history` manually
2. Identify the specific change that caused the problem
3. Write a new forward migration (e.g., V9) that reverts the problematic change
4. If data corruption occurred:
   - Restore from the most recent RDS automated snapshot
   - Re-deploy the previous application version
   - Investigate and fix the migration before re-attempting

### Stripe Rollback

If payment processing has issues:

1. Revert `STRIPE_SECRET_KEY` to test key (`sk_test_*`) in EB env vars
2. Disable the production webhook endpoint in Stripe Dashboard
3. Investigate payment logs in Stripe Dashboard
4. Coordinate refunds if needed through Stripe Dashboard

### DNS Rollback

If the new deployment is completely broken:

1. Update DNS to point to a maintenance page or previous infrastructure
2. Or use Route 53 health checks with failover routing (if configured)

---

## Emergency Contacts

| Role | Contact | Notes |
|------|---------|-------|
| Project Lead | _[Add name and contact]_ | Primary decision maker |
| Backend Engineer | _[Add name and contact]_ | Spring Boot / API issues |
| Frontend Engineer | _[Add name and contact]_ | Flutter / mobile issues |
| AWS Support | AWS Support Center | Requires Business or Enterprise support plan |
| Stripe Support | https://support.stripe.com/ | Payment processing issues |
| Domain/DNS | _[Add registrar contact]_ | ayrnow.com DNS issues |

---

## Useful Commands

```bash
# EB status
eb status ayrnow-production

# EB logs (recent)
eb logs

# EB SSH into instance
eb ssh ayrnow-production

# RDS connection (from EB instance or bastion)
psql -h <rds-endpoint> -U ayrnow -d ayrnow

# Check Flyway state
SELECT * FROM flyway_schema_history ORDER BY installed_rank;

# Check active connections
SELECT count(*) FROM pg_stat_activity WHERE datname = 'ayrnow';
```
