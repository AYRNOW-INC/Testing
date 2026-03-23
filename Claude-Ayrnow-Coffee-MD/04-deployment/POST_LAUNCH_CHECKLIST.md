# AYRNOW Post-Launch Checklist

Monitoring and verification tasks for the first week after production launch.

---

## Day 1 — Launch Day

### Immediate (first hour)

- [ ] Verify `/api/health` returns 200 (check every 5 minutes for the first hour)
- [ ] Monitor EB health status: green = healthy
- [ ] Check CloudWatch logs for any startup errors or exceptions
- [ ] Verify Flyway migration state (all V1-V8 show `success = true`)
- [ ] Verify Stripe webhook delivery in Stripe Dashboard > Developers > Webhooks > Recent deliveries

### First real user flows

- [ ] Verify first real user registration completes successfully
- [ ] Verify first real login produces valid JWT tokens
- [ ] Verify first property creation succeeds
- [ ] Verify first invitation email is delivered (check SES sending stats)
- [ ] Verify first payment flow completes end-to-end
- [ ] Check `audit_logs` table has entries for the above actions

### Monitoring

- [ ] Check CloudWatch for 5xx errors (should be zero or near-zero)
- [ ] Check CloudWatch for elevated 4xx errors (may indicate client issues)
- [ ] Monitor SES sending statistics — check bounce and complaint rates
- [ ] Verify Stripe Dashboard shows successful webhook deliveries (no persistent failures)
- [ ] Check RDS metrics: CPU, freeable memory, database connections

### End of Day 1

- [ ] Review all CloudWatch error logs from the day
- [ ] Confirm no unexpected Flyway migrations ran
- [ ] Verify RDS automated backup completed
- [ ] Document any issues encountered and their resolutions

---

## Day 2-3 — Stabilization

### Error Monitoring

- [ ] Review CloudWatch error rate trends — should be stable or declining
- [ ] Check for any repeated 5xx patterns (same endpoint, same error)
- [ ] Review application logs for unhandled exceptions
- [ ] Check for any `OutOfMemoryError` or connection pool exhaustion warnings

### Functional Verification

- [ ] Verify lease signing flow works end-to-end (landlord creates, both sign, webhook updates status)
- [ ] Verify tenant document upload and landlord review flow
- [ ] Verify invite email delivery rates (check SES > Sending Statistics)
- [ ] Verify move-out request submission and landlord approval flow
- [ ] Test password reset flow with a real email

### Performance

- [ ] Check API response times in CloudWatch (p50, p95, p99)
- [ ] Verify database query performance — check for slow queries in RDS Performance Insights
- [ ] Monitor EB instance CPU and memory usage
- [ ] Check database connection pool usage (active vs. idle connections)

### Data Integrity

- [ ] Spot-check `payments` table — amounts match Stripe Dashboard
- [ ] Spot-check `leases` table — statuses are consistent
- [ ] Verify no orphaned records (invitations without valid unit_space_id, etc.)

---

## Day 7 — First Week Review

### Metrics Review

- [ ] Compile weekly metrics:
  - Total registrations (landlords and tenants)
  - Total properties created
  - Total invitations sent vs. accepted
  - Total leases created vs. fully executed
  - Total payments processed (count and volume)
  - Total move-out requests
- [ ] Review error rate trend for the week
- [ ] Review average and p95 response times for the week

### Infrastructure Health

- [ ] Check EB instance health and instance type suitability
- [ ] Review RDS disk usage and projected growth
- [ ] Review RDS CPU and memory trends
- [ ] Verify RDS automated backups are completing daily
- [ ] Check S3 bucket usage for document storage
- [ ] Review SES sending quotas vs. actual usage

### Security Review

- [ ] Review `audit_logs` for any suspicious activity:
  - Multiple failed login attempts from same IP
  - Unusual API access patterns
  - Unauthorized access attempts (403 responses)
- [ ] Verify no secrets are exposed in CloudWatch logs
- [ ] Check for any unexpected IAM activity in CloudTrail
- [ ] Review Stripe Dashboard for any suspicious payment activity

### Flyway and Database

- [ ] Verify Flyway migration state is clean (`SELECT * FROM flyway_schema_history`)
- [ ] No pending or failed migrations
- [ ] Verify database indexes are being used (check `pg_stat_user_indexes`)
- [ ] Review `pg_stat_user_tables` for tables with high sequential scans (may need indexes)

---

## CloudWatch Alarms to Configure

Set these up in CloudWatch immediately after launch:

| Alarm | Metric | Threshold | Period | Action |
|-------|--------|-----------|--------|--------|
| High 5xx Rate | 5xx count | > 10 in 5 min | 5 min | SNS notification |
| Sustained 5xx | 5xx rate | > 1% of requests | 15 min | SNS notification |
| Slow Response | p95 latency | > 2000 ms | 5 min | SNS notification |
| High CPU | CPUUtilization | > 80% | 10 min | SNS notification |
| DB Connections | DatabaseConnections | > 80% of max | 5 min | SNS notification |
| DB CPU | RDS CPUUtilization | > 80% | 10 min | SNS notification |
| DB Storage | FreeStorageSpace | < 2 GB | 15 min | SNS notification |
| EB Health | HealthStatus | Degraded or Severe | 1 min | SNS notification |
| SES Bounce Rate | Bounce rate | > 5% | 1 hour | SNS notification |

### SNS Topic Setup

```bash
# Create SNS topic for alerts
aws sns create-topic --name ayrnow-production-alerts

# Subscribe team email
aws sns subscribe \
  --topic-arn arn:aws:sns:us-east-1:ACCOUNT_ID:ayrnow-production-alerts \
  --protocol email \
  --notification-endpoint team@ayrnow.com
```

### Sample CloudWatch Alarm (CLI)

```bash
# High 5xx error rate alarm
aws cloudwatch put-metric-alarm \
  --alarm-name "AYRNOW-High-5xx-Rate" \
  --metric-name "HTTPCode_Target_5XX_Count" \
  --namespace "AWS/ApplicationELB" \
  --statistic Sum \
  --period 300 \
  --threshold 10 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 1 \
  --alarm-actions arn:aws:sns:us-east-1:ACCOUNT_ID:ayrnow-production-alerts
```

---

## Ongoing Weekly Checks (after Week 1)

After the first week, maintain a lighter weekly cadence:

- Review error rates and response time trends
- Check RDS storage and performance metrics
- Review SES sending stats and bounce rates
- Verify backups are completing
- Review audit logs for anomalies
- Check Stripe webhook delivery success rate
- Review and rotate secrets per rotation policy (see `docs/SECRETS_ROTATION_POLICY.md`)
