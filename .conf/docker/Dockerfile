FROM dunglas/frankenphp:php8.4.11-alpine

# add additional extensions here:
RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
        freetype-dev \
        libpng-dev \
        jpeg-dev \
        zip \
        libzip-dev \
        libjpeg-turbo-dev \
        imagemagick \
        imagemagick-dev \
        autoconf \
        g++ \
        make \
        libtool \
        pcre-dev \
        linux-headers

RUN docker-php-ext-install \
		exif \
		opcache \
        mysqli pdo pdo_mysql \
		zip

RUN pecl install imagick xdebug

RUN docker-php-ext-enable imagick mysqli xdebug

WORKDIR /var/www/html
VOLUME /var/www/html

# Copy entrypoint script
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]