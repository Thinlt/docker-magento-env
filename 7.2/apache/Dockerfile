FROM php:7.2-apache
MAINTAINER Tomas Gerulaitis <tomas.gerulaitis@meanbee.com>

ENV PHP_EXT_APCU_VERSION "5.1.12"
ENV PHP_EXT_MEMCACHED_VERSION "3.0.4"
ENV PHP_EXT_XDEBUG_VERSION "2.6.1"


RUN build_packages="vim cron libpng-dev libfreetype6-dev libjpeg62-turbo-dev libxml2-dev libxslt1-dev libmemcached-dev sendmail-bin sendmail libicu-dev" \
    && apt-get update && apt-get install -y $build_packages \
    && yes "" | pecl install apcu-$PHP_EXT_APCU_VERSION && docker-php-ext-enable apcu \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring \
    && echo "no" | pecl install memcached-$PHP_EXT_MEMCACHED_VERSION && docker-php-ext-enable memcached \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install soap \
    && yes | pecl install xdebug-$PHP_EXT_XDEBUG_VERSION && docker-php-ext-enable xdebug \
    && docker-php-ext-install xsl \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install bcmath \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "export LS_OPTIONS='--color=auto'" >> /root/.bashrc \
    && echo "alias ll='ls $LS_OPTIONS -l'" >> /root/.bashrc

COPY php.ini /usr/local/etc/php/conf.d/magento.ini

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN a2enmod rewrite headers proxy proxy_http

COPY magento.conf /etc/apache2/conf-enabled/

CMD ["apache2-foreground"]
