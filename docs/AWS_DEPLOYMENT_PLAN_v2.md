# AYRNOW AWS Environment Setup — Complete Steps (Corrected)

**Last updated:** 2026-03-22
**Architecture:** No Docker. Spring Boot JAR on Elastic Beanstalk. PostgreSQL on RDS.
**Region:** us-east-1
**Budget target:** Minimal cost / free tier where possible

```
[Flutter App] --> [ALB (HTTPS/ACM)] --> [EB EC2: Spring Boot JAR] --> [RDS: PostgreSQL 16]
                                                                   --> [S3: Document Storage]
                                                                   --> [OpenSign Cloud]
                                                                   --> [Stripe API]
```

---

## Phase 1: Secure the Root Account (Do First)

### 1. Enable MFA on root
- AWS Console > IAM > Security credentials > Assign MFA
- Use authenticator app (Google Authenticator / Authy)

### 2. Create an IAM admin user (stop using root)
- IAM > Users > Create user > `ayrnow-admin`
- Attach policy: `AdministratorAccess`
- Enable console access + MFA
- Use this account for everything below

### 3. Create a budget alarm
- AWS Budgets > Create budget > Use template: "Monthly cost budget"
- Set threshold: $50
- Email notification to your inbox

> **Note:** CloudWatch billing alarms are legacy. AWS Budgets is the current
> recommended approach for cost monitoring.

---

## Phase 2: Networking (VPC & Security Groups)

### 4. Use default VPC (simplest for MVP)
- It already has public subnets in each AZ
- If you want isolation later, create a custom VPC

### 5. Create Security Groups

**SG: `ayrnow-alb-sg`** (for the Application Load Balancer)

| Direction | Protocol | Port | Source | Purpose |
|-----------|----------|------|--------|---------|
| Inbound | TCP | 443 | 0.0.0.0/0 | HTTPS from internet |
| Inbound | TCP | 80 | 0.0.0.0/0 | HTTP (redirects to HTTPS) |
| Outbound | All | All | 0.0.0.0/0 | Default |

**SG: `ayrnow-backend-sg`** (for the EB EC2 instances)

| Direction | Protocol | Port | Source | Purpose |
|-----------|----------|------|--------|---------|
| Inbound | TCP | 5000 | `ayrnow-alb-sg` | App port, only from ALB |
| Outbound | All | All | 0.0.0.0/0 | Default |

> **Note:** Do NOT open 5000 to 0.0.0.0/0. Only the ALB should reach
> the backend instances. The ALB handles all public-facing traffic.

**SG: `ayrnow-rds-sg`** (for the database)

| Direction | Protocol | Port | Source | Purpose |
|-----------|----------|------|--------|---------|
| Inbound | TCP | 5432 | `ayrnow-backend-sg` | PostgreSQL, only from backend |
| Outbound | All | All | 0.0.0.0/0 | Default |

---

## Phase 3: Database (RDS)

### 6. Create RDS PostgreSQL instance
- RDS > Create database > Standard create
- Engine: **PostgreSQL 16**
- Template: **Free tier** (selects `db.t3.micro`)
- DB instance identifier: `ayrnow-db`
- Master username: `ayrnow_admin`
- Master password: generate and save in password manager
- Storage: **20 GB gp3**, enable auto-scaling up to 50 GB
- Connectivity: Default VPC, `ayrnow-rds-sg` security group
- Public access: **No**
- Initial database name: `ayrnow`
- Backup retention: 7 days
- Encryption: Enabled (default key)
- Click Create database

> **Note:** The console may default to `gp2` storage. Explicitly select **gp3** —
> it is cheaper and faster than gp2 with no reason to use gp2 for new instances.

### 7. Note the RDS endpoint (available after ~5 min)
```
ayrnow-db.xxxxxxxxxxxx.us-east-1.rds.amazonaws.com
```

---

## Phase 4: File Storage (S3)

### 8. Create S3 bucket
- S3 > Create bucket
- Name: `ayrnow-documents-prod`
- Region: us-east-1
- Block all public access: **Yes** (files served via pre-signed URLs)
- Bucket versioning: Enable
- Server-side encryption: SSE-S3 (AES-256) — this is now the default for all new buckets
- Click Create bucket

### 9. Bucket policy
- No public bucket policy needed — access via IAM role only

---

## Phase 5: IAM Roles & Policies

### 10. Create IAM role for Elastic Beanstalk EC2 instances
- IAM > Roles > Create role
- Trusted entity: AWS service > EC2
- Name: `ayrnow-eb-ec2-role`
- Attach these managed policies:
  - `AWSElasticBeanstalkWebTier`
  - `AWSElasticBeanstalkWorkerTier`
  - `AWSElasticBeanstalkMulticontainerDocker`
  - `CloudWatchLogsFullAccess`

> **Note:** Include all three EB policies even though you're not using Docker.
> The EB console attaches all three by default and some EB internals may expect them.

- Create an inline policy named `AyrnowS3Access` for S3 access:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::ayrnow-documents-prod",
        "arn:aws:s3:::ayrnow-documents-prod/*"
      ]
    }
  ]
}
```

- After creating the role, create an instance profile and attach it:
  - IAM > Roles > `ayrnow-eb-ec2-role` — the console does this automatically
    when you create a role for EC2. Verify the instance profile exists.

### 11. Create IAM role for Elastic Beanstalk service
- IAM > Roles > Create role
- Trusted entity: AWS service > Elastic Beanstalk > Elastic Beanstalk – Environment
- Name: `ayrnow-eb-service-role`
- Attach:
  - `AWSElasticBeanstalkEnhancedHealth`
  - `AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy`

> **Alternatively:** You can skip Steps 10-11 and create these roles inline during
> the EB environment creation wizard (Phase 8). The wizard links directly to IAM
> to create them if they don't exist.

### 12. Set up OIDC federation for GitHub Actions (replaces IAM user with access keys)

AWS strongly discourages creating IAM users with long-term access keys for CI/CD.
Use OIDC federation instead — GitHub Actions gets temporary credentials automatically
with no secrets to store or rotate.

**12a. Create OIDC identity provider**
- IAM > Identity providers > Add provider
- Provider type: **OpenID Connect**
- Provider URL: `https://token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`
- Click Add provider

**12b. Create IAM role for GitHub Actions**
- IAM > Roles > Create role
- Trusted entity: **Web identity**
- Identity provider: `token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`
- Name: `ayrnow-github-actions-role`
- Set the trust policy to restrict to your repo and branch:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:AYRNOW-INC/AYRNOW-MVP:ref:refs/heads/main"
        }
      }
    }
  ]
}
```

- Attach policies:
  - `AWSElasticBeanstalkFullAccess`
  - `AmazonS3FullAccess` (for uploading deploy artifacts)

> **No access keys to create, no secrets to rotate, no credentials stored in GitHub.**
> Replace `<ACCOUNT_ID>` with your 12-digit AWS account ID.

---

## Phase 6: SSL Certificate (ACM)

### 13. Request SSL certificate
- ACM (Certificate Manager) > Request certificate
- Certificate type: Public
- Domain names:
  - `api.ayrnow.com`
  - `*.ayrnow.com`
- Validation: DNS validation
- Click Request

> **Important:** ACM certificates can only be attached to AWS load balancers
> (ALB/NLB) or CloudFront — they cannot be installed directly on EC2 instances.
> This is why Phase 8 uses a load-balanced EB environment with an ALB.

### 14. Add DNS validation records
- ACM shows CNAME records to add
- If domain is in Route 53: click "Create records in Route 53" (auto)
- If domain is elsewhere: add the CNAME records at your DNS provider
- Wait for status to change to **Issued** (~5-30 min)

---

## Phase 7: DNS (Route 53)

### 15. Create hosted zone (if not already done)
- Route 53 > Hosted zones > Create > `ayrnow.com`
- Note the 4 NS records — update these at your domain registrar

### 16. DNS records (add after EB environment is created)
- `api.ayrnow.com` > A record > Alias > target: EB environment URL

---

## Phase 8: Elastic Beanstalk (App Hosting)

### 17. Create Elastic Beanstalk application
- EB > Create application
- Name: `ayrnow-backend`

### 18. Create environment (multi-step wizard)

The EB console uses a multi-step wizard:

**Step 1 — Configure environment**
- Environment tier: **Web server environment**
- Environment name: `ayrnow-backend-prod`
- Platform: **Java** > Branch: **Corretto 21 running on 64bit Amazon Linux 2023**
- Platform version: **4.10.0** (or latest)
- Application code: **Sample application** (deploy your code later)
- Preset: **High availability** (required for ALB + ACM)
- Click Next

> **Solution stack name:** `64bit Amazon Linux 2023 v4.10.0 running Corretto 21`
> This runs on AL2023 (not AL2). Always use the AL2023 branch.

**Step 2 — Configure service access**
- Service role: select `ayrnow-eb-service-role` (or create inline)
- EC2 instance profile: select `ayrnow-eb-ec2-role` (or create inline)
- EC2 key pair: select one for SSH access (optional but recommended)
- Click Next

**Step 3 — Set up networking, database, and tags (optional)**
- VPC: Default VPC
- Instance subnets: select at least 2 AZs
- Do NOT add an RDS database here (we created it separately in Phase 3)
- Click Next

**Step 4 — Configure instance traffic and scaling**
- Load balancer type: **Application Load Balancer**
- Listener: add HTTPS (443), select your ACM certificate
- Instance type: `t3.micro`
- Min instances: 1, Max instances: 1 (scale later)
- Load balancer security group: `ayrnow-alb-sg`
- Click Next

**Step 5 — Configure updates, monitoring, and logging**
- Health reporting: Enhanced
- CloudWatch logs: Stream logs, retention 7 days
- Click Next

**Step 6 — Review and submit**
- Review all settings
- Click Submit

### 19. Wait for environment to launch (~5-10 min)
- Status will show "Launching" then turn green when ready
- Note the environment URL: `ayrnow-backend-prod.us-east-1.elasticbeanstalk.com`

### 20. Configure environment variables
After the environment is created, set environment properties:

EB > Environments > `ayrnow-backend-prod` > Configuration > Updates, monitoring,
and logging > Environment properties:

| Property | Value |
|----------|-------|
| `SERVER_PORT` | `5000` |
| `SPRING_PROFILES_ACTIVE` | `aws` |
| `SPRING_DATASOURCE_URL` | `placeholder` |
| `SPRING_DATASOURCE_USERNAME` | `placeholder` |
| `SPRING_DATASOURCE_PASSWORD` | placeholder |
| `JWT_SECRET` | placeholder |
| `STRIPE_SECRET_KEY` | `sk_test_placeholder` |
| `STRIPE_WEBHOOK_SECRET` | `whsec_placeholder` |
| `AWS_S3_BUCKET` | `ayrnow-documents-prod` |
| `AWS_S3_REGION` | `us-east-1` |
| `JAVA_TOOL_OPTIONS` | `-Xmx512m -Xms256m -XX:+UseG1GC -XX:MaxMetaspaceSize=128m` |

### 21. Update RDS security group
Allow the EB instances to reach RDS:

- EC2 > Security Groups > `ayrnow-rds-sg` > Edit inbound rules
- Add rule: TCP 5432, Source: `ayrnow-backend-sg` (the SG assigned to EB instances)

> **Note:** EB may create its own security group for instances. Check what SG is
> assigned to the EB EC2 instances and use that as the source in the RDS SG rule.

---

## Phase 9: CI/CD (GitHub Actions)

### 22. Set GitHub secrets
Only the role ARN and region are needed (no access keys):

```bash
gh secret set AWS_ROLE_ARN --repo AYRNOW-INC/AYRNOW-MVP \
  --body "arn:aws:iam::<ACCOUNT_ID>:role/ayrnow-github-actions-role"

gh secret set AWS_REGION --repo AYRNOW-INC/AYRNOW-MVP --body "us-east-1"

gh secret set EB_APPLICATION_NAME --repo AYRNOW-INC/AYRNOW-MVP --body "ayrnow-backend"

gh secret set EB_ENVIRONMENT_NAME --repo AYRNOW-INC/AYRNOW-MVP --body "ayrnow-backend-prod"
```

### 23. Update GitHub Actions workflow

The workflow at `.github/workflows/deploy-to-eb.yml` needs to be updated
to use OIDC instead of access keys:

```yaml
name: Deploy AYRNOW Backend to Elastic Beanstalk

on:
  push:
    branches: [main]
    paths:
      - 'backend/**'
      - '.ebextensions/**'
      - '.github/workflows/deploy-to-eb.yml'
  workflow_dispatch:

permissions:
  id-token: write   # Required for OIDC token
  contents: read     # Required for actions/checkout

jobs:
  build-and-deploy:
    name: Build & Deploy
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up JDK 21
        uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'corretto'
          cache: 'maven'

      - name: Build with Maven
        working-directory: backend
        run: mvn clean package -DskipTests -B

      - name: Create deployment package
        run: |
          mkdir -p deploy-package/.ebextensions
          cp backend/target/ayrnow-backend-*-SNAPSHOT.jar deploy-package/application.jar
          echo "web: java -jar application.jar --server.port=5000" > deploy-package/Procfile
          cp -r .ebextensions/* deploy-package/.ebextensions/ 2>/dev/null || true
          cd deploy-package
          zip -r ../ayrnow-deploy-${{ github.sha }}.zip .

      - name: Configure AWS credentials (OIDC)
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Deploy to Elastic Beanstalk
        uses: einaregilsson/beanstalk-deploy@v22
        with:
          aws_access_key: ${{ env.AWS_ACCESS_KEY_ID }}
          aws_secret_key: ${{ env.AWS_SECRET_ACCESS_KEY }}
          aws_session_token: ${{ env.AWS_SESSION_TOKEN }}
          application_name: ${{ secrets.EB_APPLICATION_NAME }}
          environment_name: ${{ secrets.EB_ENVIRONMENT_NAME }}
          version_label: "ayrnow-${{ github.sha }}"
          region: ${{ secrets.AWS_REGION }}
          deployment_package: ayrnow-deploy-${{ github.sha }}.zip
          use_existing_version_if_available: true

      - name: Verify deployment
        run: |
          echo "Waiting 30s for deployment to stabilize..."
          sleep 30
          aws elasticbeanstalk describe-environment-health \
            --environment-name ${{ secrets.EB_ENVIRONMENT_NAME }} \
            --attribute-names All \
            --region ${{ secrets.AWS_REGION }} || echo "Health check pending..."
```

> **Key difference:** The `configure-aws-credentials` action uses `role-to-assume`
> instead of static access keys. It gets a temporary token via OIDC. The
> `beanstalk-deploy` action reads the temporary credentials from environment
> variables set by the configure step (including `AWS_SESSION_TOKEN`).

### 24. Trigger first deployment
```bash
gh workflow run deploy-to-eb.yml --repo AYRNOW-INC/AYRNOW-MVP --ref main
gh run watch --repo AYRNOW-INC/AYRNOW-MVP
```

---

## Phase 10: Verify & Go Live

### 25. Verify backend health
```bash
# Get EB URL
aws elasticbeanstalk describe-environments \
  --environment-names ayrnow-backend-prod \
  --query "Environments[0].CNAME" --output text

# Test health endpoint
curl https://api.ayrnow.com/api/health
```

### 26. Point DNS to ALB
- Route 53 > Hosted zones > `ayrnow.com`
- Create record: `api.ayrnow.com` > A > Alias > Elastic Beanstalk environment
- Select region us-east-1 and the `ayrnow-backend-prod` environment

### 27. Update application config
- Update CORS allowed origins to `https://app.ayrnow.com`
- Update Stripe webhook endpoint to `https://api.ayrnow.com/api/stripe/webhook`
- Update any callback URLs for production domain

---

## EB Extensions File

Place at `.ebextensions/01-environment.config`:

```yaml
option_settings:
  aws:elasticbeanstalk:application:environment:
    SERVER_PORT: "5000"
    SPRING_PROFILES_ACTIVE: "aws"
    JAVA_TOOL_OPTIONS: "-Xmx512m -Xms256m -XX:+UseG1GC -XX:MaxMetaspaceSize=128m"

  aws:elasticbeanstalk:environment:process:default:
    HealthCheckPath: /api/health
    MatcherHTTPCode: "200"

  aws:autoscaling:launchconfiguration:
    InstanceType: t3.micro

  aws:elasticbeanstalk:healthreporting:system:
    SystemType: enhanced

  aws:elasticbeanstalk:cloudwatch:logs:
    StreamLogs: true
    RetentionInDays: 7
    DeleteOnTerminate: true
```

---

## Cost Estimate (MVP with ALB)

| Service | Monthly Cost |
|---------|-------------|
| EC2 t3.micro (EB) | ~$8 |
| RDS db.t3.micro (free tier year 1) | $0 |
| RDS db.t3.micro (after free tier) | ~$15 |
| ALB | ~$16 |
| S3 (minimal storage) | ~$1 |
| Route 53 | ~$1 |
| ACM | Free |
| **Total (year 1)** | **~$26/mo** |
| **Total (after free tier)** | **~$41/mo** |

---

## Cost-Saving Alternative: SingleInstance (No ALB)

If you want to save ~$16/mo by skipping the ALB:
- Use EB preset: **Single instance** instead of High availability
- You lose ACM SSL support (ACM requires a load balancer)
- Use **Let's Encrypt** (Certbot) for SSL instead, configured via `.ebextensions`
- Backend SG allows port 5000 from `0.0.0.0/0` directly
- Total drops to ~$10/mo (year 1) or ~$25/mo (after free tier)
- Trade-off: manual cert renewal config, no ALB health checks, harder to scale later

---

## Mobile App Deployment

- iOS: Build IPA, submit to App Store via App Store Connect
- Android: Build APK/AAB, submit to Google Play Console
- Both require: signing certificates, store listings, screenshots
- Update API base URL in Flutter app to `https://api.ayrnow.com`

---

## Changes from Previous Plan

| Area | Previous | Corrected |
|------|----------|-----------|
| Cost alerts | CloudWatch billing alarm | **AWS Budgets** (CloudWatch billing alarms are legacy) |
| Backend SG | Port 5000 open to 0.0.0.0/0 | Port 5000 open **only from ALB SG** |
| RDS storage | gp3 (correct but console may default gp2) | Explicitly select **gp3** |
| EC2 instance profile | Skip MulticontainerDocker | **Keep all three** EB managed policies |
| CI/CD auth | IAM user with access keys | **OIDC federation** (no long-term credentials) |
| SSL | ACM on SingleInstance | ACM requires ALB — **switched to load-balanced environment** |
| EB platform | "Java > Corretto 21" | `64bit Amazon Linux 2023 v4.10.0 running Corretto 21` |
| EB wizard | Single-step creation | **Multi-step wizard** with service access configuration |
| GitHub secrets | AWS_ACCESS_KEY_ID + SECRET | **AWS_ROLE_ARN** only (OIDC handles credentials) |
