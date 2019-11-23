INITLOGGING()
export SCHVER=1
. $YADAMU_TEST_HOME/oracle19c/env/dbConnection.sh
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_HOME/oracle/sql/COMPILE_ALL.sql $YADAMU_LOG_PATH
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_MSSQL_ALL.sql $YADAMU_LOG_PATH 1 Clarinet
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_ORACLE_ALL.sql $YADAMU_LOG_PATH 1 Clarinet DDL_AND_DATA
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_SCHEMA.sql $YADAMU_LOG_PATH jtest1 Clarinet
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_SCHEMA.sql $YADAMU_LOG_PATH sakila1 Clarinet
. $YADAMU_TEST_HOME/oracle18c/env/dbConnection.sh
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_HOME/oracle/sql/COMPILE_ALL.sql $YADAMU_LOG_PATH
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_MSSQL_ALL.sql $YADAMU_LOG_PATH 1 Clarinet
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_ORACLE_ALL.sql $YADAMU_LOG_PATH 1 Clarinet DDL_AND_DATA
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_SCHEMA.sql $YADAMU_LOG_PATH jtest1 Clarinet
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_SCHEMA.sql $YADAMU_LOG_PATH sakila1 Clarinet
. $YADAMU_TEST_HOME/oracle12c/env/dbConnection.sh
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_HOME/oracle/sql/COMPILE_ALL.sql $YADAMU_LOG_PATH
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_MSSQL_ALL.sql $YADAMU_LOG_PATH 1 Clarinet
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_ORACLE_ALL.sql $YADAMU_LOG_PATH 1 Clarinet DDL_AND_DATA
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_SCHEMA.sql $YADAMU_LOG_PATH jtest1 Clarinet
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_SCHEMA.sql $YADAMU_LOG_PATH sakila1 Clarinet
. $YADAMU_TEST_HOME/oracle11g/env/dbConnection.sh
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_HOME/oracle/sql/COMPILE_ALL.sql $YADAMU_LOG_PATH
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_MSSQL_ALL.sql $YADAMU_LOG_PATH 1 Clarinet
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_ORACLE_ALL.sql $YADAMU_LOG_PATH 1 Clarinet DDL_AND_DATA
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_SCHEMA.sql $YADAMU_LOG_PATH jtest1 Clarinet
sqlplus $DB_USER/$DB_PWD@$DB_CONNECTION @$YADAMU_TEST_HOME/oracle/sql/RECREATE_SCHEMA.sql $YADAMU_LOG_PATH sakila1 Clarinet
. $YADAMU_TEST_HOME/mssql/env/dbConnection.sh
export ID=1
export METHOD=CLARINET
export DATABASE=$DB_DBNAME
sqlcmd -U$DB_USER -P$DB_PWD -S$DB_HOST -d$DB_DBNAME -I -e -i$YADAMU_HOME/mssql/sql/YADAMU_IMPORT.sql > $YADAMU_LOG_PATH/YADAMU_IMPORT_MSSQL.log
sqlcmd -U$DB_USER -P$DB_PWD -S$DB_HOST -d$DB_DBNAME -I -e -i$YADAMU_TEST_HOME/mssql/sql/RECREATE_MSSQL_ALL.sql >$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
sqlcmd -U$DB_USER -P$DB_PWD -S$DB_HOST -d$DB_DBNAME -I -e -i$YADAMU_TEST_HOME/mssql/sql/RECREATE_ORACLE_ALL.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
export SCHEMA=AdventureWorksAll
sqlcmd -U$DB_USER -P$DB_PWD -S$DB_HOST -d$DB_DBNAME -I -e -i$YADAMU_TEST_HOME/mssql/sql/RECREATE_SCHEMA.sql >> $YADAMU_LOG_PATH/RECREATE_SCHEMA.log
export SCHEMA=jtest
sqlcmd -U$DB_USER -P$DB_PWD -S$DB_HOST -d$DB_DBNAME -I -e -i$YADAMU_TEST_HOME/mssql/sql/RECREATE_SCHEMA.sql >> $YADAMU_LOG_PATH/RECREATE_SCHEMA.log
export SCHEMA=sakila
sqlcmd -U$DB_USER -P$DB_PWD -S$DB_HOST -d$DB_DBNAME -I -e -i$YADAMU_TEST_HOME/mssql/sql/RECREATE_SCHEMA.sql >> $YADAMU_LOG_PATH/RECREATE_SCHEMA.log
. $YADAMU_TEST_HOME/mysql/env/dbConnection.sh
mysql.exe -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f <$YADAMU_HOME/mysql/sql/YADAMU_IMPORT.sql >$YADAMU_LOG_PATH/YADAMU_IMPORT_MYSQL.log
mysql.exe -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @ID='1'; set @METHOD='Clarinet'" <$YADAMU_TEST_HOME/mysql/sql/RECREATE_MSSQL_ALL.sql >$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
mysql.exe -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @ID='1'; set @METHOD='Clarinet';"<$YADAMU_TEST_HOME/mysql/sql/RECREATE_ORACLE_ALL.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
mysql.exe -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @SCHEMA='jtest'; set @ID='1'; set @METHOD='Clarinet'" <$YADAMU_TEST_HOME/mariadb/sql/RECREATE_SCHEMA.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
mysql.exe -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @SCHEMA='sakila'; set @ID='1'; set @METHOD='Clarinet'" <$YADAMU_TEST_HOME/mariadb/sql/RECREATE_SCHEMA.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
. $YADAMU_TEST_HOME/mariadb/env/dbConnection.sh
mysql.exe -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f <$YADAMU_HOME/mariadb/sql/SCHEMA_COMPARE.sql >$YADAMU_LOG_PATH/SCHEMA_COMPARE_MARIADB.log
mysql.exe -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @ID='1'; set @METHOD='Clarinet'" <$YADAMU_TEST_HOME/mysql/sql/RECREATE_MSSQL_ALL.sql >$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
mysql.exe -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @ID='1'; set @METHOD='Clarinet';"<$YADAMU_TEST_HOME/mysql/sql/RECREATE_ORACLE_ALL.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
mysql.exe -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @SCHEMA='jtest'; set @ID='1'; set @METHOD='Clarinet'" <$YADAMU_TEST_HOME/mariadb/sql/RECREATE_SCHEMA.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
mysql.exe -u$DB_USER -p$DB_PWD -h$DB_HOST -D$DB_DBNAME -P$DB_PORT -v -f --init-command="set @SCHEMA='sakila'; set @ID='1'; set @METHOD='Clarinet'" <$YADAMU_TEST_HOME/mariadb/sql/RECREATE_SCHEMA.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
. $YADAMU_TEST_HOME/postgres/env/dbConnection.sh
psql -U $DB_USER -d $DB_DBNAME -h $DB_HOST -a -f $YADAMU_HOME/postgres/sql/YADAMU_IMPORT.sql > $YADAMU_LOG_PATH/YADAMU_IMPORT_POSTGRES.log
psql -U $DB_USER -d $DB_DBNAME -h $DB_HOST -a -vID=1 -vMETHOD=Clarinet -f $YADAMU_TEST_HOME/postgres/sql/RECREATE_MSSQL_ALL.sql >$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
psql -U $DB_USER -d $DB_DBNAME -h $DB_HOST -a -vID=1 -vMETHOD=Clarinet -f $YADAMU_TEST_HOME/postgres/sql/RECREATE_ORACLE_ALL.sql >>$YADAMU_LOG_PATH/RECREATE_SCHEMA.log
psql -U $DB_USER -d $DB_DBNAME -h $DB_HOST -a -vSCHEMA=jtest -vID=1 -vMETHOD=Clarinet -f $YADAMU_TEST_HOME/postgres/sql/RECREATE_SCHEMA.sql >> $YADAMU_LOG_PATH/RECREATE_SCHEMA.log
psql -U $DB_USER -d $DB_DBNAME -h $DB_HOST -a -vSCHEMA=sakila -vID=1 -vMETHOD=Clarinet -f $YADAMU_TEST_HOME/postgres/sql/RECREATE_SCHEMA.sql >> $YADAMU_LOG_PATH/RECREATE_SCHEMA.log
exit /b

INITLOGGING()
{
export YADAMU_LOG=$YADAMU_HOME/logs
mkdir $YADAMU_LOG
export YADAMU_LOG=$YADAMU_LOG/$(date --utc +%FT%T.%3NZ)
rmdir /q /s $YADAMU_LOG
mkdir $YADAMU_LOG
mkdir $YADAMU_LOG/install
export LOGDIR=$YADAMU_LOG
}