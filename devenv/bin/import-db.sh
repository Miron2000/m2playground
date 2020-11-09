#!/bin/bash
pv /mysqldump/dump.sql.gz | zcat | mycli -u${MYSQL_USER} -p${MYSQL_PASSWORD} -hdb -D${MYSQL_DATABASE} --no-warn