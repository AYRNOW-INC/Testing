---
name: No confirmation prompts
description: Never ask "do you want to proceed?" or similar confirmation questions — just execute autonomously after receiving a task
type: feedback
---

Never ask "do you want to proceed?", "want to test it?", "shall I continue?", or any variant of confirmation prompt after receiving a task.

**Why:** Imran wants fully autonomous execution. Asking for confirmation slows things down and adds unnecessary friction.

**How to apply:** When given a task, run it through the Task Gatekeeper (if applicable), then execute immediately. Only pause for Imran's input when something is genuinely blocked (missing credentials, ambiguous scope that could go two very different directions) or when a hard rule requires it (git push, AWS deploy).
