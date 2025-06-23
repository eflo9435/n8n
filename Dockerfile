FROM node:20-alpine

# Install required packages
RUN apk add --no-cache \
    nginx \
    python3 \
    py3-pip \
    supervisor \
    curl \
    bash

# Install n8n globally
RUN npm install -g n8n

# Install LiteLLM
RUN pip3 install litellm[proxy]

# Create app directory
WORKDIR /app

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY litellm_data/config.yaml /app/litellm_config.yaml
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create directories for data
RUN mkdir -p /app/data/n8n /app/data/litellm /app/data/openwebui

# Install Open WebUI
RUN pip3 install open-webui

# Expose port 80
EXPOSE 80

# Use supervisor to manage all services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
