set SRC=%~1
set SCHEMA_VERSION=%~2
set VER=%~3
call %YADAMU_BIN%\import.bat RDBMS=%YADAMU_VENDOR%  USERID=%DB_USER%/%DB_PWD%@%DB_CONNECTION%  FILE=%SRC%\HR%VER%.json TO_USER=\"HR%SCHEMA_VERSION%\"  MODE=%MODE% LOG_FILE=%YADAMU_IMPORT_LOG% EXCEPTION_FOLDER=%YADAMU_LOG_PATH%
call %YADAMU_BIN%\import.bat RDBMS=%YADAMU_VENDOR%  USERID=%DB_USER%/%DB_PWD%@%DB_CONNECTION%  FILE=%SRC%\SH%VER%.json TO_USER=\"SH%SCHEMA_VERSION%\"  MODE=%MODE% LOG_FILE=%YADAMU_IMPORT_LOG% EXCEPTION_FOLDER=%YADAMU_LOG_PATH%
call %YADAMU_BIN%\import.bat RDBMS=%YADAMU_VENDOR%  USERID=%DB_USER%/%DB_PWD%@%DB_CONNECTION%  FILE=%SRC%\OE%VER%.json TO_USER=\"OE%SCHEMA_VERSION%\"  MODE=%MODE% LOG_FILE=%YADAMU_IMPORT_LOG% EXCEPTION_FOLDER=%YADAMU_LOG_PATH%
call %YADAMU_BIN%\import.bat RDBMS=%YADAMU_VENDOR%  USERID=%DB_USER%/%DB_PWD%@%DB_CONNECTION%  FILE=%SRC%\PM%VER%.json TO_USER=\"PM%SCHEMA_VERSION%\"  MODE=%MODE% LOG_FILE=%YADAMU_IMPORT_LOG% EXCEPTION_FOLDER=%YADAMU_LOG_PATH%
call %YADAMU_BIN%\import.bat RDBMS=%YADAMU_VENDOR%  USERID=%DB_USER%/%DB_PWD%@%DB_CONNECTION%  FILE=%SRC%\IX%VER%.json TO_USER=\"IX%SCHEMA_VERSION%\"  MODE=%MODE% LOG_FILE=%YADAMU_IMPORT_LOG% EXCEPTION_FOLDER=%YADAMU_LOG_PATH%
call %YADAMU_BIN%\import.bat RDBMS=%YADAMU_VENDOR%  USERID=%DB_USER%/%DB_PWD%@%DB_CONNECTION%  FILE=%SRC%\BI%VER%.json TO_USER=\"BI%SCHEMA_VERSION%\"  MODE=%MODE% LOG_FILE=%YADAMU_IMPORT_LOG% EXCEPTION_FOLDER=%YADAMU_LOG_PATH%
