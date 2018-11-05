export SRC=$1
export USRID=$2
export VER=$3
node ../node/jTableImport --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD  --PORT=$DB_PORT --DATABASE=$DB_DBNAME --File=$SRC/HR$VER.json --toUser=\"HR$USRID\"
node ../node/jTableImport --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD  --PORT=$DB_PORT --DATABASE=$DB_DBNAME --File=$SRC/SH$VER.json --toUser=\"SH$USRID\"
node ../node/jTableImport --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD  --PORT=$DB_PORT --DATABASE=$DB_DBNAME --File=$SRC/OE$VER.json --toUser=\"OE$USRID\"
node ../node/jTableImport --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD  --PORT=$DB_PORT --DATABASE=$DB_DBNAME --File=$SRC/PM$VER.json --toUser=\"PM$USRID\"
node ../node/jTableImport --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD  --PORT=$DB_PORT --DATABASE=$DB_DBNAME --File=$SRC/IX$VER.json --toUser=\"IX$USRID\"
node ../node/jTableImport --USERNAME=$DB_USER --HOSTNAME=$DB_HOST --PASSWORD=$DB_PWD  --PORT=$DB_PORT --DATABASE=$DB_DBNAME --File=$SRC/BI$VER.json --toUser=\"BI$USRID\"

