set echo on 
spool logs/sql/VALIDATE_CONTENT_ALL.log
--
def SCHEMA = HR
--
@@VALIDATE_CONTENT &SCHEMA &SCHEMA.1
--
def SCHEMA = SH
--
@@VALIDATE_CONTENT &SCHEMA &SCHEMA.1
--
def SCHEMA = OE
--
@@VALIDATE_CONTENT &SCHEMA &SCHEMA.1
--
def SCHEMA = PM
--
@@VALIDATE_CONTENT &SCHEMA &SCHEMA.1
--
def SCHEMA = IX
--
@@VALIDATE_CONTENT &SCHEMA &SCHEMA.1
--
def SCHEMA = BI
--
@@VALIDATE_CONTENT &SCHEMA &SCHEMA.1
--
quit
