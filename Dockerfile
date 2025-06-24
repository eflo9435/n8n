FROM node:20-slim

# Install minimal dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install n8n and AI packages
RUN npm install -g n8n

# Create a simple AI proxy using Node.js
WORKDIR /app
COPY package.json .
RUN npm install

# Copy configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY ai-proxy.js /app/ai-proxy.js
COPY start-simple.sh /app/start-simple.sh
RUN chmod +x /app/start-simple.sh

# Create data directory
RUN mkdir -p /app/data/n8n

EXPOSE 80

CMD ["/app/start-simple.sh"]
