#!/bin/bash
set -e

# Activate Python virtual environment
export PATH="/opt/venv/bin:$PATH"

echo "=== Node.js version check ==="
node --version
echo "=== Python version check ==="
python3 --version
pip --version

echo "=== Starting services sequentially ==="

# Start nginx
echo "Starting nginx..."
nginx &
sleep 2

# Start n8n with correct Node.js version
echo "Starting n8n..."
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export N8N_USER_FOLDER=/app/data/n8n
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
n8n start &
sleep 10

# Check if n8n started
curl -f http://localhost:5678 && echo "n8n OK" || echo "n8n FAILED"

# Start LiteLLM
echo "Starting LiteLLM..."
litellm --port 4000 &
sleep 10

# Check if LiteLLM started
curl -f http://localhost:4000/health && echo "LiteLLM OK" || echo "LiteLLM FAILED"

# Start Open WebUI
echo "Starting Open WebUI..."
export OPENAI_API_BASE_URL=http://127.0.0.1:4000/v1
export DATA_DIR=/app/data/openwebui
open-webui serve --port 8080 &
sleep 5

echo "=== All services started ==="
echo "Checking what's running:"
ps aux | grep -E "(n8n|nginx|litellm|open-webui)" || echo "No processes found"

echo "=== Keeping container alive ==="
tail -f /dev/null
