FROM php:8.2.9-fpm-alpine3.18 AS php_82

ARG PHALCON_VERSION=5.2.1

RUN apk add --no-cache libffi-dev icu-dev gettext gettext-dev
RUN apk add --no-cache $PHPIZE_DEPS git \
    && pecl install xdebug-3.3.2 \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure gettext \
    && docker-php-ext-configure sockets --enable-sockets \
    && docker-php-ext-install pcntl sockets pdo pdo_mysql mysqli gettext intl \
    && docker-php-ext-configure ffi --with-ffi \
    && docker-php-ext-install ffi
RUN apk add --no-cache \
      freetype \
      libjpeg-turbo \
      libpng \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && docker-php-ext-configure gd \
      --with-freetype=/usr/include/ \
      --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && apk del --no-cache \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && rm -rf /tmp/*

WORKDIR /usr/local/opnsense

RUN set -xe && \
        cd / && \
        docker-php-source extract && \
        curl -sSLO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz && \
        tar xzf /v${PHALCON_VERSION}.tar.gz && mv cphalcon-5.2.1/ /usr/src/php/ext && \
        docker-php-ext-install -j$(nproc) cphalcon-${PHALCON_VERSION}/build/phalcon && \
        rm -rf v${PHALCON_VERSION}.tar.gz && docker-php-source delete

COPY docker-phalcon-* /usr/local/bin/

COPY --from=composer/composer /usr/bin/composer /usr/bin/composer