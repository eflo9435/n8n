FROM node:20-slim

# Install Python and other dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    python3 \
    python3-pip \
    curl \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Install n8n (Node.js 20 compatible)
RUN npm install -g n8n

# Install Python packages
RUN pip3 install --no-cache-dir litellm open-webui

# Create directories
WORKDIR /app
RUN mkdir -p /app/data/n8n /app/data/openwebui

# Copy configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY start-simple.sh /app/start-simple.sh
RUN chmod +x /app/start-simple.sh

EXPOSE 80

CMD ["/app/start-simple.sh"]
