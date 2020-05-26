"use strict" 

const oracledb = require('oracledb');

const YadamuParser = require('../../common/yadamuParser.js')
const StringWriter = require('./stringWriter.js');
const BufferWriter = require('./bufferWriter.js');

class DBParser extends YadamuParser {
  
  constructor(tableInfo,objectMode,yadamuLogger) {
    super(tableInfo,objectMode,yadamuLogger);      
    this.columnMetadata = undefined;
    this.includesLobs = false;
  }

  setColumnMetadata(metadata) {
    this.columnMetadata = metadata
    this.columnMetadata.forEach(function (column) {
      if ((column.fetchType === oracledb.CLOB) || (column.fetchType === oracledb.BLOB)) {
        this.includesLobs = true;
      }
    },this)
  }
  
  blob2HexBinary(blob) {
  
    return new Promise(async function(resolve,reject) {
      try {
      const bufferWriter = new  BufferWriter();
          
        blob.on('error',
        async function(err) {
           await blob.close();
           reject(err);
        });
          
        bufferWriter.on('finish', 
        async function() {
          await blob.close(); 
          resolve(bufferWriter.toHexBinary());
        });
         
        blob.pipe(bufferWriter);
      } catch (err) {
        reject(err);
      }
    });
  };
    
  clob2String(clob) {
     
    return new Promise(async function(resolve,reject) {
      try {
        const stringWriter = new  StringWriter();
        clob.setEncoding('utf8');  // set the encoding so we get a 'string' not a 'buffer'
        
        clob.on('error',
        async function(err) {
           await clob.close();
           reject(err);
        });
        
        stringWriter.on('finish', 
        async function() {
          await clob.close(); 
          resolve(stringWriter.toString());
        });
       
        clob.pipe(stringWriter);
      } catch (err) {
        reject(err);
      }
    });
  };
  
  async _transform (data,encodoing,callback) {
	try {
      this.counter++;
      if (this.includesLobs) {
        data = await Promise.all(data.map(function (item,idx) {
                 if ((item !== null) && (this.columnMetadata[idx].fetchType === oracledb.CLOB)) {
                   return this.clob2String(item)
                 } 
                 if ((item !== null) && (this.columnMetadata[idx].fetchType === oracledb.BLOB)) {
                   return this.blob2HexBinary(item)
                 }  
                 return item
        },this))
      }  

      // Convert the JSON columns into JSON objects
      this.tableInfo.jsonColumns.forEach(function(idx) {
        if (data[idx] !== null) {
          try {
            data[idx] = JSON.parse(data[idx]) 
          } catch (e) {
            this.yadamuLogger.logException([`${this.constructor.name}._transform()`,`${this.counter}`],e);
            this.yadamuLogger.writeDirect(`${data[idx]}\n`);
          } 
        }
      },this)
      
      this.tableInfo.rawColumns.forEach(function(idx) {
        if (data[idx] !== null) {
          if (Buffer.isBuffer(data[idx])) {
            data[idx] = data[idx].toString('hex');
          }
        }
      },this)
    
      if (!this.objectMode) {
        data = JSON.stringify(data);
      }
      const res = this.push({data:data})
      callback();
	} catch (e) {
      callback(e)
	}
  }

}

module.exports = DBParser