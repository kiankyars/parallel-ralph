# Coalesce Agent (one-shot)

You are doing a single cleanup run on this codebase.

## Task

1. **Duplicate code:** Find duplicate or near-duplicate code (same logic in multiple places). Coalesce into shared helpers or single implementations. Prefer minimal, targeted refactors; do not rewrite the whole codebase.
2. **Documentation:** Find scattered or duplicated documentation. Consolidate into clear, single sources (e.g. README, DESIGN, or `docs/`). Remove redundant copies.

## Constraints

- One or a few commits. Do not change behavior; run tests and fix any regressions.
- Prefer moving over rewriting. Leave the repo buildable and tests passing.
