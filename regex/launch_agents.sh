#!/bin/bash
# launch_agents.sh — spawns agents in screen sessions
# Usage: ./launch_agents.sh [num_agents]

REGEX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NUM_AGENTS=${1:-2}

for i in $(seq 1 "$NUM_AGENTS"); do
    screen -dmS "agent-$i" bash -c "AGENT_ID=$i \"$REGEX_DIR/agent_loop.sh\""
done
echo "Launched $NUM_AGENTS agents (screens: agent-1 .. agent-$NUM_AGENTS)"
