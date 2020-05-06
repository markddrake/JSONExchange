"use strict" 
const fs = require('fs');
const path = require('path');
const Readable = require('stream').Readable;
const util = require('util')
const { performance } = require('perf_hooks');const async_hooks = require('async_hooks');

/* 
**
** Require Database Vendors API 
**
*/

const YadamuLibrary = require('./yadamuLibrary.js');
const {YadamuError, CommandLineError, ConfigurationFileError, ConnectionError} = require('./yadamuError.js');
const DBParser = require('./dbParser.js');

const DEFAULT_BATCH_SIZE   = 10000;
const DEFAULT_COMMIT_COUNT = 5;

/*
**
** YADAMU Database Inteface class 
**
**
*/

class YadamuDBI {
    
  get PASSWORD_KEY_NAME()   { return 'password' };
  get DATABASE_VENDOR()     { return undefined };
  get SOFTWARE_VENDOR()     { return undefined };
  get SPATIAL_FORMAT()      { return spatialFormat };
  get EXPORT_VERSION()      { return this.yadamu.EXPORT_VERSION }
  get DEFAULT_PARAMETERS()  { return this.yadamu.getYadamuDefaults().yadmuDBI }
  get STATEMENT_TERMINATOR() { return '' }
  
  traceSQL(msg) {
     // this.yadamuLogger.trace([this.DATABASE_VENDOR,'SQL'],msg)
     return(`${msg.trim()}${this.sqlTraceTag} ${this.sqlTerminator}`);
  }
  
  traceTiming(startTime,endTime) {      
    const sqlOperationTime = endTime - startTime;
    if (this.status.sqlTrace) {
      this.status.sqlTrace.write(`--\n--${this.sqlTraceTag} Elapsed Time: ${YadamuLibrary.stringifyDuration(sqlOperationTime)}s.\n--\n`);
    }
    this.sqlCumlativeTime = this.sqlCumlativeTime + sqlOperationTime
  }
 
  traceComment(comment) {
    return `/* ${comment} */\n`
  }
  
  doTimeout(milliseconds) {
    
     const self = this

     return new Promise(function (resolve,reject) {
        self.yadamuLogger.info([`${self.constructor.name}.doTimeout()`],`Sleeping for ${YadamuLibrary.stringifyDuration(milliseconds)}ms.`);
        setTimeout(
          function() {
           self.yadamuLogger.info([`${self.constructor.name}.doTimeout()`],`Awake.`);
           resolve();
          },
          milliseconds
       )
     })  
  }
 
  decomposeDataType(targetDataType) {
    
    const results = {};
    let components = targetDataType.split('(');
    results.type = components[0].split(' ')[0];
    if (components.length > 1 ) {
      components = components[1].split(')');
      if (components.length > 1 ) {
        results.qualifier = components[1]
      }
      components = components[0].split(',');
      if (components.length > 1 ) {
        results.length = parseInt(components[0]);
        results.scale = parseInt(components[1]);
      }
      else {
        if (components[0] === 'max') {
          results.length = -1;
        }
        else {
          results.length = parseInt(components[0])
        }
      }
    }           
    return results;      
    
  } 
  
  decomposeDataTypes(targetDataTypes) {
     return targetDataTypes.map(function (targetDataType) {
       return this.decomposeDataType(targetDataType)
     },this)
  }
  
  processError(yadamuLogger,logEntry,counters,logDDL) {
	 
	let warning = true;
	  
    switch (logEntry.severity) {
      case 'CONTENT_TOO_LARGE' :
        yadamuLogger.error([`${this.constructor.name}`,`${logEntry.severity}`,`${logEntry.tableName ? logEntry.tableName : ''} `],`This database does not support VARCHAR2 values longer than ${this.maxStringSize} bytes.`)
        return;
      case 'SQL_TOO_LARGE':
        yadamuLogger.error([`${this.constructor.name}`,`${logEntry.severity}`,`${logEntry.tableName ? logEntry.tableName : ''} `],`This database is not configured for DLL statements longer than ${this.maxStringSize} bytes.`)
        return;
      case 'FATAL':
        counters.errors++
        yadamuLogger.error([`${this.constructor.name}`,`${logEntry.severity}`,`${logEntry.tableName ? logEntry.tableName : ''}`],`Details: ${logEntry.msg}\n${logEntry.details}\n${logEntry.sqlStatement}`)
        return
      case 'WARNING':
        counters.warnings++
        break;
      case 'IGNORE':
        counters.warnings++
        break;
      case 'DUPLICATE':
        counters.duplicates++
        break;
      case 'REFERENCE':
        counters.reference++
        break;
      case 'AQ RELATED':
        counters.aq++
        break;
      case 'RECOMPILATION':
        counters.recompilation++
        break;
      default:
	    warning = false
    }
    if (logDDL) { 
	  if (warning) {
        yadamuLogger.warning([`${this.constructor.name}`,`${logEntry.severity}`,`${logEntry.tableName ? logEntry.tableName : ''}`],`Details: ${logEntry.msg}\n${logEntry.details}${logEntry.sqlStatement}`)
	  }
	  else {
        yadamuLogger.info([`${this.constructor.name}`,`${logEntry.severity}`,`${logEntry.tableName ? logEntry.tableName : ''}`],`Details: ${logEntry.msg}\n${logEntry.details}${logEntry.sqlStatement}`)
	  }
	}
  }
          
  processLog(log,status,yadamuLogger) {

    const logDML         = (status.loglevel && (status.loglevel > 0));
    const logDDL         = (status.loglevel && (status.loglevel > 1));
    const logDDLMsgs     = (status.loglevel && (status.loglevel > 2));
    const logTrace       = (status.loglevel && (status.loglevel > 3));

    if (status.dumpFileName) {
      fs.writeFileSync(status.dumpFileName,JSON.stringify(log));
    }
     
    const counters = {
       errors        : 0
      ,warnings      : 0
      ,ignoreable    : 0
      ,duplicates    : 0
      ,reference     : 0
      ,aq            : 0
      ,recompilation : 0
    };
      
	log.forEach(function(result) { 
      const logEntryType = Object.keys(result)[0];
      const logEntry = result[logEntryType];
      switch (true) {
        case (logEntryType === "message") : 
          yadamuLogger.info([`${this.constructor.name}`],`: ${logEntry}.`)
          break;
        case (logEntryType === "dml") : 
          yadamuLogger.info([`${this.constructor.name}`,`${logEntry.tableName}`],`Rows ${logEntry.rowCount}. Elaspsed Time ${YadamuLibrary.stringifyDuration(Math.round(logEntry.elapsedTime))}s. Throughput ${Math.round((logEntry.rowCount/Math.round(logEntry.elapsedTime)) * 1000)} rows/s.`)
          break;
        case (logEntryType === "info") :
          yadamuLogger.info([`${this.constructor.name}`],`"${JSON.stringify(logEntry)}".`);
          break;
        case (logDML && (logEntryType === "dml")) :
          yadamuLogger.dml([`${this.constructor.name}`,`${logEntry.tableName}`,`${logEntry.tableName}`],`\n${logEntry.sqlStatement}.`)
          break;
        case (logDDL && (logEntryType === "ddl")) :
          yadamuLogger.ddl([`${this.constructor.name}`,`${logEntry.tableName}`],`\n${logEntry.sqlStatement}.`) 
          break;
        case (logTrace && (logEntryType === "trace")) :
          yadamuLogger.trace([`${this.constructor.name}`,`${logEntry.tableName ? logEntry.tableName : ''}`],`\n${logEntry.sqlStatement}.`)
          break;
        case (logEntryType === "error"):
		  this.processError(yadamuLogger,logEntry,counters,logDDLMsgs);
      } 
      if ((status.sqlTrace) && (logEntry.sqlStatement)) { 
        status.sqlTrace.write(this.traceSQL(logEntry.sqlStatement))
      }
    },this) 
	return counters;
  }    

  logConnectionProperties() {    
    if (this.status.sqlTrace) {
      const pwRedacted = Object.assign({},this.connectionProperties)
      delete pwRedacted.password
      this.status.sqlTrace.write(this.traceComment(`Connection Properies: ${JSON.stringify(pwRedacted)}`))
    }
  }
     
  setConnectionProperties(connectionProperties) {
    if (Object.getOwnPropertyNames(connectionProperties).length > 0) {    
      this.connectionProperties = connectionProperties 
    }
  }
  
  getConnectionProperties() {
    this.connectionProperties = {}
  }
  
  isValidDDL() {
    return (this.systemInformation.vendor === this.DATABASE_VENDOR)
  }
  
  isDatabase() {
    return true;
  }
  
  objectMode() {
    return true;
  }
  
  setSystemInformation(systemInformation) {
    this.systemInformation = systemInformation
  }
  
  setMetadata(metadata) {
    this.metadata = metadata
    if (this.tableMappings) {
      this.applyTableMappings()
    }
    else {
      this.validateIdentifiers()
    }
  }
  
  validateIdentifiers() {
  }
  
  setParameters(parameters) {
     Object.assign(this.parameters, parameters ? parameters : {})
  }
  
  loadTableMappings(mappingFile) {
    this.tableMappings = require(path.resolve(mappingFile));
  }

  setTableMappings(tableMappings) {
    this.tableMappings = tableMappings
  }

  reverseTableMappings() {

    if (this.tableMappings !== undefined) {
      const reverseMappings = {}
      Object.keys(this.tableMappings).forEach(function(table) {
        const newKey = this.tableMappings[table].tableName
        reverseMappings[newKey] = { "tableName" : table};
        if (this.tableMappings[table].columns) {
          const columns = {};
          Object.keys(this.tableMappings[table].columns).forEach(function(column) {
            const newKey = this.tableMappings[table].columns[column]
            columns[newKey] = column;
          },this);
          reverseMappings[newKey].columns = columns
        }
      },this)
      return reverseMappings;
    }
    return this.tableMappings;
  }
    
  applyTableMappings() {
    
    const tables = Object.keys(this.metadata)
    tables.forEach(function(table) {
      const tableMappings = this.tableMappings[table]
      if (tableMappings) {
        this.metadata[table].tableName = tableMappings.tableName
        if (tableMappings.columns) {
          const columns = JSON.parse('[' + this.metadata[table].columns + ']');
          Object.keys(tableMappings.columns).forEach(function(columnName) {
            const idx = columns.indexOf(columnName);
            if (idx > -1) {
              columns[idx] = tableMappings.columns[columnName]                
            }
          },this);
          this.metadata[table].columns = '"' + columns.join('","') + '"';
        }
      }   
    },this);   
  }
  
  async executeDDLImpl(ddl) {
    await Promise.all(ddl.map(async function(ddlStatement) {
      try {
        ddlStatement = ddlStatement.replace(/%%SCHEMA%%/g,this.parameters.TO_USER);
        if (this.status.sqlTrace) {
          this.status.sqlTrace.write(this.traceSQL(ddlStatement));
        }
        this.executeSQL(ddlStatement,{});
      } catch (e) {
        this.yadamuLogger.logException([`${this.constructor.name}.executeDDL()`],e)
        this.yadamuLogger.writeDirect(`${ddlStatement}\n`)
      } 
    },this))
  }
  
  async executeDDL(ddl) {
    const startTime = performance.now();
    await this.executeDDLImpl(ddl);
    this.yadamuLogger.ddl([`${this.constructor.name}.executeDDL()`],`Executed ${ddl.length} DDL statements. Elapsed time: ${YadamuLibrary.stringifyDuration(performance.now() - startTime)}s.`);
  }
  
  setOption(name,value) {
    this.options[name] = value;
  }
    
  initializeParameters(parameters) {
    
    // In production mode the Databae default parameters are merged with the command Line Parameters loaded by YADAMU.

    this.parameters = this.yadamu.cloneDefaultParameters();
    
    // Merge parameters from configuration files
    Object.assign(this.parameters, parameters ? parameters : {})

    // Merge Command line arguments
    Object.assign(this.parameters, this.yadamu.getCommandLineParameters());
    
  }
  
  constructor(yadamu,parameters) {
    
    this.options = {
      recreateTargetSchema : false
    }
    
    this.spatialFormat = this.SPATIAL_FORMAT 
    this.yadamu = yadamu;
    this.sqlTraceTag = '';
    this.status = yadamu.getStatus()
    this.yadamuLogger = yadamu.getYadamuLogger();
    this.initializeParameters(parameters);
    this.systemInformation = undefined;
    this.metadata = undefined;
    this.attemptReconnection = this.setReconnectionState()
    this.connectionProperties = this.getConnectionProperties()   
    this.connection = undefined;

    this.statementCache = undefined;
	
	// Track Transaction and Savepoint state.
	// Needed to restore transacation state when reconnecting.
	
	this.transactionInProgress = false;
	this.savePointSet = false;
 
    this.tableName  = undefined;
    this.tableInfo  = undefined;
    this.insertMode = 'Empty';
    this.skipTable = true;

    this.tableMappings = undefined;
    if (this.parameters.MAPPINGS) {
      this.loadTableMappings(this.parameters.MAPPINGS);
    }   
 
    this.sqlCumlativeTime = 0
    this.sqlTerminator = `\n${this.STATEMENT_TERMINATOR}\n`
  }

  enablePerformanceTrace() { 
    const self = this;
    this.asyncHook = async_hooks.createHook({
      init(asyncId, type, triggerAsyncId, resource) {self.reportAsyncOperation(asyncId, type, triggerAsyncId, resource)}
    }).enable();
  }

  reportAsyncOperation(...args) {
     fs.writeFileSync(this.parameters.PERFORMANCE_TRACE, `${util.format(...args)}\n`, { flag: 'a' });
  }
  
  async getDatabaseConnectionImpl() {
    try {
      await this.createConnectionPool();
      this.connection = await this.getConnectionFromPool();
      await this.configureConnection();
    } catch (e) {
      const err = new ConnectionError(e,this.connectionProperties);
      throw err
    }

  }  

  waitForRestart(delayms) {
    return new Promise(function (resolve, reject) {
        setTimeout(resolve, delayms);
    });
  }
  
  setReconnectionState() {
	  
    switch (this.parameters.READ_ON_ERROR) {
	  case undefined:
	  case 'ABORT':
		return false;
	  case 'SKIP':
	  case 'FLUSH':
	    return true;
		break;
	  default:
	    return false;
	}
  }
  
  async reconnectImpl() {
    throw new Error(`Database Reconnection Not Implimented for ${this.DATABASE_VENDOR}`)
  }
  
  async reconnect(cause) {

    let retryCount = 0;
    let connectionUnavailable 
    
    const transactionInProgress = this.transactionInProgress 
    const savePointSet = this.savePointSet
	
	this.reconnectInProgress = true;
	this.attemptReconnection = false
    this.yadamuLogger.warning([`${this.constructor.name}.reconnect()`],`SQL Operation raised: ${cause}`);
	
	if (this.currentTable && this.currentTable.lostConnection && (typeof this.currentTable.lostConnection === 'function')) {
	  this.currentTable.lostConnection();
	}
	 
    while (retryCount < 10) {
	  try {
        this.yadamuLogger.info([`${this.constructor.name}.reconnect()`],`Attemping reconnection.`);
        await this.reconnectImpl()
	    await this.configureConnection();
		if (transactionInProgress) {
		  await this.beginTransaction()
		}
		if (savePointSet) {
		  await this.createSavePoint()
		}
        this.reconnectInProgress = false;
        this.yadamuLogger.info([`${this.constructor.name}.reconnect()`],`${this.DATABASE_VENDOR} service. New connection availabe.`);
        this.attemptReconnection = this.setReconnectionState()
		return;
      } catch (connectionFailure) {
		if (connectionFailure.serverUnavailable()) {
		  connectionUnavailable = connectionFailure;
          this.yadamuLogger.warning([`${this.constructor.name}.reconnect()`],`${this.DATABASE_VENDOR} service unavailable. Waiting for restart.`)
          await this.waitForRestart(5000);
          retryCount++;
        }
        else {
   	      this.reconnectInProgress = false;
          this.yadamuLogger.logException([`${this.constructor.name}.reconnect()`,`${this.constructor.name}.reconnectImpl()`],connectionFailure);
          this.attemptReconnection = this.setReconnectionState()
          throw connectionFailure;
        }
      }
    }
    // this.yadamuLogger.trace([`${this.constructor.name}.reconnectImpl()`],`Unable to re-establish connection.`)
    this.reconnectInProgress = false;
    this.attemptReconnection = this.setReconnectionState()
    throw connectionUnavailable 	
  }
  
  async getDatabaseConnection(requirePassword) {
                
    let interactiveCredentials = (requirePassword && ((this.connectionProperties[this.PASSWORD_KEY_NAME] === undefined) || (this.connectionProperties[this.PASSWORD_KEY_NAME].length === 0))) 
    let retryCount = interactiveCredentials ? 3 : 1;
    
    let prompt = `Enter password for ${this.DATABASE_VENDOR} connection: `
    while (retryCount > 0) {
      retryCount--
      if (interactiveCredentials)  {
        const pwQuery = this.yadamu.createQuestion(prompt);
        const password = await pwQuery;
        this.connectionProperties[this.PASSWORD_KEY_NAME] = password;
      }
      try {
        await this.getDatabaseConnectionImpl()  
        return;
      } catch (e) {     
        switch (retryCount) {
          case 0: 
            if (interactiveCredentials) {
              throw new CommandLineError(`Unable to establish connection to ${this.DATABASE_VENDOR} after 3 attempts. Operation aborted.`);
              break;
            }
            else {
              throw (e)
            }
            break;
          case 1:
            console.log(`Database Error: ${e.message}`)
            break;
          case 2:           
            prompt = `Unable to establish connection. Re-${prompt}`;
            console.log(`Database Error: ${e.message}`)
            break;
          default:
            throw e
        }
      } 
    }
  }
    
  /*  
  **
  **  Connect to the database. Set global setttings
  **
  */

  async initialize(requirePassword) {

    if (this.status.sqlTrace) {
       if (this.status.sqlTrace._writableState.ended === true) {
         this.status.sqlTrace = fs.createWriteStream(this.status.sqlTrace.path,{"flags":"a"})
       }
    }
    
    /*
    **
    ** Calculate CommitSize
    **
    */
    
    let batchSize = this.parameters.BATCH_SIZE ? Number(this.parameters.BATCH_SIZE) : DEFAULT_BATCH_SIZE
    batchSize = isNaN(batchSize) ? DEFAULT_BATCH_SIZE : batchSize
    batchSize = batchSize < 0 ? DEFAULT_BATCH_SIZE : batchSize
    batchSize = !Number.isInteger(batchSize) ? DEFAULT_BATCH_SIZE : batchSize
    this.batchSize = batchSize
    
    let commitCount = this.parameters.BATCH_COMMIT ? Number(this.parameters.BATCH_COMMIT) : DEFAULT_COMMIT_COUNT
    commitCount = isNaN(commitCount) ? DEFAULT_COMMIT_COUNT : commitCount
    commitCount = commitCount < 0 ? DEFAULT_COMMIT_COUNT : commitCount
    commitCount = !Number.isInteger(commitCount) ? DEFAULT_COMMIT_COUNT : commitCount
    this.commitSize = this.batchSize * commitCount
    
    if (this.parameters.PARAMETER_TRACE === true) {
      this.yadamuLogger.writeDirect(`${util.inspect(this.parameters,{colors:true})}\n`);
    }
    
    if (this.parameters.PERFORMANCE_TRACE) {
      this.enablePerformanceTrace();
    }
    
    if (this.isDatabase()) {
      await this.getDatabaseConnection(requirePassword);
    }
  }

  /*
  **
  **  Gracefully close down the database connection.
  **
  */

  async finalize() {
    throw new Error('Unimplemented Method')
  }

  /*
  **
  **  Abort the database connection.
  **
  */

  async abort(cause) {
    if (cause instanceof Error) {
      this.yadamuLogger.logException([`${this.constructor.name}`,`ABORT`],`Cause:`)
      this.yadamuLogger.logException(e)
    }
  }

  /*
  **
  ** Begin the current transaction
  **
  */
  
  async beginTransaction() {
	this.transactionInProgress = true;  
	this.savePointSet = false;
  }

  /*
  **
  ** Commit the current transaction
  **
  */
    
  async commitTransaction() {
	this.transactionInProgress = false;  
	this.savePointSet = false;
  }

  /*
  **
  ** Abort the current transaction
  **
  */
  
  async rollbackTransaction(cause) {
	this.transactionInProgress = false;  
	this.savePointSet = false;
  }
  
  /*
  **
  ** Set a Save Point
  **
  */
    
  async createSavePoint() {
	this.savePointSet = true;
  }

  /*
  **
  ** Revert to a Save Point
  **
  */

  async restoreSavePoint(cause) {
	this.savePointSet = false;
  }

  async releaseSavePoint(cause) {
	this.savePointSet = false;
  }

  /*
  **
  ** The following methods are used by JSON_TABLE() style import operations  
  **
  */

  /*
  **
  **  Upload a JSON File to the server. Optionally return a handle that can be used to process the file
  **
  */
  
  async uploadFile(importFilePath) {
    throw new Error('Unimplemented Method')
  }
  
  /*
  **
  **  Process a JSON File that has been uploaded to the server. 
  **
  */

  async processFile(hndl) {
    throw new Error('Unimplemented Method')
  }
  
  /*
  **
  ** The following methods are used by the YADAMU DBReader class
  **
  */
  
  /*
  **
  **  Generate the SystemInformation object for an Export operation
  **
  */
  
  async getSystemInformation(EXPORT_VERSION) {     
    throw new Error('Unimplemented Method')
  }

  /*
  **
  **  Generate a set of DDL operations from the metadata generated by an Export operation
  **
  */

  async getDDLOperations() {
    // Undefined means database does not provide mechanism to obtain DDL statements. Different to returning an empty Array.
    return undefined
  }
  
  async getSchemaInfo() {
    return []
  }

  generateMetadata(tableInfo,server) {    
    return {}
  }
   
  generateSelectStatement(tableMetadata) {
     return tableMetadata;
  }   

  createParser(query,objectMode) {
    return new DBParser(query,objectMode,this.yadamuLogger);      
  }
  
  forceEndOnInputStreamError(error) {
	return false;
  }
  
  streamingError(e,stack,tableInfo) {
    return new DatabaseError(e,stack,tableInfo.SQL_STATEMENT)
  }
  
  async getInputStream(tableInfo,parser) {
    throw new Error('Unimplemented Method')
  }      

  freeInputStream(inputStream){
  }

  /*
  **
  ** The following methods are used by the YADAMU DBwriter class
  **
  */
  
  async initializeExport() {
  }
  
  async finalizeExport() {
  }
  
  /*
  **
  ** The following methods are used by the YADAMU DBWriter class
  **
  */
  
  async initializeImport() {
  }
  
  async initializeData() {
  }
  
  async finalizeData() {
  }

  async finalizeImport() {
  }
    
  async generateStatementCache(StatementGenerator,schema,executeDDL) {
    const statementGenerator = new StatementGenerator(this,schema,this.metadata,this.systemInformation.spatialFormat,this.batchSize, this.commitSize, this.status, this.yadamuLogger);
    this.statementCache = await statementGenerator.generateStatementCache(executeDDL,this.systemInformation.vendor)
  }

  async finalizeRead(tableInfo) {
  }

  getTableWriter(TableWriter,table) {
    const tableName = this.metadata[table].tableName 
    return new TableWriter(this,tableName,this.statementCache[tableName],this.status,this.yadamuLogger);
  }
  
  keepAlive(rowCount) {
  }

  configureTest(recreateSchema) {
    if (this.parameters.MAPPINGS) {
      this.loadTableMappings(this.parameters.MAPPINGS);
    }  
    if (this.parameters.SQL_TRACE) {
      this.status.sqlTrace = fs.createWriteStream(this.parameters.SQL_TRACE,{flags : "a"});
    }
    if (recreateSchema === true) {
      this.setOption('recreateSchema',true);
    }
  }
  
  async cloneMaster(dbi) {
	// dbi.master = this
	dbi.metadata = this.metadata
    dbi.schemaCache = this.schemaCache
    dbi.spatialFormat = this.spatialFormat
    dbi.statementCache = this.statementCache
    dbi.systemInformation = this.systemInformation
    dbi.sqlTraceTag = ` /* Slave [${this.slaveNumber}] */`;
	dbi.setParameters(this.parameters);
  }   

  async slaveDBI(slaveNumber,dbi,connection) {
      
    // Invoked on the DBI that is being cloned. Parameter dbi is the cloned interface.
      
    dbi.slaveNumber = slaveNumber
    dbi.connection = connection
    this.cloneMaster(dbi);
    await dbi.configureConnection();
    return dbi
  }
  
}

module.exports = YadamuDBI
