export YADAMU_HOME=`pwd`
export YADAMU_LOG_ROOT=$YADAMU_HOME/log
export YADAMU_TESTNAME=cmdLine
export YADAMU_OUTPUT_PATH=$YADAMU_HOME/$YADAMU_TESTNAME
echo "Output written to: ${YADAMU_OUTPUT_PATH}"
if [ -e $YADAMU_OUTPUT_PATH ]; then rm -rf $YADAMU_OUTPUT_PATH; fi
mkdir -p $YADAMU_OUTPUT_PATH
source $YADAMU_HOME/qa/bin/initializeLogging.sh $YADAMU_TESTNAME
export YADAMU_LOG_FOLDER=$YADAMU_LOG_PATH
echo "Scripts logged to: ${YADAMU_LOG_PATH}"
echo "Yadamu log file: ${YADAMU_IMPORT_LOG}"
# Mode is set internally by the export_sample_datasets scripts
echo "Exporting Oracle19c"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/export_oracle19c.log
source qa/cmdLine/oracle19c/bin/export_sample_datasets.sh     1> $SHELL_LOG_FILE 2>&1
echo "Exporting Oracle18c"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/export_oracle18c.log
source qa/cmdLine/oracle18c/bin/export_sample_datasets.sh     1> $SHELL_LOG_FILE 2>&1
echo "Exporting Oracle12c"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/export_oracle12c.log
source qa/cmdLine/oracle12c/bin/export_sample_datasets.sh     1> $SHELL_LOG_FILE 2>&1
echo "Exporting Oracle11g"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/export_oracle11g.log
source qa/cmdLine/oracle11g/bin/export_sample_datasets.sh     1> $SHELL_LOG_FILE 2>&1
echo "Exporting MsSQL Server 2017"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/export_mssql17.log
source qa/cmdLine/mssql17/bin/export_sample_datasets.sh       1> $SHELL_LOG_FILE 2>&1
echo "Exporting MsSQL Server 2019"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/export_mssql19.log
source qa/cmdLine/mssql19/bin/export_sample_datasets.sh       1> $SHELL_LOG_FILE 2>&1
echo "Exporting MySQL"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/export_mysql.log
source qa/cmdLine/mysql/bin/export_sample_datasets.sh         1> $SHELL_LOG_FILE 2>&1
export MODE=DATA_ONLY
echo "Testing Oracle19c"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/oracle19c.log
source qa/cmdLine/oracle19c/bin/cmdLineTests.sh               1> $SHELL_LOG_FILE 2>&1
echo "Testing Oracle18c"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/oracle18c.log
source qa/cmdLine/oracle18c/bin/cmdLineTests.sh               1> $SHELL_LOG_FILE 2>&1
echo "Testing Oracle12c"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/oracle12c.log
source qa/cmdLine/oracle12c/bin/cmdLineTests.sh               1> $SHELL_LOG_FILE 2>&1
echo "Testing Oracle11g"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/oracle11g.log
source qa/cmdLine/oracle11g/bin/cmdLineTests.sh               1> $SHELL_LOG_FILE 2>&1
echo "Testing MsSQL Server 2017"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/mssql17.log
source qa/cmdLine/mssql17/bin/cmdLineTests.sh                 1> $SHELL_LOG_FILE 2>&1
echo "Testing MsSQL Server 2019"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/mssql19.log
source qa/cmdLine/mssql19/bin/cmdLineTests.sh                 1> $SHELL_LOG_FILE 2>&1
echo "Testing Postgres"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/postgres.log
source qa/cmdLine/postgres/bin/cmdLineTests.sh                1> $SHELL_LOG_FILE 2>&1
echo "Testing MySQL"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/mysql.log
source qa/cmdLine/mysql/bin/cmdLineTests.sh                   1> $SHELL_LOG_FILE 2>&1
echo "Testing MariaDB"
export SHELL_LOG_FILE=$YADAMU_LOG_PATH/mariadb.log
source qa/cmdLine/mariadb/bin/cmdLineTests.sh                 1> $SHELL_LOG_FILE 2>&1
