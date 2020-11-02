#!/bin/bash
su www-data -c "php -dmemory_limit=4096m bin/magento sampledata:deploy"
su www-data -c "php -dmemory_limit=4096m bin/magento set:up"
su www-data -c "php -dmemory_limit=4096m bin/magento in:rei"