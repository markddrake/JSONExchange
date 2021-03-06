--
:setvar DATABASE Northwind
use $(database)$(ID1)
:setvar SCHEMA dbo
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
:setvar DATABASE AdventureWorks
use $(database)$(ID1)
:setvar SCHEMA Sales
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
:setvar SCHEMA Person
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
:setvar SCHEMA Production
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
:setvar SCHEMA Purchasing
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
:setvar SCHEMA HumanResources
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
:setvar DATABASE AdventureWorksDW
use $(database)$(ID1)
:setvar SCHEMA dbo
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
/*
**
** Dissable Command Line Testing for WorldWideImporters and WorldWideImportersDW
**
*/
quit
--
:setvar DATABASE WorldWideImporters
use $(database)$(ID1)
:setvar SCHEMA Application
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
:setvar SCHEMA Purchasing
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
:setvar SCHEMA Sales
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
:setvar SCHEMA Warehouses
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
:setvar DATABASE WorldWideImportersDW
use $(database)$(ID1)
:setvar SCHEMA Dimension
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
:setvar SCHEMA Fact
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
:setvar SCHEMA Integration
DECLARE @COMMENT NVARCHAR(128) ='$(METHOD)'
DECLARE @DATETIME_PRECISION INT = $(DATETIME_PRECISION)
DECLARE @SPATIAL_PRECISION INT = $(SPATIAL_PRECISION)
DECLARE @SOURCE_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID1)'
DECLARE @TARGET_DATABASE NVARCHAR(128) = '$(DATABASE)$(ID2)'
DECLARE @SOURCE_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @TARGET_SCHEMA NVARCHAR(128) = '$(SCHEMA)'
DECLARE @OPTIONS NVARCHAR(512) = concat('{"emptyStringIsNull": false,  "timestampPrecision": ',@DATETIME_PRECISION,',"spatialPrecision": ',@SPATIAL_PRECISION,',"doublePrecision": 18, "orderedJSON": true, "xmlRule": "DECODE_AND_STRIP_DECLARATION" }');
--
exec sp_COMPARE_SCHEMA TRUE, @SOURCE_DATABASE, @SOURCE_SCHEMA, @TARGET_DATABASE, @TARGET_SCHEMA, @COMMENT, @OPTIONS
go
--
quit

