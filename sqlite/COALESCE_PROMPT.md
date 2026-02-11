# Coalesce Agent (one-shot)

You are doing a single cleanup run on this codebase.

## Workflow

1. **Orient first:**
- Read `README.md`, `DESIGN.md`, `PROGRESS.md`, and relevant `notes/`.
- Check `current_tasks/` for active locks. Do not work on locked tasks.

2. **Coalesce duplicates:**
- Find duplicate or near-duplicate code (same logic in multiple places).
- Coalesce into shared helpers or single implementations.
- Do not delete or rewrite code without reading `notes/` first to understand why it exists.
- Prefer minimal, targeted refactors; do not rewrite the whole codebase.

3. **Consolidate documentation:**
- Find scattered or duplicated documentation.
- Consolidate into clear, single sources (e.g. README, DESIGN, or `docs/`).
- Remove redundant copies.

4. **Test before push:**
- Run `./test.sh --fast` before each push.
- If behavior changes, add tests in the same commit.
- Do not push regressions.

5. **Clean up:**
- Pull/rebase and push cleanly. If you hit a merge conflict, resolve carefully; read the other agent's changes before resolving.

## Constraints

- One or a few commits. Do not change behavior; run tests and fix any regressions.
- Prefer moving over rewriting. Leave the repo buildable and tests passing.
- Keep changes scoped.
