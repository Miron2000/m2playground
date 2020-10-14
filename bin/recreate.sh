#!/bin/bash
mycli -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${MYSQL_HOST} -e "drop database ${MYSQL_DATABASE}"
mycli -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${MYSQL_HOST} -e "create database ${MYSQL_DATABASE}"
