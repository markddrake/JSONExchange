"use strict"

const { performance } = require('perf_hooks');

const YadamuWriter = require('../../common/yadamuWriter.js');
const {BatchInsertError} = require('../../common/yadamuError.js')

class TableWriter extends YadamuWriter {

  constructor(dbi,tableName,tableInfo,status,yadamuLogger) {
    super(dbi,tableName,tableInfo,status,yadamuLogger)
    this.tableInfo.columnCount = this.tableInfo.targetDataTypes.length;
    this.tableInfo.args =  '(' + Array(this.tableInfo.columnCount).fill('?').join(',')  + '),';
    
    this.transformations = this.tableInfo.dataTypes.map(function(dataType,idx) {
      switch (dataType.type) {
        case "tinyblob" :
        case "blob" :
        case "mediumblob" :
        case "longblob" :
        case "varbinary" :
        case "binary" :
	      return function(col,idx) {
            return Buffer.from(col,'hex');
		  }
          break;
        case "json" :
          return function(col,idx) {
            if (typeof col === 'object') {
              return JSON.stringify(col);
            }
			return col
	      }
          break;
        case "date":
        case "time":
        case "datetime":
        case "timestamp":
          return function(col,idx) {
            // If the the input is a string, assume 8601 Format with "T" seperating Date and Time and Timezone specified as 'Z' or +00:00
            // Neeed to convert it into a format that avoiods use of convert_tz and str_to_date, since using these operators prevents the use of Bulk Insert.
            // Session is already in UTC so we safely strip UTC markers from timestamps
            if (typeof col !== 'string') {
              col = col.toISOString();
            }             
            col = col.substring(0,10) + ' '  + (col.endsWith('Z') ? col.substring(11).slice(0,-1) : (col.endsWith('+00:00') ? col.substring(11).slice(0,-6) : col.substring(11)))
            // Truncate fractional values to 6 digit precision
            // ### Consider rounding, but what happens at '9999-12-31 23:59:59.999999
            return col.substring(0,26);
		  }
		  break;
        default :
          return null;
      }
    },this)
	
  }

  async initialize() {
	await super.initialize()
  }
  
  getStatistics() {
    const results = super.getStatistics()
    results.insertMode = this.tableInfo.insertMode
    return results;
  }
  
  async appendRow(row) {
            
	// Use forEach not Map as transformations are not required for most columns. 
	// Avoid uneccesary data copy at all cost as this code is executed for every column in every row.
	  
	this.transformations.forEach(function (transformation,idx) {
      if ((transformation !== null) && (row[idx] !== null)) {
	    row[idx] = transformation(row[idx])
      }
	},this)

    // Batch Mode : Create one large array. Iterative Mode : Create an Array of Arrays.    

    if (this.tableInfo.insertMode === 'Iterative') {
      this.batch.push(row);
    }
    else {
      this.batch.push(...row);
    
	}
    this.rowCounters.cached++
	return this.skipTable;
  }

  async processWarnings(results) {
   // ### Output Records that generate warnings
   if (results.warningCount >  0) {
      const warnings = await this.dbi.executeSQL('show warnings');
      warnings.forEach(function(warning,idx) {
        if (warning.Level === 'Warning') {
          this.yadamuLogger.warning([`${this.constructor.name}.writeBatch()`],`Warnings reported by bulk insert operation. Details: ${JSON.stringify(warning)}`)
          this.yadamuLogger.writeDirect(`${this.batch[idx]}\n`)
        }
      },this)
    }
  }
    
  handleBatchException(cause,message) {
   
    // Use Slice to add first and last row, rather than first and last value.
    const batchException = new BatchInsertError(cause,this.tableName,this.tableInfo.dml,this.rowCounters.cached,this.batch.slice(0,this.tableInfo.columnCount),this.batch.slice(this.batch.length-this.tableInfo.columnCount,this.batch.length))
    this.yadamuLogger.handleWarning([this.dbi.DATABASE_VENDOR,this.tableName,`WRITE`,this.insertMode],batchException)

  }
  	
  async writeBatch() {     

    this.batchCount++; 
    let repackBatch = false;

    if (this.tableInfo.insertMode === 'Batch') {
      try {    
        // Slice removes the unwanted last comma from the replicated args list.
        const args = this.tableInfo.args.repeat(this.rowCounters.cached).slice(0,-1);
        await this.dbi.createSavePoint();
        const results = await this.dbi.executeSQL(this.tableInfo.dml.slice(0,-1) + args, this.batch);
        await this.processWarnings(results);
        this.endTime = performance.now();
        await this.dbi.releaseSavePoint();
		this.batch.length = 0;  
        this.rowCounters.written += this.rowCounters.cached;
		this.rowCounters.cached = 0;
        return this.skipTable
      } catch (e) {
        await this.dbi.restoreSavePoint(e);
		this.handleBatchException(e,'Batch Insert')
        this.yadamuLogger.warning([this.dbi.DATABASE_VENDOR,this.tableName,this.insertMode],`Switching to Iterative mode.`);          
        this.tableInfo.insertMode = 'Iterative' 
        this.tableInfo.dml = this.tableInfo.dml.slice(0,-1) + this.tableInfo.args.slice(0,-1)
        repackBatch = true;
      }
    }

    for (let row =0; row < this.rowCounters.cached; row++) {
      const nextRow = repackBatch ?  this.batch.splice(0,this.tableInfo.columnCount) : this.batch[row]
      try {
        const results = await this.dbi.executeSQL(this.tableInfo.dml,nextRow);
        await this.processWarnings(results);
		this.rowCounters.written++;
      } catch (e) {
        const errInfo = [this.tableInfo.dml]
        this.skipTable = await this.handleInsertError(`INSERT ONE`,this.rowCounters.cached,row,nextRow,e,errInfo);
        if (this.skipTable) {
          break;
        }
      }
    }     
   
    this.endTime = performance.now();
    this.batch.length = 0;
    this.rowCounters.cached = 0;
    return this.skipTable          
  }

}

module.exports = TableWriter;