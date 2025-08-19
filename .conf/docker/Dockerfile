FROM dunglas/frankenphp:php8.4.11-alpine

# add additional extensions here:
RUN apk update && apk add \
    libpng-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \

WORKDIR /var/www/html
VOLUME /var/www/html

# Copy entrypoint script
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]