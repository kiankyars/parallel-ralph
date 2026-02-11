#!/bin/bash
# setup_coalesce_cron.sh — add cron job for daily coalesce agent at midnight Pacific
# Usage: ./setup_coalesce_cron.sh
# Adds crontab entry; run from sqlite/ directory on the server.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CRON_ENTRY="0 0 * * * TZ=America/Los_Angeles cd '${SCRIPT_DIR}' && ./run_coalesce.sh"

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
