# AYRNOW Secrets Rotation Policy

Credential management, rotation schedules, and emergency procedures.

---

## Secret Inventory

| Secret | Location | Rotation Frequency | Owner |
|--------|----------|-------------------|-------|
| `JWT_SECRET` | EB env var | Every 90 days | Backend lead |
| `SPRING_DATASOURCE_PASSWORD` | EB env var + RDS | Every 90 days | Infra lead |
| `STRIPE_SECRET_KEY` | EB env var | On compromise only | Backend lead |
| `STRIPE_WEBHOOK_SECRET` | EB env var | On endpoint change | Backend lead |
| `OPENSIGN_API_TOKEN` | EB env var | Every 90 days | Backend lead |
| `MAIL_PASSWORD` (SES SMTP) | EB env var | On compromise | Infra lead |
| `AUTHGEAR_CLIENT_SECRET` | EB env var | On compromise | Backend lead |

---

## Rotation Procedures

### JWT_SECRET

**Generate new value:**

```bash
openssl rand -base64 48
```

**Where to update:**
1. AWS EB environment properties: `JWT_SECRET`

**How to verify:**
1. After EB restarts, call `POST /api/auth/login` with valid credentials
2. Verify a new JWT is issued and works for authenticated endpoints

**Impact on active sessions:**
- All existing JWTs become invalid immediately
- Users will need to log in again
- Schedule rotation during low-traffic hours

**Rollback:**
- Set the old `JWT_SECRET` value back in EB env vars
- EB will restart and old tokens will work again

---

### SPRING_DATASOURCE_PASSWORD (Database)

**Generate new value:**

```bash
openssl rand -base64 24
```

**Where to update (two-step, order matters):**
1. **First:** Update password in RDS:
   ```sql
   ALTER USER ayrnow WITH PASSWORD 'new-password-here';
   ```
2. **Second:** Update EB env var `SPRING_DATASOURCE_PASSWORD` with the new password
3. EB will restart automatically and connect with the new password

**How to verify:**
1. Check EB health returns to green after restart
2. Call any API endpoint that queries the database
3. Check CloudWatch logs for successful database connection

**Impact on active sessions:**
- Brief downtime during EB restart (typically 30-60 seconds)
- No impact on user sessions (JWT-based auth is independent of DB password)

**Rollback:**
- If step 2 fails: revert RDS password to old value
  ```sql
  ALTER USER ayrnow WITH PASSWORD 'old-password-here';
  ```
- If step 2 succeeded but app is broken: revert both RDS and EB to old password

**IMPORTANT:** Never update EB before RDS. The app will fail to connect during the gap.

---

### STRIPE_SECRET_KEY

**When to rotate:** Only on compromise or when migrating Stripe accounts.

**Where to update:**
1. In Stripe Dashboard: API Keys > Roll key (this invalidates the old key immediately)
2. Copy the new `sk_live_*` key
3. Update EB env var `STRIPE_SECRET_KEY`

**How to verify:**
1. After EB restart, initiate a test payment
2. Verify Stripe Dashboard shows the charge under the correct API key
3. Check that webhook events are still being received

**Impact on active sessions:**
- Any in-flight payment intents created with the old key will still complete (Stripe handles this)
- New payment creation will use the new key after restart

**Rollback:**
- Cannot unroll a Stripe key. If the new key doesn't work, check Stripe Dashboard for issues.
- In emergency, create a new restricted key with the same permissions.

---

### STRIPE_WEBHOOK_SECRET

**When to rotate:** When changing the webhook endpoint URL or on compromise.

**Where to update:**
1. In Stripe Dashboard: Developers > Webhooks > Select endpoint > Reveal signing secret
2. If creating a new endpoint, the secret is shown upon creation
3. Update EB env var `STRIPE_WEBHOOK_SECRET`

**How to verify:**
1. After EB restart, trigger a test webhook event from Stripe Dashboard
2. Check that the AYRNOW backend processes it successfully (check logs and database)
3. Verify no `400` responses to Stripe webhook deliveries

**Impact:**
- Webhook events sent between old secret invalidation and new secret deployment will fail signature verification
- Stripe will retry failed webhooks for up to 3 days

**Rollback:**
- Keep the old webhook endpoint active in Stripe until the new one is verified

---

### OPENSIGN_API_TOKEN

**Generate new value:**
- Generate in the OpenSign admin panel or self-hosted configuration

**Where to update:**
1. Update the token in the OpenSign server configuration
2. Update EB env var `OPENSIGN_API_TOKEN`

**How to verify:**
1. After EB restart, create a test lease and send for signing
2. Verify OpenSign receives the document and creates signer links
3. Check AYRNOW logs for successful OpenSign API calls

**Impact on active sessions:**
- Any leases currently in the signing process should continue (OpenSign tracks them internally)
- New signing requests will use the new token

**Rollback:**
- Revert both OpenSign server config and EB env var to the old token

---

### MAIL_PASSWORD (SES SMTP)

**Generate new value:**
1. Go to AWS SES Console > SMTP Settings > Create SMTP credentials
2. This creates a new IAM user with SMTP permissions
3. Download the new credentials

**Where to update:**
1. Update EB env vars: `MAIL_USERNAME` and `MAIL_PASSWORD`

**How to verify:**
1. After EB restart, trigger an action that sends email (e.g., tenant invite)
2. Verify the email is received
3. Check SES sending statistics for successful deliveries

**Impact:**
- Brief gap in email sending during EB restart
- No queued emails will be lost (they'll fail and can be retried)

**Rollback:**
- Revert to old SES SMTP credentials (they remain valid until the IAM user is deleted)
- Delete the new IAM SMTP user if not needed

---

### AUTHGEAR_CLIENT_SECRET

**When to rotate:** On compromise or app recreation in Authgear.

**Where to update:**
1. Generate new client secret in Authgear portal > Applications > AYRNOW app
2. Update EB env var `AUTHGEAR_CLIENT_SECRET`

**How to verify:**
1. After EB restart, attempt a login flow that goes through Authgear
2. Verify tokens are exchanged successfully

**Impact:**
- Any in-flight Authgear auth flows may fail
- Users will need to re-authenticate

**Rollback:**
- Revert to old secret in EB if Authgear still accepts it
- Authgear may invalidate old secrets — check their documentation

---

## Emergency Rotation Procedure

If any secret is suspected to be compromised:

### Immediate Actions (within 1 hour)

1. **Assess scope:** Determine which secret(s) are compromised and how
2. **Generate new secret:** Use the procedures above for the specific secret
3. **Update in production:** Apply to EB environment (or RDS, Stripe, etc.)
4. **Restart application:** EB auto-restarts on env var change; verify health check
5. **Monitor:** Watch CloudWatch logs and Stripe Dashboard for unauthorized activity

### Investigation (within 24 hours)

6. **Review audit logs:** Check `audit_logs` table for unusual activity during the exposure window
7. **Review CloudTrail:** Check for unauthorized AWS API calls
8. **Review Stripe Dashboard:** Check for unauthorized charges or API calls
9. **Review access logs:** Check EB/ALB access logs for unusual request patterns
10. **Identify exposure vector:** How was the secret compromised? Fix the root cause.

### Communication (as needed)

11. **Notify affected users** if user data may have been exposed
12. **Document the incident:** Timeline, scope, actions taken, root cause, prevention measures
13. **Update this policy** if the incident reveals gaps

---

## Rotation Schedule

Maintain a rotation log to track when each secret was last rotated:

| Secret | Last Rotated | Next Due | Rotated By |
|--------|-------------|----------|------------|
| `JWT_SECRET` | _[date]_ | _[+90 days]_ | _[name]_ |
| `SPRING_DATASOURCE_PASSWORD` | _[date]_ | _[+90 days]_ | _[name]_ |
| `OPENSIGN_API_TOKEN` | _[date]_ | _[+90 days]_ | _[name]_ |
| `STRIPE_SECRET_KEY` | _[date]_ | On compromise | _[name]_ |
| `STRIPE_WEBHOOK_SECRET` | _[date]_ | On endpoint change | _[name]_ |
| `MAIL_PASSWORD` | _[date]_ | On compromise | _[name]_ |
| `AUTHGEAR_CLIENT_SECRET` | _[date]_ | On compromise | _[name]_ |

Set a calendar reminder for 90-day rotations.
