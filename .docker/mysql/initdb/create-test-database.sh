#!/usr/bin/env bash
echo "--------------------------------------------------------"
echo "Create test database!"
mysql \
--user='root' \
--password=${MYSQL_ROOT_PASSWORD} \
--execute "CREATE DATABASE app_test CHARACTER SET utf8 COLLATE utf8_bin"

mysql \
--user='root' \
--password=${MYSQL_ROOT_PASSWORD} \
--execute "CREATE USER 'testUser'@'%' IDENTIFIED BY 'testPass';"


mysql \
--user='root' \
--password=${MYSQL_ROOT_PASSWORD} \
--execute "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,INDEX,REFERENCES on app_test.* TO 'testUser'@'%' IDENTIFIED BY 'testPass';"

mysql \
--user='root' \
--password=${MYSQL_ROOT_PASSWORD} \
--execute "flush privileges;"

echo "--------------------------------------------------------"

