<?php
return [
    'backend' => [
        'frontName' => 'admin'
    ],
    'crypt' => [
        'key' => "${ENC_KEY}"
    ],
    'db' => [
        'table_prefix' => '',
        'connection' => [
            'default' => [
                'host' => "${MYSQL_HOST}",
                'dbname' => "${MYSQL_DATABASE}",
                'username' => "${MYSQL_USER}",
                'password' => "${MYSQL_PASSWORD}",
                'active' => '1'
            ]
        ]
    ],
    'resource' => [
        'default_setup' => [
            'connection' => 'default'
        ]
    ],
    'x-frame-options' => 'SAMEORIGIN',
    'MAGE_MODE' => 'production',
    'cache_types' => [
        'config' => 1,
        'layout' => 1,
        'block_html' => 1,
        'collections' => 1,
        'reflection' => 1,
        'db_ddl' => 1,
        'eav' => 1,
        'customer_notification' => 1,
        'config_integration' => 1,
        'config_integration_api' => 1,
        'full_page' => 1,
        'config_webservice' => 1,
        'translate' => 1
    ],
    'install' => [
        'date' => 'Sun, 11 Nov 2018 20:55:01 +0000'
    ],
    'cache' => [
        'frontend' => [
            'default' => [
                'backend' => 'Cm_Cache_Backend_Redis',
                'backend_options' => [
                    'server' => "${REDIS_HOST}",
                    'database' => "${REDIS_CACHE_DB}",
                    'port' => '6379'
                ]
            ],
            'page_cache' => [
                'backend' => 'Cm_Cache_Backend_Redis',
                'backend_options' => [
                    'server' => "${REDIS_HOST}",
                    'port' => '6379',
                    'database' => "${REDIS_FPC_DB}",
                    'compress_data' => '0'
                ]
            ]
        ]
    ],
    'session' => [
        'save' => 'redis',
        'redis' => [
            'host' => "${REDIS_HOST}",
            'port' => '6379',
            'password' => '',
            'timeout' => '2.5',
            'persistent_identifier' => '',
            'database' => "${REDIS_SESSION_DB}",
            'compression_threshold' => '2048',
            'compression_library' => 'gzip',
            'log_level' => '1',
            'max_concurrency' => '6',
            'break_after_frontend' => '5',
            'break_after_adminhtml' => '30',
            'first_lifetime' => '600',
            'bot_first_lifetime' => '60',
            'bot_lifetime' => '7200',
            'disable_locking' => '0',
            'min_lifetime' => '60',
            'max_lifetime' => '2592000'
        ]
    ],
    'system' => [
        'default' => [
            'catalog' => [
                'search' => [
                    'engine' => 'elasticsearch7',
                    'elasticsearch7_server_hostname' => "${ELASTIC_HOST}",
                    'elasticsearch7_server_port' => "${ELASTIC_PORT}"
                ]
            ]
        ]
    ]
];