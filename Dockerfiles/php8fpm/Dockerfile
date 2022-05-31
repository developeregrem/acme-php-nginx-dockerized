# docker-compose build
FROM php:8.1-fpm-alpine

ENV PHPREDIS_VERSION 5.3.7

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts 
    
RUN apk add --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
		libpng-dev \
        libxml2-dev \
        icu-dev \
        pcre-dev \
        autoconf \
        git \
        zip \
        unzip \
        tzdata \
        openldap-dev \
        curl-dev \
        curl \
	&& docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install intl pdo_mysql xml opcache ldap mysqli redis curl

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer