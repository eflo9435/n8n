FROM docker:24-dind

# Install required packages
RUN apk add --no-cache docker-compose curl bash

# Create app directory
WORKDIR /app

# Copy configuration files
COPY docker-compose.yml .
COPY nginx.conf .
COPY litellm_data ./litellm_data

# Expose port 80
EXPOSE 80

# Start Docker daemon and services directly
CMD dockerd --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 & \
    sleep 15 && \
    docker-compose up --build
