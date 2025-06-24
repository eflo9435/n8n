#!/bin/bash
set -e

export PATH="/opt/venv/bin:$PATH"

echo "=== Starting services with diagnostics ==="

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

# Test if n8n is responding
curl -f http://localhost:5678 && echo "✅ n8n OK" || echo "❌ n8n FAILED"

# Try starting LiteLLM with diagnostics
echo "=== Testing LiteLLM ==="
which litellm || echo "litellm command not found"
litellm --version || echo "litellm version failed"
litellm --port 4000 --host 0.0.0.0 &
sleep 10
curl -f http://localhost:4000/health && echo "✅ LiteLLM OK" || echo "❌ LiteLLM FAILED"

# Try starting Open WebUI with diagnostics  
echo "=== Testing Open WebUI ==="
which open-webui || echo "open-webui command not found"
export DATA_DIR=/app/data/openwebui
open-webui serve --port 8080 --host 0.0.0.0 &
sleep 10
curl -f http://localhost:8080 && echo "✅ Open WebUI OK" || echo "❌ Open WebUI FAILED"

echo "=== Port status ==="
netstat -tlnp 2>/dev/null || ss -tlnp

echo "=== Process status ==="
ps aux | grep -E "(n8n|litellm|open-webui)" | grep -v grep

tail -f /dev/null
