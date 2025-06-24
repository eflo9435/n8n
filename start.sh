#!/bin/bash
set -e

echo "=== Starting all services ==="

# Start nginx
nginx &
sleep 2

# Start n8n
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export N8N_USER_FOLDER=/root/.n8n
n8n start &
sleep 10

# Start LiteLLM proxy
node /app/litellm-proxy.js &
sleep 5

# Start Open WebUI
cd /app/openwebui
export OPENAI_API_BASE_URL=http://127.0.0.1:4000/v1
export OPENAI_API_KEY=${OPENAI_API_KEY:-dummy-key}
export DATA_DIR=/app/data/openwebui
export WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY:-default-secret}
python3 -m uvicorn main:app --host 0.0.0.0 --port 8080 &

echo "=== All services starting ==="
echo "n8n: https://ai-hub-v2.onrender.com/"
echo "Open WebUI: https://ai-hub-v2.onrender.com/chat/"
echo "LiteLLM: https://ai-hub-v2.onrender.com/v1/"

tail -f /dev/null
