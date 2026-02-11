#!/bin/bash
# agent_loop.sh — run in a screen session per agent
# Usage: AGENT_ID=1 ./agent_loop.sh

[ -n "$AGENT_ID" ] || { echo "AGENT_ID required"; exit 1; }

REPO="${REPO:-git@github.com:kiankyars/regex.git}"
REGEX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(dirname "$REGEX_DIR")"
WORKSPACE="${WORKSPACE_ROOT}/workspace-${AGENT_ID}"
PROMPT_PATH="${PROMPT_PATH:-$REGEX_DIR/AGENT_PROMPT.md}"

if [ ! -d "$WORKSPACE/.git" ]; then
    git clone "$REPO" "$WORKSPACE"
fi
cd "$WORKSPACE"
mkdir -p agent_logs current_tasks notes

while true; do
    git pull --rebase origin main 2>/dev/null || git pull origin main
    COMMIT=$(git rev-parse --short=6 HEAD)
    LOGFILE="agent_logs/agent_${AGENT_ID}_${COMMIT}_$(date +%s).log"
    echo "[$(date)] Agent ${AGENT_ID} starting session at ${COMMIT}"
    claude --dangerously-skip-permissions -p "$(cat "$PROMPT_PATH")" --model claude-opus-4-6 &>> "$LOGFILE"
    EXIT_CODE=$?
    echo "[$(date)] Agent ${AGENT_ID} session ended (exit $EXIT_CODE)"
    [ $EXIT_CODE -eq 0 ] && sleep 5 || { echo "[$(date)] Backing off 60s..."; sleep 60; }
done
