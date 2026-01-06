ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

ARG PHP_EXTENSIONS
ENV COMPOSER_CACHE_DIR=/tmp/composer

# Installation de install-php-extensions (mlocati)
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

# Installation des extensions PHP via install-php-extensions
RUN install-php-extensions $PHP_EXTENSIONS

# Installation de Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

COPY ./php.ini /usr/local/etc/php/
COPY ./php-fpm.conf /usr/local/etc/php-fpm.d/zz-dockit.conf
WORKDIR /var/www/html