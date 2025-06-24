FROM node:20-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    procps \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create Python virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip first
RUN pip install --upgrade pip

# Install n8n
RUN npm install -g n8n

# Install Python packages one by one with better error handling
RUN pip install --no-cache-dir litellm
RUN pip install --no-cache-dir open-webui

# Create directories
WORKDIR /app
RUN mkdir -p /app/data/n8n /app/data/openwebui

# Copy configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY start-simple.sh /app/start-simple.sh
RUN chmod +x /app/start-simple.sh

EXPOSE 80

CMD ["/app/start-simple.sh"]
