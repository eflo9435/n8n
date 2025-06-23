#!/bin/bash
set -e

echo "=== Starting all services ==="

# Start nginx
echo "Starting nginx..."
nginx &
sleep 2

# Start n8n with more explicit settings
echo "Starting n8n..."
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export N8N_PROTOCOL=http
export N8N_USER_FOLDER=/app/data/n8n
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
export NODE_ENV=production

# Make sure data directory exists and has proper permissions
mkdir -p /app/data/n8n
chmod 755 /app/data/n8n

# Start n8n and wait for it to be ready
n8n start &
N8N_PID=$!
sleep 10

# Check if n8n is responding
echo "Checking if n8n is running..."
curl -f http://localhost:5678 || echo "n8n not responding yet"

# Start LiteLLM
echo "Starting LiteLLM..."
export LITELLM_MASTER_KEY=${LITELLM_MASTER_KEY}
litellm --port 4000 &
sleep 5

# Start Open WebUI
echo "Starting Open WebUI..."
export OPENAI_API_BASE_URL=http://127.0.0.1:4000/v1
export OPENAI_API_KEY=${LITELLM_MASTER_KEY}
export WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY}
export DATA_DIR=/app/data/openwebui
open-webui serve --port 8080 &
sleep 5

echo "=== Service status ==="
echo "Checking ports:"
netstat -tlnp 2>/dev/null || ss -tlnp
echo "Processes:"
ps aux | grep -E "(n8n|nginx|litellm|open-webui)" || true

echo "=== Keeping container alive ==="
wait
