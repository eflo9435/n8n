FROM node:20-alpine

# Install system dependencies
RUN apk add --no-cache nginx bash curl

# Install n8n
RUN npm install -g n8n

# Create working directory
WORKDIR /app

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /app/start.sh

# Make start script executable
RUN chmod +x /app/start.sh

# Create n8n data directory
RUN mkdir -p /root/.n8n

EXPOSE 80

CMD ["/app/start.sh"]
