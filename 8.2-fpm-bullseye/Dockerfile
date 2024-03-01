FROM php:8.2.16-fpm-bullseye

RUN set -e && \
    apt-get update && apt-get install --no-install-recommends -y \
    wget \
    rsyslog \
    ssh \
    git \
    telnet \
    unzip \
    openssl \
    # zip
    zlib1g-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    # amqp
    librabbitmq-dev \
    g++ \
    ssh

# Sockets
# https://github.com/php/php-src/issues/7986
RUN CFLAGS="$CFLAGS -D_GNU_SOURCE" docker-php-ext-install sockets

# amqp
RUN pecl install amqp-1.11.0 && docker-php-ext-enable amqp

# Intl extension
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

RUN docker-php-ext-install pdo_mysql mysqli zip bcmath soap

# -----------------------------------------------
# Composer
# -----------------------------------------------

RUN EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig) \
    ; php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    ; ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');") \
    ; [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ] && echo 'ERROR: Invalid installer signature' && exit 1 \
    ; php composer-setup.php --version=2.7.1 --quiet \
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
    && echo "zend_extension = $(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request = default" >> /usr/local/etc/php/conf.d/xdebug.ini


#REDIS
RUN pecl install igbinary && docker-php-ext-enable igbinary
RUN pecl install redis && docker-php-ext-enable redis

RUN apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/pear \
    && rm -rf /var/lib/apt/lists/*

# Labels
LABEL maintainer="jan.chudomsky@r2b2.cz"

# Workdir
WORKDIR /var/docker
