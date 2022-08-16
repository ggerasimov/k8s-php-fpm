ARG PHP_VERSION=8.1

FROM php:$PHP_VERSION-fpm-alpine

RUN apk add --no-cache fcgi && \
    wget -O /usr/local/bin/php-fpm-healthcheck https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/v0.5.0/php-fpm-healthcheck && chmod +x /usr/local/bin/php-fpm-healthcheck
HEALTHCHECK --interval=5s --timeout=1s \
    CMD php-fpm-healthcheck || exit 1

RUN apk add --no-cache --virtual .build-deps ${PHPIZE_DEPS} && \
    apk add --no-cache \
    freetype-dev \
    gettext-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libpq-dev \
    libzip-dev \
    openldap-dev && \
    pecl install -o -f redis && \
    docker-php-ext-enable redis && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-freetype && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-install calendar exif gettext gd ldap mysqli pgsql pdo pdo_mysql pdo_pgsql shmop sockets && \
    apk del .build-deps \
    && rm -rf /tmp/* \
    && rm -rf /usr/src/* \
    && rm -rf /var/cache/apk/*
