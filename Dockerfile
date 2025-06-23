FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    curl \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install n8n globally
RUN npm install -g n8n

# Install Python packages
RUN pip install --no-cache-dir \
    litellm \
    open-webui

# Create app directory
WORKDIR /app

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY litellm_data/config.yaml /app/litellm_config.yaml
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create directories for data
RUN mkdir -p /app/data/n8n /app/data/litellm /app/data/openwebui

# Expose port 80
EXPOSE 80

# Use supervisor to manage all services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
