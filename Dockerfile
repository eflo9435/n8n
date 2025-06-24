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
    git \
    && rm -rf /var/lib/apt/lists/*

# Create Python virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip and install wheel
RUN pip install --upgrade pip setuptools wheel

# Install n8n
RUN npm install -g n8n

# Install LiteLLM with all dependencies
RUN pip install --no-cache-dir litellm[proxy]
RUN pip install --no-cache-dir uvicorn fastapi

# Install Open WebUI
RUN pip install --no-cache-dir open-webui

# Verify installations
RUN litellm --version || echo "LiteLLM install failed"
RUN open-webui --version || echo "Open WebUI install succeeded"

# Create directories
WORKDIR /app
RUN mkdir -p /app/data/n8n /app/data/openwebui

# Copy configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY start-simple.sh /app/start-simple.sh
RUN chmod +x /app/start-simple.sh

EXPOSE 80

CMD ["/app/start-simple.sh"]
