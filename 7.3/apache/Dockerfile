FROM php:7.3-apache
LABEL Robert.L <mrthinlt@gmail.com>

ENV PHP_EXT_APCU_VERSION "5.1.18"
ENV PHP_EXT_MEMCACHED_VERSION "3.1.5"
ENV PHP_EXT_XDEBUG_VERSION "2.9.0"

ENV PATH /usr/local/go/bin:$PATH

RUN apt-get update && apt-get install -y vim cron git \
       libpng-dev libfreetype6-dev libjpeg62-turbo-dev libxml2-dev libxslt1-dev \
       libmemcached-dev sendmail-bin sendmail libicu-dev libzip-dev \
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
    && docker-php-ext-install opcache \
    && docker-php-ext-install sockets \
    # install go -> Mailhog: mhsendmail
    && curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf - \
    && go get github.com/mailhog/mhsendmail \
    && cp /root/go/bin/mhsendmail /usr/bin/mhsendmail \
    && apt-get clean && rm -rf /tmp/* /var/tmp/* \
    && echo "export LS_OPTIONS='--color=auto'" >> /root/.bashrc \
    && echo "alias ll='ls $LS_OPTIONS -l'" >> /root/.bashrc \
    && a2enmod rewrite headers proxy proxy_http ssl

RUN apt-get install -y zip unzip

COPY magento.zip /var/www/
COPY php.ini /usr/local/etc/php/conf.d/magento.ini
COPY magento.conf /etc/apache2/conf-enabled/
COPY entrypoint.sh /entrypoint.sh
COPY 000-default.conf /etc/apache2/sites-enabled/
COPY domain.crt /var/www/
COPY domain.key /var/www/

WORKDIR /var/www/
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
