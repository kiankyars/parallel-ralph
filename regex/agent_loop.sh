#!/bin/bash
# agent_loop.sh — run in a screen session per agent
# Usage: AGENT_ID=1 ./agent_loop.sh

SCRIPT_DIR="/project/6049267/kyars/server-stuff"
AGENT_ID="${AGENT_ID:-0}"
REPO="git@github.com:kiankyars/regex.git"

WORKSPACE_ROOT="$(cd "$(dirname "$REPO")" && pwd)"
WORKSPACE="${WORKSPACE_ROOT}/workspace-${AGENT_ID}"
PROMPT_PATH="${SCRIPT_DIR}/AGENT_PROMPT.md"

# Clone if needed
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

    claude --dangerously-skip-permissions \
           -p "$(cat "$PROMPT_PATH")" \
           --model claude-opus-4-6 &>> "$LOGFILE"

    EXIT_CODE=$?
    echo "[$(date)] Agent ${AGENT_ID} session ended (exit $EXIT_CODE)"

    if [ $EXIT_CODE -ne 0 ]; then
        echo "[$(date)] Backing off 60s..."
        sleep 60
    else
        sleep 5
    fi
done
