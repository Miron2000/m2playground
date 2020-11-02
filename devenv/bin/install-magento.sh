#!/bin/bash

su www-data -c "php -dmemory_limit=4096m bin/magento setup:install \
--base-url=http://localhost/ \
--db-host=db \
--db-name=magento \
--db-user=magento \
--db-password=magento \
--admin-firstname=admin \
--admin-lastname=admin \
--admin-email=admin@admin.com \
--admin-user=developer \
--admin-password=password123 \
--language=en_US \
--currency=USD \
--timezone=America/Chicago \
--use-rewrites=1 \
--search-engine=elasticsearch7 \
--elasticsearch-host=elasticsearch \
--elasticsearch-port=9200 \
--backend-frontname=admin \
--key=qazwsxedcrfvtgbyhnujmikolp123456 \
--session-save=redis \
--session-save-redis-host=redis-session \
--session-save-redis-port=6379 \
--session-save-redis-db=0 \
--cache-backend=redis \
--cache-backend-redis-server=redis-cache \
--cache-backend-redis-db=1 \
--cache-backend-redis-port=6379 \
--page-cache=redis \
--page-cache-redis-server=redis-cache \
--page-cache-redis-db=2 \
--page-cache-redis-port=6379 \
--use-sample-data"

su www-data -c "cp composer.json var/composer_home/"
su www-data -c "cp ../.composer/auth.json var/composer_home/"