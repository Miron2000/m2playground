FROM golang:1.8 AS go_builder
ENV GOOS linux
ENV GOARCH amd64
RUN go get github.com/mailhog/mhsendmail

FROM php:7.4.11-fpm

RUN apt update && apt install \
    libpng-dev zlib1g-dev libicu-dev libfreetype6-dev \
    libxml2-dev libxslt1-dev libzip-dev libjpeg-dev \
    wget vim htop unzip mycli -yqq

RUN docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-configure hash --with-mhash

RUN docker-php-ext-install -j$(nproc) bcmath gd intl \
    pdo_mysql soap xsl zip sockets

COPY --from=go_builder /go/bin/mhsendmail /usr/local/bin/mhsendmail
RUN echo 'sendmail_path = "/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025"' >  $PHP_INI_DIR/conf.d/20-mhsendmail.ini \
    && chmod +x /usr/local/bin/mhsendmail

RUN usermod -s /bin/bash -u 1000 www-data

RUN wget -O /usr/local/bin/composer https://getcomposer.org/download/1.10.15/composer.phar && chmod +x /usr/local/bin/composer

COPY ./bin/init.sh                  /usr/local/bin/init-project
COPY ./bin/setup.sh                 /usr/local/bin/setup
COPY ./bin/install-magento.sh       /usr/local/bin/install-magento
COPY ./bin/config-provision.sh      /usr/local/bin/config-provision
COPY ./bin/entrypoint.sh            /usr/local/bin/entrypoint
COPY ./bin/recreate.sh               /usr/local/bin/recreate
COPY ./bin/db-console.sh            /usr/local/bin/db-console
COPY --chown=www-data:www-data ./etc/composer/auth.json /var/www/.composer/auth.json
RUN chmod +x /usr/local/bin/init-project /usr/local/bin/setup \
    /usr/local/bin/install-magento /usr/local/bin/config-provision \
    /usr/local/bin/entrypoint /usr/local/bin/recreate \
    /usr/local/bin/db-console

RUN echo "entrypoint" >> /root/.bashrc