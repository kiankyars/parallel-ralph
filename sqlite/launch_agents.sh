#!/bin/bash
# launch_agents.sh
# 1) Run one bootstrap agent once.
# 2) Wait until bootstrap artifacts are visible on origin/main.
# 3) Launch 4 workers: 2 Claude Opus 4.6 + 2 Codex 5.3.

# Enable unset variable detection: script will exit if any variable is referenced before being set.
set -u

# Determine the absolute path to the directory containing the script.
# /project/6049267/kyars/parallel-ralph/sqlite
WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="git@github.com:kiankyars/sqlite.git"

BOOTSTRAP_PROMPT="${WORKSPACE_ROOT}/BOOTSTRAP_PROMPT.md"
AGENT_PROMPT="${WORKSPACE_ROOT}/AGENT_PROMPT.md"

BOOTSTRAP_WORKSPACE="${WORKSPACE_ROOT}/workspace-bootstrap"
BOOTSTRAP_LOG_DIR="${BOOTSTRAP_WORKSPACE}/agent_logs"
BOOTSTRAP_LOG="${BOOTSTRAP_LOG_DIR}/bootstrap_$(date +%s).log"

if [ ! -d "${BOOTSTRAP_WORKSPACE}/.git" ]; then
    git clone "${REPO}" "${BOOTSTRAP_WORKSPACE}"
fi

cd "${BOOTSTRAP_WORKSPACE}" || exit 1
# Ensure the local repo is up to date with origin/main; try a rebase first, fallback to merge if rebase fails.
git pull --rebase origin main 2>/dev/null || git pull origin main
# Create the directory for bootstrap agent logs if it doesn't exist.
# The '-p' flag tells mkdir to create parent directories as needed and not to error if the directory already exists.
mkdir -p "${BOOTSTRAP_LOG_DIR}"

echo "=== SQLite Bootstrap Run ==="
echo "[bootstrap] Running one bootstrap agent (claude-opus-4-6)..."
if ! claude --dangerously-skip-permissions \
    -p "$(cat "${BOOTSTRAP_PROMPT}")" \
    --model "claude-opus-4-6" \
    >> "${BOOTSTRAP_LOG}" 2>&1; then
    echo "[bootstrap] ERROR: bootstrap agent failed, see ${BOOTSTRAP_LOG}" >&2
    exit 1
fi

echo "[bootstrap] Waiting for bootstrap files on origin/main..."
while true; do
    if ! git fetch origin main >/dev/null 2>&1; then
        echo "[bootstrap] ERROR: git fetch origin main failed" >&2
        exit 1
    fi

    if git cat-file -e "origin/main:README.md" 2>/dev/null \
        && git cat-file -e "origin/main:DESIGN.md" 2>/dev/null \
        && git cat-file -e "origin/main:PROGRESS.md" 2>/dev/null; then
        echo "[bootstrap] Detected README.md, DESIGN.md, and PROGRESS.md on origin/main"
        break
    fi

    sleep 15
done

echo "=== Launching Worker Agents ==="

screen -dmS "sqlite-agent-1" bash -c "AGENT_ID=1 AGENT_LABEL=claude AGENT_MODEL=claude-opus-4-6 AGENT_COMMAND='claude --dangerously-skip-permissions -p \"\$PROMPT_TEXT\" --model \"\$AGENT_MODEL\"' PROMPT_PATH='${AGENT_PROMPT}' '${WORKSPACE_ROOT}/agent_loop.sh'"
screen -dmS "sqlite-agent-2" bash -c "AGENT_ID=2 AGENT_LABEL=claude AGENT_MODEL=claude-opus-4-6 AGENT_COMMAND='claude --dangerously-skip-permissions -p \"\$PROMPT_TEXT\" --model \"\$AGENT_MODEL\"' PROMPT_PATH='${AGENT_PROMPT}' '${WORKSPACE_ROOT}/agent_loop.sh'"
screen -dmS "sqlite-agent-3" bash -c "AGENT_ID=3 AGENT_LABEL=codex AGENT_MODEL=gpt-5.3-codex AGENT_COMMAND='codex exec --dangerously-bypass-approvals-and-sandbox --model \"\$AGENT_MODEL\" \"\$PROMPT_TEXT\"' PROMPT_PATH='${AGENT_PROMPT}' '${WORKSPACE_ROOT}/agent_loop.sh'"
screen -dmS "sqlite-agent-4" bash -c "AGENT_ID=4 AGENT_LABEL=codex AGENT_MODEL=gpt-5.3-codex AGENT_COMMAND='codex exec --dangerously-bypass-approvals-and-sandbox --model \"\$AGENT_MODEL\" \"\$PROMPT_TEXT\"' PROMPT_PATH='${AGENT_PROMPT}' '${WORKSPACE_ROOT}/agent_loop.sh'"

echo ""
echo "=== All 4 worker agents launched ==="
echo ""
