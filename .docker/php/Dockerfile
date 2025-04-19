FROM php:${PHP_VERSION}-fpm

ARG PHP_EXTENSIONS
ENV COMPOSER_CACHE_DIR=/tmp/composer

RUN apt-get update && apt-get install -y --no-install-recommends \
    git unzip zip curl libicu-dev libxml2-dev libzip-dev libonig-dev \
    libpq-dev libjpeg-dev libpng-dev libwebp-dev libfreetype6-dev \
    libmagickwand-dev libxpm-dev libvpx-dev libssl-dev libxslt1-dev \
    libmcrypt-dev libreadline-dev libbz2-dev \
    gnupg2 ca-certificates \
    && docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype \
    && docker-php-ext-install $PHP_EXTENSIONS \
    && pecl install blackfire \
    && apt-get purge -y --auto-remove \
    && rm -rf /var/lib/apt/lists/*

# Script pour activer les extensions PHP
COPY ./scripts/enable-php-extensions.sh /usr/local/bin/enable-php-extensions
RUN chmod +x /usr/local/bin/enable-php-extensions

# Désactiver blackfire par défaut
RUN rm -f /usr/local/etc/php/conf.d/*blackfire.ini || true

COPY ./php.ini /usr/local/etc/php/
COPY ./php-fpm.conf /usr/local/etc/php-fpm.d/zz-dockit.conf
WORKDIR /var/www/html