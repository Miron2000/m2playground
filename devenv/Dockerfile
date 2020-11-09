FROM golang:1.8 AS go_builder
ENV GOOS linux
ENV GOARCH amd64
RUN go get github.com/mailhog/mhsendmail

FROM php:7.4.11-fpm

RUN apt update && apt install \
    libpng-dev zlib1g-dev libicu-dev libfreetype6-dev \
    libxml2-dev libxslt1-dev libzip-dev libjpeg-dev \
    wget vim htop unzip mycli pv -yqq

RUN docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-configure hash --with-mhash

RUN docker-php-ext-install -j$(nproc) bcmath gd intl \
    pdo_mysql soap xsl zip sockets

COPY --from=go_builder /go/bin/mhsendmail /usr/local/bin/mhsendmail
RUN echo 'sendmail_path = "/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025"' >  $PHP_INI_DIR/conf.d/20-mhsendmail.ini \
    && chmod +x /usr/local/bin/mhsendmail

RUN usermod -s /bin/bash -u 1000 www-data

RUN wget -O /usr/local/bin/composer https://getcomposer.org/download/1.10.15/composer.phar && chmod +x /usr/local/bin/composer

COPY ./bin/config-provision.sh      /usr/local/bin/config-provision
COPY ./bin/entrypoint.sh            /usr/local/bin/entrypoint
COPY ./bin/db-console.sh            /usr/local/bin/db-console
COPY ./bin/import-db.sh             /usr/local/bin/import-db
COPY --chown=www-data:www-data ./etc/composer/auth.json /var/www/.composer/auth.json
RUN chmod +x /usr/local/bin/config-provision \
    /usr/local/bin/entrypoint /usr/local/bin/import-db \
    /usr/local/bin/db-console

RUN echo "entrypoint" >> /root/.bashrc