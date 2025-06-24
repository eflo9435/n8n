#!/bin/bash
set -e

export PATH="/opt/venv/bin:$PATH"

echo "=== Starting services sequentially ==="

# Start nginx
nginx &
sleep 2

# Start n8n with proper reverse proxy settings
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export N8N_PATH="/n8n/"
export N8N_PROTOCOL=https
export N8N_LISTEN_ADDRESS=0.0.0.0
export N8N_USER_FOLDER=/app/data/n8n
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
export WEBHOOK_URL=https://ai-hub-v2.onrender.com/n8n/webhook
n8n start &
sleep 10

# Check if n8n is responding
curl -f http://localhost:5678 && echo "n8n OK" || echo "n8n check failed"

# Start LiteLLM with better error handling
echo "Starting LiteLLM..."
python3 -m litellm --port 4000 --host 0.0.0.0 &
sleep 10

# Check if LiteLLM started
curl -f http://localhost:4000/health && echo "LiteLLM OK" || echo "LiteLLM check failed"

# Start Open WebUI
export OPENAI_API_BASE_URL=http://127.0.0.1:4000/v1
export DATA_DIR=/app/data/openwebui
open-webui serve --port 8080 --host 0.0.0.0 &

echo "=== Services started, checking status ==="
sleep 5
ps aux | grep -E "(n8n|nginx|litellm|open-webui)" | grep -v grep

echo "=== Keeping container alive ==="
tail -f /dev/null
