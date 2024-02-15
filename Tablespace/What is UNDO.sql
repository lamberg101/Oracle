
1. WHAT IS UNDO TABLESPACE???

ROLLBACK or UNDO is the backbone of the READ CONSISTENCY mechanism provided by Oracle. 
Every Oracle Database must have a method of maintaining information that is used to roll back, or undo, changes to the database. 
Such information consists of records of the actions of transactions, primarily before they are committed. 
These records are collectively referred to as undo.

Undo records are used to:
	- Roll back transactions when a ROLLBACK statement is issued.
	- Recover the database
	- Provide read consistency
	- Analyze data as of an earlier point in time by using Oracle Flashback Query
	- Recover from logical corruptions using Oracle Flashback features



3. UNDO RETENTION?


Automatic undo management depends upon  undo_retention, which defines how long Oracle should try to keep committed transactions in UNDO. 
However, this parameter is only a suggestion. 
You must also have an UNDO tablespace thats large enough to handle the amount of UNDO you will be generating/holding, 
or you will get ORA-01555: Snapshot too old, rollback segment too small errors.
You can use the parameter undo_retention to set the amount of time you want undo information retained in the database.

You set the UNDO_MANAGEMENT initialization parameter to AUTO in order to enable automatic undo management. 

Rather than having to define and manage rollback segments, you can simply define an Undo tablespace and let Oracle take care of the rest. 
Turning on automatic undo management is easy.  All you need to do is create an undo tablespace and set UNDO_MANAGEMENT = AUTO.
If the database contains multiple undo tablespaces, you can optionally specify at startup that you want to use a specific undo tablespace. 

ALTER SYSTEM SET UNDO_TABLESPACE = undotbs_02; --> mungkin add scope and sid.

When automatic undo management is enabled, there is always a current undo retention period, 
which is the minimum amount of time that Oracle Database attempts to retain old undo information before overwriting it. 

- Old (committed) undo information that is older than the current undo retention period is said to be expired. 
- Old undo information with an age that is less than the current undo retention period is said to be unexpired.
- The default is 900 seconds (5 minutes).


Oracle Database automatically tunes the undo retention period based on undo tablespace size and system activity. 
You can specify a minimum undo retention period (in seconds) by setting the UNDO_RETENTION initialization parameter. 

RULES of owerwriten for Undo retention:
	- The database makes its best effort to honor the specified minimum undo retention period, 
	- provided that the undo tablespace has space available for new transactions.
	- When available space for new transactions becomes short, the database begins to overwrite expired undo. 
	- If the undo tablespace has no space for new transactions after all expired undo is overwritten, 
	- the database may begin overwriting unexpired undo information. 
	- If any of this overwritten undo information is required for consistent read in a current long-running query, 
	- the query could fail with the snapshot too old error message.



Oracle 10g also gives you the ability to guarantee undo. 
This means that instead of throwing an error on SELECT statements, 
it guarantees your UNDO retention for consistent reads and instead errors your DML that would cause UNDO to be overwritten.

To create an undo tablespace (RETENTION GUARANTEE)
SQL> CREATE UNDO TABLESPACE undo_tbs DATAFIEL '/u02/oradata/grid/undo_tbs01.dbf' SIZE 1G RETENTION GUARANTEE;

Use the UNDO advisor to find out how large this tablespace should be given a desired UNDO retention or script on google.

Its easier for the DBA to minimize the issues of UNDO when using automatic undo management. 
If you set the UNDO_RETENTION high enough accompanied with properly sized undo tablespace, you shouldnt have as many issues with UNDO. 
How often you commit should have nothing to do with it, as long as your DBA has properly set UNDO_RETENTION and has an optimally sized UNDO tablespace.
Committing more often will only result in your script taking longer, more LGWR/DBWR issues


-----------------------------------------------------------------------------------------------------------------------------------------------

Calculate UNDO_RETENTION for given UNDO Tabespace

Because these following queries use the V$UNDOSTAT statistics, 
run the queries only after the database has been running with UNDO for a significant and representative time.

Optimal Undo Retention = Actual Undo Size / (DB_BLOCK_SIZE × UNDO_BLOCK_REP_ESC)

1. Actual Undo Size

	SELECT SUM(a.bytes) "UNDO_SIZE"
	FROM v$datafile a,
		v$tablespace b,
		dba_tablespaces c
	WHERE c.contents = 'UNDO'
	AND c.status = 'ONLINE'
	AND b.name = c.tablespace_name
	AND a.ts# = b.ts#;

2. Undo Blocks per Second

	SELECT MAX(undoblks/((end_time-begin_time)*3600*24)) "UNDO_BLOCK_PER_SEC"
	FROM v$undostat;

3. DB Block Size

	SELECT TO_NUMBER(value) "DB_BLOCK_SIZE [KByte]"
	FROM v$parameter
	WHERE name = 'db_block_size';


4. Optimal Undo Retention Calculation

Formula: Optimal Undo Retention =  Actual Undo Size / (DB_BLOCK_SIZE × UNDO_BLOCK_REP_ESC)

	SELECT d.undo_size/(1024*1024) "ACTUAL UNDO SIZE [MByte]",
		SUBSTR(e.value,1,25)    "UNDO RETENTION [Sec]",
		ROUND((d.undo_size / (to_number(f.value) *
		g.undo_block_per_sec)))"OPTIMAL UNDO RETENTION [Sec]"
	FROM (
		SELECT SUM(a.bytes) undo_size
			FROM v$datafile a,
				v$tablespace b,
				dba_tablespaces c
			WHERE c.contents = 'UNDO'
			AND c.status = 'ONLINE'
			AND b.name = c.tablespace_name
			AND a.ts# = b.ts#
		) d,
		v$parameter e,
		v$parameter f,
		(
		SELECT MAX(undoblks/((end_time-begin_time)*3600*24))undo_block_per_sec
		FROM v$undostat
		) g
	WHERE e.name = 'undo_retention'
	AND f.name = 'db_block_size';
	
	

5. Calculate Needed UNDO Size for given Database Activity

If you are not limited by disk space, then it would be better to choose the UNDO_RETENTION time that is best for you (for FLASHBACK, etc.). 
Allocate the appropriate size to the UNDO tablespace according to the database activity:

Formula: Undo Size = Optimal Undo Retention × DB_BLOCK_SIZE × UNDO_BLOCK_REP_ESC

	SELECT d.undo_size/(1024*1024) "ACTUAL UNDO SIZE [MByte]",
		SUBSTR(e.value,1,25) "UNDO RETENTION [Sec]",
		(TO_NUMBER(e.value) * TO_NUMBER(f.value) *
		g.undo_block_per_sec) / (1024*1024)
		"NEEDED UNDO SIZE [MByte]"
	FROM (
		SELECT SUM(a.bytes) undo_size
			FROM v$datafile a,
				v$tablespace b,
				dba_tablespaces c
			WHERE c.contents = 'UNDO'
			AND c.status = 'ONLINE'
			AND b.name = c.tablespace_name
			AND a.ts# = b.ts#
		) d,
		v$parameter e,
		v$parameter f,
		(
		SELECT MAX(undoblks/((end_time-begin_time)*3600*24))
			undo_block_per_sec
			FROM v$undostat
		) g
	WHERE e.name = 'undo_retention'
	AND f.name = 'db_block_size';
	
	


6. Automatic Undo Retention Tuning

Oracle 10g automatically tunes undo retention to reduce the chances of “snapshot too old” errors during long-running queries. 
The UNDO_RETENTION parameter is used to set a low retention time threshold which the system will attempt to achieve. 
In the event of any undo space constraints the system will prioritize DML operations over undo retention meaning the low threshold may not be achieved. 
If the undo retention threshold must be guaranteed, even at the expense of DML operations, 
the RETENTION GUARANTEE clause can be set against the undo tablespace during or after creation:

Reset the undo low threshold.
	
	SQL> ALTER SYSTEM SET UNDO_RETENTION = 2400; --ad parameter such as sid and scope.

#Guarantee the minimum threshold is maintained.
SQL> ALTER TABLESPACE undotbs1 RETENTION GUARANTEE; --> learn lagi.
 
#Check
SQL> SELECT tablespace_name, retention FROM dba_tablespaces;
 
	TABLESPACE_NAME                RETENTION
	------------------------------ -----------
	SYSTEM                         NOT APPLY
	UNDOTBS1                       GUARANTEE
	SYSAUX                         NOT APPLY
	TEMP                           NOT APPLY
	USERS                          NOT APPLY
 


#Switch back to the default mode.
SQL> ALTER TABLESPACE undotbs1 RETENTION NOGUARANTEE;
 
	TABLESPACE_NAME                RETENTION
	------------------------------ -----------
	SYSTEM                         NOT APPLY
	UNDOTBS1                       NOGUARANTEE
	SYSAUX                         NOT APPLY
	TEMP                           NOT APPLY
	USERS                          NOT APPLY
 


8. The Undo Advisor PL/SQL Interface

Oracle Database provides an Undo Advisor that provides advice on and helps automate the establishment of your undo environment. 
You activate the Undo Advisor by creating an undo advisor task through the advisor framework. 
The following example creates an undo advisor task to evaluate the undo tablespace. 
The name of the advisor is ‘Undo Advisor‘. 
The analysis is based on Automatic Workload Repository snapshots, which you must specify by setting parameters START_SNAPSHOT and END_SNAPSHOT. 
In the following example, the START_SNAPSHOT is “1” and END_SNAPSHOT is “2”.

	DECLARE
	tid    NUMBER;
	tname  VARCHAR2(30);
	oid    NUMBER;
	BEGIN
	DBMS_ADVISOR.CREATE_TASK('Undo Advisor', tid, tname, 'Undo Advisor Task');
	DBMS_ADVISOR.CREATE_OBJECT(tname, 'UNDO_TBS', null, null, null, 'null', oid);
	DBMS_ADVISOR.SET_TASK_PARAMETER(tname, 'TARGET_OBJECTS', oid);
	DBMS_ADVISOR.SET_TASK_PARAMETER(tname, 'START_SNAPSHOT', 1);
	DBMS_ADVISOR.SET_TASK_PARAMETER(tname, 'END_SNAPSHOT', 2);
	DBMS_ADVISOR.execute_task(tname);
	end;





