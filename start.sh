#!/bin/sh

echo "Starting nginx..."
nginx &

echo "Starting n8n..."
exec n8n start
