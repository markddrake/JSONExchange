source qa/cmdLine/bin/initialize.sh $BASH_SOURCE[0] $BASH_SOURCE[0] mssql upload $YADAMU_TESTNAME
export YADAMU_PARSER="SQL"
export SCHEMA_VERSION=1
mysql -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @ID=$SCHEMA_VERSION; set @METHOD='$YADAMU_PARSER';" <$YADAMU_SQL_PATH/RECREATE_MSSQL_ALL.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
source $YADAMU_SCRIPT_PATH/upload_operations_MsSQL.sh $YADAMU_IMPORT_MSSQL $SCHEMA_VERSION ""
source $YADAMU_SCRIPT_PATH/export_operations_MsSQL.sh $YADAMU_OUTPUT_PATH $SCHEMA_VERSION $SCHEMA_VERSION
export PRIOR_VERSION=$SCHEMA_VERSION
let "SCHEMA_VERSION+=1"
mysql -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @ID=$SCHEMA_VERSION; set @METHOD='$YADAMU_PARSER';" <$YADAMU_SQL_PATH/RECREATE_MSSQL_ALL.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
source $YADAMU_SCRIPT_PATH/upload_operations_MsSQL.sh $YADAMU_OUTPUT_PATH $SCHEMA_VERSION $PRIOR_VERSION
mysql -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @ID1=$PRIOR_VERSION; set @ID2=$SCHEMA_VERSION; set @METHOD='$YADAMU_PARSER'" --table <$YADAMU_SQL_PATH/COMPARE_MSSQL_ALL.sql >>$YADAMU_LOG_PATH/COMPARE_SCHEMA.log
source $YADAMU_SCRIPT_PATH/export_operations_MsSQL.sh $YADAMU_OUTPUT_PATH $SCHEMA_VERSION $SCHEMA_VERSION
export SCHEMA=ADVWRK
export SCHEMA_VERSION=1
export FILENAME=AdventureWorksALL
mysql -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT  -v -f --init-command="set @SCHEMA='$SCHEMA$SCHEMA_VERSION'; set @METHOD='$YADAMU_PARSER'" <$YADAMU_SQL_PATH/RECREATE_SCHEMA.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
source $YADAMU_BIN/upload.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PORT=$DB_PORT --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME FILE=$YADAMU_IMPORT_MSSQL/$FILENAME.json TO_USER=\"$SCHEMA$SCHEMA_VERSION\" MODE=$MODE  LOG_FILE=$YADAMU_IMPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
mysql -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @SCHEMA='$SCHEMA'; set @ID1=''; set @ID2=$SCHEMA_VERSION; set @METHOD='$YADAMU_PARSER'" --table  <$YADAMU_SQL_PATH/COMPARE_SCHEMA.sql >>$YADAMU_LOG_PATH/COMPARE_SCHEMA.log
source $YADAMU_BIN/export.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PORT=$DB_PORT --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME FILE=$YADAMU_OUTPUT_PATH/$FILENAME$SCHEMA_VERSION.json owner=\"$SCHEMA$SCHEMA_VERSION\" MODE=$MODE LOG_FILE=$YADAMU_EXPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
export PRIOR_VERSION=$SCHEMA_VERSION
let "SCHEMA_VERSION+=1"
mysql -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT  -v -f --init-command="set @SCHEMA='$SCHEMA$SCHEMA_VERSION'; set @METHOD='$YADAMU_PARSER'" <$YADAMU_SQL_PATH/RECREATE_SCHEMA.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
source $YADAMU_BIN/upload.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PORT=$DB_PORT --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME FILE=$YADAMU_OUTPUT_PATH/$FILENAME$PRIOR_VERSION.json TO_USER=\"$SCHEMA$SCHEMA_VERSION\" MODE=$MODE LOG_FILE=$YADAMU_IMPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
mysql -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @SCHEMA='$SCHEMA'; set @ID1=$PRIOR_VERSION; set @ID2=$SCHEMA_VERSION; set @METHOD='$YADAMU_PARSER'" --table  <$YADAMU_SQL_PATH/COMPARE_SCHEMA.sql >>$YADAMU_LOG_PATH/COMPARE_SCHEMA.log
source $YADAMU_BIN/export.sh --RDBMS=$YADAMU_VENDOR --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PORT=$DB_PORT --PASSWORD=$DB_PWD --DATABASE=$DB_DBNAME FILE=$YADAMU_OUTPUT_PATH/$FILENAME$SCHEMA_VERSION.json owner=\"$SCHEMA$SCHEMA_VERSION\" MODE=$MODE LOG_FILE=$YADAMU_EXPORT_LOG  EXCEPTION_FOLDER=$YADAMU_LOG_PATH
node $YADAMU_QA_JSPATH/compareFileSizes $YADAMU_LOG_PATH $YADAMU_IMPORT_MSSQL $YADAMU_OUTPUT_PATH
node --max_old_space_size=4096 $YADAMU_QA_JSPATH/compareArrayContent $YADAMU_LOG_PATH $YADAMU_IMPORT_MSSQL $YADAMU_OUTPUT_PATH false