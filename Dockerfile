FROM n8nio/n8n:latest

USER root

# Install nginx
RUN apk add --no-cache nginx

# Copy files to correct locations
COPY nginx.conf /etc/nginx/nginx.conf
COPY start.sh /start.sh

# Make start script executable
RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]
