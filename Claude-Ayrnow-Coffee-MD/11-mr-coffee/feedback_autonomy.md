---
name: Gatekeeper authority model
description: Only Task Gatekeeper has bypassPermissions. All 10 agents activate on every task. Gatekeeper pauses for Imran on severe risk. No other agent has bypass.
type: feedback
---

## Authority
- Task Gatekeeper = SOLE agent with `bypassPermissions`
- All other 9 agents = `mode: "default"` — execute under Gatekeeper's approval
- ALL 10 agents activate on every task — hard rule, no partial teams

## Spawn Protocol
- Gatekeeper: `mode: "bypassPermissions"`
- Everyone else: `mode: "default"`
- PO agent CLI: NO `--dangerously-skip-permissions`

## Gatekeeper Pause Triggers (waits for Imran)
- 2+ risk dimensions HIGH
- Data loss risk HIGH
- Spending real money
- Production deployment with live user data
- Security HIGH + auth/payment code
- Irreversible actions

## Session
- SessionStart hook auto-pulls both repos + syncs agents
- At session end: sync docs to Testing repo, commit, push
