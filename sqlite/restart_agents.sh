#!/bin/bash
# restart_agents.sh — restart only Claude or only Codex workers
# Usage: ./restart_agents.sh claude|codex

set -u

WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_PROMPT="${WORKSPACE_ROOT}/AGENT_PROMPT.md"

GROUP="${1:-}"
if [ -z "${GROUP}" ]; then
    echo "Usage: $0 claude|codex" >&2
    exit 1
fi

if [ "${GROUP}" = "claude" ]; then
    screen -S "sqlite-agent-1" -X quit >/dev/null 2>&1 || true
    screen -S "sqlite-agent-2" -X quit >/dev/null 2>&1 || true
    screen -dmS "sqlite-agent-1" bash -c "AGENT_ID=1 AGENT_LABEL=claude AGENT_MODEL=claude-opus-4-6 AGENT_COMMAND='claude --dangerously-skip-permissions -p \"\$PROMPT_TEXT\" --model \"\$AGENT_MODEL\"' PROMPT_PATH='${AGENT_PROMPT}' '${WORKSPACE_ROOT}/agent_loop.sh'"
    screen -dmS "sqlite-agent-2" bash -c "AGENT_ID=2 AGENT_LABEL=claude AGENT_MODEL=claude-opus-4-6 AGENT_COMMAND='claude --dangerously-skip-permissions -p \"\$PROMPT_TEXT\" --model \"\$AGENT_MODEL\"' PROMPT_PATH='${AGENT_PROMPT}' '${WORKSPACE_ROOT}/agent_loop.sh'"
    exit 0
fi

if [ "${GROUP}" = "codex" ]; then
    screen -S "sqlite-agent-3" -X quit >/dev/null 2>&1 || true
    screen -S "sqlite-agent-4" -X quit >/dev/null 2>&1 || true
    screen -dmS "sqlite-agent-3" bash -c "AGENT_ID=3 AGENT_LABEL=codex AGENT_MODEL=gpt-5.3-codex AGENT_COMMAND='codex exec -c model_reasoning_effort=high --yolo --model \"\$AGENT_MODEL\" \"\$PROMPT_TEXT\"' PROMPT_PATH='${AGENT_PROMPT}' '${WORKSPACE_ROOT}/agent_loop.sh'"
    screen -dmS "sqlite-agent-4" bash -c "AGENT_ID=4 AGENT_LABEL=codex AGENT_MODEL=gpt-5.3-codex AGENT_COMMAND='codex exec -c model_reasoning_effort=high --yolo --model \"\$AGENT_MODEL\" \"\$PROMPT_TEXT\"' PROMPT_PATH='${AGENT_PROMPT}' '${WORKSPACE_ROOT}/agent_loop.sh'"
    exit 0
fi

echo "Invalid group '${GROUP}'. Use claude or codex." >&2
exit 1
