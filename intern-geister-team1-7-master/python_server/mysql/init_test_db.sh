#!/bin/bash

# mysql用のコンテナ起動時に、test用のデータベースを作成するためのスクリプト

DB_NAME=test_${MYSQL_DATABASE}
echo "CREATE DATABASE IF NOT EXISTS ${DB_NAME} ;" | "${mysql[@]}"
echo "GRANT ALL ON ${DB_NAME}.* TO '"$MYSQL_USER"'@'%' ;" | "${mysql[@]}"
echo 'FLUSH PRIVILEGES ;' | "${mysql[@]}"
