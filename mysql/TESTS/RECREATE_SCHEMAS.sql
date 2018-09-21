--
SET SESSION SQL_MODE=ANSI_QUOTES;
--
set @ID  = 2;
--
set @SCHEMA = 'HR';
--
SET @STATEMENT = CONCAT('DROP SCHEMA ','"',@SCHEMA,@ID,'"');
--
PREPARE STATEMENT FROM @STATEMENT;
EXECUTE STATEMENT;
DEALLOCATE PREPARE STATEMENT;
--
SET @STATEMENT = CONCAT('CREATE SCHEMA ','"',@SCHEMA,@ID,'"');
--
PREPARE STATEMENT FROM @STATEMENT;
EXECUTE STATEMENT;
DEALLOCATE PREPARE STATEMENT;
--
set @SCHEMA = 'SH';
--
SET @STATEMENT = CONCAT('DROP SCHEMA ','"',@SCHEMA,@ID,'"');
--
PREPARE STATEMENT FROM @STATEMENT;
EXECUTE STATEMENT;
DEALLOCATE PREPARE STATEMENT;
--
SET @STATEMENT = CONCAT('CREATE SCHEMA ','"',@SCHEMA,@ID,'"');
--
PREPARE STATEMENT FROM @STATEMENT;
EXECUTE STATEMENT;
DEALLOCATE PREPARE STATEMENT;
--
set @SCHEMA = 'OE';
--
SET @STATEMENT = CONCAT('DROP SCHEMA ','"',@SCHEMA,@ID,'"');
--
PREPARE STATEMENT FROM @STATEMENT;
EXECUTE STATEMENT;
DEALLOCATE PREPARE STATEMENT;
--
SET @STATEMENT = CONCAT('CREATE SCHEMA ','"',@SCHEMA,@ID,'"');
--
PREPARE STATEMENT FROM @STATEMENT;
EXECUTE STATEMENT;
DEALLOCATE PREPARE STATEMENT;
--
set @SCHEMA = 'PM';
--
SET @STATEMENT = CONCAT('DROP SCHEMA ','"',@SCHEMA,@ID,'"');
--
PREPARE STATEMENT FROM @STATEMENT;
EXECUTE STATEMENT;
DEALLOCATE PREPARE STATEMENT;
--
SET @STATEMENT = CONCAT('CREATE SCHEMA ','"',@SCHEMA,@ID,'"');
--
PREPARE STATEMENT FROM @STATEMENT;
EXECUTE STATEMENT;
DEALLOCATE PREPARE STATEMENT;
--
set @SCHEMA = 'IX';
--
SET @STATEMENT = CONCAT('DROP SCHEMA ','"',@SCHEMA,@ID,'"');
--
PREPARE STATEMENT FROM @STATEMENT;
EXECUTE STATEMENT;
DEALLOCATE PREPARE STATEMENT;
--
SET @STATEMENT = CONCAT('CREATE SCHEMA ','"',@SCHEMA,@ID,'"');
--
PREPARE STATEMENT FROM @STATEMENT;
EXECUTE STATEMENT;
DEALLOCATE PREPARE STATEMENT;
--
set @SCHEMA = 'BI';
--
SET @STATEMENT = CONCAT('DROP SCHEMA ','"',@SCHEMA,@ID,'"');
--
PREPARE STATEMENT FROM @STATEMENT;
EXECUTE STATEMENT;
DEALLOCATE PREPARE STATEMENT;
--
SET @STATEMENT = CONCAT('CREATE SCHEMA ','"',@SCHEMA,@ID,'"');
--
PREPARE STATEMENT FROM @STATEMENT;
EXECUTE STATEMENT;
DEALLOCATE PREPARE STATEMENT;
--
