FROM docker:24-dind

# Install docker-compose
RUN apk add --no-cache docker-compose curl

# Create app directory
WORKDIR /app

# Copy configuration files
COPY docker-compose.yml .
COPY nginx.conf .
COPY litellm_data/config.yaml ./litellm_data/config.yaml

# Create directories for volumes
RUN mkdir -p n8n_data litellm_data open_webui_data

# Expose port 80 (nginx proxy)
EXPOSE 80

# Start script
COPY start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
