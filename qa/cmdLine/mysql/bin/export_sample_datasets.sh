#1/bin/bash
START_TIME=`date +%s`
source qa/cmdLine/bin/initialize.sh $BASH_SOURCE[0] $BASH_SOURCE[0] mysql export $YADAMU_TESTNAME
rm -rf $YADAMU_EXPORT_PATH
mkdir -p $YADAMU_EXPORT_PATH
export MODE=DATA_ONLY
export FILENAME=sakila
export SCHEMA=sakila
source $YADAMU_BIN/export.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PORT=$DB_PORT --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME --FILE=$YADAMU_EXPORT_PATH/$FILENAME.json ENCRYPTION=false FROM_USER=\"$SCHEMA\" MODE=$MODE LOG_FILE=$YADAMU_EXPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
export FILENAME=jsonExample
export SCHEMA=jtest
source $YADAMU_BIN/export.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PORT=$DB_PORT --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME --FILE=$YADAMU_EXPORT_PATH/$FILENAME.json ENCRYPTION=false FROM_USER=\"$SCHEMA\" MODE=$MODE LOG_FILE=$YADAMU_EXPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
END_TIME=`date +%s`
TOTAL_TIME=$((END_TIME-START_TIME))
ELAPSED_TIME=`date -d@$TOTAL_TIME -u +%H:%M:%S`
echo "Export ${YADAMU_DATABASE}. Elapsed time: ${ELAPSED_TIME}. Log Files written to ${YADAMU_LOG_PATH}."