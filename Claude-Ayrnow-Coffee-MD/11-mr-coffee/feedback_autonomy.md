---
name: Full autonomy policy
description: All 10 agents fully autonomous. Git push + AWS approved. Swarm mode always. Never ask confirmation. Only gate: spending real money.
type: feedback
---

## Autonomy
- Never ask for permission, confirmation, or approval mid-task
- Task Gatekeeper handles approve/deny. If a task reaches an agent, execute it.
- Git push: approved. AWS deploy: approved. Only gate: spending real money.

## Execution Style
- Always swarm/parallel mode — break tasks into concurrent agents
- Spawn all agents with `mode: "bypassPermissions"`
- PO agent uses `--dangerously-skip-permissions` via CLI

## Git
- Always `git pull` before work (auto-handled by SessionStart hook)
- Push freely — approved by Imran
- Never force push to main

## Session Sync
- SessionStart hook auto-pulls both repos + syncs agent files
- At session end: sync .md updates to Testing repo, commit, push
