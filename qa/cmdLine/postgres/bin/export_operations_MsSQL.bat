set TGT=%~1
set FILEVER=%~2
set SCHEMA_VERSION=%~3
call %YADAMU_BIN%\export.bat --RDBMS=%YADAMU_VENDOR% --USERNAME=%DB_USER% --HOSTNAME=%DB_HOST% --PASSWORD=%DB_PWD% --DATABASE=%DB_DBNAME%  FROM_USER=\"Northwind%SCHEMA_VERSION%\"         FILE=%TGT%\Northwind%FILEVER%.json         MODE=%MODE% LOG_FILE=%YADAMU_EXPORT_LOG%  EXCEPTION_FOLDER=%YADAMU_LOG_PATH%
call %YADAMU_BIN%\export.bat --RDBMS=%YADAMU_VENDOR% --USERNAME=%DB_USER% --HOSTNAME=%DB_HOST% --PASSWORD=%DB_PWD% --DATABASE=%DB_DBNAME%  FROM_USER=\"Sales%SCHEMA_VERSION%\"             FILE=%TGT%\Sales%FILEVER%.json             MODE=%MODE% LOG_FILE=%YADAMU_EXPORT_LOG%  EXCEPTION_FOLDER=%YADAMU_LOG_PATH%
call %YADAMU_BIN%\export.bat --RDBMS=%YADAMU_VENDOR% --USERNAME=%DB_USER% --HOSTNAME=%DB_HOST% --PASSWORD=%DB_PWD% --DATABASE=%DB_DBNAME%  FROM_USER=\"Person%SCHEMA_VERSION%\"            FILE=%TGT%\Person%FILEVER%.json            MODE=%MODE% LOG_FILE=%YADAMU_EXPORT_LOG%  EXCEPTION_FOLDER=%YADAMU_LOG_PATH%
call %YADAMU_BIN%\export.bat --RDBMS=%YADAMU_VENDOR% --USERNAME=%DB_USER% --HOSTNAME=%DB_HOST% --PASSWORD=%DB_PWD% --DATABASE=%DB_DBNAME%  FROM_USER=\"Production%SCHEMA_VERSION%\"        FILE=%TGT%\Production%FILEVER%.json        MODE=%MODE% LOG_FILE=%YADAMU_EXPORT_LOG%  EXCEPTION_FOLDER=%YADAMU_LOG_PATH%
call %YADAMU_BIN%\export.bat --RDBMS=%YADAMU_VENDOR% --USERNAME=%DB_USER% --HOSTNAME=%DB_HOST% --PASSWORD=%DB_PWD% --DATABASE=%DB_DBNAME%  FROM_USER=\"Purchasing%SCHEMA_VERSION%\"        FILE=%TGT%\Purchasing%FILEVER%.json        MODE=%MODE% LOG_FILE=%YADAMU_EXPORT_LOG%  EXCEPTION_FOLDER=%YADAMU_LOG_PATH%
call %YADAMU_BIN%\export.bat --RDBMS=%YADAMU_VENDOR% --USERNAME=%DB_USER% --HOSTNAME=%DB_HOST% --PASSWORD=%DB_PWD% --DATABASE=%DB_DBNAME%  FROM_USER=\"HumanResources%SCHEMA_VERSION%\"    FILE=%TGT%\HumanResources%FILEVER%.json    MODE=%MODE% LOG_FILE=%YADAMU_EXPORT_LOG%  EXCEPTION_FOLDER=%YADAMU_LOG_PATH%
call %YADAMU_BIN%\export.bat --RDBMS=%YADAMU_VENDOR% --USERNAME=%DB_USER% --HOSTNAME=%DB_HOST% --PASSWORD=%DB_PWD% --DATABASE=%DB_DBNAME%  FROM_USER=\"AdventureWorksDW%SCHEMA_VERSION%\"  FILE=%TGT%\AdventureWorksDW%FILEVER%.json  MODE=%MODE% LOG_FILE=%YADAMU_EXPORT_LOG%  EXCEPTION_FOLDER=%YADAMU_LOG_PATH%%