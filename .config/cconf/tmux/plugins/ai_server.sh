#!/usr/bin/env bash
## Detect whether the AI local server is running

CHECK="$HOME/.tmux_ai_server_checked"
#INTERVAL=1

#if [ -f "$CHECK" ]; then
    #now=$(date +%s)
    #created=$(stat "$CHECK" --format %Y)
    #if [ $(( now - created )) -lt "$INTERVAL"  ]; then
        #cat "$CHECK"
        #exit 0
    #fi
#fi


touch "$CHECK" >/dev/null
{
if ssh personal -- podman ps | grep -c ollama >/dev/null 2>&1; then
   echo "󱙺  "
else
   echo "󱙺  "
fi
## Curl the endpoint seems to crash ollama
#AI_PORT=11434
#if ! SERVER_IP=$(ssh -G personal | grep -e "^hostname" | cut -d" " -f2); then
   #echo "󱙺  : could not get server IP"
#elif curl --silent "http://$SERVER_IP:$AI_PORT/" | grep "Ollama is running"; then
   #echo "󱙺  "
#else
   #echo "󱙺  "
#fi


} > "$CHECK"
cat "$CHECK"
