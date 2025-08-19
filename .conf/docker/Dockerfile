FROM dunglas/frankenphp:php8.4.11-alpine

# add additional extensions here:
RUN install-php-extensions imagick xdebug
RUN docker-php-ext-install bcmath \
    exif \
    gd \
    mysqli \
    opcache \
    zip \
    pdo_mysql

WORKDIR /var/www/html
VOLUME /var/www/html

# Copy entrypoint script
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]