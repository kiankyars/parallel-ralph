#!/bin/bash
# coalesce.sh — coalesce duplicate code and documentation, optionally set up cron
# Usage:
#   ./coalesce.sh              # Run coalesce agent
#   ./coalesce.sh setup-cron   # Set up daily cron job at midnight Pacific

set -u

WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="${REPO:-git@github.com:kiankyars/sqlite.git}"
COALESCE_PROMPT="${WORKSPACE_ROOT}/COALESCE_PROMPT.md"
WORKSPACE="${WORKSPACE_ROOT}/workspace-coalesce"
SCRIPT_PATH="${WORKSPACE_ROOT}/coalesce.sh"

# Setup cron job
if [ "${1:-}" = "setup-cron" ]; then
    CRON_ENTRY="0 0 * * * TZ=America/Los_Angeles cd '${WORKSPACE_ROOT}' && ${SCRIPT_PATH}"
    
    echo "Adding cron entry:"
    echo "${CRON_ENTRY}"
    echo ""
    echo "To add manually, run:"
    echo "crontab -e"
    echo "Then add this line:"
    echo "${CRON_ENTRY}"
    echo ""
    read -p "Add this cron job now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        (crontab -l 2>/dev/null; echo "${CRON_ENTRY}") | crontab -
        echo "Cron job added. Current crontab:"
        crontab -l
    fi
    exit 0
fi

# Run coalesce agent
if [ ! -d "${WORKSPACE}/.git" ]; then
    git clone "${REPO}" "${WORKSPACE}"
fi

cd "${WORKSPACE}" || exit 1
git pull --rebase origin main 2>/dev/null || git pull origin main

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

mkdir -p agent_logs
LOG="agent_logs/coalesce_$(date +%s).log"

echo "[$(date)] Coalesce agent start"
export AGENT_LABEL=gemini
gemini --prompt "$(cat "${COALESCE_PROMPT}")" --model gemini-3-flash-preview --yolo \
    >> "${LOG}" 2>&1
echo "[$(date)] Coalesce agent end (see ${LOG})"
