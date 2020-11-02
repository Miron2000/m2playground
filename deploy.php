<?php
namespace Deployer;

require 'recipe/common.php';

// Project name
set('application', getenv('APP_DESTINATION'));

// Project repository
set('repository', getenv('CI_REPOSITORY_URL'));

set('writable_use_sudo', true);

set('clear_use_sudo', true);

set('default_timeout', 1200);

set('bin/php', function () {
    return '/usr/bin/php7.4';
});


// Deploy targets
inventory('deploy/hosts.yml');

// [Optional] Allocate tty for git clone. Default value is false.
set('git_tty', false);

set('deploy_path',"/var/www/{{application}}");

// Writable dirs by web server
set('allow_anonymous_stats', false);

// Shared files/dirs between deploys
set('shared_files', [
    'var/.maintenance.ip',
]);
set('shared_dirs', [
    'var/composer_home',
    'var/log',
    'var/cache',
    'var/export',
    'var/report',
    'var/import_history',
    'var/session',
    'var/importexport',
    'var/import',
    'var/backups',
    'var/tmp',
    'pub/sitemaps',
    'pub/media',
    'feeds'
]);

set('writable_dirs', [
    'var',
//    'pub/static',
    'generated'
]);
// TODO: Not sure we need to clear generated, as far as we are not linking it and every release starts from the empty dir
set('clear_paths', [
    'generated/*',
    'var/generation/*',
    'var/cache/*',
    'var/page_cache/*',
    'var/view_preprocessed/*',
]);

//Tasks
desc('Warm up');
task('deploy:magento:warm_up', function () {
    run('cd {{release_path}} && /usr/bin/php7.4 /usr/local/bin/composer config http-basic.repo.magento.com ${MAGENTO_COMPOSER_USER} ${MAGENTO_COMPOSER_PASS}');
});

desc('Compile magento di');
task('magento:compile', function () {
    run("{{bin/php}} {{release_path}}/bin/magento setup:di:compile");
});

desc('Deploy assets');
task('magento:deploy:assets', function () {
    run("sudo mkdir {{release_path}}/pub/static/_cache");
    $stage = "";
    if (input()->hasArgument('stage')) {
        $stage = strtoupper(input()->getArgument('stage'));
    }
    if ($stage == "PRODUCTION") {
        run("sudo chown -R www-data:www-data {{release_path}}/pub/static/_cache && sudo chmod -R 775 {{release_path}}/pub/static/_cache");
    }
    elseif ($stage == "TEST") {
        run("sudo chown -R www-data:www-data {{release_path}}/pub/static/_cache && sudo chmod -R 775 {{release_path}}/pub/static/_cache");
    }
    run("{{bin/php}} {{release_path}}/bin/magento c:f");
    run("{{bin/php}} {{release_path}}/bin/magento cache:clean");
    run("sudo service php7.4-fpm restart");
    run("{{bin/php}} {{release_path}}/bin/magento setup:static-content:deploy -j $(nproc)");
});


task('magento:client-cache:flush', function () {
    $newContentVersion = time();
    run("{{bin/php}} {{release_path}}/bin/magento setup:static-content:deploy --content-version ${newContentVersion} --refresh-content-version-only");
});

desc('Enable maintenance mode');
task('magento:maintenance:enable', function () {
    run("if [ -d $(echo {{deploy_path}}/current) ]; then {{bin/php}} {{deploy_path}}/current/bin/magento maintenance:enable; else echo Folder is not found.; fi");
    run("touch {{deploy_path}}/current/maintenance.enable || echo File not found but OK.");
});

desc('Disable maintenance mode');
task('magento:maintenance:disable', function () {
    run("if [ -d $(echo {{deploy_path}}/current) ]; then {{bin/php}} {{deploy_path}}/current/bin/magento maintenance:disable; fi");
    run("rm {{deploy_path}}/current/maintenance.enable || echo File not found but OK.");
});

desc('Upgrade magento database');
task('magento:upgrade:db', function () {
    run("{{bin/php}} {{release_path}}/bin/magento setup:upgrade --keep-generated");
});

desc('Flush Magento Cache');
task('magento:cache:flush', function () {
    run("{{bin/php}} {{release_path}}/bin/magento cache:flush");
    run("sudo service php7.4-fpm restart");
});

desc('Check Magento variables');
task('magento:check:vars', function () {
    $stage = "";
    $varlist = array();
    foreach(['MYSQL_HOST','MYSQL_DATABASE','MYSQL_USER','MYSQL_PASSWORD',
    'ENC_KEY', 'APP_DESTINATION',
    'MAGENTO_COMPOSER_USER', 'MAGENTO_COMPOSER_PASS'] as $base_var_name )
    {
        if ( getenv($base_var_name) == "" ) {
                $varlist[] = $base_var_name;
        }
    }
if (empty($varlist) != true) {
        echo("GitLab has not provided the required variables:");
        print_r($varlist);
        exit(1);
}
});

//Tasks

desc('Magento import database');
task('magento:import-db', function () {
    $stage = "";
    if (input()->hasArgument('stage')) {
        $stage = strtoupper(input()->getArgument('stage'));
    }
    if ($stage == "TEST") {
        run('cd {{release_path}} && bash deploy/test/bin/import-db.sh');
    }
});

desc('Symlink media');
task('magento:symlink:media', function(){
    $stage = "";
    if (input()->hasArgument('stage')) {
        $stage = strtoupper(input()->getArgument('stage'));
    }
    if ($stage == "TEST") {
        run('rm -rf {{release_path}}pub/media && ln -sfT /data/playground/media {{release_path}}/pub/media');
        run('chown magento:www-data {{release_path}}/pub/media');
    }
});


desc('Chown && restart');
task('magento:chown:restart', function(){
    run("sudo chown -R magento:www-data /var/www/{{application}}/releases/");
    run("sudo service php7.4-fpm restart");
});

desc('Chown && restart2');
task('magento:chown:restart2', function(){
    run("sudo chown -R magento:www-data /var/www/{{application}}/releases/");
    run("sudo chown -R www-data:www-data {{release_path}}/pub/static/_cache && sudo chmod -R 775 {{release_path}}/pub/static/_cache");
    run("sudo service php7.4-fpm restart");
});



desc('Config-provision');
task('magento:config-provision', function(){
    $stage = "";
    if (input()->hasArgument('stage')) {
        $stage = strtoupper(input()->getArgument('stage'));
    }
    if ($stage == "TEST") {
        run('cd {{release_path}} && bash deploy/test/bin/config-provision.sh');
    }
});


desc('Magento2 deployment operations');
task('deploy:magento', [
    'magento:import-db',
    'magento:maintenance:enable',
    'deploy:clear_paths',
    'magento:cache:flush',
    'magento:chown:restart',
    'magento:symlink:media',
    'magento:compile',
    'magento:deploy:assets',
#    'magento:client-cache:flush',
    'magento:config-provision',
    'magento:upgrade:db',
    'magento:cache:flush',
    'magento:chown:restart2',
    'magento:maintenance:disable'
]);

desc('Build your project');
task('build', static function () {
    run(' /usr/bin/php7.4 /usr/local/bin/composer config http-basic.repo.magento.com ${MAGENTO_COMPOSER_USER} ${MAGENTO_COMPOSER_PASS}');
    run(' /usr/bin/php7.4 /usr/local/bin/composer install --ignore-platform-reqs');
    run(' chmod 640 auth.json');
    invoke('magento:check:vars');
})->local();

desc('Create a deploy folder');
task('deploy:mkdir', function () {
        run('sudo mkdir -p {{deploy_path}} || echo ok');
        run('sudo chown magento:www-data {{deploy_path}}');
    }
);


task('upload', static function () {
    upload(__DIR__ . '/', '{{release_path}}');
});


task('release', [
    'deploy:info',
    'deploy:mkdir',
    'deploy:prepare',
    'deploy:lock',
    'deploy:release',
    'upload',
    'deploy:shared',
    'deploy:writable',
    'deploy:magento',
    'deploy:symlink',
    'magento:cache:flush',
    'deploy:unlock'
]);

task('deploy', [
    'build',
    'release',
    'cleanup',
    'success'
]);

task('backup', [
    'magento:check:vars',
    'backup:database'
]);


after('deploy:failed', 'magento:maintenance:disable');
after('deploy:failed', 'deploy:unlock');