#!/bin/bash

echo "Starting nginx..."
nginx &
sleep 2

echo "Starting n8n..."
export N8N_HOST=0.0.0.0
export N8N_PORT=5678

# Start n8n
n8n start
