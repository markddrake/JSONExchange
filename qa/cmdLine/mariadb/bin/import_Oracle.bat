@echo %YADAMU_TRACE%
call qa\cmdLine\bin\initialize.bat %~dp0 %~dp0 oracle import %YADAMU_TESTNAME%
set YADAMU_PARSER=CLARINET
set SCHEMA_VERSION=1
mysql -u%DB_USER% -p%DB_PWD% -h%DB_HOST% -D%DB_DBNAME% -P%DB_PORT% -v -f --init-command="set @ID=%SCHEMA_VERSION%; set @METHOD='%YADAMU_PARSER%';" <%YADAMU_SQL_PATH%\RECREATE_ORACLE_ALL.sql >>%YADAMU_LOG_PATH%\RECREATE_SCHEMA.log
call %YADAMU_SCRIPT_PATH%\import_operations_Oracle.bat %YADAMU_IMPORT_ORACLE% %SCHEMA_VERSION% ""
call %YADAMU_SCRIPT_PATH%\export_operations_Oracle.bat %YADAMU_OUTPUT_PATH% %SCHEMA_VERSION% %SCHEMA_VERSION% %MODE%
set PRIOR_VERSION=%SCHEMA_VERSION%
set /a SCHEMA_VERSION+=1
mysql -u%DB_USER% -p%DB_PWD% -h%DB_HOST% -D%DB_DBNAME% -P%DB_PORT% -v -f --init-command="set @ID=%SCHEMA_VERSION%; set @METHOD='%YADAMU_PARSER%';" <%YADAMU_SQL_PATH%\RECREATE_ORACLE_ALL.sql >>%YADAMU_LOG_PATH%\RECREATE_SCHEMA.log
call %YADAMU_SCRIPT_PATH%\import_operations_Oracle.bat %YADAMU_OUTPUT_PATH% %SCHEMA_VERSION% %PRIOR_VERSION% 
mysql -u%DB_USER% -p%DB_PWD% -h%DB_HOST% -D%DB_DBNAME% -P%DB_PORT% -f --init-command="set @ID1=%PRIOR_VERSION%; set @ID2=%SCHEMA_VERSION%; set @METHOD='%YADAMU_PARSER%'" --table <%YADAMU_SQL_PATH%\COMPARE_ORACLE_ALL.sql >>%YADAMU_LOG_PATH%\COMPARE_SCHEMA.log
call %YADAMU_SCRIPT_PATH%\export_operations_Oracle.bat %YADAMU_OUTPUT_PATH% %SCHEMA_VERSION% %SCHEMA_VERSION% %MODE% 
node %YADAMU_QA_JSPATH%\compareFileSizes %YADAMU_LOG_PATH% %YADAMU_IMPORT_ORACLE% %YADAMU_OUTPUT_PATH%
node %YADAMU_QA_JSPATH%\compareArrayContent %YADAMU_LOG_PATH% %YADAMU_IMPORT_ORACLE% %YADAMU_OUTPUT_PATH% false