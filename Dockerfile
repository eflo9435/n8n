FROM node:20-alpine as n8n-base

# Install n8n and basic dependencies
RUN apk add --no-cache nginx bash curl
RUN npm install -g n8n

# Create n8n data directory
RUN mkdir -p /root/.n8n

# Multi-stage build - OpenWebUI in separate container, then copy
FROM ghcr.io/open-webui/open-webui:main as openwebui

# Final combined image
FROM n8n-base

# Copy OpenWebUI from official image
COPY --from=openwebui /app /app/openwebui

# Install Python for OpenWebUI
RUN apk add --no-cache python3 py3-pip
RUN pip3 install --break-system-packages uvicorn

# Create working directory
WORKDIR /app

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /app/start.sh
COPY litellm-proxy.js /app/litellm-proxy.js

# Make start script executable
RUN chmod +x /app/start.sh

EXPOSE 80

CMD ["/app/start.sh"]
