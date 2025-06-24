#!/bin/bash
set -e

echo "=== Testing n8n only ==="

# Start nginx
nginx &
sleep 2

# Start n8n without reverse proxy path (test direct access)
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export N8N_USER_FOLDER=/app/data/n8n
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
n8n start &
sleep 15

echo "=== Checking if n8n responds ==="
curl -v http://localhost:5678 || echo "n8n not responding"

echo "=== Services started - n8n should be accessible at root ==="
tail -f /dev/null
