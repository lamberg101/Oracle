1. Pastikan Archiving di Primary database sudah archive mode. 
SQL> SELECT log_mode FROM v$database;

2. Enable force logging di primary database
SQL> select force_logging from v$database;

if teh current status is NO then 
--SQL> Alter database force logging;


3. Create standby redo logs di primary database. 

SQL> 
select group#,THREAD#,bytes/1024/1024 "Size in MB" from v$log;

SQL> 
set linesize 900
col MEMBER format a80
SELECT * FROM V$LOGFILE;


4. Setup tnsnames.ora di primary dan standby database 

--#PRIMARY
OPCRMBE =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exa82tbs-scan1)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPCRMBE)
    )
  )

OPCRMBE1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exa82tbsdb01-vip)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPCRMBE)
      (SID = OPCRMBE1)
    )
  )

OPCRMBE2 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exa82tbsdb02-vip)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPCRMBE)
      (SID = OPCRMBE2)
    )
  )



--#STANDBY
OPCRMBSD =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exa82bsdp-scan1)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPCRMBSD)
      (UR=A)
    )
  )

OPCRMBSD1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exa82bsdpdb01-vip)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPCRMBSD)
      (UR=A)
    )
  )
  
OPCRMBSD2 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = exa82bsdpdb02-vip)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPCRMBSD)
      (UR=A)
    )
  ) 



5. backup pfile and drop old standby database
SQL> 
create pfile='/home/oracle/pfile_20210616.txt' from spfile;

--DROP STANDBY DATABASE
DROP DATABASE;



6. Create dan copy password file dari primary ke standby database
--create and copy password file:
cd /u01/app/oracle/product/12.1.0.2/dbhome_1/dbs
orapwd file='orapwOPCRMBE1' password=xxxxxxxxxxx force=y ignorecase=Y

--copy to node 2 and standby 
scp orapwOPCRMBE1 oracle@exa82tbspdbadm01:/u01/app/oracle/product/12.1.0.2/dbhome_1/dbs/orapwOPCRMBE2
scp orapwOPCRMBE1 oracle@ 10.49.132.14:/u01/app/oracle/product/12.1.0.2/dbhome_1/dbs/ orapwOPCRMBSD1
scp orapwOPCRMBE1 oracle@ 10.49.132.15:/u01/app/oracle/product/12.1.0.2/dbhome_1/dbs/ orapwOPCRMBSD2



7. Create directory on file system for dump trace and file db on ASM

--FILE SYSTEM (BOTH NODES)
cd /u01/app/oracle/admin/
mkdir OPCRMBSD
cd OPCRMBSD
mkdir adump bdump cdump udump

--ON ASM
. .grid_profile
asmcmd
cd +DATAC1/
mkdir OPCRMBSD
cd OPCRMBSD
mkdir PARAMETERFILE DATAFILE CONTROLFILE TEMPFILE ONLINELOG
cd ../..
cd +RECOC1/
mkdir OPCRMBSD
cd OPCRMBSD
mkdir CONTROLFILE ONLINELOG

#####
asmcmd
cd +DATAC2/
mkdir OPCRMBSD
cd OPCRMBSD
mkdir PARAMETERFILE DATAFILE CONTROLFILE TEMPFILE ONLINELOG
cd ../..
cd +RECOC2/
mkdir OPCRMBSD
cd OPCRMBSD
mkdir CONTROLFILE ONLINELOG



8. di primary Create controlfile standby :

--creta standby control_files
SQL> 
ALTER DATABASE CREATE STANDBY CONTROLFILE AS '/home/oracle/ssi/OPCRMBE/OPCRMBE_stby.ctl';


--kirim ke standby
scp OPCRMBE_stby.ctl oracle@ 10.49.132.14:/home/oracle/ssi/OPCRMBSD/OPCRMBE_stby.ctl


STANDBY: --copy ke asm
. .grid_profile
asmcmd
cd +DATAC1/OPCRMBSD/CONTROLFILE/
cp /home/oracle/ssi/ OPCRMBSD /OPCRMBE_stby.ctl OPCRMBSD_stby.ctl
cd +RECOC2/OPCRMBSD/CONTROLFILE/
cp /home/oracle/ssi/ OPCRMBSD /OPCRMBE_stby.ctl OPCRMBSD_stby.ctl



9. Di primary backup/create pfile dan configure untuk database standby 

--create backup spfile
SQL> create pfile='/home/oracle/ssi/OPCRMBE/pfile_OPCRMBSD_backup_15062021.txt' from spfile;


alter system set LOG_ARCHIVE_DEST_STATE_4=DEFER sid='*' scope=both; 

tidak perlu lagi karena sudah di alter sebelumnya
--alter system set LOG_ARCHIVE_CONFIG='DG_CONFIG=(OPCRMBE,OPCRMBSD)' sid='*' scope=both;
--alter system set LOG_ARCHIVE_DEST_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=OPCRMBE' sid='*' scope=both;
--alter system set LOG_ARCHIVE_DEST_2='SERVICE=OPCRMBSD1 ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=OPCRMBSD ' sid='*' scope=both;
--alter system set LOG_ARCHIVE_DEST_STATE_1=ENABLE sid='*' scope=both;
--alter system set LOG_ARCHIVE_DEST_STATE_2=DEFER sid='*' scope=both;
--alter system set FAL_CLIENT='OPCRMBE' sid='*' scope=both;
--alter system set FAL_SERVER='OPCRMBSD' sid='*' scope=both;


 

-- Create pfile from spfile:
SQL> show parameter pfile;
NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
spfile		          string	 +DATAC1/OPCRMBE/PARAMETERFILE/spfile.270.1026737765

#PRIMARY PFILE:
SQL> create pfile='/home/oracle/ssi/OPCRMBE/pfile_OPCRMBE_15062021.txt' from spfile;

- PRIMARY PFILE
OPCRMBE1.__data_transfer_cache_size=0
OPCRMBE2.__data_transfer_cache_size=0
OPCRMBE1.__db_cache_size=156229435392
OPCRMBE2.__db_cache_size=156229435392
OPCRMBE1.__java_pool_size=3758096384
OPCRMBE2.__java_pool_size=3758096384
OPCRMBE1.__large_pool_size=1073741824
OPCRMBE2.__large_pool_size=1073741824
OPCRMBE1.__oracle_base='/u01/app/oracle'#ORACLE_BASE set from environment
OPCRMBE2.__oracle_base='/u01/app/oracle'#ORACLE_BASE set from environment
OPCRMBE1.__pga_aggregate_target=64424509440
OPCRMBE2.__pga_aggregate_target=64424509440
OPCRMBE1.__sga_target=182536110080
OPCRMBE2.__sga_target=182536110080
OPCRMBE1.__shared_io_pool_size=536870912
OPCRMBE2.__shared_io_pool_size=536870912
OPCRMBE1.__shared_pool_size=19327352832
OPCRMBE2.__shared_pool_size=19327352832
OPCRMBE1.__streams_pool_size=0
OPCRMBE2.__streams_pool_size=0
*._always_semi_join='OFF'
*._b_tree_bitmap_plans=FALSE
*._gc_defer_time=0
*._gc_policy_minimum=1000000
*._like_with_bind_as_equality=TRUE
*._no_or_expansion=FALSE
*._optimizer_max_permutations=100
*._parallel_adaptive_max_users=2
*._partition_view_enabled=FALSE
*._smm_auto_max_io_size=1024
*.archive_lag_target=0
*.audit_sys_operations=TRUE
*.audit_trail='db'
*.cluster_database=TRUE
OPCRMBE1.cluster_interconnects='192.168.10.1:192.168.10.2'
OPCRMBE2.cluster_interconnects='192.168.10.3:192.168.10.4'
*.compatible='12.1.0.2.0'
*.control_files='+DATAC1/OPCRMBE/CONTROLFILE/current.259.1026737357'
*.cursor_sharing='EXACT'
*.db_block_checking='false'
*.db_block_checksum='full'
*.db_block_size=8192
*.db_cache_advice='ON'
*.db_cache_size=107374182400
*.db_create_file_dest='+DATAC1'
*.db_create_online_log_dest_1='+DATAC1'
*.db_domain=''
*.db_file_multiblock_read_count=32
*.db_files=5000
*.db_lost_write_protect='typical'
*.db_name='OPCRMBE'
*.db_recovery_file_dest='+RECOC2'
*.db_recovery_file_dest_size=8589934592000
*.db_unique_name='OPCRMBE'#ENSURE THAT DB_UNIQUE_NAME IS UNIQUE ACROSS THE ENTERPRISE
*.dg_broker_config_file1='+DATAC1/OPCRMBE/dr1OPCRMBE.dat'
*.dg_broker_config_file2='+DATAC1/OPCRMBE/dr2OPCRMBE.dat'
*.dg_broker_start=TRUE
*.diagnostic_dest='/u01/app/oracle'
*.enable_goldengate_replication=TRUE
*.fal_client='OPCRMBE'
*.fal_server='OPCRMBSD'
*.fast_start_mttr_target=300
*.fast_start_parallel_rollback='FALSE'
*.filesystemio_options='setall'
*.global_names=FALSE
OPCRMBE2.instance_number=2
OPCRMBE1.instance_number=1
*.log_archive_config='dg_config=(zdlra,opcrmbe,opcrmbsd)'
*.log_archive_dest_1='location=USE_DB_RECOVERY_FILE_DEST valid_for=(ALL_LOGFILES,ALL_ROLES) MAX_FAILURE=1 REOPEN=5 DB_UNIQUE_NAME=OPCRMBE ALTERNATE=LOG_ARCHIVE_DEST_2'
*.log_archive_dest_2='location=+DATAC2','valid_for=(ALL_LOGFILES,ALL_ROLES)','DB_UNIQUE_NAME=OPCRMBE','ALTERNATE=LOG_ARCHIVE_DEST_1'
*.log_archive_dest_3='SERVICE="zdlra62-scan:1521/zdlra:dedicated"',' VALID_FOR=(ALL_LOGFILES, ALL_ROLES) ASYNC DB_UNIQUE_NAME=zdlra'
*.log_archive_dest_4='service="opcrmbsd"','ASYNC NOAFFIRM delay=0 optional compression=disable max_failure=0 max_connections=1 reopen=300 db_unique_name="opcrmbsd" net_timeout=30','valid_for=(online_logfile,all_roles)'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_dest_state_2='ALTERNATE'
*.log_archive_dest_state_3='ENABLE'
*.log_archive_dest_state_4='ENABLE'
*.log_archive_format='%t_%s_%r.dbf'
OPCRMBE1.log_archive_format='%t_%s_%r.dbf'
OPCRMBE2.log_archive_format='%t_%s_%r.dbf'
*.log_archive_max_processes=4
*.log_archive_min_succeed_dest=1
OPCRMBE1.log_archive_trace=0
OPCRMBE2.log_archive_trace=0
*.log_buffer=1073741824
OPCRMBE2.open_cursors=5000
OPCRMBE1.open_cursors=5000
*.open_cursors=50000
*.optimizer_adaptive_features=FALSE
*.optimizer_dynamic_sampling=1
*.optimizer_index_caching=0
*.optimizer_index_cost_adj=1
*.optimizer_mode='ALL_ROWS'
*.os_authent_prefix=''
*.parallel_adaptive_multi_user=FALSE
*.parallel_degree_policy='MANUAL'
*.parallel_max_servers=128
*.parallel_threads_per_cpu=1
*.pga_aggregate_target=64424509440
*.processes=5132
*.query_rewrite_enabled='FALSE'
*.query_rewrite_integrity='ENFORCED'
*.recyclebin='OFF'
*.redo_transport_user='SYS'
*.remote_login_passwordfile='exclusive'
*.session_cached_cursors=1500
*.sessions=7720
*.sga_max_size=182536110080
*.sga_target=182536110080
*.shared_pool_size=19327352832
*.sql92_security=TRUE
*.standby_file_management='MANUAL'
*.star_transformation_enabled='FALSE'
*.statistics_level='TYPICAL'
OPCRMBE2.thread=2
OPCRMBE1.thread=1
*.timed_statistics=TRUE
*.undo_retention=3600
OPCRMBE2.undo_tablespace='UNDOTBS2'
OPCRMBE1.undo_tablespace='UNDOTBS1'
*.use_large_pages='ONLY'


--#STANDBY PFILE
OPCRMBSD2.__data_transfer_cache_size=0
OPCRMBSD1.__data_transfer_cache_size=0
OPCRMBSD2.__db_cache_size=21273509888
OPCRMBSD1.__db_cache_size=20065550336
OPCRMBSD2.__java_pool_size=402653184
OPCRMBSD1.__java_pool_size=402653184
OPCRMBSD2.__large_pool_size=402653184
OPCRMBSD1.__large_pool_size=402653184
OPCRMBSD1.__oracle_base='/u01/app/oracle'#ORACLE_BASE set from environment
OPCRMBSD2.__oracle_base='/u01/app/oracle'#ORACLE_BASE set from environment
OPCRMBSD2.__pga_aggregate_target=17179869184
OPCRMBSD1.__pga_aggregate_target=17179869184
OPCRMBSD2.__sga_target=25769803776
OPCRMBSD1.__sga_target=25769803776
OPCRMBSD2.__shared_io_pool_size=536870912
OPCRMBSD1.__shared_io_pool_size=536870912
OPCRMBSD2.__shared_pool_size=2952790016
OPCRMBSD1.__shared_pool_size=4160749568
OPCRMBSD2.__streams_pool_size=0
OPCRMBSD1.__streams_pool_size=0
*._parallel_adaptive_max_users=2
*._smm_auto_max_io_size=1024
*.archive_lag_target=0
*.audit_sys_operations=TRUE
*.audit_trail='db'
*.cluster_database=TRUE
OPCRMBSD1.cluster_interconnects='192.168.10.1:192.168.10.2'
OPCRMBSD2.cluster_interconnects='192.168.10.3:192.168.10.4'
*.compatible='12.1.0.2.0'
*.control_files='+DATAC1/OPCRMBSD/CONTROLFILE/current.259.1069804651'#Restore Controlfile
*.db_block_checking='false'
*.db_block_checksum='full'
*.db_block_size=8192
*.db_create_file_dest='+DATAC1'
*.db_create_online_log_dest_1='+DATAC1'
*.db_domain=''
*.db_files=1024
*.db_lost_write_protect='typical'
*.db_name='OPCRMBE'
*.db_recovery_file_dest='+RECOC2'
*.db_recovery_file_dest_size=10737418240000
*.db_unique_name='OPCRMBSD'#ENSURE THAT DB_UNIQUE_NAME IS UNIQUE ACROSS THE ENTERPRISE
*.dg_broker_config_file1='+DATAC1/OPCRMBSD/dr1OPCRMBSD.dat'
*.dg_broker_config_file2='+DATAC1/OPCRMBSD/dr2OPCRMBSD.dat'
*.dg_broker_start=TRUE
*.diagnostic_dest='/u01/app/oracle'
*.fal_client='OPCRMBSD'
*.fal_server='opcrmbe'
*.fast_start_mttr_target=300
*.filesystemio_options='setall'
*.global_names=TRUE
OPCRMBSD1.instance_number=1
OPCRMBSD2.instance_number=2
*.log_archive_config='dg_config=(zdlra,opcrmbe,opcrmbsd)'
*.log_archive_dest_1='location=USE_DB_RECOVERY_FILE_DEST valid_for=(ALL_LOGFILES,ALL_ROLES) MAX_FAILURE=1 REOPEN=5 DB_UNIQUE_NAME=OPCRMBSD ALTERNATE=LOG_ARCHIVE_DEST_2'
*.log_archive_dest_2='location=+DATAC1 valid_for=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=OPCRMBSD ALTERNATE=LOG_ARCHIVE_DEST_1'
*.log_archive_dest_state_1='ENABLE'
*.log_archive_dest_state_2='ALTERNATE'
*.log_archive_format='%t_%s_%r.dbf'
OPCRMBSD2.log_archive_format='%t_%s_%r.dbf'
OPCRMBSD1.log_archive_format='%t_%s_%r.dbf'
*.log_archive_max_processes=4
*.log_archive_min_succeed_dest=1
OPCRMBSD2.log_archive_trace=0
OPCRMBSD1.log_archive_trace=0
*.log_buffer=134217728
*.open_cursors=1000
*.os_authent_prefix=''
*.parallel_adaptive_multi_user=FALSE
*.parallel_threads_per_cpu=1
*.pga_aggregate_target=16384m
*.processes=1024
*.recyclebin='on'
*.remote_login_passwordfile='exclusive'
*.sga_target=24576m
*.sql92_security=TRUE
*.standby_file_management='AUTO'
OPCRMBSD2.thread=2
OPCRMBSD1.thread=1
OPCRMBSD1.undo_tablespace='UNDOTBS1'
OPCRMBSD2.undo_tablespace='UNDOTBS2'
*.use_large_pages='ONLY'



9. Create profile di server standby:
node1:
export ORACLE_SID=OPCRMBSD1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/u01/app/oracle/product/12.1.0.2/dbhome_1/bin

node2:
export ORACLE_SID=OPCRMBSD2
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/u01/app/oracle/product/12.1.0.2/dbhome_1/bin


10. Start instance di standby database (nomount) menggunaka pfile yang dibuat di step nomor 7 
SQL> startup nomount pfile =' /home/oracle/ssi/OPCRMBSD/pfile_OPCRMBSD_15062021.txt';


11. Tes koneksi dari server primary ke standby database :
#PRIMARY KE STANDBY:
tnsping OPCRMBSD
tnsping OPCRMBSD1
tnsping OPCRMBSD2
sqlplus sys@OPCRMBSD as sysdba
sqlplus sys@OPCRMBSD1 as sysdba
sqlplus sys@OPCRMBSD2 as sysdba

#STANDBY KE PRIMARY:
tnsping OPCRMBE
tnsping OPCRMBE
tnsping OPCRMBE
sqlplus sys@OPCRMBE as sysdba
sqlplus sys@OPCRMBE1 as sysdba
sqlplus sys@OPCRMBE2 as sysdba

12. Di server primary, perform RMAN duplicate dari primary database 

export ORACLE_SID=OPCRMBE1
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.4/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman target sys/OR4cl35y5#2015@OPCRMBE1AUXILIARY sys/OR4cl35y5#2015@ OPCRMBSD1 trace=/home/oracle/ssi/OPCRMBSD/duplicate_OPCRMBSD_23062021.log << EOF
run {
allocate channel c1 device type disk; 
allocate channel c2 device type disk;  
allocate channel c3 device type disk;
allocate channel c4 device type disk;
allocate auxiliary channel c1 device type disk;
allocate auxiliary channel c2 device type disk;
duplicate target database for standby from active database;  
}
exit
EOF



13. Di server standby, setelah selesai duplicate database standby, Check status database standby di node 1 
SQL> select name, database_role from v$database;



14. Di server standby, create spfile from pfile
- Create spfile from pfile:
SQL> create spfile='+DATAC1/OPCRMBSD/PARAMETERFILE/spfileOPCRMBSD.ora' from pfile='/home/oracle/ssi/OPCRMBSD/ pfile_OPCRMBSD_15062021.txt';



15. Di server standby, Shutdown database di node 1 
SQL> shutdown immediate;



16. Di server standby, Register Standby Database Resources with Clusterware 
. .OPCRMBSD_profile
$ srvctl add database -d OPCRMBSD -o /u01/app/oracle/product/12.1.0.2/dbhome_1
$ srvctl add instance -d OPCRMBSD -i OPCRMBSD1 -n exa82bsdpdbadm01
$ srvctl add instance -d OPCRMBSD -i OPCRMBSD2 -n exa82bsdpdbadm02
$ srvctl modify database -d OPCRMBSD -r physical_standby
$ srvctl modify database -d OPCRMBSD -p '+DATAC1/OPCRMBSD/PARAMETERFILE/spfileOPCRMBSD.ora'



17. Di server standby, Start standby database 
$ srvctl start database -d OPCRMBSD -o mount



18. Di server primary, ENABLE status LOG_ARCHIVE_DEST_STATE_3  
SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_4 = ENABLE sid='*' scope=both;



19. Di server standby, Enable MRP dan recover database 
SQL> alter database recover managed standby database using current logfile disconnect;


20. Di server standby, Monitor apply process 
select thread#,sequence#,archived,applied from v$archived_log order by first_time;
select inst_id, process, status, thread#, sequence#, block#, blocks from gv$managed_standby where process in ('RFS','LNS','MRP0');
select DEST_ID,dest_name,status,type,srl,recovery_mode from v$archive_dest_status where dest_id=1;
select name, open_mode, database_role,open_mode from gv$database;



19. Di server standby, Enable MRP dan recover database 
SQL> alter database recover managed standby database using current logfile disconnect;



20. Di server standby, Monitor apply process 
select thread#,sequence#,archived,applied from v$archived_log order by first_time;
select inst_id, process, status, thread#, sequence#, block#, blocks from gv$managed_standby where process in ('RFS','LNS','MRP0');
select DEST_ID,dest_name,status,type,srl,recovery_mode from v$archive_dest_status where dest_id=1;
select name, open_mode, database_role from v$database;



21. Di server primary, check status archive destination 
set line 200
col DEST_NAME for a50
col BINDING for a10
select DEST_ID,DEST_NAME,STATUS,BINDING,ERROR from v$ARCHIVE_DEST where status<>'INACTIVE';



22. Di server standby, Open read only standby database 
Alter database recover managed standby database cancel;
Alter database open read only;
alter database recover managed standby database using current logfile disconnect from session;



23. Di server standby, Monitor MRP - Managed Recover Process: 
untuk otomatis proses apply archive yang sudah diterima dari primary proses 
SELECT PROCESS, STATUS, THREAD#, SEQUENCE#, BLOCK#, BLOCKS FROM V$MANAGED_STANDBY;
select name, applied from v$archived_log where applied = 'NO' order by name;
select * from v$archive_gap;
select group#,status from v$standby_log;
select START_TIME,TYPE, ITEM,UNITS,SOFAR,TIMESTAMP from v$recovery_progress where ITEM='Last Applied Redo';
select max(sequence#) from v$log_history; (di database primary & standby)
select name, instance_name, open_mode, database_role, flashback_on , current_scn from v$database,v$instance;  (di database primary & standby)
