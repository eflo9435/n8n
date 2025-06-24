#!/bin/bash
set -e

export PATH="/opt/venv/bin:$PATH"

echo "=== Starting services with fixed installation ==="

# Start nginx
nginx &
sleep 2

# Start n8n (we know this works)
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export N8N_USER_FOLDER=/app/data/n8n
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
n8n start &
sleep 10

curl -f http://localhost:5678 && echo "✅ n8n OK" || echo "❌ n8n FAILED"

# Start LiteLLM with working command
echo "=== Starting LiteLLM with proxy server ==="
litellm --model gpt-3.5-turbo --port 4000 --host 0.0.0.0 &
sleep 10
curl -f http://localhost:4000/v1/models && echo "✅ LiteLLM OK" || echo "❌ LiteLLM FAILED"

# Start Open WebUI
echo "=== Starting Open WebUI ==="
export OPENAI_API_BASE_URL=http://127.0.0.1:4000/v1
export OPENAI_API_KEY=sk-dummy-key-for-local-testing
export DATA_DIR=/app/data/openwebui
export WEBUI_SECRET_KEY=your-secret-key
open-webui serve --port 8080 --host 0.0.0.0 &
sleep 10
curl -f http://localhost:8080 && echo "✅ Open WebUI OK" || echo "❌ Open WebUI FAILED"

echo "=== Final status check ==="
ps aux | grep -E "(n8n|litellm|open-webui)" | grep -v grep

tail -f /dev/null
