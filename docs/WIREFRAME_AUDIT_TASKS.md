# AYRNOW Wireframe Audit — Task Breakdown

_Created: 2026-03-22 | Source: WIREFRAME_AUDIT_REPORT.md_

## Overview

23 new tasks (TASK-58 to TASK-80) created from a comprehensive 8-agent wireframe audit.
- **54 wireframe screens** compared against **35 built Flutter screens**
- **25 fully built** | **26 partially built** | **3 missing**
- Total new subtasks: ~130

## Task Summary

### P0 — Must Fix for MVP (5 tasks)

| Task | Screen | Type | Subtasks |
|------|--------|------|:---:|
| TASK-58 | Lease Settings Overview | NEW SCREEN | 9 |
| TASK-59 | Lease Settings Edit | NEW SCREEN | 9 |
| TASK-60 | Lease Creation Date Pickers | ENHANCE | 8 |
| TASK-61 | Invite Date Picker Bug | BUG FIX | 5 |
| TASK-62 | Dashboard Activity Data-Driven | ENHANCE | 6 |

### P1 — UX Parity (10 tasks)

| Task | Screen | Type | Subtasks |
|------|--------|------|:---:|
| TASK-63 | Search Bars (4 screens) | ENHANCE | 6 |
| TASK-64 | Notifications Date Groups | ENHANCE | 6 |
| TASK-65 | Lease Wizard UX | ENHANCE | 10 |
| TASK-66 | Landlord Dashboard Populated | ENHANCE | 5 |
| TASK-67 | Payment Method Selection | ENHANCE | 8 |
| TASK-68 | Pending Invites | ENHANCE | 6 |
| TASK-69 | Landlord Info on Invite Screens | ENHANCE | 7 |
| TASK-70 | Tenant Dashboard States | ENHANCE | 7 |
| TASK-71 | Account Settings Both Roles | ENHANCE | 9 |
| TASK-72 | Unit Filter Chips | BUG FIX | 5 |

### P2 — Polish (8 tasks)

| Task | Screen | Type | Subtasks |
|------|--------|------|:---:|
| TASK-73 | Landlord Onboarding | ENHANCE | 4 |
| TASK-74 | Lease Detail Draft | ENHANCE | 5 |
| TASK-75 | Payment Ledger | ENHANCE | 6 |
| TASK-76 | Signing Status Timeline | ENHANCE | 5 |
| TASK-77 | Move-Out Screens | ENHANCE | 5 |
| TASK-78 | Text Copy Mismatches | FIX | 7 |
| TASK-79 | Landlord Payments | ENHANCE | 6 |
| TASK-80 | Document Screens | ENHANCE | 6 |

## Execution Strategy

1. PO Agent starts with P0 tasks (TASK-58-62) — these are MVP blockers
2. Then P1 tasks (TASK-63-72) — UX parity with wireframes
3. Finally P2 tasks (TASK-73-80) — polish and text fidelity
4. Each task spawns a dev sub-agent with the wireframe PNG path so agents can visually verify
5. Every dev agent runs `flutter analyze` and/or `mvn compile -q` before marking done
