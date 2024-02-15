Steps Cut Off Dataguard OPRBRICKEXAP to OPRBRICKBSD:
===================================================

ip db old (primary):		
OPRBRICKEXAP1	exapdb01-mgt	10.250.193.101
OPRBRICKEXAP2	exapdb02-mgt	10.250.192.102

ip DB new (standby):
OPRBRICKBSD1  exa62bsdpdb1-mgt	10.54.128.6
OPRBRICKBSD2  exa62bsdpdb1-mgt	110.54.128.7

primary:
-------
ora.OPRBRICKEXAP.db
      1        ONLINE  ONLINE       exapdb01-mgt             Open
      2        ONLINE  ONLINE       exapdb02-mgt             Open    

standby:
---------
ora.OPRBRICKBSD.db
      1        ONLINE  ONLINE       exa62bsdpdb1-mgt         Open,Readonly,STABLE
      2        ONLINE  ONLINE       exa62bsdpdb1-mgt          Open,Readonly,STABLE


1. Steps prepare:
--------------------------------------
1.1. Check status database primary & standby:
SQL> select INST_ID,name, open_mode, database_role from gv$database;

   INST_ID NAME      OPEN_MODE		  DATABASE_ROLE
---------- --------- -------------------- ----------------
	 1 OPRBRICK  READ WRITE 	  PRIMARY
	 2 OPRBRICK  READ WRITE 	  PRIMARY


	 
SQL> select INST_ID,name, open_mode, database_role from gv$database;

   INST_ID NAME      OPEN_MODE		  DATABASE_ROLE
---------- --------- -------------------- ----------------
	 1 OPRBRICK  OPEN		  PHYSICAL STANDBY
	 2 OPRBRICK  OPEM		  PHYSICAL STANDBY


		 
1.2. Check status MRP dataguard di database standby:
SELECT INST_ID,PROCESS, STATUS, THREAD#, SEQUENCE#, BLOCK#, BLOCKS FROM GV$MANAGED_STANDBY;

1.3. Check archivelog not applied di database standby:
select INST_ID,name, applied from gv$archived_log where applied = 'NO' order by name;

1.4. Check gap archivelog di database standby:
select * from gv$archive_gap;

1.5. Check last status sequence# di database primary dan standby:
select max(sequence#) from gv$log_history; 
select thread#,sequence#,archived,applied from v$archived_log order by first_time;

1.6. Check status count object di database primary dan standby:
select owner,object_type,count(*)from dba_objects group by owner,object_type order by 1;

1.7. Check status invalid object di database primary dan standby:
select owner, object_type, status, count(*) from dba_objects where status ='INVALID' group by owner,object_type,status order by 1;


2. Steps execute cut off:
--------------------------------------
2.1. Di database primary, setelah tim apps mematikan services apps ke arah database primary:
SQL> alter system switch logfile; --> dikedua node 3x switch
SQL> alter system set log_archive_dest_state_2='defer' scope=memory sid='*';
SQL> show parameter log_archive_dest_state_2;


2.2. Cancel recover managed standby database di database standby:
SQL> alter database recover managed standby database cancel;


2.3. Lock user apps on database primary:
---------------------------------------------------------------------------------------
2.3.1. Check status user-user apps on database primary:
SQL> SELECT USERNAME, USER_ID, ACCOUNT_STATUS, LOCK_DATE, EXPIRY_DATE, CREATED FROM dba_users where ACCOUNT_STATUS='OPEN' and USERNAME not in ('SYSTEM','SYS','DBSNMP');

USERNAME			  USER_ID ACCOUNT_STATUS		   LOCK_DATE EXPIRY_DA CREATED
------------------------------ ---------- -------------------------------- --------- --------- ---------
REVASS				      104 OPEN						       17-JUN-14
SOE				       84 OPEN						       17-SEP-13
GRID				      101 OPEN						       13-JUN-14
REDBRICK			      103 OPEN						       16-JUN-14
OGG				       83 OPEN						       23-AUG-13
BRICKTEST			      105 OPEN						       26-JUN-14

6 rows selected.

set pagesize 200
select 'alter user '||USERNAME||' account lock;' FROM dba_users where ACCOUNT_STATUS='OPEN' and USERNAME not in ('SYSTEM','SYS','DBSNMP');

2.3.2. Lock user-user apps on database primary:
alter user REVASS account lock;
alter user SOE account lock;
alter user GRID account lock;
alter user REDBRICK account lock;
alter user OGG account lock;
alter user BRICKTEST account lock;

6 rows selected.

Note:
Jika masih ada session dari user apps yang masih active bisa dikill atau restart database.
SQL >
set pagesize 500
spool kill_session.sql
SELECT 'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||''' IMMEDIATE;' from
gv$session where USERNAME in ('REVASS','SOE','GRID','REDBRICK','OGG','BRICKTEST');
spool off

2.3.3. Disable job user;
SQL> select job, log_user, schema_user, next_date, broken from dba_jobs where broken='N';

       JOB LOG_USER			  SCHEMA_USER			 NEXT_DATE B
---------- ------------------------------ ------------------------------ --------- -
      4001 SYS				  APEX_030200			 02-MAY-19 N
      4002 SYS				  APEX_030200			 02-MAY-19 N
     56412 REDBRICK			  REDBRICK			 03-MAY-19 N
     10113 SYS				  SYSMAN			 02-MAY-19 N




18 rows selected.

2.3.2. Lock user-user apps on database primary:
EXEC DBMS_JOB.BROKEN(4001,TRUE);
EXEC DBMS_JOB.BROKEN(4002,TRUE);
EXEC DBMS_JOB.BROKEN(56412,TRUE);
EXEC DBMS_JOB.BROKEN(10113,TRUE);


Note:
Jika masih ada session dari user apps yang masih active bisa dikill atau restart database.

SQL >
set pagesize 500
spool kill_session.sql
SELECT 'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||''' IMMEDIATE;' from
gv$session where USERNAME in ('REVASS','SOE','GRID','REDBRICK','OGG','BRICKTEST');
spool off


2.4. Configure and restart database OPRBRICKBSD di database standby menjadi database primary:
SQL> alter database activate standby database;
SQL> SELECT PROCESS, STATUS, THREAD#, SEQUENCE#, BLOCK#, BLOCKS FROM V$MANAGED_STANDBY where process ='MRP0';
#> srvctl status database -d OPRBRICKBSD
#> srvctl stop database -d OPRBRICKBSD
#> srvctl config database -d OPRBRICKBSD
#> srvctl modify database -d OPRBRICKBSD -r primary
#> srvctl start database -d OPRBRICKBSD
SQL> select name, open_mode, database_role from v$database;


3. Steps after cut off:
--------------------------------------
3.1. Shutdown database old (exapdb01-mgt):
srvctl status database -d OPRBRICKEXAP
srvctl stop database -d OPRBRICKEXAP
srvctl status database -d OPRBRICKEXAP

3.2. Monitor alert log database OPRBRICKBSD (database primary baru).
