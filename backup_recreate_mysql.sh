#!/usr/bin/env bash
# Resolve local directory of the script
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
################################################
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

LOG_DIR=${DIR}/logs/
CUR_DATE=`date "+%Y-%m-%d";`
cd ${DIR}
./run > ${LOG_DIR}/recreate_${CUR_DATE}.log 2>&1
echo "Imported from Home" >> ${LOG_DIR}/recreate_${CUR_DATE}.log
#DUMP_FILE=backup/irenajarocka_dump_${CUR_DATE}.sql
#./mysql_dump_master.sh ${DUMP_FILE}
source ${DIR}/.credentials
NEW_SQL_FILE=${DIR}/dump/mysql57.sql
#cd ${DIR}
./mysql_recreate_db.sh -d ${SQLDB} -u ${SQLUSER} -p ${SQLPASS} -f ${NEW_SQL_FILE} >> ${LOG_DIR}/recreate_${CUR_DATE}.log 2>&1
cd mysql_backups/
gzip *.sql
