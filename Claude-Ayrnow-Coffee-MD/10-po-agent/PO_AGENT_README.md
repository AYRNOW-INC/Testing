# AYRNOW Product Owner Agent System

## What is this?

An autonomous, always-on Product Owner Agent that runs in your terminal via Claude Code CLI. It reads a master todo list of 34 tasks (180+ subtasks), breaks them down, dispatches developer sub-agents, verifies the work compiles and passes analysis, commits changes, and loops until every task is done.

## Architecture

```
┌─────────────────────────────────┐
│       PO Agent (po_agent.sh)    │  ← Orchestrator with max authority
│  Reads MASTER_TODO.md           │
│  Picks next task by priority    │
│  Spawns dev agents via Claude   │
│  Verifies compilation           │
│  Commits passing changes        │
│  Loops until all done           │
└──────────┬──────────────────────┘
           │ spawns
           ▼
┌─────────────────────────────────┐
│     Developer Agent (Claude)    │  ← Executes one task at a time
│  Reads existing source code     │
│  Implements subtasks            │
│  Verifies after each edit       │
│  Marks subtasks done            │
│  Reports back to PO             │
└─────────────────────────────────┘
```

## Quick Start

```bash
# 1. Navigate to project root
cd /Users/imranshishir/Documents/claude/AYRNOW/ayrnow-mvp

# 2. Start the PO Agent
./alwaysOnProductOwnerAgent/po_agent.sh

# That's it. The agent runs autonomously until all tasks are done.
```

## Commands

| Command | Description |
|---------|-------------|
| `./alwaysOnProductOwnerAgent/po_agent.sh` | Start fresh from the first incomplete task |
| `./alwaysOnProductOwnerAgent/po_agent.sh continue` | Resume from last checkpoint |
| `./alwaysOnProductOwnerAgent/po_agent.sh status` | Show progress dashboard |
| `./alwaysOnProductOwnerAgent/po_agent.sh task 07` | Run a specific task by number |
| `./alwaysOnProductOwnerAgent/po_agent.sh help` | Show help |

## Task Execution Order

### Wave 1 — Production Blockers (Tasks 01-10)
Must be done before any production claim.

### Wave 2 — Public Beta (Tasks 11-22)
Must be done before public beta launch.

### Wave 3 — Store Launch (Tasks 23-28)
Polish and release prep.

### Hidden Gaps (Tasks 29-34)
Cross-cutting concerns that extend earlier tasks.

## How It Works

1. **PO Agent reads MASTER_TODO.md** — finds the next incomplete task in priority order
2. **Builds a targeted prompt** — extracts the task block, adds project context and verification rules
3. **Spawns a developer agent** — pipes the prompt to `claude --print` with file editing permissions
4. **Developer agent works** — reads code, edits files, verifies compilation after each change
5. **PO Agent verifies** — runs `mvn compile` and `flutter analyze`, checks subtask completion
6. **Commits & moves on** — git commits the changes, picks the next task
7. **Loops until done** — or pauses after 3 consecutive failures

## Safety Features

- **Build verification after every task** — backend must compile, frontend must analyze clean
- **Max 3 retries per task** — gives up gracefully if stuck
- **Checkpoint system** — can resume from where it left off after interruption
- **Execution log** — every action is logged to `alwaysOnProductOwnerAgent/logs/`
- **Git discipline** — commits after each task with descriptive messages

## Files

```
alwaysOnProductOwnerAgent/
├── CLAUDE.md            # PO Agent system prompt (instructions for Claude)
├── MASTER_TODO.md       # The execution board — all 34 tasks, 180+ subtasks
├── po_agent.sh          # The launcher script
├── README.md            # This file
├── .checkpoint          # Auto-created: tracks last task for resume
└── logs/                # Auto-created: execution logs per day
```

## Monitoring

Watch progress in real-time:
```bash
# In another terminal
watch -n 5 './alwaysOnProductOwnerAgent/po_agent.sh status'

# Or tail the logs
tail -f alwaysOnProductOwnerAgent/logs/po_agent_$(date '+%Y%m%d').log
```
