ODG ODCBDL11 mcd_105
1. Enable Archiving di Primary database (Step ini sudah)
Check archivelog mode:
SQL> SELECT log_mode FROM v$database;

LOG_MODE
------------
NOARCHIVELOG

** ACT : Shutdown immediate;
** ACT :Startup mount;
** ACT : Alter database ARCHIVELOG;
** ACT :Alter database open;

SQL> archive log list;
Database log mode	       Archive Mode
Automatic archival	       Enabled
Archive destination	       USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     162
Next log sequence to archive   164
Current log sequence	       164

2. Check force logging di primary database ODCBDL11 
SQL> select force_logging from v$database;
FOR
---
NO

** ACT : ALTER DATABASE FORCE LOGGING;

3. Check redo logs di primary database (standby redolog n+1)
SQL> select group#,THREAD#,bytes/1024/1024 "Size in MB" from v$log;

    GROUP#    THREAD# Size in MB
---------- ---------- ----------
	 1	    1	      50
	 2	    1	      50
	 3	    1	      50

8 rows selected.

alter database add standby logfile group 11 ('/data/oradata/ODCBDL11/datafile/ODCBDL11/standby_redo01.log') SIZE 50M;
alter database add standby logfile group 12 ('/data/oradata/ODCBDL11/datafile/ODCBDL11/standby_redo02.log') SIZE 50M;
alter database add standby logfile group 13 ('/data/oradata/ODCBDL11/datafile/ODCBDL11/standby_redo03.log') SIZE 50M;
alter database add standby logfile group 14 ('/data/oradata/ODCBDL11/datafile/ODCBDL11/standby_redo04.log') SIZE 50M;

set linesize 900
col MEMBER format a80
SELECT * FROM V$LOGFILE;  

    GROUP# STATUS  TYPE    MEMBER									    IS_
---------- ------- ------- -------------------------------------------------------------------------------- ---
	 3	   ONLINE  /data/oradata/ODCBDL11/datafile/ODCBDL11/redo03.log				    NO
	 2	   ONLINE  /data/oradata/ODCBDL11/datafile/ODCBDL11/redo02.log				    NO
	 1	   ONLINE  /data/oradata/ODCBDL11/datafile/ODCBDL11/redo01.log				    NO
	11	   STANDBY /data/oradata/ODCBDL11/datafile/ODCBDL11/standby_redo01.log			    NO
	12	   STANDBY /data/oradata/ODCBDL11/datafile/ODCBDL11/standby_redo02.log			    NO
	13	   STANDBY /data/oradata/ODCBDL11/datafile/ODCBDL11/standby_redo03.log			    NO
	14	   STANDBY /data/oradata/ODCBDL11/datafile/ODCBDL11/standby_redo04.log			    NO


20 rows selected.

4. Setup tnsnames.ora di primary dan standby server

#Primary

ODCBDL11 =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.2.230.105)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = ODCBDL11)
      (UR = A)
    )
  )

#standby

ODCBDL =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.2.230.105)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = ODCBDL)
      (UR = A)
    )
  )


5. Create dan copy password file dari primary ke standby database (belum)

cd /data/oracle/product/11.2.0.4/dbs
cp orapwODCBDL11 orapwODCBDL

6. Create directory file system dan asm di server standby :

** HOME / File system **
cd $ORACLE_BASE/admin
mkdir ODCBDL
cd ODCBDL
mkdir adump  bdump  cdump  dpdump  pfile  udump


cd /data/oradata
mkdir ODCBDL
cd ODCBDL
mkdir PARAMETERFILE DATAFILE CONTROLFILE TEMPFILE ONLINELOG FRA


7. Create controlfile standby (di PRIMARY):

SQL> ALTER DATABASE CREATE STANDBY CONTROLFILE AS '/home/oracle/ODCBDL/ODCBDL_stby.ctl';

#Kemudian controlfile copykan ke path controlfile database standby:
cd /home/oracle/ODCBDL
cp ODCBDL_stby.ctl /data/oradata/ODCBDL/CONTROLFILE/ODCEO_stby.ctl

8. Create pfile dan configure untuk database standby sudah

backup pfile sebelum odg:
SQL> create pfile='/home/oracle/ODCBDL/pfile_ODCBDL_orig.txt' from spfile;

alter system set LOG_ARCHIVE_CONFIG='DG_CONFIG=(ODCBDL11,ODCBDL)' sid='*' scope=both;
alter system set LOG_ARCHIVE_DEST_2='SERVICE=ODCBDL ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=ODCBDL' sid='*' scope=both;
alter system set LOG_ARCHIVE_DEST_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=ODCBDL11' sid='*' scope=both;
alter system set LOG_ARCHIVE_DEST_STATE_1=ENABLE sid='*' scope=both;
alter system set LOG_ARCHIVE_DEST_STATE_2=DEFER sid='*' scope=both;
alter system set FAL_CLIENT='ODCBDL11' sid='*' scope=both;
alter system set FAL_SERVER='ODCBDL' sid='*' scope=both;

backup pfile sebelum odg:
SQL> create pfile='/home/oracle/ODCBDL/pfile_ODCBDL_orig.txt' from spfile;

** CREATE PFILE (PRIMARY) **
SQL> create pfile='/home/oracle/ODCBDL/pfile_ODCBDL_prim.txt' from spfile;


##FOR STANDBY PFILE

ODCBDL.__db_cache_size=3288334336
ODCBDL.__java_pool_size=50331648
ODCBDL.__large_pool_size=67108864
ODCBDL.__oracle_base='/data/oracle'#ORACLE_BASE set from environment
ODCBDL.__pga_aggregate_target=3154116608
ODCBDL.__sga_target=4194304000
ODCBDL.__shared_io_pool_size=0
ODCBDL.__shared_pool_size=704643072
ODCBDL.__streams_pool_size=0
*.audit_file_dest='/data/oracle/admin/ODCBDL/adump'
*.audit_trail='db'
*.compatible='11.2.0.4.0'
*.control_files='/data/oradata/ODCBDL/CONTROLFILE/ODCBDL.ctl'
*.db_block_size=8192
*.db_domain=''
*.db_name='ODCBDL'
*.db_recovery_file_dest='/data/oradata/ODCBDL/FRA'
*.db_recovery_file_dest_size=107374182400
*.diagnostic_dest='/data/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=ODCBDLXDB)'
*.fal_client='ODCBDL'
*.fal_server='ODCBDL11'
*.log_archive_config='DG_CONFIG=(ODCBDL,ODCBDL11)'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=ODCBDL'
*.log_archive_dest_2='SERVICE=ODCBDL ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=ODCBDL11'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_dest_state_2='DEFER'
*.open_cursors=300
*.pga_aggregate_target=3145728000
*.db_unique_name='ODCBDL'
*.processes=1000
*.remote_login_passwordfile='EXCLUSIVE'
*.sessions=1105
*.sga_target=4194304000
*.undo_tablespace='UNDOTBS1'
*.log_file_name_convert='/data/oradata/ODCBDL11/archivelog/ODCBDL11','/data/oradata/ODCBDL/FRA','/data/oradata/ODCBDL11/datafile/ODCBDL11','/data/oradata/ODCBDL/DATAFILE'
*.db_file_name_convert='/data/oradata/ODCBDL11/datafile/ODCBDL11','/data/oradata/ODCBDL/DATAFILE','/data/oradata/ODCBDL11/archivelog/ODCBDL11','/data/oradata/ODCBDL/FRA'
*.standby_file_management='AUTO'
*.nls_language='AMERICAN'
*.nls_territory='AMERICA'
*.db_create_file_dest='/data/oradata/ODCBDL/DATAFILE'

9. Create profile ODCEO_profile di server standby

vi .ODCBDL_profile
export ORACLE_BASE=/data/oracle
export ORACLE_HOME=/data/oracle/product/11.2.0.4
export ORACLE_SID=ODCBDL
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

10. Start instance di standby database (nomount) menggunaka pfile yang dibuat di step nomor 7 sudah
SQL> startup nomount pfile='/home/oracle/ODCBDL/pfile_ODCBDL_stdby.txt'; 


11. Tes koneksi 

#PRIMARY TO STANDBY 
tnsping ODCBDL11
sqlplus sys/oracle123@ODCBDL11 as sysdba
sqlplus sys/oracle123@ODCBDL as sysdba

--masukan pass system

12. Di server primary, perform RMAN duplicate dari primary database 
cd /home/oracle/ODCBDL
vi duplicate_ODCBDL11.sh

------------------------------
export ORACLE_SID=ODCBDL11
export ORACLE_HOME=/data/oracle/product/11.2.0.4
export ORACLE_BASE=/data/oracle
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/jre/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman target sys/oracle123@ODCBDL11 AUXILIARY sys/oracle123@ODCBDL trace=/home/oracle/ODCBDL/duplicate_ODCBSL_14012021.log << EOF
run {
allocate channel c1 device type disk;
allocate channel c2 device type disk;
allocate auxiliary channel d1 device type disk;
allocate auxiliary channel d2 device type disk;
duplicate target database for standby from active database;
}
exit
EOF
------------------------------

13. Di server standby, setelah selesai duplikat database standby, Check status database standby di node 1 
SQL> select name, database_role from v$database;


14. Di server standby, modify pfile, dan kemudian create spfile from pfile (Step ini belum)
- Create spfile from pfile:
SQL> create spfile from pfile='/home/oracle/ODCBDL/pfile_ODCBDL_stdby.txt';


15. Di server standby, Shutdown database di node 1 (Step ini belum)
SQL> shutdown immediate;


16. Di server standby, Start standby database (Step ini belum)
SQL> startup nomount;
SQL> alter database mount standby database;

17. Di server primary, ENABLE status LOG_ARCHIVE_DEST_STATE_2  (Step ini belum)
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2 = ENABLE sid='*' scope=both;

18. Di server standby, Enable MRP dan recover database (Step ini belum)
alter database recover managed standby database using current logfile disconnect;


19. Di server standby, Monitor apply process (Step ini belum)
select thread#,sequence#,archived,applied from v$archived_log order by first_time;
select inst_id, process, status, thread#, sequence#, block#, blocks from gv$managed_standby where process in ('RFS','LNS','MRP0');
select DEST_ID,dest_name,status,type,srl,recovery_mode from v$archive_dest_status where dest_id=1;
select name, open_mode, database_role from v$database;


20. Di server primary, check status archive destination (Step ini belum)
set line 200
col DEST_NAME for a50
col BINDING for a10
select DEST_ID,DEST_NAME,STATUS,BINDING,ERROR from v$ARCHIVE_DEST where status<>'INACTIVE';


21. Di server standby, Open read only standby database (Step ini belum)
Alter database recover managed standby database cancel;
Alter database open read only;
alter database recover managed standby database using current logfile disconnect from session;


22. Di server standby, Monitor MRP - Managed Recover Process: untuk otomatis proses apply archive yang sudah diterima dari primary proses (Step ini belum)
- SELECT PROCESS, STATUS, THREAD#, SEQUENCE#, BLOCK#, BLOCKS FROM V$MANAGED_STANDBY;
- select name, applied from v$archived_log where applied = 'NO' order by name;
- select * from v$archive_gap;
- select group#,status from v$standby_log;
- select START_TIME,TYPE, ITEM,UNITS,SOFAR,TIMESTAMP from v$recovery_progress where ITEM='Last Applied Redo';
- select max(sequence#) from v$log_history; (di database primary & standby)
- select name, instance_name, open_mode, database_role, flashback_on , current_scn from v$database,v$instance;  (di database primary & standby)