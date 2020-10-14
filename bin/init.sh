#!/bin/bash
chown -R www-data:www-data /var/www
rm -rfv /var/www/html/*
rm -rfv /var/www/html/.*
rm -v /var/www/html/.*
su www-data -c "php -dmemory_limit=4096m /usr/local/bin/composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition . 2.4"