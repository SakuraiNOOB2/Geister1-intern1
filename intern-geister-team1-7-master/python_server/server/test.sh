#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)

DB=test_${GEISTER_DATABASE_NAME}
# テスト用DBの初期化
mysql   -u${GEISTER_DATABASE_USER} \
        -p${GEISTER_DATABASE_PASS} \
        -h${GEISTER_DATABASE_HOST} \
        -P${GEISTER_DATABASE_PORT} \
        -e "DROP DATABASE IF EXISTS ${DB}; CREATE DATABASE ${DB};"

python3 ${SCRIPT_DIR}/test.py
