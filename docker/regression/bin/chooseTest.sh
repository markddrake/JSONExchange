export YADAMU_HOME="${YADAMU_HOME:=`pwd`}"
export YADAMU_QA_HOME=$YADAMU_HOME/qa
export YADAMU_SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
export YADAMU_TEST_NAME=${YADAMU_TEST_NAME:-all}
source qa/bin/createSharedFolders.sh mnt
case $YADAMU_TEST_NAME  in
  shortRegression)
    source qa/bin/resetFolders.sh mnt/stagingArea/export/json/postgres
    source qa/bin/resetFolders.sh mnt/stagingArea/export/json/postgres
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh shortRegression
  ;;

  dataTypes)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh postgresDataTypes
	;;
  
  export)
    source qa/bin/resetFolders.sh mnt/stagingArea/export/json/mysql
    source qa/bin/resetFolders.sh mnt/stagingArea/export/json/mssql
    source qa/bin/resetFolders.sh mnt/stagingArea/export/json/oracle
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh export
  ;;
  
  import)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh import
  ;;
  fileRoundtrip)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh fileRoundtrip
	;;
	
  dbRoundtrip)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh dbRoundtrip
  ;;
    
  mongo)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh mongoTestSuite
  ;;

  lostConnection)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh lostConnection
  ;;

  all)
    source $YADAMU_SCRIPT_DIR/runRegressionTests.sh 
  ;;	
  
  snowflake)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh snowflakeDataTypes
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh snowflakeTestSuite
  ;;

  vertica)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh verticaDataTypes
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh vertica900DataTypes
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh verticaTestSuite
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh vertica900TestSuite
  ;;

  mssql2014TestSuite)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh mssql2014TestSuite
  ;;

  loader)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh loaderTestSuite
  ;;

  aws)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh awsTestSuite
  ;;

  azure)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh azureTestSuite
  ;;

  cmdLine) 
    source  $YADAMU_SCRIPT_DIR/runCmdLineTests.sh
  ;;

  interactive)
    sleep 365d
  ;; 
  
  custom)
    source $YADAMU_SCRIPT_DIR/runCustomTest.sh $TESTNAME
  ;; 
  
  regression)
    source $YADAMU_SCRIPT_DIR/runRegressionTest.sh $TESTNAME
  ;; 

  *)
    echo "Invalid Test $YADAMU_TEST_NAME: Valid values are shortRegression, export, import, fileRoundtrip, dbRoundtrip, lostConnection, mongo, snowflake, vertica, loader, aws, azure, cmdLine, interactive or all (default)"
  ;;
esac