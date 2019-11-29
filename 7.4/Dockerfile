# -------------------------------------------------------------
# Cause of changes, this file is NOT generated anymore
# -------------------------------------------------------------

FROM php:7.4.0-fpm

RUN set -e && \
	apt-get update && apt-get install --no-install-recommends -y \
		wget \
		rsyslog \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        ssh \
        git \
        telnet \
        unzip \
        openssl \
        zlib1g-dev \
        libicu-dev \
        libxml2-dev \
        g++ \
        ssh


# Soap
RUN docker-php-ext-install soap && docker-php-ext-enable soap

# Sockets
RUN docker-php-ext-install sockets

# Intl extension
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

RUN set -e && \
	apt-get update && apt-get install --no-install-recommends -y \
        libzip-dev

RUN docker-php-ext-install pdo pdo_mysql mysqli zip bcmath

# -----------------------------------------------
# Composer
# -----------------------------------------------

RUN EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig) \
    ; php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    ; ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');") \
    ; [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ] && echo 'ERROR: Invalid installer signature' && exit 1 \
	; php composer-setup.php --quiet \
	; mv composer.phar /usr/local/bin/composer \
	; chmod +x /usr/local/bin/composer \
	; RESULT=$? \
	; rm composer-setup.php \
	; exit $RESULT

# -----------------------------------------------
# XDebug
# -----------------------------------------------

RUN echo "Install xDebug ..." \
    && yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini


#REDIS
RUN pecl install igbinary && docker-php-ext-enable igbinary

# Compile Redis 3.0.0 extension
# 4.0.0 needs updated Kdyby/Redis
RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/3.0.0.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-configure redis --enable-redis-igbinary \
    && docker-php-ext-install redis

# Labels
LABEL maintainer="arziel12@gmail.com"
LABEL maintainer_padavan="honza.chudomsky@webgarden.cz"
#	config.php=$PHP_VERSION

# Workdir
WORKDIR /var/docker
