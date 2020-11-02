#!/bin/bash
start(){
        echo -e  "Welcome to entrypoint \e[32mv0.0.x\e[0m
                ###############################
                You can always get a fresh version of devenv with:\n\
                \e[33mgit pull origin master\n\
                docker-compose up -d --build\e[0m\n\
                ###############################\n\
                After installation, your website will be accessible at:\n\
                http://localhost/\n\
                Mailhog:\n\
                http://localhost:8025/\n\
                You want to:\n\
                1. Install Magento 2.4 full auto. Approximately 1 hour. (Press 1 or Enter)\n\
                YOUR PROJECT WILL BE DESTROYED!\n\
                2. Init Magento 2.4 (Step I).\n\
                3. Magento setup:install (Step II).\n\
                4. Magento setup:upgrade (Step III).\n\
                5. Config-provision (Step IV).\n\
                6. Enter developer-mode (User www-data will be used).\n\
                7. Enter r00t-mode. (Press 7 or Ctrl+C).\n\
                8. DB-console.\n\
                9. RECREATE DATABASE.\n"
        read yn
        case $yn in
                ""|'1')
                        init-project
                        install-magento
                        setup
                        config-provision
                        return 0;;
                '2')    
                        init-project
                        return 0;;
                '3')
                        install-magento
                        return 0;;
                '4')    
                        setup
                        return 0;;
                '5')    
                        config-provision
                        return 0;;
                '6')
                        su www-data
                        return 0;;
                '7')
                        exit 0
                        return 0;;
                '8')    
                        db-console
                        return 0;;
                '9')    
                        recreate
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
