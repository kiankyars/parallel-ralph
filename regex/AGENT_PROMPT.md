# Regex Engine Agent Prompt

You are building a regex engine from scratch in Rust, with no external dependencies beyond the Rust standard library. This is a clean-room implementation.

## Your Goal

Build a fully-featured regex engine that supports:
- Literals and concatenation
- Quantifiers: `*`, `+`, `?`, `{n}`, `{n,}`, `{n,m}`
- Character classes: `[abc]`, `[a-z]`, `[^abc]`, `\d`, `\w`, `\s` and their negations
- Anchors: `^`, `$`, `\b`
- Alternation: `a|b`
- Grouping and capturing: `(...)`, `(?:...)`
- Greedy and lazy matching
- Escape sequences: `\.`, `\\`, etc.
- Backreferences: `\1`, `\2`
- Lookahead and lookbehind: `(?=...)`, `(?!...)`, `(?<=...)`, `(?<!...)`

## How to Work

1. **Orient yourself first.** Read `README.md`, `PROGRESS.md`, and `notes/` before doing anything. Check `current_tasks/` to see what other agents are working on — do NOT work on anything that is already locked.

2. **Pick one task.** Look at `PROGRESS.md` for what needs doing. Pick the highest-priority unlocked task. Create a lock file at `current_tasks/<short_task_name>.txt` with a one-line description of what you're doing. Commit and push this lock immediately before starting work.

3. **Work in small, testable increments.** Do not write 500 lines and then test. Write a small piece, test it, fix it, repeat.

4. **Run tests before pushing.** Always run `./test.sh --fast` before pushing. If the pass rate drops compared to what `PROGRESS.md` reports, fix the regression before pushing. Do NOT push code that breaks existing tests.

5. **Run the full test suite occasionally.** Use `./test.sh` (no --fast) when you've made significant changes, but prefer `--fast` for iteration.

6. **Update PROGRESS.md** when you finish a task. Record: what you did, current test pass rate, what you think should be done next.

7. **Leave notes for other agents.** If you discover something important — a tricky edge case, a design constraint, a failed approach — write it to `notes/<topic>.md`. Read existing notes before starting work on a related area.

8. **Clean up when done.** Remove your lock file from `current_tasks/`, pull from upstream, merge, push your changes.

9. **If you hit a merge conflict**, resolve it carefully. Read the other agent's changes and understand them before resolving.

## Architecture Guidelines

- The engine should have clearly separated phases: **parsing** → **AST** → **compilation to bytecode/NFA** → **execution/matching**
- Keep modules small and focused. One file per major component.
- Write doc comments on public functions.
- No `unsafe` code unless absolutely necessary and documented.

## What NOT to Do

- Do not refactor large parts of the codebase in a single commit. Small changes only.
- Do not delete or rewrite another agent's code without understanding it first (check notes/).
- Do not work on optimization until core functionality is passing tests.
- Do not spend more than ~30 minutes on a single bug. If stuck, document what you tried in `notes/` and move on to something else.
