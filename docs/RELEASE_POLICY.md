# AYRNOW — Release Policy

## Versioning
Semantic Versioning: `vMAJOR.MINOR.PATCH`

| Component | When to bump |
|-----------|-------------|
| MAJOR | Breaking API changes, major architecture change, or production milestone |
| MINOR | New features, new screens, new endpoints |
| PATCH | Bug fixes, dependency updates, documentation, minor improvements |

## Current Releases
| Tag | Commit | Description |
|-----|--------|-------------|
| v1.0.0 | f44f577 | MVP with all screens, docs, scripts |
| v1.0.1 | f091f5e | Stripe integration with idempotent webhooks |

## Release Checklist

Before creating a release tag:

### 1. Code Quality
- [ ] `cd frontend && flutter analyze` — 0 errors
- [ ] `cd backend && mvn package -DskipTests` — builds successfully
- [ ] Backend starts: `java -jar target/ayrnow-backend-1.0.0-SNAPSHOT.jar`
- [ ] Health check passes: `curl http://localhost:8080/api/health`
- [ ] App runs on iOS simulator: `cd frontend && flutter run`
- [ ] Flyway migrations apply cleanly on fresh database

### 2. Smoke Tests
- [ ] Register landlord, login, create property — works
- [ ] Register tenant, login — works
- [ ] API auth (register/login/refresh/me) — returns correct data
- [ ] Dashboard loads for both roles
- [ ] No console errors or stack traces during basic flows

### 3. Security
- [ ] `git diff --staged` reviewed for secrets
- [ ] No `.env` files tracked
- [ ] No hardcoded API keys or passwords in source
- [ ] `.gitignore` is up to date
- [ ] Stripe keys are test keys (not live) in committed config

### 4. Environment
- [ ] `backend/.env.example` matches all vars in `application.properties`
- [ ] `frontend/.env.example` is current
- [ ] Production env vars documented in `docs/ENVIRONMENT_VARIABLES.md`

### 5. Documentation
- [ ] API_OVERVIEW.md updated if endpoints changed
- [ ] SCHEMA_OVERVIEW.md updated if migrations added
- [ ] README.md reflects current state

### 6. Tag and Push
```bash
git tag -a v1.x.x -m "AYRNOW v1.x.x — description"
git push origin v1.x.x
```

### 7. GitHub Release (recommended)
- Create release from tag in GitHub UI
- Include summary of changes since last release

### 8. Deploy (when AWS is ready)
- [ ] Build JAR with production profile: `mvn package -Pprod -DskipTests`
- [ ] Upload JAR to deployment target (EC2/Elastic Beanstalk)
- [ ] Verify Flyway migrations ran on production DB
- [ ] Verify `/api/health` returns UP on production
- [ ] Verify CORS allows production frontend domain
- [ ] Verify Stripe webhook endpoint is reachable
- [ ] Build Flutter app with production API URL
- [ ] Submit to App Store / Play Store if applicable

## Hotfix Process
1. Create branch: `hotfix/description`
2. Fix the issue
3. Test locally
4. Merge to main (PR if team)
5. Tag as patch release (v1.x.PATCH+1)
6. Push

## Pre-Release Tags
For testing before official release:
- `v1.2.0-rc.1` — Release candidate
- `v1.2.0-beta.1` — Beta
- Do not use pre-release tags for production deployment
