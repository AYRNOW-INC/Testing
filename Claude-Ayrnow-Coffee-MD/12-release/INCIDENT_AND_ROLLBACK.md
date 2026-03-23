# Incident Response and Rollback

## Rollback Procedure

### Backend (Spring Boot JAR on EC2/EB)

1. **Stop current service**
   ```bash
   sudo systemctl stop ayrnow
   ```

2. **Deploy previous JAR**
   ```bash
   # Keep previous JARs in /opt/ayrnow/releases/
   cp /opt/ayrnow/releases/ayrnow-backend-PREVIOUS.jar /opt/ayrnow/current/ayrnow-backend.jar
   sudo systemctl start ayrnow
   ```

3. **Verify**
   ```bash
   curl https://api.ayrnow.com/api/health
   ```

If using Elastic Beanstalk:
```bash
# List recent versions
aws elasticbeanstalk describe-application-versions --application-name ayrnow

# Deploy previous version
aws elasticbeanstalk update-environment \
  --environment-name ayrnow-prod \
  --version-label PREVIOUS_VERSION_LABEL
```

### Flyway / Database Rollback

Flyway migrations are **forward-only**. There is no automatic rollback.

If a migration causes issues:
1. Do NOT delete or edit the failed migration file.
2. Write a new migration (e.g., `V5__Revert_v4_changes.sql`) that undoes the changes.
3. Apply it by restarting the backend (Flyway runs on startup).
4. If the backend cannot start due to a broken migration, manually fix the DB:
   ```bash
   psql ayrnow -U ayrnow
   -- Fix the data/schema manually
   -- Then repair Flyway's history:
   DELETE FROM flyway_schema_history WHERE version = 'X';
   ```

**Prevention:** Always test migrations on a copy of the production database before deploying.

### Frontend (Flutter Mobile App)

Mobile apps cannot be rolled back once published to stores. Mitigation:
- Use feature flags or API version checks to disable broken features server-side.
- Push a hotfix build to the stores as fast as possible.
- For TestFlight/internal testing, simply deploy the previous build.

## Common Incident Scenarios

### Backend won't start after deploy
1. Check logs: `journalctl -u ayrnow -n 100` or CloudWatch
2. Common causes: missing env var, Flyway migration failure, port conflict
3. Fix: rollback JAR or fix env vars, restart

### Stripe webhooks failing
1. Check Stripe Dashboard > Webhooks > recent events
2. Check backend logs for webhook errors
3. Common causes: wrong `STRIPE_WEBHOOK_SECRET`, endpoint unreachable, signature mismatch
4. Fix: update secret, verify endpoint URL, redeploy if needed
5. Stripe retries failed webhooks automatically for up to 72 hours

### Database connection failures
1. Check RDS status in AWS console
2. Check security groups (EC2 must be able to reach RDS on port 5432)
3. Check credentials in env vars
4. Check connection pool exhaustion in logs

### Payment stuck in PENDING
1. Check Stripe Dashboard for the checkout session status
2. Check if webhook was delivered (Stripe Dashboard > Webhooks > Events)
3. If webhook was delivered but not processed, check backend logs
4. Manual fix: update payment status in DB after confirming Stripe state

## Monitoring Checklist

- [ ] `/api/health` endpoint monitored (CloudWatch, UptimeRobot, or similar)
- [ ] Backend application logs flowing to CloudWatch
- [ ] Stripe webhook delivery monitored in Stripe Dashboard
- [ ] RDS automated backups enabled
- [ ] Alerts configured for: health check failure, 5xx spike, DB connection errors
