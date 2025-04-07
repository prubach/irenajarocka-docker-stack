#!/usr/bin/env bash
LOCAL_DIR=/Users/pol/irenajarocka.pl/
LOCAL_STACK=/Users/pol/irenajarocka-docker-stack
LOG_DIR=${LOCAL_STACK}/logs/
CUR_DATE=`date "+%Y-%m-%d";`
LOG_FILE=${LOG_DIR}/rsync_${CUR_DATE}.log
/usr/local/bin/rsync -chavzP --iconv=utf-8-mac,cp1250 -e "/usr/bin/ssh -p 22222" irenajarocka@irenajarocka.pl:/home/irenajarocka/public_html/ ${LOCAL_DIR} > ${LOG_FILE}
#rsync -chavzP -e "/usr/bin/ssh -p 22222" irenajarocka@irenajarocka.pl:/home/irenajarocka/public_html ${LOCAL_DIR} > ${LOG_FILE}
#--iconv=utf-8-mac,utf-8
# copy local config
cp -f ${LOCAL_STACK}/secrets/config.php ${LOCAL_DIR}/public_html/lib/
#cp -f ${LOCAL_STACK}/secrets/config.php ${LOCAL_DIR}/lib/
