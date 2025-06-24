#!/bin/bash
set -e

export PATH="/opt/venv/bin:$PATH"

echo "=== Starting all services ==="

# Start nginx
nginx &
sleep 2

# Start n8n (working configuration)
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export N8N_USER_FOLDER=/app/data/n8n
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
n8n start &
sleep 10

# Start LiteLLM
echo "Starting LiteLLM..."
litellm --port 4000 --host 0.0.0.0 &
sleep 10

# Start Open WebUI
echo "Starting Open WebUI..."
export DATA_DIR=/app/data/openwebui
open-webui serve --port 8080 --host 0.0.0.0 &
sleep 5

echo "=== All services started ==="
echo "n8n: https://ai-hub-v2.onrender.com/"
echo "Open WebUI: https://ai-hub-v2.onrender.com/chat/"
echo "LiteLLM API: https://ai-hub-v2.onrender.com/v1/"

tail -f /dev/null
