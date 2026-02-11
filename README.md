# parallel-ralph

## Overview
`parallel-ralph` is a multi-agent engineering sandbox that tracks two independent subprojects: a Rust regex engine and an embedded Rust SQLite clone. Each subproject is driven by its own agent prompt, test harness, and launch script so teams can iterate autonomously while sharing this single workspace.

## Repository layout
- `regex/` — clean-room regex engine exercise. The agent prompt (`regex/AGENT_PROMPT.md`) lays out parsing/AST/bytecode goals, testing expectations, and the lock-file workflow. `launch_agents.sh` boots agents inside `screen` sessions, while `agent_loop.sh` contains the interaction loop the agents run.
- `sqlite/` — embedded SQLite-like engine. The agent prompt (`sqlite/AGENT_PROMPT.md`) plus bootstrap prompt describe the expected architecture, testing rules, and coordination steps. The launcher script handles one bootstrap agent, waits for core artifacts, and then spins up Claude and Codex workers; `agent_loop.sh` implements each worker loop, with `restart_agents.sh` available for recovery.

## Working with agents
- Read the relevant `AGENT_PROMPT.md` (and `BOOTSTRAP_PROMPT.md` for the SQLite stack) before editing so you understand the task selection, locking, and testing conventions.
- Respect each project’s local `current_tasks/`, `PROGRESS.md`, and `notes/` workflows: lock a task before working, update the progress document when you complete a task, leave notes for teammates, and remove the lock only when the work is finished.
- Always run `./test.sh --fast` within the subproject you touched before pushing; if you touched a high-impact area, run the full `./test.sh` suite as well.

## Running agents locally
- Regex: `cd regex && ./launch_agents.sh [num_agents]` (default 2). The launcher spins up `screen` sessions on `/project/6049267/kyars/server-stuff/agent_loop.sh`, so adjust the path or run from the containerized environment that provides that layout.
- SQLite: `cd sqlite && ./launch_agents.sh`. The script clones `git@github.com:kiankyars/sqlite.git` into a bootstrap workspace, runs a single Claude bootstrap agent, waits for the shared README/DESIGN/PROGRESS files to appear on `origin/main`, and then launches the worker agents specified in the script.

## Contribution notes
- Capture design changes in `DESIGN.md` (SQLite) or the equivalent notes directory, and sync progress updates before committing for transparency.
- Follow the codebase conventions from the agent prompts: small modules, doc comments on public APIs, no `unsafe` unless documented, and test-driven small increments.
- After committing, push to the same branch you fetched from so bootstrap workers can see the new state; the SQLite launcher depends on `origin/main` containing the latest README/DESIGN/PROGRESS files.

## Key references
- The agent prompts (`regex/AGENT_PROMPT.md`, `sqlite/AGENT_PROMPT.md`) describe the technical goals, testing rules, and lock protocols for each subproject.
- `sqlite/BOOTSTRAP_PROMPT.md` contains the bootstrap agent briefing required before launching additional workers.
