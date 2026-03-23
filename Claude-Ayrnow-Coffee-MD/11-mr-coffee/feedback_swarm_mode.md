---
name: Always use swarm/agent mode
description: User wants every task broken into parallel agent swarms automatically — no single-threaded execution
type: feedback
---

Always decompose tasks into multiple parallel agents (swarm mode) by default.

When the user pastes a prompt or gives a task:
1. Immediately break it into independent workstreams (research, planning, backend, frontend, testing, etc.)
2. Launch all independent agents in parallel in a single response
3. Use sequential agents only when there are true dependencies
4. Coordinate results from all agents and synthesize into a unified response/action

**Why:** User wants maximum parallelism and speed. They don't want serial, one-step-at-a-time execution. Every task should feel like a team working simultaneously.

**How to apply:** On every new task/prompt:

### Step 0 — Verify swarm infrastructure (ALWAYS, BEFORE anything else)
Check that these 4 files exist and are intact:
1. `~/.claude/settings.json` — Agent Teams + hooks config
2. `~/.claude/CLAUDE.md` — Swarm-first instructions
3. `~/.claude/save-context.sh` — Context-saving hook
4. `~/.claude/last-action-context.md` — Auto-updated session state

If ANY file is missing or corrupted, recreate it immediately before proceeding.

### Step 1 — Execute in swarm mode
Identify 2+ parallel workstreams and launch agents concurrently. Default to this behavior without being asked. This is a permanent preference.
