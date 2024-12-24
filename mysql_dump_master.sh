#!/usr/bin/env bash
LOG_DIR=${LOCAL_STACK}/logs/
CUR_DATE=`date "+%Y-%m-%d";`
DUMP_FILE=irenajarocka_dump_${CUR_DATE}.sql
mysqldump --defaults-file=/home/irenajarocka/.my.cnf –u irenajarocka irenajarocka > irenajarocka.sql