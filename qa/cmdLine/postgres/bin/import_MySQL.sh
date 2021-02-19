source qa/cmdLine/bin/initialize.sh $BASH_SOURCE[0] $BASH_SOURCE[0] mysql import $YADAMU_TESTNAME
export YADAMU_PARSER="CLARINET"
export FILENAME=sakila
export SCHEMA=sakila
export SCHEMA_VERSION=1
psql -U $DB_USER -d $DB_DBNAME -h $DB_HOST -a -vSCHEMA=$SCHEMA -vID=$SCHEMA_VERSION -vMETHOD=$YADAMU_PARSER -f $YADAMU_SQL_PATH/RECREATE_SCHEMA.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
source $YADAMU_BIN/import.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME FILE=$YADAMU_IMPORT_MYSQL/$FILENAME.json TO_USER=\"$SCHEMA$SCHEMA_VERSION\" LOG_FILE=$YADAMU_IMPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
source $YADAMU_BIN/export.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME FILE=$YADAMU_OUTPUT_PATH/$FILENAME$SCHEMA_VERSION.json owner=\"$SCHEMA$SCHEMA_VERSION\" MODE=$MODE LOG_FILE=$YADAMU_EXPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
export PRIOR_VERSION=$SCHEMA_VERSION
let "SCHEMA_VERSION+=1"
psql -U $DB_USER -d $DB_DBNAME -h $DB_HOST -a -vSCHEMA=$SCHEMA -vID=$SCHEMA_VERSION -vMETHOD='JSON_TABLE' -f $YADAMU_SQL_PATH/RECREATE_SCHEMA.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
source $YADAMU_BIN/import.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME FILE=$YADAMU_OUTPUT_PATH/$FILENAME$PRIOR_VERSION.json TO_USER=\"$SCHEMA$SCHEMA_VERSION\" LOG_FILE=$YADAMU_IMPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
psql -U $DB_USER -d $DB_DBNAME -h $DB_HOST -q -vSCHEMA=$SCHEMA -vID1=$PRIOR_VERSION -vID2=$SCHEMA_VERSION -vMETHOD=$YADAMU_PARSER -f $YADAMU_SQL_PATH/COMPARE_SCHEMA.sql >>$YADAMU_LOG_PATH/COMPARE_SCHEMA.log
source $YADAMU_BIN/export.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME FILE=$YADAMU_OUTPUT_PATH/$FILENAME$SCHEMA_VERSION.json owner=\"$SCHEMA$SCHEMA_VERSION\" MODE=$MODE LOG_FILE=$YADAMU_EXPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
export FILENAME=jsonExample
export SCHEMA=jtest
export SCHEMA_VERSION=1
psql -U $DB_USER -d $DB_DBNAME -h $DB_HOST -a -vSCHEMA=$SCHEMA -vID=$SCHEMA_VERSION -vMETHOD=$YADAMU_PARSER -f $YADAMU_SQL_PATH/RECREATE_SCHEMA.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
source $YADAMU_BIN/import.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME FILE=$YADAMU_IMPORT_MYSQL/$FILENAME.json TO_USER=\"$SCHEMA$SCHEMA_VERSION\" LOG_FILE=$YADAMU_IMPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
source $YADAMU_BIN/export.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME FILE=$YADAMU_OUTPUT_PATH/$FILENAME$SCHEMA_VERSION.json owner=\"$SCHEMA$SCHEMA_VERSION\" MODE=$MODE LOG_FILE=$YADAMU_EXPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
export PRIOR_VERSION=$SCHEMA_VERSION
let "SCHEMA_VERSION+=1"
psql -U $DB_USER -d $DB_DBNAME -h $DB_HOST -a -vSCHEMA=$SCHEMA -vID=$SCHEMA_VERSION -vMETHOD='JSON_TABLE' -f $YADAMU_SQL_PATH/RECREATE_SCHEMA.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
source $YADAMU_BIN/import.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME FILE=$YADAMU_OUTPUT_PATH/$FILENAME$PRIOR_VERSION.json TO_USER=\"$SCHEMA$SCHEMA_VERSION\" LOG_FILE=$YADAMU_IMPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
psql -U $DB_USER -d $DB_DBNAME -h $DB_HOST -q -vSCHEMA=$SCHEMA -vID1=$PRIOR_VERSION -vID2=$SCHEMA_VERSION -vMETHOD=$YADAMU_PARSER -f $YADAMU_SQL_PATH/COMPARE_SCHEMA.sql >>$YADAMU_LOG_PATH/COMPARE_SCHEMA.log
source $YADAMU_BIN/export.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME FILE=$YADAMU_OUTPUT_PATH/$FILENAME$SCHEMA_VERSION.json owner=\"$SCHEMA$SCHEMA_VERSION\" MODE=$MODE LOG_FILE=$YADAMU_EXPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
node $YADAMU_QA_JSPATH/compareFileSizes $YADAMU_LOG_PATH $YADAMU_EXPORT_PATH $YADAMU_OUTPUT_PATH
node $YADAMU_QA_JSPATH/compareArrayContent $YADAMU_LOG_PATH $YADAMU_EXPORT_PATH $YADAMU_OUTPUT_PATH false