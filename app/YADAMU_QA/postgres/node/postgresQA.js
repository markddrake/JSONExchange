"use strict" 

const PostgresDBI = require('../../../YADAMU/postgres/node/postgresDBI.js');

const sqlSuccess =
`select SOURCE_SCHEMA "SOURCE_SCHEMA", TARGET_SCHEMA "TARGET_SCHEMA", TABLE_NAME "TABLE_NAME", 'SUCCESSFUL' "RESULTS", TARGET_ROW_COUNT "TARGET_ROW_COUNT"
   from SCHEMA_COMPARE_RESULTS 
  where SOURCE_ROW_COUNT = TARGET_ROW_COUNT
    and MISSING_ROWS = 0
    and EXTRA_ROWS = 0
    and SQLERRM is NULL
 order by TABLE_NAME`;

const sqlFailed = 
`select SOURCE_SCHEMA "SOURCE_SCHEMA", TARGET_SCHEMA "TARGET_SCHEMA", TABLE_NAME "TABLE_NAME", 'FAILED' "RESULTS", SOURCE_ROW_COUNT "SOURCE_ROW_COUNT", TARGET_ROW_COUNT "TARGET_ROW_COUNT", MISSING_ROWS "MISSING_ROWS", EXTRA_ROWS "EXTRA_ROWS",  SQLERRM "SQLERRM"
   from SCHEMA_COMPARE_RESULTS 
  where SOURCE_ROW_COUNT <> TARGET_ROW_COUNT
     or MISSING_ROWS <> 0
      or EXTRA_ROWS <> 0
    or SQLERRM is NOT NULL
  order by TABLE_NAME`;

const sqlSchemaTableRows = `select relname "TABLE_NAME", n_live_tup "ROW_COUNT" from pg_stat_user_tables where schemaname = $1`;

const sqlCompareSchema = `call COMPARE_SCHEMA($1,$2,$3,$4,$5)`

class PostgresQA extends PostgresDBI {
    
    async recreateSchema() {
      try {
        const dropSchema = `drop schema if exists "${this.parameters.TO_USER}" cascade`;
        if (this.status.sqlTrace) {
          this.status.sqlTrace.write(`${dropSchema};\n--\n`)
        }
        await this.executeSQL(dropSchema);      
      } catch (e) {
        if (e.errorNum && (e.errorNum === 1918)) {
        }
        else {
          throw e;
        }
      }
      await this.createSchema(this.parameters.TO_USER);    
    }      

	async scheduleTermination(pid) {
	  const self = this
      const killOperation = this.parameters.KILL_READER_AFTER ? 'Reader'  : 'Writer'
	  const killDelay = this.parameters.KILL_READER_AFTER ? this.parameters.KILL_READER_AFTER  : this.parameters.KILL_WRITER_AFTER
	  const timer = setTimeout(
	    async function(pid) {
		   if (self.pool !== undefined && self.pool.end) {
		     self.yadamuLogger.qa(['KILL',self.DATABASE_VENDOR,killOperation,killDelay,pid,self.getSlaveNumber()],`Killing connection.`);
	         const conn = await self.getConnectionFromPool();
		     const res = await conn.query(`select pg_terminate_backend(${pid})`);
		     await conn.release()
		   }
		   else {
		     self.yadamuLogger.qa(['KILL',self.DATABASE_VENDOR,killOperation,killDelay,pid,self.getSlaveNumber()],`Unable to Kill Connection: Connection Pool no longer available.`);
		   }
		},
		killDelay,
	    pid
      )
	  timer.unref()
	}
	
    constructor(yadamu) {
       super(yadamu);
    }
    
	async initialize() {
	  await super.initialize();
	  if (this.options.recreateSchema === true) {
		await this.recreateSchema();
	  }
	  if (this.testLostConnection()) {
		const dbiID = await this.getConnectionID();
		this.scheduleTermination(dbiID);
	  }
	}
	
    async compareSchemas(source,target) {

      const report = {
        successful : []
       ,failed     : []
      }

      if (this.status.sqlTrace) {
        this.status.sqlTrace.write(`${sqlCompareSchema};\n--\n`)
      }
      
      await this.executeSQL(sqlCompareSchema,[source.schema,target.schema,this.parameters.EMPTY_STRING_IS_NULL === true,this.parameters.STRIP_XML_DECLARATION === true, this.parameters.hasOwnProperty('SPATIAL_PRECISION') ? this.parameters.SPATIAL_PRECISION : 18])      
      
      const successful = await this.executeSQL(sqlSuccess)
            
      report.successful = successful.rows.map(function(row,idx) {          
        return [row.SOURCE_SCHEMA,row.TARGET_SCHEMA,row.TABLE_NAME,row.TARGET_ROW_COUNT]
      },this)
      
      const failed = await this.executeSQL(sqlFailed)

      report.failed = failed.rows.map(function(row,idx) {
        return [row.SOURCE_SCHEMA,row.TARGET_SCHEMA,row.TABLE_NAME,row.SOURCE_ROW_COUNT,row.TARGET_ROW_COUNT,row.MISSING_ROWS,row.EXTRA_ROWS,(row.SQLERRM !== null ? row.SQLERRM : '')]
      },this)

      return report
    }
	
	async getRowCounts(target) {
        
      const results = await this.executeSQL(sqlSchemaTableRows,[target.schema]);

      return results.rows.map(function(row,idx) {          
        return [target.schema,row.TABLE_NAME,row.ROW_COUNT]
      },this)
      
    }    
	
  async slaveDBI(idx)  {
	const slaveDBI = await super.slaveDBI(idx);
	if (slaveDBI.testLostConnection()) {
	  const dbiID = await slaveDBI.getConnectionID();
	  this.scheduleTermination(dbiID);
    }
	return slaveDBI
  }
}

module.exports = PostgresQA