#!/usr/bin/env bash
## Detect whether the AI local server is running

if ssh personal -- podman inspect --format "{{.State.Status}}" ollama | grep -c "running" >/dev/null; then
    echo "󱙺  "
else
    echo "󱙺  "
fi
