#!/bin/bash
set -e

echo "=== Starting simplified services ==="

# Start nginx
nginx &
sleep 2

# Start n8n (keep the working configuration)
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export N8N_USER_FOLDER=/app/data/n8n
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
n8n start &
sleep 10

# Start simple AI proxy
node /app/ai-proxy.js &
sleep 5

echo "=== Testing services ==="
curl -f http://localhost:5678 && echo "✅ n8n OK" || echo "❌ n8n FAILED"
curl -f http://localhost:4000/health && echo "✅ AI Proxy OK" || echo "❌ AI Proxy FAILED"

tail -f /dev/null
