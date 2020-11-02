#!/bin/bash

set -exu
DUMP="dump.sql"
COMPRESSION=".gz"

MYSQL_DATABASE="playground_${CI_COMMIT_REF_SLUG}"

check_conn(){
    echo "Checking connection to ${MYSQL_DATABASE} on ${IMTEST_MYSQL_HOST}..."
#Checking connection to DB, preventing to stop setuper immediately.
    while ! mysql -u ${TEST_MYSQL_USER} -p${TEST_MYSQL_PASSWORD} -h${IMTEST_MYSQL_HOST} -P${IMTEST_MYSQL_PORT} -e ";" ; do
        echo "${MYSQL_DATABASE} is still offline or not initialized. Timeout 5s..."
        sleep 5
        echo "Rechecking ${MYSQL_DATABASE} on ${IMTEST_MYSQL_HOST}..."
    done
}

create_db(){
    echo "CREATING DATABASE ${MYSQL_DATABASE}"
    mysqladmin -u${TEST_MYSQL_USER} -p${TEST_MYSQL_PASSWORD} -h${IMTEST_MYSQL_HOST} -P${IMTEST_MYSQL_PORT} create ${MYSQL_DATABASE}
}


import_db(){
    echo "Starting to import mysql dump..."
    pv /data/playground/mysqldump/dump.sql.gz | zcat | mysql -u${TEST_MYSQL_USER} -p${TEST_MYSQL_PASSWORD} -h${IMTEST_MYSQL_HOST} -P${IMTEST_MYSQL_PORT} ${MYSQL_DATABASE}
    echo "Database imported."
}

#IMPORT_DB block
check_conn

export DB_EXIST=$(mysqlshow --user=${TEST_MYSQL_USER} --password=${TEST_MYSQL_PASSWORD} -h${IMTEST_MYSQL_HOST} -P${IMTEST_MYSQL_PORT} ${MYSQL_DATABASE} | grep -v Wildcard | grep -o ${MYSQL_DATABASE})
if [ $(mysqlshow --user=${TEST_MYSQL_USER} --password=${TEST_MYSQL_PASSWORD} -h${IMTEST_MYSQL_HOST} -P${IMTEST_MYSQL_PORT} ${MYSQL_DATABASE} | grep -v Wildcard | grep -o ${MYSQL_DATABASE}) ]; then
    echo "Database already exist, skip DB-creating."

else
    echo "Database ${MYSQL_DATABASE} does not exist."
    echo "Creating the DB..."
    create_db
    import_db
    echo "Database imported."
fi