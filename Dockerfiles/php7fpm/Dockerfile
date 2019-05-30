# docker-compose build
FROM php:7.3-fpm-alpine

ENV PHPREDIS_VERSION 4.2.0

RUN apk add --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
		libpng-dev \
        libxml2-dev \
        icu-dev \
        pcre-dev \
        git \
        zip \
        unzip \
        tzdata \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install intl \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install xml \
    && docker-php-ext-install opcache

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer