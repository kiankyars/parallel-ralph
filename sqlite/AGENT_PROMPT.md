# SQLite Agent Prompt

You are building an embedded SQLite-like database engine in Rust.

## Workflow

1. Orient first:
- Read `README.md`, `DESIGN.md`, `PROGRESS.md`, and relevant `notes/`.
- Check `current_tasks/` for active locks. Do not work on a task that is already locked.

2. Claim one task:
- Pick the highest-priority unlocked task from `PROGRESS.md`.
- Create `current_tasks/<task_name>.txt`.
- Commit and push the lock before implementation.

3. Implement in small, testable increments. Do not delete or rewrite another agent's code without reading `notes/` first.

4. Test before push:
- Run `./test.sh --fast` before each push.
- If behavior changes, add tests in the same commit.
- Use `sqlite3` as behavioral oracle for SQL semantics/results.
- Keep internal storage/engine invariants owned by this repo's design.

5. Update shared state:
- Update `PROGRESS.md` when finishing a task: what you did, current test pass rate, what should be done next.
- Add important handoff notes in `notes/<topic>.md`.
- Update `README.md` or `DESIGN.md` only if implementation reality changes; keep updates minimal and in the same commit as related code changes.

6. Clean up:
- Remove your lock file when done.
- Pull/rebase and push cleanly. If you hit a merge conflict, resolve carefully; read the other agent's changes before resolving.

## Constraints

- Follow best-practice stale-lock handling.
- If you remove stale locks, include that cleanup in a commit and push.
- Keep changes scoped.
- Do not push regressions.
- Avoid `unsafe` unless documented and justified in `DESIGN.md`.
- If stuck on a bug, document what you tried in `notes/` and move on.
