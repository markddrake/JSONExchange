use master
go
drop function sp_MAP_FOREIGN_DATATYPE
go
drop function sp_GENERATE_STATEMENTS
go
drop procedure sp_IMPORT_JSON
go
create OR ALTER FUNCTION sp_MAP_FOREIGN_DATATYPE(@VENDOR NVARCHAR(128), @DATA_TYPE NVARCHAR(128), @DATA_TYPE_LENGTH BIGINT, @DATA_TYPE_SCALE INT, @DB_COLLATION NVARCHAR(32)) 
returns VARCHAR(128) 
as
begin
  return 
  case
    when @VENDOR = 'Oracle' then
      case 
        when @DATA_TYPE = 'VARCHAR2' then 
          'varchar'
        when @DATA_TYPE = 'NVARCHAR2' then
          'nvarchar'
        when @DATA_TYPE = 'CLOB' then
          'varchar(max)'
        when @DATA_TYPE = 'NCLOB' then
          'nvarchar(max)'
        when @DATA_TYPE = 'NUMBER' then
          'decimal'
        when @DATA_TYPE = 'BINARY_DOUBLE' then
          'float(53)'
        when @DATA_TYPE = 'BINARY_FLOAT' then
          'real'
        when @DATA_TYPE = 'BOOLEAN' then 
          'bit'
        when @DATA_TYPE = 'RAW' and @DATA_TYPE_LENGTH = 1 then 
          'bit'
        when @DATA_TYPE = 'RAW' then
          'varbinary'
        when @DATA_TYPE = 'BLOB' then
          'varbinary(max)'
        when @DATA_TYPE = 'BFILE' then
          'varchar(2048)'  
        when @DATA_TYPE in ('ROWID','UROWID') then
          'varchar(18)'                  
        when @DATA_TYPE in ('ANYDATA') then
          'nvarchar(max)'                
        when (CHARINDEX('INTERVAL',@DATA_TYPE) = 1) then
          'varchar(16)'                  
        when (CHARINDEX('TIMESTAMP',@DATA_TYPE) = 1) then
          case
                 when (CHARINDEX('TIME ZONE',@DATA_TYPE) > 0) 
                   then 'datetimeoffset'
                 else 
                  'datetime2' 
          end
        when @DATA_TYPE = 'XMLTYPE' then
          'xml'
        when @DATA_TYPE = '"MDSYS"."SDO_GEOMETRY"' then
          'geometry'                
        when @DATA_TYPE like '"%"."%"' then
          'nvarchar(max)'
        when @DATA_TYPE = 'JSON' then
          'json'
        else
          lower(@DATA_TYPE)
      end
    when @VENDOR in ('MySQL','MariaDB') then
      case 
        when @DATA_TYPE = 'tinyint' and @DATA_TYPE_LENGTH = 1 then
          'bit'
        when @DATA_TYPE = 'boolean' then
          'bit'
        when @DATA_TYPE = 'mediumint' then
          'int'
        when @DATA_TYPE = 'datetime' then
          'datetime2'
        when @DATA_TYPE = 'timestamp' then
          'datetime2'
        when @DATA_TYPE = 'float' then
          'real'
        when @DATA_TYPE = 'double' then
          'float(53)'
        when @DATA_TYPE = 'enum' then
          'varchar(255)'
        when @DATA_TYPE = 'set' then
          'json'
        when @DATA_TYPE = 'year' then
          'smallint'
        when @DATA_TYPE = 'json' then
          'json'
        when @DATA_TYPE = 'blob' and @DATA_TYPE_LENGTH > 8000  then
          'varbinary(max)'
        when @DATA_TYPE = 'blob' then
          'varbinary'
        -- For MySQL may need to add column character set to the table metadata object in order to accutately determine varchar Vs nvarchar ? 
        -- Alternatively the character set could be used when generating metadata from the MySQL dictionaly that distinguishes varchar from nvarchar even thought the dictionaly does not.
        when @DATA_TYPE = 'varchar' and (@DATA_TYPE_LENGTH is null or @DATA_TYPE_LENGTH > 4000) then
          'nvarchar(max)'
        when @DATA_TYPE = 'varchar' then
          'nvarchar'
        when @DATA_TYPE = 'text' then
          'nvarchar(max)'
        when @DATA_TYPE = 'mediumtext' then
          'nvarchar(max)'
        when @DATA_TYPE = 'longtext' then
          'nvarchar(max)'
        when @DATA_TYPE = 'longblob' then
          'varbinary(max)'
        when @DATA_TYPE = 'mediumblob' then
          'varbinary(max)'
        else
          lower(@DATA_TYPE)
      end
    when @VENDOR = 'Postgres' then
      case 
        when @DATA_TYPE = 'character varying' and (@DATA_TYPE_LENGTH is null or @DATA_TYPE_LENGTH > 4000) then
          'nvarchar(max)'
        when @DATA_TYPE = 'character varying' then
          'nvarchar'
        when @DATA_TYPE = 'character' then
          'nchar'
        when @DATA_TYPE = 'text' then
          'nvarchar(max)'
        when @DATA_TYPE = 'bytea' and (@DATA_TYPE_LENGTH is null or @DATA_TYPE_LENGTH > 8000)  then 
          'varbinary(max)'
        when @DATA_TYPE = 'bytea' then
          'varbinary'
        when @DATA_TYPE = 'boolean' then
          'bit'
        when @DATA_TYPE = 'timestamp' then
          'datetime'
        when @DATA_TYPE = 'timestamp with time zone' then
          'datetimeoffset'
        when @DATA_TYPE = 'timestamp without time zone' then
          'datetime2'
        when @DATA_TYPE = 'time without time zone' then
          'time'
        when (CHARINDEX('interval',@DATA_TYPE) = 1) then
          'varchar(64)'
        when @DATA_TYPE = 'double precision' then
          'float(53)'
        when @DATA_TYPE = 'real' then
          'real'
        when @DATA_TYPE = 'geometry' then
          'geometry'
        when @DATA_TYPE = 'geography'then
          'geography'
        when @DATA_TYPE = 'jsonb'then
          'json'
        when @DATA_TYPE = 'integer' then
          'int'
        else
          lower(@DATA_TYPE)
      end          
    when ((@VENDOR = 'MSSQLSERVER') and (@DB_COLLATION like '%UTF8')) then
      case 
        when @DATA_TYPE = 'text' then
          'varchar(max)'
        when @DATA_TYPE = 'ntext' then
          'nvarchar(max)'
        else
          lower(@DATA_TYPE)
      end      
    when @VENDOR = 'MongoDB' then
      -- MongoDB typing based on BSON type model and the aggregation $type operator
      -- ### No support for depricated Data types undefined, dbPointer, symbol
      case
        when @DATA_TYPE in ('undefined','object','function','symbol') then 
          'json'
        when @DATA_TYPE = 'double' then
          'float(53)'
        when @DATA_TYPE = 'string' and (@DATA_TYPE_LENGTH is null or @DATA_TYPE_LENGTH > 4000) then
          'nvarchar(max)'
        when @DATA_TYPE = 'string' then
          'nvarchar'
        when @DATA_TYPE = 'object' then 
          'json'          
        when @DATA_TYPE = 'array' then 
          'json'
        when @DATA_TYPE = 'binData' then 
          'varbinary(max)'
        when @DATA_TYPE = 'objectId' then
          'binary(12)'
        when @DATA_TYPE = 'bool' then
          'bit'
        when @DATA_TYPE = 'null' then
              'nvarchar(2048)'
        when @DATA_TYPE = 'regex' then
              'nvarchar(2048)'
        when @DATA_TYPE = 'javascript' then
              'nvarchar(max)'
        when @DATA_TYPE = 'javascriptWithScope' then
              'nvarchar(max)'         
        when @DATA_TYPE = 'int' then
          'int'
        when @DATA_TYPE = 'long' then
          'bigint'
        when @DATA_TYPE = 'decimal' then
          'decimal'
        when @DATA_TYPE = 'timestamp' then
          'datatime2'
        when @DATA_TYPE = 'date' then
          'datatime2'
        when @DATA_TYPE = 'minkey' then 
          'json'          
        when @DATA_TYPE = 'maxkey' then 
          'json'          
        else 
           lower(@DATA_TYPE)
      end
    when @VENDOR = 'SNOWFLAKE' then
      case
        when @DATA_TYPE = 'TEXT' and (@DATA_TYPE_LENGTH is null or @DATA_TYPE_LENGTH > 4000) then
          'nvarchar(max)'
        when @DATA_TYPE = 'TEXT' then
          'nvarchar'
        when @DATA_TYPE = 'BINARY' and (@DATA_TYPE_LENGTH is null or @DATA_TYPE_LENGTH > 8000)  then 
          'varbinary(max)'
        when @DATA_TYPE = 'BOOLEAN' then
          'bit'
        when @DATA_TYPE = 'BINARY' then
          'varbinary'
        when @DATA_TYPE = 'VARIANT' then
          'varbinary(max)'
        when @DATA_TYPE = 'TIMESTAMP_NTZ' and (@DATA_TYPE_LENGTH > 7) then
          'datetimeoffset(7)'
        when @DATA_TYPE = 'TIMESTAMP_NTZ' then
          'datetimeoffset'
        when @DATA_TYPE = 'NUMBER' then
          'decimal'
        else 
           lower(@DATA_TYPE)
      end
    else 
      lower(@DATA_TYPE)
  end
end
--
go
--
EXECUTE sp_ms_marksystemobject 'sp_MAP_FOREIGN_DATATYPE'
go
--
create OR ALTER FUNCTION sp_GENERATE_STATEMENTS(@VENDOR NVARCHAR(128), @SCHEMA NVARCHAR(128), @TABLE_NAME NVARCHAR(128), @SPATIAL_FORMAT NVARCHAR(128), @COLUMN_NAMES_ARRAY NVARCHAR(MAX),@DATA_TYPES_ARARY NVARCHAR(MAX),@SIZE_CONSTRAINTS_ARRAY NVARCHAR(MAX),@DB_COLLATION NVARCHAR(32)) 
returns NVARCHAR(MAX)
as
begin
  DECLARE @COLUMN_LIST        NVARCHAR(MAX);  
  DECLARE @COLUMNS_CLAUSE     NVARCHAR(MAX);
  DECLARE @INSERT_SELECT_LIST NVARCHAR(MAX);
  DECLARE @WITH_CLAUSE        NVARCHAR(MAX);
  DECLARE @TARGET_DATA_TYPES  NVARCHAR(MAX)
  
  DECLARE @DDL_STATEMENT      NVARCHAR(MAX);
  DECLARE @DML_STATEMENT      NVARCHAR(MAX);
  DECLARE @LEGACY_COLLATION   VARCHAR(256);
  
  SET @LEGACY_COLLATION = @DB_COLLATION;
  
  if (@LEGACY_COLLATION like '%_UTF8') begin
    SET @LEGACY_COLLATION = LEFT(@LEGACY_COLLATION, LEN(@LEGACY_COLLATION)-5);
  end;
 
  if (@LEGACY_COLLATION like '%_SC') begin
    SET @LEGACY_COLLATION = LEFT(@LEGACY_COLLATION, LEN(@LEGACY_COLLATION)-3);
  end;
  
  WITH "SOURCE_TABLE_DEFINITION" as (
          SELECT c."KEY" "INDEX"
                ,c."VALUE" "COLUMN_NAME"
                ,t."VALUE" "DATA_TYPE"
                ,CAST(case
                        when s.VALUE = '' then
                          NULL
                        when CHARINDEX(',',s."VALUE") > 0 then
                          LEFT(s."VALUE",CHARINDEX(',',s."VALUE")-1)
                        else
                          s."VALUE"
                      end 
                      as BIGINT) "DATA_TYPE_LENGTH"
                ,case
                   when CHARINDEX(',',s."VALUE") > 0  then 
                     RIGHT(s."VALUE", CHARINDEX(',',REVERSE(s."VALUE"))-1)
                   else 
                     NULL
                 end "DATA_TYPE_SCALE"
            FROM OPENJSON(@COLUMN_NAMES_ARRAY) c,
                 OPENJSON(@DATA_TYPES_ARARY) t,
                 OPENJSON(@SIZE_CONSTRAINTS_ARRAY) s
           WHERE c."KEY" = t."KEY" and c."KEY" = s."KEY"
  ),
  "TARGET_TABLE_DEFINITION" as (
    select st.*, master.dbo.sp_MAP_FOREIGN_DATATYPE(@VENDOR, "DATA_TYPE","DATA_TYPE_LENGTH","DATA_TYPE_SCALE",@DB_COLLATION) TARGET_DATA_TYPE
      from "SOURCE_TABLE_DEFINITION" st
  )
  SELECT @COLUMN_LIST = STRING_AGG(CONCAT('"',"COLUMN_NAME",'"'),',')
        ,@COLUMNS_CLAUSE =
         STRING_AGG(CONCAT('"',"COLUMN_NAME",'" ',
                           case
                             when "TARGET_DATA_TYPE" = 'boolean' then
                               'bit'
                             when "TARGET_DATA_TYPE" = 'json' then
                               CONCAT('nvarchar(max) CHECK(ISJSON("',"COLUMN_NAME",'") > 0)')
                             when TARGET_DATA_TYPE LIKE '%(%)%' then
                               "TARGET_DATA_TYPE"
                             when "TARGET_DATA_TYPE" in('text','ntext')  then
                               CONCAT("TARGET_DATA_TYPE",' collate ',@LEGACY_COLLATION)
                             when "TARGET_DATA_TYPE" in('xml','image','real','double precision','tinyint','smallint','int','bigint','bit','date','datetime','money','smallmoney','geography','geometry','hierarchyid','uniqueidentifier')  then
                               "TARGET_DATA_TYPE"                
                             when "DATA_TYPE_SCALE" IS NOT NULL then
                               CONCAT("TARGET_DATA_TYPE",'(',"DATA_TYPE_LENGTH",',', "DATA_TYPE_SCALE",')')
                             when "DATA_TYPE_LENGTH"  IS NOT NULL  then
                               case 
                                 when "DATA_TYPE_LENGTH" = -1  then
                                   CONCAT("TARGET_DATA_TYPE",'(max)')
                                 else 
                                   CONCAT("TARGET_DATA_TYPE",'(',"DATA_TYPE_LENGTH",')')
                               end
                             else 
                               "TARGET_DATA_TYPE"
                           end
                         ) 
                   ,','                 
                   )
        ,@TARGET_DATA_TYPES =
         CONCAT('[',
                STRING_AGG(CONCAT(
                                  '"',
                                  case
                                    when "TARGET_DATA_TYPE" LIKE '%(%)%' then
                                      "TARGET_DATA_TYPE"
                                    when "TARGET_DATA_TYPE" in ('json','xml','text','ntext','image','real','double precision','tinyint','smallint','int','bigint','bit','date','datetime','money','smallmoney','geography','geometry') then
                                      "TARGET_DATA_TYPE"                 
                                    when "DATA_TYPE_SCALE" IS NOT NULL then
                                      CONCAT("TARGET_DATA_TYPE",'(',"DATA_TYPE_LENGTH",',', "DATA_TYPE_SCALE",')')
                                    when "DATA_TYPE_LENGTH"  IS NOT NULL  then
                                      case 
                                        when "DATA_TYPE_LENGTH" = -1  then
                                          CONCAT("TARGET_DATA_TYPE",'(max)')
                                        else 
                                          CONCAT("TARGET_DATA_TYPE",'(',"DATA_TYPE_LENGTH",')')
                                      end
                                    else 
                                      "TARGET_DATA_TYPE"
                                  end,
                                  '"'
                                 )
                           ,','                 
                          )
                ,']'
               )
        ,@INSERT_SELECT_LIST = 
         STRING_AGG(case
                      when "TARGET_DATA_TYPE" = 'image' then
                        CONCAT('CONVERT(image,CONVERT(varbinary(max),data."',"COLUMN_NAME",'",2))')
                      when "TARGET_DATA_TYPE" = 'varbinary(max)' then
                        CONCAT('CONVERT(varbinary(max),data."',"COLUMN_NAME",'",2)')
                      when "TARGET_DATA_TYPE" in ('binary','varbinary') then
                        case
                          when ((DATA_TYPE_LENGTH = -1) OR (DATA_TYPE = 'BLOB') or ((CHARINDEX('"."',DATA_TYPE) > 0))) then
                            CONCAT('CONVERT(',"TARGET_DATA_TYPE",'(max),data."',"COLUMN_NAME",'",2) "',"COLUMN_NAME",'"')
                          else 
                            CONCAT('CONVERT(',"TARGET_DATA_TYPE",'(',"DATA_TYPE_LENGTH",'),data."',"COLUMN_NAME",'",2) "',"COLUMN_NAME",'"')
                        end
                      when "TARGET_DATA_TYPE" = 'geometry'  then
                        case
                          when @SPATIAL_FORMAT in ('WKT','EWKT') then
                            CONCAT('geometry::STGeomFromText(data."',"COLUMN_NAME",'",4326) "',"COLUMN_NAME",'"')
                          when @SPATIAL_FORMAT in ('WKB','EWKB') then
                            CONCAT('geometry::STGeomFromWKB(CONVERT(varbinary(max),data."',"COLUMN_NAME",'",2),4326) "',"COLUMN_NAME",'"')
                          else                            
                            CONCAT('geometry::STGeomFromWKB(CONVERT(varbinary(max),data."',"COLUMN_NAME",'",2),4326) "',"COLUMN_NAME",'"')
                        end
                      when "TARGET_DATA_TYPE" = 'geography' then
                        case
                          when @SPATIAL_FORMAT in ('WKT','EWKT') then
                            CONCAT('geography::STGeomFromText(data."',"COLUMN_NAME",'",4326) "',"COLUMN_NAME",'"')
                          when @SPATIAL_FORMAT in ('WKB','EWKB') then
                            CONCAT('geography::STGeomFromWKB(CONVERT(varbinary(max),data."',"COLUMN_NAME",'",2),4326) "',"COLUMN_NAME",'"')
                          else                            
                            CONCAT('geography::STGeomFromWKB(CONVERT(varbinary(max),data."',"COLUMN_NAME",'",2),4326) "',"COLUMN_NAME",'"')
                        end
                      else
                        CONCAT('data."',"COLUMN_NAME",'"')
                    end 
                   ,','                 
                   )
       ,@WITH_CLAUSE =
        STRING_AGG(CONCAT('"',COLUMN_NAME,'" ',
                          case            
                            when "TARGET_DATA_TYPE" = 'json' then
                              'nvarchar(max)'                
                            when "TARGET_DATA_TYPE" = 'varbinary(max)' then
                              'varchar(max)'                
                            when (CHARINDEX('(',"TARGET_DATA_TYPE") > 0) then
                              "TARGET_DATA_TYPE"
                            when "TARGET_DATA_TYPE" in('xml','real','double precision','tinyint','smallint','int','bigint','bit','date','datetime','money','smallmoney') then
                              "TARGET_DATA_TYPE"         
                            when "TARGET_DATA_TYPE" = 'image' then
                              'varchar(max)'                
                            when "TARGET_DATA_TYPE" = 'text' then
                              'varchar(max)'                 
                            when "TARGET_DATA_TYPE" = 'ntext' then
                              'nvarchar(max)'                
                            when "TARGET_DATA_TYPE" = 'geography' then
                              'nvarchar(4000)'                
                            when "TARGET_DATA_TYPE" = 'geometry' then
                              'nvarchar(4000)'                
                            when "TARGET_DATA_TYPE" = 'hierarchyid' then
                              'nvarchar(4000)'                
                            when "TARGET_DATA_TYPE" in ('binary','varbinary') then
                              case
                                when "DATA_TYPE_LENGTH" < 0  then
                                  'varchar(max)'
                                else 
                                  CONCAT('varchar(',cast(("DATA_TYPE_LENGTH" * 2) as VARCHAR),')')
                              end
                            when "DATA_TYPE_SCALE" IS NOT NULL then
                              CONCAT("TARGET_DATA_TYPE",'(',"DATA_TYPE_LENGTH",',', "DATA_TYPE_SCALE",')')
                            when "DATA_TYPE_LENGTH" IS NOT NULL  then
                              case 
                                when "DATA_TYPE_LENGTH" < 0  then
                                  CONCAT("TARGET_DATA_TYPE",'(max)')
                                else 
                                  CONCAT("TARGET_DATA_TYPE",'(',"DATA_TYPE_LENGTH",')')
                              end
                            else 
                              "TARGET_DATA_TYPE"
                          end,
                          ' ''$[',"INDEX",']'''
                        )
                        ,','                    
                   )
      FROM "TARGET_TABLE_DEFINITION" tt;
      
   SET @DDL_STATEMENT = CONCAT('if object_id(''"',@SCHEMA,'"."',@TABLE_NAME,'"'',''U'') is NULL create table "',@SCHEMA,'"."',@TABLE_NAME,'" (',@COLUMNS_CLAUSE,')');   
   SET @DML_STATEMENT = CONCAT('insert into "' ,@SCHEMA,'"."',@TABLE_NAME,'" (',@COLUMN_LIST,') select ',@INSERT_SELECT_LIST,'  from "#YADAMU_STAGING" s cross apply OPENJSON("DATA",''$.data."',@TABLE_NAME,'"'') with ( ',@WITH_CLAUSE,') data');
   RETURN JSON_MODIFY(JSON_MODIFY(JSON_MODIFY('{}','$.ddl',@DDL_STATEMENT),'$.dml',@DML_STATEMENT),'$.targetDataTypes',JSON_QUERY(@TARGET_DATA_TYPES))
end;
--
go
--
EXECUTE sp_ms_marksystemobject 'sp_GENERATE_STATEMENTS'
go
--
create OR ALTER PROCEDURE sp_IMPORT_JSON(@TARGET_DATABASE VARCHAR(128),@DB_COLLATION VARCHAR(32)) 
as
begin
  DECLARE @OWNER            VARCHAR(128);
  DECLARE @TABLE_NAME       VARCHAR(128);
  DECLARE @STATEMENTS       NVARCHAR(MAX);
  DECLARE @SQL_STATEMENT    NVARCHAR(MAX);
  
  DECLARE @START_TIME       DATETIME2;
  DECLARE @END_TIME         DATETIME2;
  DECLARE @ELAPSED_TIME     BIGINT;  
  DECLARE @ROW_COUNT        BIGINT;
 
  DECLARE @LOG_ENTRY        NVARCHAR(MAX);
  DECLARE @RESULTS          NVARCHAR(MAX) = '[]';
                            
  DECLARE FETCH_METADATA 
  CURSOR FOR 
  select TABLE_NAME, 
         master.dbo.sp_GENERATE_STATEMENTS(VENDOR, @TARGET_DATABASE, v.TABLE_NAME, SPATIAL_FORMAT, v.COLUMN_NAMES_ARRAY, v.DATA_TYPES_ARARY, v.SIZE_CONSTRAINTS_ARRAY,@DB_COLLATION) as STATEMENTS
   from "#YADAMU_STAGING"
         cross apply OPENJSON("DATA") 
         with (
           VENDOR         nvarchar(128) '$.systemInformation.vendor'
          ,SPATIAL_FORMAT nvarchar(128) '$.systemInformation.spatialForamt'
          ,METADATA       nvarchar(max) '$.metadata' as json
         ) x
         cross apply OPENJSON(x.METADATA) y
         cross apply OPENJSON(y.value) 
                     with (
                       OWNER                        NVARCHAR(128)  '$.owner'
                      ,TABLE_NAME                   NVARCHAR(128)  '$.tableName'
                      ,COLUMN_NAMES_ARRAY           NVARCHAR(MAX)  '$.columnNames' as json
                      ,DATA_TYPES_ARARY             NVARCHAR(MAX)  '$.dataTypes' as json
                      ,SIZE_CONSTRAINTS_ARRAY       NVARCHAR(MAX)  '$.sizeConstraints' as json
                     ) v;

  SET @SQL_STATEMENT = CONCAT('if not exists (select 1 from sys.schemas where name = N''',@TARGET_DATABASE,''') exec(''create schema "',@TARGET_DATABASE,'"'')')
  begin TRY 
    EXEC(@SQL_STATEMENT)
    SET @LOG_ENTRY = (
      select @TARGET_DATABASE as [ddl.tableName], @SQL_STATEMENT as [ddl.sqlStatement] 
        for JSON PATH, INCLUDE_NULL_VALUES
    )
    SET @RESULTS = JSON_MODIFY(@RESULTS,'append $',JSON_QUERY(@LOG_ENTRY,'$[0]'))
  end TRY
  begin CATCH  
    SET @LOG_ENTRY = (
      select 'FATAL' as 'error.severity', @TARGET_DATABASE as [error.tableName], @SQL_STATEMENT as [error.sqlStatement], ERROR_NUMBER() as [error.code], ERROR_MESSAGE() as [error.msg], CONCAT(ERROR_PROCEDURE(),'. Line: ', ERROR_LINE(),'. State',ERROR_STATE(),'. Severity:',ERROR_SEVERITY(),'.') as [error.details]
        for JSON PATH, INCLUDE_NULL_VALUES
    )
    SET @RESULTS = JSON_MODIFY(@RESULTS,'append $',JSON_QUERY(@LOG_ENTRY,'$[0]'))
  end CATCH
        
  SET QUOTED_IDENTIFIER ON; 
  begin TRY
    OPEN FETCH_METADATA;
    FETCH FETCH_METADATA INTO @TABLE_NAME, @STATEMENTS

    WHILE @@FETCH_STATUS = 0 
    begin 
      SET @ROW_COUNT = 0;
      SET @SQL_STATEMENT = JSON_VALUE(@STATEMENTS,'$.ddl')
      begin TRY 
        EXEC(@SQL_STATEMENT)
        SET @LOG_ENTRY = (
          select @TABLE_NAME as [ddl.tableName], @SQL_STATEMENT as [ddl.sqlStatement] 
             for JSON PATH, INCLUDE_NULL_VALUES
        )
        SET @RESULTS = JSON_MODIFY(@RESULTS,'append $',JSON_QUERY(@LOG_ENTRY,'$[0]'))
      end TRY
      begin CATCH  
        SET @LOG_ENTRY = (
          select 'FATAL' as 'error.severity', @TABLE_NAME as [error.tableName], @SQL_STATEMENT as [error.sqlStatement], ERROR_NUMBER() as [error.code], ERROR_MESSAGE() as [error.msg], CONCAT(ERROR_PROCEDURE(),'. Line: ', ERROR_LINE(),'. State',ERROR_STATE(),'. Severity:',ERROR_SEVERITY(),'.') as [error.details]
             for JSON PATH, INCLUDE_NULL_VALUES
        )
        SET @RESULTS = JSON_MODIFY(@RESULTS,'append $',JSON_QUERY(@LOG_ENTRY,'$[0]'))
      end CATCH
      
      begin TRY 
        SET @START_TIME = SYSUTCDATETIME();
        SET @SQL_STATEMENT = JSON_VALUE(@STATEMENTS,'$.dml')
        EXEC(@SQL_STATEMENT)
        SET @ROW_COUNT = @@ROWCOUNT;
        SET @END_TIME = SYSUTCDATETIME();
        SET @ELAPSED_TIME = DATEDIFF(MILLISECOND,@START_TIME,@END_TIME);
        SET @LOG_ENTRY = (
          select @TABLE_NAME as [dml.tableName], @ROW_COUNT as [dml.rowCount], @ELAPSED_TIME as [dml.elapsedTime], @SQL_STATEMENT  as [dml.sqlStatement]
             for JSON PATH, INCLUDE_NULL_VALUES
          )
        SET @RESULTS = JSON_MODIFY(@RESULTS,'append $',JSON_QUERY(@LOG_ENTRY,'$[0]'))
      end TRY  
      begin CATCH  
        SET @LOG_ENTRY = (
          select 'FATAL' as 'error.severity', @TABLE_NAME as [error.tableName],@SQL_STATEMENT  as [error.sqlStatement], ERROR_NUMBER() as [error.code], ERROR_MESSAGE() as [error.msg], CONCAT(ERROR_PROCEDURE(),'. Line: ', ERROR_LINE(),'. Severity:',ERROR_SEVERITY(),'.') as [error.details]
             for JSON PATH, INCLUDE_NULL_VALUES
        )
        SET @RESULTS = JSON_MODIFY(@RESULTS,'append $',JSON_QUERY(@LOG_ENTRY,'$[0]'))
      end CATCH

      FETCH FETCH_METADATA INTO @TABLE_NAME, @STATEMENTS
    end;
   
    CLOSE FETCH_METADATA;
    DEALLOCATE FETCH_METADATA;
   
  end TRY 
  begin CATCH
    SET @LOG_ENTRY = (
      select 'FATAL' as 'error.severity', ERROR_PROCEDURE() as [error.tableName], ERROR_NUMBER() as [error.code], ERROR_MESSAGE() as [error.msg], CONCAT(ERROR_PROCEDURE(),'. Line: ', ERROR_LINE(),'. Severity:',ERROR_SEVERITY(),'.') as [error.details]
        for JSON PATH, INCLUDE_NULL_VALUES
    )
    SET @RESULTS = JSON_MODIFY(@RESULTS,'append $',JSON_QUERY(@LOG_ENTRY,'$[0]'))
  end CATCH
--
  SELECT @RESULTS;
end
--
go
--
EXECUTE sp_ms_marksystemobject 'sp_IMPORT_JSON'
go
--
create OR ALTER FUNCTION sp_GENERATE_SQL(@TARGET_DATABASE VARCHAR(128), @SPATIAL_FORMAT NVARCHAR(128), @METADATA NVARCHAR(MAX),@DB_COLLATION NVARCHAR(32)) 
returns NVARCHAR(MAX)
as
begin
  DECLARE @OWNER            VARCHAR(128);
  DECLARE @TABLE_NAME       VARCHAR(128);
  DECLARE @STATEMENTS       NVARCHAR(MAX);
  
  DECLARE @RESULTS          NVARCHAR(MAX) = '{}'
                            
  DECLARE FETCH_METADATA 
  CURSOR FOR 
  select TABLE_NAME, 
         master.dbo.sp_GENERATE_STATEMENTS(VENDOR, @TARGET_DATABASE, v.TABLE_NAME, @SPATIAL_FORMAT, v.COLUMN_NAMES_ARRAY, v.DATA_TYPES_ARARY, v.SIZE_CONSTRAINTS_ARRAY,@DB_COLLATION) as STATEMENTS
  from  OPENJSON(@METADATA) 
         with (
           METADATA      nvarchar(max) '$.metadata' as json
         ) x
         cross apply OPENJSON(x.METADATA) y
         cross apply OPENJSON(y.value) 
                     with(
                       VENDOR                       NVARCHAR(128)  '$.vendor'
                      ,OWNER                        NVARCHAR(128)  '$.owner'
                      ,TABLE_NAME                   NVARCHAR(128)  '$.tableName'
                      ,COLUMN_NAMES_ARRAY           NVARCHAR(MAX)  '$.columnNames' as json
                      ,DATA_TYPES_ARARY             NVARCHAR(MAX)  '$.dataTypes' as json
                      ,SIZE_CONSTRAINTS_ARRAY       NVARCHAR(MAX)  '$.sizeConstraints' as json
                     ) v;
 
  SET QUOTED_IDENTIFIER ON; 
  OPEN FETCH_METADATA;
  FETCH FETCH_METADATA INTO @TABLE_NAME, @STATEMENTS

  WHILE @@FETCH_STATUS = 0 
  begin 
    SET @RESULTS = JSON_MODIFY(@RESULTS,concat('lax $."',@TABLE_NAME,'"'),JSON_Query(@STATEMENTS))
    FETCH FETCH_METADATA INTO @TABLE_NAME, @STATEMENTS
  end;
   
  CLOSE FETCH_METADATA;
  DEALLOCATE FETCH_METADATA;
    
  RETURN @RESULTS;
end
--
go
--
EXECUTE sp_ms_marksystemobject 'sp_GENERATE_SQL'
go
--
EXIT