#!/bin/bash
set -x  # Show all commands for debugging

echo "=== DEBUGGING n8n startup ==="

# Check if n8n command exists
which n8n
n8n --version

# Create data directory with proper permissions
mkdir -p /app/data/n8n
ls -la /app/data/

# Set environment variables
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
export N8N_USER_FOLDER=/app/data/n8n
export N8N_DISABLE_PRODUCTION_MAIN_PROCESS=true

echo "Starting n8n..."
# Try to start n8n in foreground first to see errors
timeout 30 n8n start || echo "n8n failed to start"

echo "Checking what's running on ports..."
netstat -tlnp || ss -tlnp

# If n8n started, start other services
if curl -f http://localhost:5678 2>/dev/null; then
    echo "n8n is running! Starting other services..."
    
    # Start nginx
    nginx &
    
    # Start the other services in background
    n8n start &
    litellm --port 4000 &
    open-webui serve --port 8080 &
    
else
    echo "n8n failed to start. Only starting nginx and open-webui..."
    nginx &
    open-webui serve --port 8080 &
fi

echo "Keeping container alive..."
tail -f /dev/null
