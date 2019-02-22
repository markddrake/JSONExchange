"use strict";
const fs = require('fs');
const mysql = require('mysql')
const path = require('path');

const Yadamu = require('../../common/yadamuCore.js');
const RowParser = require('../../common/rowParser.js');
const DBWriter = require('./dbWriter.js');
const MySQLCore = require('./mysqlCore.js');

function processFile(conn, schema, importFilePath, batchSize, commitSize, mode, status, logWriter) {
  
  return new Promise(function (resolve,reject) {
    try {
      const dbWriter = new DBWriter(conn,schema,batchSize,commitSize,mode,status,logWriter);
      dbWriter.on('finish', function(){resolve(parser.checkState())});
      dbWriter.on('error',function(err){logWriter.write(`${new Date().toISOString()}[DBWriter.error()]}: ${err}\n`);reject(err)})
      const parser = new RowParser(logWriter);
      const readStream = fs.createReadStream(importFilePath);    
      readStream.pipe(parser).pipe(dbWriter);
    } catch (e) {
      logWriter.write(`${e}\n${e.stack}\n`);
      reject(e);
    }
  })
}
    
async function main() {

  let pool; 
  let conn;
  let parameters;
  let logWriter = process.stdout;
  let status;
  
  let results;
  
  try {
      
    process.on('unhandledRejection', function (err, p) {
      logWriter.write(`Unhandled Rejection:\Error:`);
      logWriter.write(`${err}\n${err.stack}\n`);
    })
    
    parameters = MySQLCore.processArguments(process.argv);
    status = Yadamu.getStatus(parameters,'Import');
    
    if (parameters.LOGFILE) {
      logWriter = fs.createWriteStream(parameters.LOGFILE,{flags : "a"});
    }

    conn = await MySQLCore.getConnection(parameters,status,logWriter);
    
 	results = await MySQLCore.createTargetDatabase(conn,status,parameters.TOUSER);
    
    const stats = fs.statSync(parameters.FILE)
    const fileSizeInBytes = stats.size
    logWriter.write(`${new Date().toISOString()}[Clarinet]: Processing file "${path.resolve(parameters.FILE)}". Size ${fileSizeInBytes} bytes.\n`)
            
    status.warningsRaised = await processFile(conn, parameters.TOUSER, parameters.FILE, parameters.BATCHSIZE, parameters.COMMITSIZE, parameters.MODE, status, logWriter);
    await conn.end();
    Yadamu.reportStatus(status,logWriter)
  } catch (e) {
    if (logWriter !== process.stdout) {
      console.log(`Import operation failed: See "${parameters.LOGFILE}" for details.`);
      logWriter.write('Import operation failed.\n');
      logWriter.write(`${e}\n`);
    }
    else {
      console.log(`Import operation Failed:`);
      console.log(e);
    }
    if (conn !== undefined) {
      await conn.end();
    }
  }
  
  if (logWriter !== process.stdout) {
    logWriter.close();
  }

  if (parameters.SQLTRACE) {
    status.sqlTrace.close();
  }
}
    
main()