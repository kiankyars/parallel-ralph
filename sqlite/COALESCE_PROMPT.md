# Coalesce Agent (one-shot)

You are doing a single cleanup run on this codebase.

## Workflow

1. **Orient first:**
- Read `README.md`, `DESIGN.md`, `PROGRESS.md`, and relevant `notes/`.

2. **Coalesce duplicates:**
- Find duplicate or near-duplicate code (same logic in multiple places).
- Coalesce into shared helpers or single implementations.
- Prefer minimal, targeted refactors; do not rewrite the whole codebase.

3. **Consolidate documentation:**
- Find scattered or duplicated documentation (.md).
- Consolidate redundancy into clear, single sources.

4. **Test before push:**
- Run `./test.sh` before each push.
- Do not push regressions.

5. **Clean up:**
- Pull/rebase and push cleanly. If you hit a merge conflict, resolve carefully; read the other agent's changes before resolving.

## Constraints

- One or a few commits. Do not change behavior; run tests and fix any regressions.
- Prefer moving over rewriting. Leave the repo buildable and tests passing.
- Keep changes scoped.
