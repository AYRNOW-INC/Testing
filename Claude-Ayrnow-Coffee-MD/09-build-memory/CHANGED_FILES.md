# AYRNOW Changed Files Log — Complete

## Commit 1: 4305ceb — MVP build
- 131 files, 11,423 lines
- All backend source (entities, repos, services, controllers, DTOs, security, config)
- All frontend screens (20 Dart files + theme + services + providers + main)
- Flyway V1 migration, application.properties, pom.xml, pubspec.yaml
- .gitignore, WIREFRAME_MAPPING.md

## Commit 2: f44f577 — Docs, scripts, wireframe gaps
- 27 files, 2,509 lines
- README.md, 12 docs files, 5 scripts, 2 env examples
- 5 new Flutter screens (lease signing, signing status, lease ready, invite accept, tenant onboarding)
- signature package added to pubspec.yaml

## Commit 3: f091f5e — Stripe integration (tagged v1.0.1)
- 8 files, 317 insertions
- V2 Flyway migration (payment stripe fields)
- PaymentService, LeaseService, WebhookController, PaymentController, Payment entity, PaymentRepository enhanced
- docs/STRIPE_INTEGRATION.md

## Commit 4: 1c90517 — GitHub security governance
- 7 files, 489 lines
- .gitignore hardened
- 6 docs (GITHUB_SECURITY, GIT_WORKFLOW, RELEASE_POLICY, GITHUB_SETTINGS_CHECKLIST, GITHUB_ACCOUNT_CHECKLIST, OFFICIAL_GITHUB_BASELINE)

## Commit 5: 94b0347 — Frontend config (latest on main)
- 3 files, 29 insertions
- frontend/lib/config/app_config.dart (new)
- frontend/lib/services/api_service.dart (updated baseUrl)
- frontend/.env.example (updated)

## Total: 5 commits, 176 files, ~14,700 lines
