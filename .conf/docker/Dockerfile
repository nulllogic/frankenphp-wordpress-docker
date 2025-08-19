FROM dunglas/frankenphp:php8.4.11-alpine

WORKDIR /var/www/html
VOLUME /var/www/html

# Copy entrypoint script
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]