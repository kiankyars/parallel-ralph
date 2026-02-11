#!/bin/bash
# launch_agents.sh — spawns agents in screen sessions
# Usage: ./launch_agents.sh <num_agents>

WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# NUM_AGENTS is set to the first command-line argument, or defaults to 2 if not provided.
NUM_AGENTS=${1:-2}

echo "=== Regex Agent Team Launcher ==="

for i in $(seq 1 "$NUM_AGENTS"); do
    echo "[launch] Starting agent $i in screen 'agent-$i'..."
    screen -dmS "agent-$i" bash -c "AGENT_ID=$i \"$WORKSPACE_ROOT/agent_loop.sh\""
    echo "[launch] Agent $i running"
done

echo "=== All $NUM_AGENTS agents running ==="
echo "Reattach: screen -r agent-<n>"
echo ""
