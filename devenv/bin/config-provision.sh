#!/bin/bash
su www-data -c "bin/magento config:set dev/static/sign 0"
su www-data -c "bin/magento module:disable Magento_TwoFactorAuth"
su www-data -c "bin/magento c:f"