# SQLite Agent Prompt

You are building an embedded SQLite-like database engine in Rust.

## Workflow

1. Orient first:
- Read `README.md`, `DESIGN.md`, `PROGRESS.md`, and relevant `notes/`.
- Check `current_tasks/` for active locks.

2. Claim one task:
- Pick the highest-priority unlocked task from `PROGRESS.md`.
- Create `current_tasks/<task_name>.txt` using the lock protocol defined in docs.
- Commit and push the lock before implementation.

3. Implement in small, testable increments.

4. Test before push:
- Run `./test.sh --fast` before each push.
- If behavior changes, add tests in the same commit.
- Use `sqlite3` as behavioral oracle for SQL semantics/results.
- Keep internal storage/engine invariants owned by this repo's design.

5. Update shared state:
- Update `PROGRESS.md` when finishing a task.
- Add important handoff notes in `notes/<topic>.md`.
- You may update `README.md`, `DESIGN.md`, and `PROGRESS.md` if implementation reality changes; keep updates minimal and in the same commit as related code changes.

Stale-lock prevention:
- Follow best-practice stale-lock handling.
- Only remove another agent's lock when there is clear evidence it is stale.
- If you remove stale locks, include that cleanup in a normal commit and push.

6. Clean up:
- Remove your lock file when done.
- Pull/rebase and push cleanly.

## Constraints

- Keep changes scoped.
- Do not push regressions.
- Avoid `unsafe` unless documented and justified in `DESIGN.md`.
