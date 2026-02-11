#!/bin/bash
# restart_agents.sh — restart only Claude, Codex, or Gemini workers
# Usage: ./restart_agents.sh claude|codex|gemini

set -u

WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_PROMPT="${WORKSPACE_ROOT}/AGENT_PROMPT.md"

GROUP="${1:-}"
if [ -z "${GROUP}" ]; then
    echo "Usage: $0 claude|codex|gemini" >&2
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

if [ "${GROUP}" = "gemini" ]; then
    screen -S "sqlite-agent-5" -X quit >/dev/null 2>&1 || true
    screen -S "sqlite-agent-6" -X quit >/dev/null 2>&1 || true
    screen -dmS "sqlite-agent-5" bash -c "AGENT_ID=5 AGENT_LABEL=gemini AGENT_MODEL=gemini-3-pro-preview AGENT_COMMAND='gemini --prompt \"\$PROMPT_TEXT\" --model \"\$AGENT_MODEL\" --yolo' PROMPT_PATH='${AGENT_PROMPT}' '${WORKSPACE_ROOT}/agent_loop.sh'"
    screen -dmS "sqlite-agent-6" bash -c "AGENT_ID=6 AGENT_LABEL=gemini AGENT_MODEL=gemini-3-pro-preview AGENT_COMMAND='gemini --prompt \"\$PROMPT_TEXT\" --model \"\$AGENT_MODEL\" --yolo' PROMPT_PATH='${AGENT_PROMPT}' '${WORKSPACE_ROOT}/agent_loop.sh'"
    exit 0
fi

echo "Invalid group '${GROUP}'. Use claude, codex, or gemini." >&2
exit 1
