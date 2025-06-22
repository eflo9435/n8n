#!/bin/bash

# Start Docker daemon in background
dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 &

# Wait for Docker daemon to start
sleep 10

# Pull required images
docker-compose pull

# Start all services
docker-compose up --build
