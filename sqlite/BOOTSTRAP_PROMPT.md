# SQLite Bootstrap Prompt

You are bootstrapping a new SQLite-like engine project in Rust.
Your job in this run is to create baseline project docs, layout, and initial test harness.

## Goal

Build a robust SQLite-style engine incrementally:
- SQL parser and AST
- query planning and execution
- pager and on-disk format
- B+tree tables and indexes
- transactions and WAL/recovery
- strong automated tests

## Mandatory Outputs

1. Create `README.md` with:
- project purpose
- architecture overview
- build/run/test instructions
- scope and non-goals

2. Create `DESIGN.md` with:
- architecture and module boundaries
- data model and on-disk layout assumptions
- pager, B+tree, and transaction strategy
- staged roadmap

3. Create `PROGRESS.md` with:
- current status
- prioritized task backlog
- completed tasks
- known issues

4. Create baseline test runner `test.sh`:
- `--fast` mode for iteration
- full mode for milestones
- clear pass/fail summary
- Use `sqlite3` as behavioral oracle. When comparing results: normalize row order (explicit ORDER BY in test or sort both sides), NULL handling consistent, floats with tolerance or fixed format, and error-message wording normalized or ignored.
- Keep internal storage/engine invariants owned by this repo's design.

`--fast` mode must be:
- deterministic 10% sampling
- seeded per agent (for example using `AGENT_ID`)
- implemented with `md5sum` hashing so fixed seed => fixed sample set

5. Initialize a hello-world Rust crate/workspace skeleton for parser/planner/executor/storage (minimal stubs only).

6. Define lock-file protocol in docs:
- Lock files in `current_tasks/` contain `created_at_unix` (Unix timestamp).
- Stale locks: agents may remove a lock only if its file mtime is older than 30 minutes and there is no recent commit touching that task (e.g. last 30 min). Document this in the same place as the lock format.

## Constraints

- Keep bootstrap focused; do not start database implementation in this run.
- Commit bootstrap artifacts with clear commit messages.
- Ensure the repository is in a buildable state before finishing.
