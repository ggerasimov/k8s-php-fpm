ARG PHP_VERSION=8.1

FROM php:$PHP_VERSION-fpm-alpine

RUN apk add --no-cache fcgi && \
    wget -O /usr/local/bin/php-fpm-healthcheck https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/v0.5.0/php-fpm-healthcheck && chmod +x /usr/local/bin/php-fpm-healthcheck
HEALTHCHECK --interval=5s --timeout=1s \
    CMD php-fpm-healthcheck || exit 1
