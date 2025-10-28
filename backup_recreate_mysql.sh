#!/usr/bin/env bash
LOG_DIR=${LOCAL_STACK}/logs/
CUR_DATE=`date "+%Y-%m-%d";`
#DUMP_FILE=backup/irenajarocka_dump_${CUR_DATE}.sql
#./mysql_dump_master.sh ${DUMP_FILE}
source .credentials
NEW_SQL_FILE=data/mysql57.sql
./mysql_recreate_db.sh -d ${SQLDB} -u ${SQLUSER} -p ${SQLPASS} -f ${NEW_SQL_FILE}
#gzip ${DUMP_FILE}