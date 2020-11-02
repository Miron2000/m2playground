#!/bin/bash
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
mycli -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${MYSQL_HOST} ${MYSQL_DATABASE}