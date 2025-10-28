#!/usr/bin/env bash
LOG_DIR=${LOCAL_STACK}/logs/
CUR_DATE=`date "+%Y-%m-%d";`
DUMP_FILE=$1
CREDENTIALS=/home/irenajarocka/.my.cnf
mysqldump --defaults-file= –u irenajarocka irenajarocka > $1
