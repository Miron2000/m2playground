#!/bin/bash
composer_install(){
        chown -R www-data:www-data /var/www && chmod 755 /var/www
        su www-data -c "php -dmemory_limit=4096m /usr/local/bin/composer config http-basic.repo.magento.com 91e5f164731b9efc8abf0dbb409e3e87 526f67ce8954603fcbddea87951acdb1"
        su www-data -c "php -dmemory_limit=4096m /usr/local/bin/composer install"
}

env_php(){
        su www-data -c "cp devenv/etc/magento/env.tpl.php app/etc/env.php"
}

sampledata_deploy(){
        su www-data -c "php -dmemory_limit=4096m bin/magento sampledata:deploy"
}

setup_upgrade(){
        su www-data -c "php -dmemory_limit=4096m bin/magento set:up"
}

reindex(){
        su www-data -c "php -dmemory_limit=4096m bin/magento in:res"
        su www-data -c "php -dmemory_limit=4096m bin/magento in:rei"
        su www-data -c "php -dmemory_limit=4096 bin/magento c:f"
}


start(){
        echo -e  "Welcome to entrypoint \e[32mv0.0.x\e[0m
                ###############################
                You can always get a fresh version of devenv with:\n\
                \e[33mgit pull origin develop\n\
                docker-compose up -d --build\e[0m\n\
                ###############################\n\
                After installation, your website will be accessible at:\n\
                http://localhost/\n\
                Mailhog:\n\
                http://localhost:8025/\n\
                You want to:\n\
                1.  Install Magento 2.4 full auto. Approximately 10 minutes. (Press 1 or Enter)\n\
                2.  Composer install (Step I).\n\
                3.  Add env.php (Step II).\n\
                4.  Import database (Step III).\n\
                5.  Deploy sample-data (Step IV).\n\
                6.  Magento setup:upgrade (Step V).\n\
                7.  Reindex (Step VI).\n\
                8.  Config-provision (Step VII).\n\
                Other options:\n\
                9.  Enter developer-mode (User www-data will be used).\n\
                10.  Enter r00t-mode. (Press 7 or Ctrl+C).\n\
                11. DB-console.\n"
        read yn
        case $yn in
                ""|'1')
                        composer_install
                        import-db
                        env_php
                        sampledata_deploy
                        setup_upgrade
                        reindex
                        config-provision
                        return 0;;
                '2')    
                        composer_install
                        return 0;;
                '3')    env_php
                        return 0;;
                '4')    
                        import-db
                        return 0;;
                '5')
                        sampledata_deploy
                        return 0;;
                '6')    
                        setup_upgrade
                        return 0;;
                '7')    
                        reindex
                        return 0;;
                '8')    
                        config-provision
                        return 0;;
                '9')
                        su www-data
                        return 0;;
                '10')
                        exit 0
                        return 0;;
                '11')    
                        db-console
                        return 0;;
                *)
                echo "Sorry, not recognized."
                        return 1;;
        esac

}

i=1

     while [ $i == 1 ]; do
                start $i
        done