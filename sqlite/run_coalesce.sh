#!/bin/bash
# run_coalesce.sh — one-shot agent to coalesce duplicate code and documentation.
# Usage: from sqlite/ run: ./run_coalesce.sh
# Uses workspace-coalesce; requires REPO and gemini CLI in env.
# Runs daily via cron at midnight Pacific.

set -u

WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="${REPO:-git@github.com:kiankyars/sqlite.git}"
COALESCE_PROMPT="${WORKSPACE_ROOT}/COALESCE_PROMPT.md"
WORKSPACE="${WORKSPACE_ROOT}/workspace-coalesce"

if [ ! -d "${WORKSPACE}/.git" ]; then
    git clone "${REPO}" "${WORKSPACE}"
fi

cd "${WORKSPACE}" || exit 1
git pull --rebase origin main 2>/dev/null || git pull origin main

mkdir -p agent_logs
LOG="agent_logs/coalesce_$(date +%s).log"

echo "[$(date)] Coalesce agent start"
gemini exec --model "gemini-3-flash-preview" "$(cat "${COALESCE_PROMPT}")" \
    >> "${LOG}" 2>&1
echo "[$(date)] Coalesce agent end (see ${LOG})"
