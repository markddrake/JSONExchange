"use strict" 

const { Transform, PassThrough, finished } = require('stream');
const { performance } = require('perf_hooks');

const YadamuLibrary = require('../../common/yadamuLibrary.js');
const DBIConstants = require('../../common/dbiConstants.js');
const {CommandLineError} =  require('../../common/yadamuException.js');

class EventStream extends Transform {
  
  get INPUT_METRICS()                 { return this._INPUT_METRICS }
  set INPUT_METRICS(v) {
	this._INPUT_METRICS =  Object.assign({},v);
  }
  
  get TABLE_FILTER()                  { return this.dbWriter.dbi.TABLE_FILTER }
  
  constructor(yadamu) {

    super({objectMode: true });  
	this.yadamu = yadamu
    this.yadamuLogger = this.yadamu.LOGGER
	this.rowsRead = 0
  }

  pipe(outputStream,options) {
	// Cache the target outputStream
  	// this.yadamuLogger.trace([this.constructor.name,outputStream.constructor.name,outputStream.tableName],'Attaching pipe')
	this.outputStream = outputStream
	if (this.dbWriter === undefined) {
	  this.dbWriter = outputStream;
	}
	return super.pipe(outputStream,options);
  } 
  
  async createWriter(tableName) {
    // const writer = this.dbWriter.dbi.getOutputStream(tableName,this.dbWriter.ddlComplete)
	const writers = await this.dbWriter.dbi.getOutputStreams(tableName,this.dbWriter.ddlComplete)	
	const writer = writers[0]
	this.terminalStream = writers[writers.length-1]
	let nextStream = writers.shift()
	while (writers.length > 0) {
	  nextStream = nextStream.pipe(writers.pop());
	  this.dbWriter.listeners('error').forEach((f) => {nextStream.on('error',f)});	
    }
    // Propigate Error event Handlers from dbWriter to writer
    this.dbWriter.listeners('error').forEach((f) => {writer.on('error',f)});	
	return writer
  }
  
  async createTransformations(tableName) {

    // this.yadamuLogger.trace([this.constructor.name,tableName],'createTransformations()')
	  
	const tableMetadata = this.metadata[tableName]
	this.transformations = tableMetadata.dataTypes.map((targetDataType,idx) => {

      const dataType = YadamuLibrary.decomposeDataType(targetDataType);

	  if (YadamuLibrary.isBinaryType(dataType.type)) {
        return (row,idx) =>  {
  		  row[idx] = Buffer.from(row[idx],'hex')
		}
      }

	  switch (dataType.type.toUpperCase()) {
        case "GEOMETRY":
        case "GEOGRAPHY":
		case "POINT":
        case "LSEG":
        case "BOX":
        case "PATH":
        case "POLYGON":
        case "LINESTRING":
		case "MULTIPOINT":
        case "MULTILINESTRING":
        case "MULTIPOLYGON":
        case "GEOMETRYCOLLECTION":
        case "GEOMCOLLECTION":
        case '"MDSYS"."SDO_GEOMETRY"':
          if (this.spatialFormat.endsWith('WKB')) {
            return (row,idx)  => {
  		      row[idx] = Buffer.from(row[idx],'hex')
			}
          }
		  return null;
        case "CIRCLE":
		  if (this.circleFormat === 'CIRCLE') { 
            return null;
		  }
          if (this.spatialFormat.endsWith('WKB')) {
            return (row,idx)  => {
  		      row[idx] = Buffer.from(row[idx],'hex')
			}
          }
		  return null;
		case "REAL":
        case "FLOAT":
		case "DOUBLE":
		case "DOUBLE PRECISION":
		case "BINARY_FLOAT":
		case "BINARY_DOUBLE":
		   return (row, idx) => {
//			 if (!isFinite(row[idx])) {
			   switch (row[idx]) {
		         case "NaN":
		   	       row[idx] = 0/0
				   break;
			     case "Infinity":
				   row[idx] = 1/0
				   break;
				 case "-Infinity":
				   row[idx] = -1/0
				   break;
				 default:
			   }   
//		     }
		   }			 
   		 default:
		   return null
      }
    }) 
	
	// Use a dummy rowTransformation function if there are no transformations required.

	this.rowTransformation = this.transformations.every((currentValue) => { currentValue === null}) ? (row) => {} : (row) => {
      this.transformations.forEach((transformation,idx) => {
        if ((transformation !== null) && (row[idx] !== null)) {
          transformation(row,idx)
        }
      }) 
    }	  
	
  }
  
  filterTables(data) {
	
	// Restrict operations to the list of tables specified.
	// Order operations according to the order in which the tables were specified
		
    if (this.TABLE_FILTER.length > 0) {
	  
	  // Check table names are valid.
	  // For each name in the Table Filter check there is a corresponding entry in the schemaInfoormation collection
	  
	  const tableNames = Object.keys(data.metadata)

	  const invalidTableNames = this.TABLE_FILTER.filter((tableName) => {
		 // Return true if the table does not have an entry in the schemaInformstion collection
		 return !tableNames.includes(tableName)
	  })
	  
	  if (invalidTableNames.length > 0) {
        throw new CommandLineError(`Could not resolve the following table names : "${invalidTableNames}".`)
      }
	
      this.yadamuLogger.info(['FILE'],`Operations restricted to the following tables: ${JSON.stringify(this.TABLE_FILTER)}.`)
	  	 
      const metadata = {}
	  this.TABLE_FILTER.forEach((table) => {
         metadata[table] = data.metadata[table]
	  })
	  return {metadata: metadata}
	}
	return data
  }
  
  forwardRow(data) {
    this.rowsRead++
    this.rowTransformation(data.data)
	const state = this.push(data);
  }
  
  skipRow(data) {
  }
  
  processRow = this.forwardRow
  
  async _transform (data,encoding,callback)  {
	let messageType
	try {
	  messageType = Object.keys(data)[0]
	  // this.yadamuLogger.trace([this.constructor.name,'_transform()'],`${messageType}`)
	  switch (messageType) {
	    case 'data':
		  this.processRow(data)
 	      break;
        case 'systemInformation' :
          this.push(data)
	  	  this.spatialFormat = data.systemInformation.typeMappings.spatialFormat
		  this.circleFormat = data.systemInformation.typeMappings.circleFormat
	  	  this.yadamu.REJECTION_MANAGER.setSystemInformation(data.systemInformation)
	  	  this.yadamu.WARNING_MANAGER.setSystemInformation(data.systemInformation)
 	      break;
        case 'metadata' :		
          data = this.filterTables(data)
          this.push(data)
	  	  this.unpipe();
	      this.metadata = data.metadata
	  	  this.yadamu.REJECTION_MANAGER.setMetadata(data.metadata)
	  	  this.yadamu.WARNING_MANAGER.setMetadata(data.metadata)
	  	  // Wait for DDL Complete and then release the DBWriter by invoking the deferredCallback
		  if ((this.yadamu.MODE === 'DDL_ONLY') || (YadamuLibrary.isEmpty(this.metadata))) {
    		await this.dbWriter.ddlComplete
	        this.pipe(this.dbWriter);
	      }
	      break;
        case 'table':
          if (this.metadata.hasOwnProperty(data.table)) {
            // Table is in the list of tables to be processed.
			this.skipTable = false;
  		    this.processRow = this.forwardRow
		    // Attach new Writer - Couldnot get this work with 'drain' for some reason
		    this.unpipe(this.outputStream);
	  	    const writer = await this.createWriter(data.table)
  		    this.INPUT_METRICS = DBIConstants.NEW_TIMINGS
		    writer.setReaderMetrics(this.INPUT_METRICS)
   	        this.INPUT_METRICS.parserStartTime = performance.now();
	  	    this.pipe(writer) 
	  	    this.push(data)
	  	    this.createTransformations(data.table)
	      }
		  else {
     		this.skipTable = true;
			this.processRow = this.skipRow
		  }
          this.rowsRead = 0;
	      break;
        case 'eod':
		  // Simulate an 'end' condition and report results for the current table.
		  if (!this.skipTable) {
		    const outputStream = this.outputStream
            outputStream.on('error',(err) => { console.log(err) })
            this.INPUT_METRICS.rowsRead = this.rowsRead;
		    this.INPUT_METRICS.pipeStartTime = data.eod.startTime
		    this.INPUT_METRICS.readerStartTime = data.eod.startTime;
		    this.INPUT_METRICS.readerEndTime = data.eod.endTime;
	        this.INPUT_METRICS.parserEndTime = performance.now();
      	    
			const allDataReceived = new Promise((resolve,reject) => {
	          outputStream.once('allDataReceived',() => {
	            // this.yadamuLogger.trace([this.constructor.name,outputStream.constructor.name,outputStream.tableName,'ON'],'allDataReceived')
			    resolve()
	  	      })
	        })
			
            this.push(data);

            // this.yadamuLogger.trace([this.constructor.name,outputStream.constructor.name,outputStream.tableName],`Waiting for 'allDataReceived'`)
	  	    await allDataReceived;
  		    // this.yadamuLogger.trace([this.constructor.name,outputStream.constructor.name,outputStream.tableName],`allDataReceived'`)
			
			const writerComplete = new Promise((resolve,reject) => {
			  finished(outputStream,(err) => {resolve(err)})
            })
			
			// outputStream.destroy()	
			outputStream.end()	
		    await writerComplete
			
			if ((this.terminalStream instanceof PassThrough) && !this.terminalStream.ended) {
	          // Pipelines that terminate in a PassThrough stream seem not to destroy all of the components correctly when the data has been proceseds. This causes the operation to hang. 
	          // Explicitly end such a stream
			  this.terminalStream.end()
			}
		  }
		  break;
	    case 'eof':
		  this.pipe(this.dbWriter); 
	  	  this.dbWriter.deferredCallback()
	      this.push(data);
      	  break;
	    default:
          this.push(data);
	  }
	  callback();	
    } catch(e) { 
	  this.yadamuLogger.handleException(['FILE','EVENT STREAM',`_TRANSFORM(${messageType})`],e);
      this.destroy(e)
	}
  };

}

module.exports = EventStream;
