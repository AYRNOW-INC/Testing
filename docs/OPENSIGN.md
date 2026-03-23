# AYRNOW — OpenSign Integration & S3 Migration Plan

## Table of Contents
1. Architecture Overview
2. Local Development Setup (OpenSign Self-Hosted)
3. AYRNOW Backend Integration
4. AYRNOW Frontend Integration
5. Webhook Flow
6. Production Migration: Local Storage → AWS S3
7. Environment Configuration Reference
8. Troubleshooting

---

## 1. Architecture Overview

```
LOCAL DEV:
┌──────────────┐     Parse REST API     ┌────────────────────┐
│ AYRNOW       │ ──────────────────────→ │ OpenSign Server    │
│ Spring Boot  │     port 1337           │ (self-hosted)      │
│ port 8080    │ ←────────────────────── │ MongoDB on 27017   │
│              │     webhook callback    │ Local file storage  │
└──────┬───────┘                         └────────────────────┘
       │
       ▼
┌──────────────┐
│ PostgreSQL   │
│ port 5432    │
│ DB: ayrnow   │
└──────────────┘

PRODUCTION (AWS):
┌──────────────┐     Parse REST API     ┌────────────────────┐
│ AYRNOW       │ ──────────────────────→ │ OpenSign Server    │
│ EC2 / EB     │     (same EC2 or       │ EC2 instance       │
│              │      separate)          │ MongoDB Atlas /    │
│              │ ←────────────────────── │ DocumentDB         │
│              │     webhook callback    └────────────────────┘
└──────┬───────┘
       │           ┌──────────────┐
       ├──────────→│ RDS Postgres │
       │           └──────────────┘
       │           ┌──────────────┐
       └──────────→│ AWS S3       │  ← lease PDFs, signed docs, uploads
                   └──────────────┘
```

### Role Boundaries
- **OpenSign owns**: signing workflow, signer link routing, signature capture, webhook notifications, signed PDF generation
- **AYRNOW owns**: lease drafting, lease settings, tenant assignment, lease lifecycle state, document references, file storage (local dev or S3 in prod)
- **Rule**: OpenSign is a signing engine — not AYRNOW's lease database

---

## 2. Local Development Setup (OpenSign Self-Hosted)

### Prerequisites
- Node.js 18+
- MongoDB running locally (`brew services start mongodb-community`)
- OpenSign repo cloned at `/Users/imranshishir/Documents/claude/AYRNOW/opensign/`

### Start OpenSign Server

```bash
cd /Users/imranshishir/Documents/claude/AYRNOW/opensign/apps/OpenSignServer

export PORT=1337
export APP_ID=opensign
export MASTER_KEY=AyrnowOpenSign2026
export MONGODB_URI=mongodb://localhost:27017/opensign
export SERVER_URL=http://localhost:1337/app
export PARSE_MOUNT=/app
export USE_LOCAL=true

npm install && node index.js
```

### Verify It's Running

```bash
# Health check
curl http://localhost:1337/app/health

# Test Parse API
curl -X POST http://localhost:1337/app/functions/getUser \
  -H "X-Parse-Application-Id: opensign" \
  -H "X-Parse-Master-Key: AyrnowOpenSign2026" \
  -H "Content-Type: application/json" \
  -d '{}'
```

### Connection Details (Dev)

| Setting | Value |
|---------|-------|
| OpenSign URL | `http://localhost:1337` |
| Parse mount | `/app` |
| App ID | `opensign` |
| Master Key | `AyrnowOpenSign2026` |
| MongoDB | `mongodb://localhost:27017/opensign` |
| File storage | Local filesystem (USE_LOCAL=true) |
| Webhook target | `http://localhost:8080/api/webhooks/opensign` |

---

## 3. AYRNOW Backend Integration

### 3.1 Spring Boot Configuration

Add to `application.properties`:
```properties
# OpenSign
opensign.base-url=${OPENSIGN_URL:http://localhost:1337}
opensign.parse-mount=${OPENSIGN_PARSE_MOUNT:/app}
opensign.app-id=${OPENSIGN_APP_ID:opensign}
opensign.master-key=${OPENSIGN_MASTER_KEY:AyrnowOpenSign2026}
opensign.webhook-secret=${OPENSIGN_WEBHOOK_SECRET:}
```

### 3.2 OpenSignService.java (Service Client)

```
Location: backend/src/main/java/com/ayrnow/service/OpenSignService.java
```

Responsibilities:
- Create document on OpenSign (upload lease PDF, define signers)
- Fetch document status from OpenSign
- Fetch signed PDF URL from OpenSign
- Verify webhook signatures

API calls use Parse REST API pattern:
```
POST http://localhost:1337/app/functions/createdocument
Headers:
  X-Parse-Application-Id: opensign
  X-Parse-Master-Key: AyrnowOpenSign2026
  Content-Type: application/json
```

### 3.3 Lease → OpenSign Flow

```
1. Landlord creates lease in AYRNOW (DRAFT status)
2. Landlord taps "Send for Signing"
3. AYRNOW backend:
   a. Generates lease PDF (openhtmltopdf — already in pom.xml)
   b. Calls OpenSign POST /functions/createdocument with:
      - PDF file
      - Signers: [landlord email, tenant email]
      - Callback URL: http://<ayrnow>/api/webhooks/opensign
   c. Stores OpenSign document ID in lease.opensignDocId
   d. Updates lease status → SENT_FOR_SIGNING
4. OpenSign sends signing links to signers via email
5. Each signer clicks link → signs in OpenSign UI
6. OpenSign calls AYRNOW webhook after each signature event
```

### 3.4 Webhook Endpoint

```
Location: backend/src/main/java/com/ayrnow/controller/WebhookController.java
Endpoint: POST /api/webhooks/opensign
```

Handles events:
- `signer_completed` → update LeaseSignature for that signer
- `document_completed` → all signers done → lease status → FULLY_EXECUTED
- `document_declined` → handle rejection

### 3.5 Database Fields (Already Exist)

```sql
-- V1__Initial_schema.sql already has:
leases.opensign_doc_id VARCHAR(255)

-- LeaseSignature entity tracks per-signer status
-- Lease entity has opensignDocId field
```

---

## 4. AYRNOW Frontend Integration

### 4.1 Signing Screen
- When lease is SENT_FOR_SIGNING, show "Sign Now" button
- Opens OpenSign signing URL in WebView or external browser
- User signs within OpenSign UI
- On return/webhook, AYRNOW refreshes lease status

### 4.2 PDF Preview / Download
- Lease Ready Screen: preview PDF from OpenSign via URL
- Lease Detail: download signed PDF
- Tenant Lease Screen: download signed PDF
- Uses `url_launcher` or in-app WebView to display PDFs

### 4.3 Status Tracking
- Signing Status Screen polls or reacts to webhook-triggered state
- Shows which signers have signed, who is pending
- Updates in real-time when webhook fires

---

## 5. Webhook Flow (Complete Lifecycle)

```
┌──────────┐  1. Send for signing  ┌──────────┐
│  AYRNOW  │ ───────────────────→  │ OpenSign │
│ Backend  │                       │ Server   │
│          │  6. Webhook events    │          │
│          │ ←──────────────────── │          │
└──────────┘                       └──────────┘
                                        │
                              2. Email signing links
                                        │
                                        ▼
                                   ┌──────────┐
                                   │ Signers  │
                                   │ (email)  │
                                   └──────────┘
                                        │
                              3-5. Open link → Sign
                                        │
                                        ▼
                                   Back to OpenSign
                                   which fires webhook
```

Webhook payload (expected format):
```json
{
  "event": "document_completed",
  "documentId": "abc123",
  "signers": [
    {"email": "landlord@example.com", "status": "signed", "signedAt": "..."},
    {"email": "tenant@example.com", "status": "signed", "signedAt": "..."}
  ],
  "signedDocumentUrl": "http://localhost:1337/files/signed_lease.pdf"
}
```

AYRNOW webhook handler actions:
1. Verify webhook signature (if configured)
2. Look up lease by `opensignDocId`
3. Update `LeaseSignature` records per signer
4. Update lease status: `LANDLORD_SIGNED` / `TENANT_SIGNED` / `FULLY_EXECUTED`
5. Store signed document reference (URL or download + store to S3 in prod)
6. Create notifications for relevant users

---

## 5.1 Source-of-Truth Boundaries (TASK-31)

### What AYRNOW Stores (PostgreSQL)

| Field | Column | Description |
|-------|--------|-------------|
| Lease metadata | `leases.*` | All lease terms, parties, dates, status |
| OpenSign doc ID | `leases.opensign_doc_id` | Reference to OpenSign document objectId |
| Unsigned PDF URL | `leases.document_url` | URL of the generated (draft) lease PDF in OpenSign |
| Signed PDF URL | `leases.signed_document_url` | URL of the fully-signed PDF from OpenSign |
| Signature records | `lease_signatures.*` | Per-signer signed/unsigned status, timestamps, IP |
| Audit trail | `audit_logs.*` | All signing events logged |

### What OpenSign Stores (MongoDB + File Storage)

- The actual PDF files (both unsigned and signed versions)
- Signer routing and email delivery state
- Signature capture data (drawn signatures, positions)
- Document completion state
- Webhook delivery logs

### Rule

> AYRNOW is the source of truth for lease lifecycle state. OpenSign is the source of truth for signing workflow execution and PDF file storage.
>
> AYRNOW never depends solely on OpenSign for lease status. The webhook handler
> updates AYRNOW's internal status, and the `signLease()` endpoint also updates
> status for in-app signing. Both paths converge on the same `LeaseStatus` enum.

### Status Sync: OpenSign Events to AYRNOW Lease Status

| OpenSign Event | Payload Key | AYRNOW Action |
|----------------|------------|---------------|
| `signer_completed` | `signerEmail`, `signerRole` | Mark matching `LeaseSignature.signed=true`. Update lease to `LANDLORD_SIGNED` or `TENANT_SIGNED` (or `FULLY_EXECUTED` if both done). |
| `document_completed` | `documentId`, `signedDocumentUrl` | Set lease to `FULLY_EXECUTED`. Store `signedDocumentUrl`. Mark all signatures as signed. Auto-create first rent payment. Notify both parties. |
| `document_declined` | `documentId` | Set lease to `TERMINATED`. Notify both parties. |

### Signed Artifact Retrieval

When `document_completed` fires:
1. The webhook handler calls `OpenSignService.getSignedDocumentUrl(documentId)` which queries the OpenSign Parse API for the document's `SignedUrl`, `file.url`, or `URL` field.
2. If the webhook payload contains a `signedDocumentUrl` field, that takes precedence.
3. The URL is stored in `leases.signed_document_url`.
4. Frontend uses this URL with `url_launcher` to open/download the signed PDF.

### Access Control

Document URLs are only exposed through authenticated AYRNOW API endpoints:
- `GET /api/leases/{id}` requires the requester to be either the lease's landlord or tenant (enforced in `LeaseService.getLease()`).
- `GET /api/leases/landlord` returns only leases where the authenticated user is the landlord.
- `GET /api/leases/tenant` returns only leases where the authenticated user is the tenant.
- The OpenSign webhook endpoint (`POST /api/webhooks/opensign`) is unauthenticated but only accepts documentId lookups — it cannot expose URLs to arbitrary callers.

---

## 6. Production Migration: Local Storage → AWS S3

### 6.1 Why S3

| Concern | Local Storage | AWS S3 |
|---------|--------------|--------|
| Scalability | Limited to EC2 disk | Unlimited |
| Durability | Single disk, no redundancy | 99.999999999% (11 nines) |
| Access control | File system permissions | IAM policies + pre-signed URLs |
| Cost | Included in EC2 | ~$0.023/GB/month |
| CDN | None | CloudFront integration |
| Backup | Manual | Versioning + lifecycle policies |

### 6.2 Migration Scope

Three categories of files move to S3:

1. **Tenant document uploads** (currently saved to `./uploads/` via `file.upload-dir`)
2. **Generated lease PDFs** (created by openhtmltopdf, sent to OpenSign)
3. **Signed lease PDFs** (returned from OpenSign after all parties sign)

### 6.3 Implementation Plan

#### Step 1: Add AWS S3 SDK dependency

```xml
<!-- pom.xml -->
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>s3</artifactId>
    <version>2.25.0</version>
</dependency>
```

#### Step 2: Create S3StorageService.java

```
Location: backend/src/main/java/com/ayrnow/service/S3StorageService.java
```

```java
// Interface: StorageService
// Two implementations:
//   - LocalStorageService (dev — writes to file.upload-dir)
//   - S3StorageService (prod — writes to S3 bucket)
//
// Methods:
//   String upload(String key, InputStream data, String contentType)
//   InputStream download(String key)
//   String getPresignedUrl(String key, Duration expiry)
//   void delete(String key)
```

Use Spring `@Profile` or `@ConditionalOnProperty` to switch:
```java
@Service
@ConditionalOnProperty(name = "storage.type", havingValue = "s3")
public class S3StorageService implements StorageService { ... }

@Service
@ConditionalOnProperty(name = "storage.type", havingValue = "local", matchIfMissing = true)
public class LocalStorageService implements StorageService { ... }
```

#### Step 3: Configuration

```properties
# application.properties (dev default)
storage.type=${STORAGE_TYPE:local}
file.upload-dir=${FILE_UPLOAD_DIR:./uploads}

# application-aws.properties (production)
storage.type=s3
aws.s3.bucket=${AWS_S3_BUCKET:ayrnow-documents}
aws.s3.region=${AWS_REGION:us-east-1}
aws.s3.prefix=${AWS_S3_PREFIX:uploads/}
```

#### Step 4: S3 Bucket Setup

```bash
# Create bucket
aws s3 mb s3://ayrnow-documents --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket ayrnow-documents \
  --versioning-configuration Status=Enabled

# Block public access (all files served via pre-signed URLs)
aws s3api put-public-access-block \
  --bucket ayrnow-documents \
  --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# Lifecycle policy: move old versions to Glacier after 90 days
aws s3api put-bucket-lifecycle-configuration \
  --bucket ayrnow-documents \
  --lifecycle-configuration '{
    "Rules": [{
      "ID": "archive-old-versions",
      "Status": "Enabled",
      "NoncurrentVersionTransitions": [{
        "NoncurrentDays": 90,
        "StorageClass": "GLACIER"
      }],
      "NoncurrentVersionExpiration": {
        "NoncurrentDays": 365
      }
    }]
  }'
```

#### Step 5: IAM Policy for EC2/EB

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::ayrnow-documents",
        "arn:aws:s3:::ayrnow-documents/*"
      ]
    }
  ]
}
```

Attach this policy to the EC2 instance role — no access keys needed.

#### Step 6: S3 Key Structure

```
ayrnow-documents/
├── uploads/
│   └── {tenantId}/
│       └── {documentId}_{filename}      ← tenant document uploads
├── leases/
│   └── {leaseId}/
│       ├── draft_{leaseId}.pdf          ← generated lease PDF
│       └── signed_{leaseId}.pdf         ← signed PDF from OpenSign
└── temp/
    └── {uuid}                           ← temporary files (auto-expire 24h)
```

#### Step 7: Pre-signed URLs for Frontend

Instead of serving files directly, generate time-limited pre-signed URLs:

```java
// In S3StorageService:
public String getPresignedUrl(String key, Duration expiry) {
    GetObjectPresignRequest presignRequest = GetObjectPresignRequest.builder()
        .signatureDuration(expiry)  // e.g., Duration.ofMinutes(15)
        .getObjectRequest(b -> b.bucket(bucketName).key(key))
        .build();
    return s3Presigner.presignGetObject(presignRequest).url().toString();
}
```

Frontend receives a temporary URL (valid 15 min) to download/preview documents. No direct S3 access from the app.

#### Step 8: Migrate Existing Files (One-Time)

```bash
# Sync local uploads to S3 (run once during migration)
aws s3 sync ./uploads/ s3://ayrnow-documents/uploads/ --region us-east-1
```

#### Step 9: Update DocumentService.java

Replace direct file I/O with `StorageService` calls:

```java
// Before (local):
Path filePath = Paths.get(uploadDir).resolve(filename);
Files.copy(inputStream, filePath);

// After (abstracted):
String key = "uploads/" + tenantId + "/" + documentId + "_" + filename;
storageService.upload(key, inputStream, contentType);
```

### 6.4 OpenSign + S3 in Production

In production, OpenSign also needs document storage. Two options:

**Option A: OpenSign uses its own S3 bucket** (recommended for separation)
```bash
# OpenSign env vars for S3 storage
export USE_LOCAL=false
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_REGION=us-east-1
export S3_BUCKET=opensign-documents
```

**Option B: OpenSign uses same S3 bucket with a prefix**
```bash
export USE_LOCAL=false
export S3_BUCKET=ayrnow-documents
export S3_PREFIX=opensign/
```

Recommendation: **Option A** — separate buckets for clean IAM boundaries and independent lifecycle policies.

### 6.5 Migration Checklist

```
PRE-MIGRATION:
□ S3 bucket created with versioning enabled
□ Public access blocked
□ IAM policy attached to EC2 role
□ S3StorageService.java implemented and tested locally with LocalStack or MinIO
□ StorageService interface used everywhere (no direct file I/O)
□ Pre-signed URL generation working
□ Lifecycle policies configured

MIGRATION DAY:
□ Deploy new backend with storage.type=s3
□ Sync existing uploads: aws s3 sync ./uploads/ s3://ayrnow-documents/uploads/
□ Verify document download works via pre-signed URLs
□ Verify new uploads go to S3
□ Verify OpenSign signed PDFs are stored to S3
□ Monitor CloudWatch for S3 errors
□ Remove local uploads directory from EC2 after 1 week verification

POST-MIGRATION:
□ Remove LocalStorageService code (optional — keep for dev)
□ Set up CloudFront CDN if needed for performance
□ Enable S3 access logging for audit
□ Test disaster recovery: restore from S3 versioning
```

---

## 7. Environment Configuration Reference

### Development (Local)

```properties
# application.properties
opensign.base-url=http://localhost:1337
opensign.parse-mount=/app
opensign.app-id=opensign
opensign.master-key=AyrnowOpenSign2026
storage.type=local
file.upload-dir=./uploads
```

### Staging

```properties
# application-staging.properties
opensign.base-url=${OPENSIGN_URL:http://opensign-staging:1337}
opensign.app-id=${OPENSIGN_APP_ID:opensign}
opensign.master-key=${OPENSIGN_MASTER_KEY}
storage.type=s3
aws.s3.bucket=ayrnow-documents-staging
aws.s3.region=us-east-1
```

### Production (AWS)

```properties
# application-aws.properties
opensign.base-url=${OPENSIGN_URL}
opensign.app-id=${OPENSIGN_APP_ID}
opensign.master-key=${OPENSIGN_MASTER_KEY}
opensign.webhook-secret=${OPENSIGN_WEBHOOK_SECRET}
storage.type=s3
aws.s3.bucket=ayrnow-documents
aws.s3.region=us-east-1
```

All secrets managed via AWS Secrets Manager / Parameter Store.

---

## 8. Troubleshooting

**OpenSign won't start:**
- Check MongoDB is running: `brew services list | grep mongo`
- Check port 1337 isn't taken: `lsof -i :1337`
- Check env vars are set (especially MONGODB_URI)

**Webhook not firing:**
- Verify OpenSign callback URL points to `http://localhost:8080/api/webhooks/opensign`
- Check AYRNOW backend is running on port 8080
- Check OpenSign logs for webhook delivery errors

**PDF generation fails:**
- `openhtmltopdf` is already in pom.xml — verify dependency resolves
- Check lease template HTML is valid

**S3 upload fails in production:**
- Verify EC2 instance role has the S3 policy attached
- Verify bucket name matches config
- Check CloudWatch logs for access denied errors
- Verify region matches between bucket and SDK config

**Pre-signed URL expired:**
- Default expiry is 15 minutes — adjust if users need longer
- Frontend should request fresh URL on each download/preview action
