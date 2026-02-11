#!/bin/bash
# agent_loop.sh — run one autonomous agent loop
# Usage:
#   AGENT_ID=1 AGENT_LABEL=claude AGENT_MODEL=claude-opus-4-6 \
#   AGENT_COMMAND='claude --dangerously-skip-permissions -p "$PROMPT_TEXT" --model "$AGENT_MODEL"' \
#   PROMPT_PATH=/path/AGENT_PROMPT.md ./agent_loop.sh

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="git@github.com:kiankyars/sqlite.git"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

AGENT_ID="${AGENT_ID:?AGENT_ID is required}"
AGENT_LABEL="${AGENT_LABEL:?AGENT_LABEL is required}"
AGENT_MODEL="${AGENT_MODEL:?AGENT_MODEL is required}"
PROMPT_PATH="${PROMPT_PATH:?PROMPT_PATH is required}"
AGENT_COMMAND="${AGENT_COMMAND:?AGENT_COMMAND is required}"

WORKSPACE="${WORKSPACE_ROOT}/workspace-${AGENT_ID}"

if [ ! -d "${WORKSPACE}/.git" ]; then
    git clone "${REPO}" "${WORKSPACE}"
fi

cd "${WORKSPACE}" || exit 1

mkdir -p agent_logs

while true; do
    git pull --rebase origin main 2>/dev/null || git pull origin main

    COMMIT="$(git rev-parse --short=6 HEAD)"
    TS="$(date +%s)"
    LOGFILE="agent_logs/agent_${AGENT_ID}_${AGENT_LABEL}_${COMMIT}_${TS}.log"
    TMP_LOG="$(mktemp "/tmp/agent_${AGENT_ID}_${AGENT_LABEL}_${COMMIT}_${TS}.XXXX.log")"

    echo "[$(date)] Agent ${AGENT_ID} (${AGENT_LABEL}) start at ${COMMIT}"

    PROMPT_TEXT="$(cat "${PROMPT_PATH}")"
    export AGENT_MODEL
    export PROMPT_TEXT
    bash -lc "${AGENT_COMMAND}" > "${TMP_LOG}" 2>&1

    EXIT_CODE=$?
    if grep -Eqi 'rate[ -]?limit|too many requests|quota|429' "${TMP_LOG}"; then
        echo "[$(date)] Agent ${AGENT_ID} (${AGENT_LABEL}) rate-limited; dropping session log"
        rm -f "${TMP_LOG}"
        sleep 60
        continue
    fi

    mv "${TMP_LOG}" "${LOGFILE}"
    echo "[$(date)] Agent ${AGENT_ID} (${AGENT_LABEL}) end (exit ${EXIT_CODE})"

    if [ ${EXIT_CODE} -ne 0 ]; then
        echo "[$(date)] Backing off 60s..."
        sleep 60
    else
        sleep 5
    fi
done
