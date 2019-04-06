export SRC=$1
export SCHEMAVER=$2
export FILEVER=$3
node $YADAMU_DB_ROOT/node/jTableImport --username=$DB_USER --hostname=$DB_HOST --password=$DB_PWD --database=HR$SCHEMAVER file=$SRC/HR$FILEVER.json toUser=\"dbo\" logFile=$IMPORTLOG mode=$MODE
node $YADAMU_DB_ROOT/node/jTableImport --username=$DB_USER --hostname=$DB_HOST --password=$DB_PWD --database=SH$SCHEMAVER file=$SRC/SH$FILEVER.json toUser=\"dbo\" logFile=$IMPORTLOG mode=$MODE
node $YADAMU_DB_ROOT/node/jTableImport --username=$DB_USER --hostname=$DB_HOST --password=$DB_PWD --database=OE$SCHEMAVER file=$SRC/OE$FILEVER.json toUser=\"dbo\" logFile=$IMPORTLOG mode=$MODE
node $YADAMU_DB_ROOT/node/jTableImport --username=$DB_USER --hostname=$DB_HOST --password=$DB_PWD --database=PM$SCHEMAVER file=$SRC/PM$FILEVER.json toUser=\"dbo\" logFile=$IMPORTLOG mode=$MODE
node $YADAMU_DB_ROOT/node/jTableImport --username=$DB_USER --hostname=$DB_HOST --password=$DB_PWD --database=IX$SCHEMAVER file=$SRC/IX$FILEVER.json toUser=\"dbo\" logFile=$IMPORTLOG mode=$MODE
node $YADAMU_DB_ROOT/node/jTableImport --username=$DB_USER --hostname=$DB_HOST --password=$DB_PWD --database=BI$SCHEMAVER file=$SRC/BI$FILEVER.json toUser=\"dbo\" logFile=$IMPORTLOG mode=$MODE