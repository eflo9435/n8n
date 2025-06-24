FROM n8nio/n8n:latest

USER root

# Install nginx only
RUN apk add --no-cache nginx

# Copy simple nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Simple startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]
