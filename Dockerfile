FROM docker/compose:latest

WORKDIR /app

COPY docker-compose.yml .
COPY nginx.conf .

EXPOSE 80

CMD ["up", "--build"]
