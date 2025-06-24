#!/bin/bash

echo "Starting nginx..."
nginx &
sleep 2

echo "Starting AI service..."
node /app/ai-proxy.js &
sleep 2

echo "Starting n8n..."
export N8N_HOST=0.0.0.0
export N8N_PORT=5678
n8n start
