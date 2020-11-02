#!/bin/bash
bin/magento app:config:import
bin/magento config:set web/unsecure/base_url "https://${SUBDOMAIN}.playground.n2.mavendev.com/"
bin/magento config:set web/secure/base_url "https://${SUBDOMAIN}.playground.n2.mavendev.com/"
bin/magento config:set web/unsecure/base_static_url "{{unsecure_base_url}}static/"
bin/magento config:set web/unsecure/base_media_url "{{unsecure_base_url}}media/"
bin/magento config:set web/secure/base_static_url "{{secure_base_url}}static/"
bin/magento config:set web/secure/base_media_url "{{secure_base_url}}media/"
bin/magento config:set web/cookie/cookie_domain ""
bin/magento config:set web/cookie/cookie_path ""
bin/magento config:set web/url/use_store "1"
bin/magento config:set admin/url/custom "https://${SUBDOMAIN}.playground.n2.mavendev.com/"


bin/magento a:u:cre --admin-user developer --admin-email developer@mavenecommerce.com --admin-password password123 --admin-firstname Cool --admin-lastname Dev


if [ -f /etc/nginx/sites-enabled/playground-${SUBDOMAIN}.conf ] 
    then
        sudo certbot renew -n
    else
        sudo cp deploy/test/etc/nginx/upstream_php74.conf /etc/nginx/conf.d/upstream_php74.conf
        sudo cp deploy/test/etc/nginx/nginx.conf /etc/nginx/sites-available/playground-${SUBDOMAIN}.conf
        sudo cp deploy/test/etc/nginx/maintenance.conf /etc/nginx/playground_maintenance.conf
        sudo ln -s /etc/nginx/sites-available/playground-${SUBDOMAIN}.conf /etc/nginx/sites-enabled/
        sudo certbot run --nginx -n -d ${SUBDOMAIN}.playground.n2.mavendev.com
        sudo certbot enhance -n -d ${SUBDOMAIN}.playground.n2.mavendev.com --redirect --nginx --cert-name ${SUBDOMAIN}.playground.n2.mavendev.com
fi