#!/bin/bash
# agent_loop.sh — run in a screen session per agent
# Usage: AGENT_ID=1 ./agent_loop.sh

REPO="git@github.com:kiankyars/regex.git"
WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

AGENT_ID="${AGENT_ID:?AGENT_ID is required}"
AGENT_LABEL="${AGENT_LABEL:-claude}"

WORKSPACE="${WORKSPACE_ROOT}/workspace-${AGENT_ID}"
PROMPT_PATH="${WORKSPACE_ROOT}/AGENT_PROMPT.md"

# Clone if needed
if [ ! -d "$WORKSPACE/.git" ]; then
    git clone "$REPO" "$WORKSPACE"
    git checkout -f c592a0534e60db71795863a8e64598f3779afc86
fi

cd "$WORKSPACE"

# Configure git hook for co-author attribution
mkdir -p .git/hooks
cat > .git/hooks/prepare-commit-msg <<EOF
#!/bin/bash
case "\$AGENT_LABEL" in
  codex)
    echo "Co-authored-by: Codex <codex@local>" >> "\$1"
    ;;
  gemini)
    echo "Co-authored-by: Gemini <gemini@local>" >> "\$1"
    ;;
esac
EOF
chmod +x .git/hooks/prepare-commit-msg

mkdir -p agent_logs current_tasks notes

while true; do
    git pull --rebase origin main 2>/dev/null || git pull origin main

    COMMIT=$(git rev-parse --short=6 HEAD)
    LOGFILE="agent_logs/agent_${AGENT_ID}_${COMMIT}_$(date +%s).log"

    echo "[$(date)] Agent ${AGENT_ID} starting session at ${COMMIT}"

    export AGENT_LABEL
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
