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
- Use `sqlite3` as behavioral oracle for SQL semantics/results.
- Keep internal storage/engine invariants owned by this repo's design.

`--fast` mode must be:
- deterministic 10% sampling
- seeded per agent (for example using `AGENT_ID`)
- implemented with `md5sum` hashing so fixed seed => fixed sample set

5. Initialize a hello-world Rust crate/workspace skeleton for parser/planner/executor/storage (minimal stubs only).

6. Define lock-file protocol in docs:
- Lock files in `current_tasks/` contain `created_at_unix`.
- Establish best-practice stale-lock handling.

## Constraints

- Keep bootstrap minimal; do not start implementation.
- Commit all bootstrap artifacts in one clear commit.
- Ensure the repository is in a buildable state before finishing.
