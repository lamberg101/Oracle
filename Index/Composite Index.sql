
--COMPOSITE INDEX? 
-- also called a concatenated index. 
-- an index on multiple columns in a table. 
-- In general, the most commonly accessed columns go first.

------------------------------------------------------------------------------------------------

--EXAMPLE
SQL> Create index EMPLOYEES_IX ON employees (LAST_NAME, JOB_ID, SALARY);

Query that uses this index are:
- Queries that access all THREE COLUMNS
- Only the LAST_NAME column
- Or only the LAST_NAME and JOB_ID

You can create multiple indexes using the same columns if you specify distinctly different permutations of the columns. 
SQL> CREATE INDEX employee_idx1 ON employees (LAST_NAME, JOB_ID);
SQL> CREATE INDEX employee_idx2 ON employees (JOB_ID, LAST_NAME);

------------------------------------------------------------------------------------------------

Contoh:
------
CREATE INDEX DOM.IDX_AO_RNFLG_LATFLG_STCD_RTRY 
ON DOM.ACTIVE_OFFER (
	'RENEWAL_ACC_FLAG', 
	'LATEST_RECORD_FLAG', 
	'ST_CD', 
	'RETRY'
	)
PCTFREE 10 
INITRANS 2 
MAXTRANS 255  
LOGGING
STORAGE(
	INITIAL 65536 
	NEXT 1048576 
	MINEXTENTS 1 
	MAXEXTENTS 2147483645
	PCTINCREASE 0
	BUFFER_POOL DEFAULT 
	FLASH_CACHE DEFAULT 
	CELL_FLASH_CACHE DEFAULT
  )
TABLESPACE INDEX_DATA  LOCAL (
PARTITION 'dpa_p0919'
PCTFREE 10 
INITRANS 2 
MAXTRANS 255
STORAGE(
	INITIAL 65536 
	NEXT 1048576 
	MINEXTENTS 1 
	MAXEXTENTS 2147483645
	PCTINCREASE 0
	BUFFER_POOL DEFAULT 
	FLASH_CACHE DEFAULT 
	CELL_FLASH_CACHE DEFAULT
	)
TABLESPACE INDEX_DATA ( 
	SUBPARTITION 'dpa_p0919_DAY30' TABLESPACE INDEX_DATA ,
	SUBPARTITION 'dpa_p0919_DAY60' TABLESPACE INDEX_DATA ,
	SUBPARTITION 'dpa_p0919_DAY90' TABLESPACE INDEX_DATA ,
	SUBPARTITION 'dpa_p0919_OTHERDAYS' TABLESPACE INDEX_DATA
	) 
);

