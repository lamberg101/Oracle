1. PASTIKAN ARCHIVING DI PRIMARY DATABASE SUDAH ARCHIVE MODE. (done)

SQL> SELECT log_mode FROM v$database;

LOG_MODE
------------
ARCHIVELOG

NAME	  DATABASE_ROLE
--------- ----------------
OPHPOINT	  PRIMARY

SQL> exaimcpdb01-mgt.telkomsel.co.id

SQL> Tue Jan 19 22:23:23 WIB 2021

--------------------------------------------------------------------------------------------------------

2. Check AND ENABLE FORCE LOGGING DI PRIMARY DATABASE (done)

SQL> select force_logging from v$database;

FOR
---
YES

NAME	  DATABASE_ROLE
--------- ----------------
OPHPOINT	  PRIMARY

SQL> exaimcpdb01-mgt.telkomsel.co.id

SQL> Tue Jan 19 22:23:55 WIB 2021


--------------------------------------------------------------------------------------------------------

3. CREATE STANDBY REDO LOGS DI PRIMARY DATABASE. (done)

SQL> select group#,THREAD#,bytes/1024/1024 "Size in MB" from v$log;

    GROUP#    THREAD# Size in MB
---------- ---------- ----------
	 1	    1	    1024
	 2	    1	    1024
	 3	    1	    1024
	 4	    1	    1024
	 5	    1	    1024
	 6	    1	    1024
	 7	    1	    1024
	 8	    2	    1024
	 9	    2	    1024
	10	    2	    1024
	11	    2	    1024
	12	    2	    1024
	13	    2	    1024
	14	    2	    1024

14 rows selected.

NAME	  DATABASE_ROLE
--------- ----------------
OPHPOINT  PRIMARY

SQL> exaimcpdb01-mgt.telkomsel.co.id

SQL> Thu Feb 18 04:39:19 WIB 2021.

set pagesize 200
set linesize 900
col member format a80
col type format a10
select * from v$logfile;
GROUP# STATUS  TYPE       MEMBER							  IS_
---------- ------- ---------- ----------------------------------------------- ---
	 1	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_1.7262.967797375		NO
	 1	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_1.54866.967797377	 NO
	 2	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_2.7263.967797377		NO
	 2	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_2.54867.967797377	 NO
	 5	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_5.7266.967797381		NO
	 5	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_5.54870.967797381	 NO
	 6	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_6.7267.967797383		NO
	 6	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_6.54871.967797383	 NO
	 8	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_8.7269.967797385		NO
	 8	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_8.54873.967797385	 NO
	 9	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_9.7270.967797385		NO
	 9	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_9.54874.967797387	 NO
	 3	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_3.7264.967797379		NO
	 3	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_3.54868.967797379	 NO
	 4	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_4.7265.967797379		NO
	 4	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_4.54869.967797381	 NO
	 7	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_7.7268.967797383		NO
	 7	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_7.54872.967797385	 NO
	10	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_10.7271.967797387	 NO
	10	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_10.54875.967797387	 NO
	11	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_11.7272.967797389	 NO
	11	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_11.54876.967797389	 NO
	12	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_12.7273.967797389	 NO
	12	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_12.54877.967797391	 NO
	13	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_13.7274.967797391	 NO
	13	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_13.54878.967797391	 NO
	14	   ONLINE     +DATAIMC/ophpointimc/onlinelog/group_14.7275.967797393	 NO
	14	   ONLINE     +RECOIMC/ophpointimc/onlinelog/group_14.54879.967797393	 NO
	16	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_16.7277.967797395	 NO
	16	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_16.54881.967797395	 NO
	17	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_17.7278.967797397	 NO
	17	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_17.54882.967797397	 NO
	15	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_15.7276.967797393	 NO
	15	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_15.54880.967797395	 NO
	18	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_18.7279.967797397	 NO
	18	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_18.54883.967797399	 NO
	19	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_19.7280.967797399	 NO
	19	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_19.54884.967797401	 NO
	20	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_20.7281.967797401	 NO
	20	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_20.54885.967797401	 NO
	21	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_21.7282.967797401	 NO
	21	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_21.54886.967797403	 NO
	22	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_22.7283.967797403	 NO
	22	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_22.54887.967797405	 NO
	23	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_23.7284.967797405	 NO
	23	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_23.54888.967797405	 NO
	24	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_24.7285.967797407	 NO
	24	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_24.54889.967797407	 NO
	25	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_25.7286.967797407	 NO
	25	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_25.54890.967797409	 NO
	26	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_26.7287.967797409	 NO
	26	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_26.54891.967797409	 NO
	27	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_27.7288.967797411	 NO
	27	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_27.54892.967797411	 NO
	28	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_28.7289.967797411	 NO
	28	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_28.54893.967797413	 NO
	29	   STANDBY    +DATAIMC/ophpointimc/onlinelog/group_29.7290.967797413	 NO
	29	   STANDBY    +RECOIMC/ophpointimc/onlinelog/group_29.54894.967797413	 NO



Note! kalau belum ada standby log file nya

untuk logstanby, jumalh yg di create, logfile +1

**** CRAETE STANDBY REDO LOG **** (belum)

alter database add standby logfile THREAD 1
group 23 ('+DATAC2','+RECOC2') size 1024M,
group 24 ('+DATAC2','+RECOC2') size 1024M,
group 25 ('+DATAC2','+RECOC2') size 1024M,
group 26 ('+DATAC2','+RECOC2') size 1024M,
group 27 ('+DATAC2','+RECOC2') size 1024M,
group 28 ('+DATAC2','+RECOC2') size 1024M,
group 29 ('+DATAC2','+RECOC2') size 1024M,
group 30 ('+DATAC2','+RECOC2') size 1024M,
group 31 ('+DATAC2','+RECOC2') size 1024M,
group 32 ('+DATAC2','+RECOC2') size 1024M;

alter database add standby logfile THREAD 2
group 33 ('+DATAC2','+RECOC2') size 1024M,
group 34 ('+DATAC2','+RECOC2') size 1024M,
group 35 ('+DATAC2','+RECOC2') size 1024M,
group 36 ('+DATAC2','+RECOC2') size 1024M,
group 37 ('+DATAC2','+RECOC2') size 1024M,
group 38 ('+DATAC2','+RECOC2') size 1024M,
group 39 ('+DATAC2','+RECOC2') size 1024M,
group 40 ('+DATAC2','+RECOC2') size 1024M,
group 41 ('+DATAC2','+RECOC2') size 1024M,
group 42 ('+DATAC2','+RECOC2') size 1024M;


contoh lain:
Example last group number nya 4
SQL>
alter database add standby logfile thread 1 
group 5 ('+DATA1','+RECO1') size 200M,
group 6 ('+DATA1','+RECO1') size 200M,
group 7 ('+DATA1','+RECO1') size 200M;

SQL>
alter database add standby logfile thread 2 
group 8 ('+DATA1','+RECO1') size 200M,
group 9 ('+DATA1','+RECO1') size 200M,
group 10 ('+DATA1','+RECO1') size 20

--------------------------------------------------------------------------------------------------------

4. SETUP TNSNAMES.ORA DI PRIMARY DAN STANDBY DATABASE (done)

#PRIMARY:
OPHPOINTIMC =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = exaimcpdb-scan)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPHPOINTIMC)
      (UR = A)
    )
  )
  
OPHPOINTIMC2 =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.53.71.164)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPHPOINTIMC)
      (SID = OPHPOINTIMC2)
      (UR = A)
    )
  )

OPHPOINTIMC1 =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.53.71.163)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = OPHPOINTIMC)
      (SID = OPHPOINTIMC1)
      (UR = A)
    )
  )
------------------------------------

#STANDBY
OPPOIN19  =
		(DESCRIPTION = 
			(ADDRESS_LIST = (ADDRESS = 
				(PROTOCOL = TCP)(HOST = exaimcpdb-scan)(PORT = 1521))) 
			(CONNECT_DATA = (SERVER = DEDICATED) 
		(SERVICE_NAME = OPPOIN19 ) 
	(UR=A)
	)
)

OPPOIN191 = 
	(DESCRIPTION = 
		(ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)
			(HOST = 10.53.71.163)(PORT = 1521))) 
		(CONNECT_DATA = (SERVER = DEDICATED) 
	(SERVICE_NAME = OPPOIN19 ) 
	(SID = OPPOIN191) 
	(UR=A)
	)
)

OPPOIN192 = 
	(DESCRIPTION = 
		(ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)
			(HOST = 10.53.71.164)(PORT = 1521))) 
		(CONNECT_DATA = (SERVER = DEDICATED) 
	(SERVICE_NAME = OPPOIN19) 
	(SID = OPPOIN192) 
	(UR=A)
	)
)


--------------------------------------------------------------------------------------------------------


5. CREATE DAN COPY PASSWORD FILE DARI PRIMARY KE STANDBY DATABASE (done)

-- CREATE AND COPY PASSWORD FILE:
cd /u01/app/oracle/product/11.2.0/dbhome_1/dbs/
orapwd file='orapwOPHPOINTIMC1' password=OR4cl35y5#2015 force=y ignorecase=Y

-- COPY TO NODE 2 AND STANDBY 
scp orapwOPHPOINTIMC1 oracle@exaimcpdb02-mgt:/u01/app/oracle/product/11.2.0/dbhome_1/dbs/orapwOPHPOINTIMC2
scp orapwOPHPOINTIMC1 oracle@10.250.192.181:/u01/app/oracle/product/11.2.0/dbhome_1/dbs/orapwOPPOIN191
scp orapwOPHPOINTIMC1 oracle@10.250.192.182:/u01/app/oracle/product/11.2.0/dbhome_1/dbs/orapwOPPOIN192


--------------------------------------------------------------------------------------------------------

6. CREATE DIRECTORY FILE SYSTEM DAN ASM DI SERVER STANDBY (done)

--FILE SYSTEM (BOTH NODES)
cd /u01/app/oracle/admin/
mkdir OPPOIN19
cd OPPOIN19
mkdir adump bdump cdump udump

--ON ASM
. .grid_profile
asmcmd
cd +DATAIMC/
mkdir OPPOIN19
cd OPPOIN19
mkdir PARAMETERFILE DATAFILE CONTROLFILE TEMPFILE ONLINELOG
cd ../..
cd +RECOIMC/
mkdir OPPOIN19
cd OPPOIN19
mkdir CONTROLFILE ONLINELOG

--------------------------------------------------------------------------------------------------------

7. DI PRIMARY CREATE CONTROLFILE STANDBY (done)

SQL> ALTER DATABASE CREATE STANDBY CONTROLFILE AS '/home/oracle/ssi/slam/OPHPOINT19/OPHPOINTIMC_stby.ctl';

--kirim ke standby
cp OPHPOINTIMC_stby.ctl /home/oracle/ssi/slam/OPHPOINT19/OPHPOIN19_stby.ctl


STANDBY: --copy ke asm
. .grid_profile
asmcmd
cd +DATAIMC/OPPOIN19/CONTROLFILE/
cp /home/oracle/ssi/slam/OPHPOINT19/OPHPOINTIMC_stby.ctl +DATAIMC/OPPOIN19/CONTROLFILE/OPHPOIN19_stby.ctl




--------------------------------------------------------------------------------------------------------

8. DI PRIMARY BACKUP/CREATE PFILE DAN CONFIGURE UNTUK DATABASE STANDBY (dne)

SQL> create pfile='/home/oracle/ssi/slam/OPHPOINT19/pfile_OPHPOINTIMC_backup_18022021.txt' from spfile;

create pfile='/home/oracle/ssi/slam/OPHPOINT19/pfile_OPPOIN19_backup_24022021.txt' from spfile;

alter system set LOG_ARCHIVE_CONFIG='DG_CONFIG=(OPHPOINTIMC,OPPOIN19)' sid='*' scope=both;
alter system set LOG_ARCHIVE_DEST_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=OPHPOINTIMC' sid='*' scope=both;
alter system set LOG_ARCHIVE_DEST_2='SERVICE=OPHPNT191 ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=OPPOIN19 ' sid='*' scope=both;
alter system set LOG_ARCHIVE_DEST_STATE_1=ENABLE sid='*' scope=both;
alter system set LOG_ARCHIVE_DEST_STATE_2=DEFER sid='*' scope=both;
alter system set FAL_CLIENT='OPHPOINTIMC' sid='*' scope=both;
alter system set FAL_SERVER='OPPOIN19' sid='*' scope=both;
--alter system set LOG_ARCHIVE_MAX_PROCESSES=30 sid='*' scope=both;
--alter system set STANDBY_FILE_MANAGEMENT=AUTO sid='*' scope=both;


-- CREATE PFILE FROM SPFILE:
SQL> show parameter pfile;
NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
spfile				     string	 +DATAIMC/OPHPOIN19/PARAMETERFILE/spfile.20649.1037812629


#PRIMARY PFILE:
SQL> create pfile='/home/oracle/ssi/slam/OPHPOINT19/pfile_OPHPOIN19.txt' from spfile;

- PRIMARY PFILE
OPHPOINTIMC2.__db_cache_size=26172456960
OPHPOINTIMC1.__db_cache_size=26038239232
OPHPOINTIMC1.__java_pool_size=939524096
OPHPOINTIMC2.__java_pool_size=939524096
OPHPOINTIMC1.__large_pool_size=939524096
OPHPOINTIMC2.__large_pool_size=939524096
OPHPOINTIMC1.__pga_aggregate_target=8589934592
OPHPOINTIMC2.__pga_aggregate_target=8589934592
OPHPOINTIMC1.__sga_target=37580963840
OPHPOINTIMC2.__sga_target=37580963840
OPHPOINTIMC1.__shared_io_pool_size=0
OPHPOINTIMC2.__shared_io_pool_size=0
OPHPOINTIMC2.__shared_pool_size=9126805504
OPHPOINTIMC1.__shared_pool_size=9261023232
OPHPOINTIMC1.__streams_pool_size=134217728
OPHPOINTIMC2.__streams_pool_size=134217728
*.archive_lag_target=0
*.audit_file_dest='/u01/app/oracle/admin/OPHPOINTIMC/adump'
*.audit_trail='db'
*.cluster_database=true
OPHPOINTIMC1.cluster_interconnects='192.168.11.31:192.168.11.32'
OPHPOINTIMC2.cluster_interconnects='192.168.11.33:192.168.11.34'
*.compatible='11.2.0.4.0'
*.control_file_record_keep_time=14
*.control_files='+DATAIMC/OPHPOINTIMC/CONTROLFILE/OPHPOINT_stby.ctl'
*.db_block_size=8192
*.db_create_file_dest='+DATAIMC'
*.db_create_online_log_dest_1='+DATAIMC'
*.db_create_online_log_dest_2='+RECOIMC'
*.db_domain=''
*.db_file_name_convert='+DATA_EXAP/OPHPOINT','+DATAIMC/OPHPOINTIMC'
*.db_files=30000
*.db_name='OPHPOINT'
*.db_recovery_file_dest='+RECOIMC'
*.db_recovery_file_dest_size=3221225472000
*.db_unique_name='OPHPOINTIMC'
*.dg_broker_config_file1='+DATAIMC/OPHPOINTIMC/PARAMETERFILE/dr1OPHPOINT.dat'
*.dg_broker_config_file2='+DATAIMC/OPHPOINTIMC/PARAMETERFILE/dr2OPHPOINT.dat'
*.dg_broker_start=FALSE
*.diagnostic_dest='/u01/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=OPHPOINTXDB)'
*.fal_client='OPHPOINTIMC'
*.fal_server='OPHPOINT'
OPHPOINTIMC2.instance_number=2
OPHPOINTIMC1.instance_number=1
*.java_jit_enabled=FALSE
*.job_queue_processes=20
*.log_archive_config='dg_config=(ophpoint,ophpointimc,rabsdp)'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=OPHPOINTIMC'
*.log_archive_dest_2='SERVICE="zdlrabsda-scan:1521/rabsdp:dedicated"',' VALID_FOR=(ALL_LOGFILES, ALL_ROLES) ASYNC DB_UNIQUE_NAME=rabsdp'
*.log_archive_dest_state_2='ENABLE'
*.log_archive_format='arch_%t_%s_%r.arc'
OPHPOINTIMC2.log_archive_format='arch_%t_%s_%r.arc'
OPHPOINTIMC1.log_archive_format='arch_%t_%s_%r.arc'
*.log_archive_max_processes=30
*.log_archive_min_succeed_dest=1
OPHPOINTIMC2.log_archive_trace=0
OPHPOINTIMC1.log_archive_trace=0
*.log_file_name_convert='+DATA_EXAP/OPHPOINT','+DATAIMC/OPHPOINTIMC','+RECO_EXAP/OPHPOINT','+RECOIMC/OPHPOINTIMC','+DBFS_EXAP/OPHPOINT','+RECOIMC/OPHPOINTIMC'
*.open_cursors=300
*.pga_aggregate_target=8589934592
*.processes=1325
*.redo_transport_user='RAVPC1'
*.remote_listener='exaimcpdb-scan:1521'
*.remote_login_passwordfile='exclusive'
*.sessions=1655,1200
*.sga_max_size=37580963840
*.sga_target=37580963840
*.shared_pool_reserved_size=838860800
*.shared_pool_size=8388608000
*.sort_area_retained_size=65536000
*.sort_area_size=65536000
*.standby_file_management='AUTO'
OPHPOINTIMC2.thread=2
OPHPOINTIMC1.thread=1
*.undo_retention=90000
OPHPOINTIMC1.undo_tablespace='UNDOTBS1'
OPHPOINTIMC2.undo_tablespace='UNDOTBS2'



#STANDBY PFILE
OPPOIN192.__db_cache_size=26172456960
OPPOIN191.__db_cache_size=26038239232
OPPOIN191.__java_pool_size=939524096
OPPOIN192.__java_pool_size=939524096
OPPOIN191.__large_pool_size=939524096
OPPOIN192.__large_pool_size=939524096
OPPOIN191.__pga_aggregate_target=8589934592
OPPOIN192.__pga_aggregate_target=8589934592
OPPOIN191.__sga_target=37580963840
OPPOIN192.__sga_target=37580963840
OPPOIN191.__shared_io_pool_size=0
OPPOIN192.__shared_io_pool_size=0
OPPOIN192.__shared_pool_size=9126805504
OPPOIN191.__shared_pool_size=9261023232
OPPOIN191.__streams_pool_size=134217728
OPPOIN192.__streams_pool_size=134217728
*.archive_lag_target=0
*.audit_file_dest='/u01/app/oracle/admin/OPPOIN19/adump' --stby sesuaikan path nya
*.audit_trail='db'
*.cluster_database=true
OPPOIN191.cluster_interconnects='192.168.11.31:192.168.11.32'
OPPOIN192.cluster_interconnects='192.168.11.33:192.168.11.34'
*.compatible='11.2.0.4.0'
*.control_file_record_keep_time=14
*.control_files='+DATAIMC/OPPOIN19/CONTROLFILE/OPHPOIN19_stby.ctl'--stby sesuaikan di asm, pastikan ada + nya
*.db_block_size=8192
*.db_create_file_dest='+DATAIMC'--stby
*.db_create_online_log_dest_1='+DATAIMC'
*.db_create_online_log_dest_2='+RECOIMC'
*.db_domain=''
*.db_file_name_convert='+DATAIMC/OPHPOINTIMC','+DATAIMC/OPPOIN19','+RECOIMC/OPHPOINTIMC','+RECOIMC/OPPOIN19'--primary -> stby
*.db_files=30000
*.db_name='OPHPOINT'--primary (show parameter name)
*.db_unique_name='OPPOIN19'--stby
*.db_recovery_file_dest='+RECOIMC'--stby (pastikan sesuai, kalau salah akan masuk ke /u01)
*.db_recovery_file_dest_size=3221225472000
*.diagnostic_dest='/u01/app/oracle'
*.dispatchers='(PROTOCOL=TCP) (SERVICE=OPPOIN19XDB)'--stby
*.fal_client='OPPOIN19'--stby
*.fal_server='OPHPOINTIMC'--primary
OPPOIN192.instance_number=2
OPPOIN191.instance_number=1
*.java_jit_enabled=FALSE
*.job_queue_processes=20
*.log_archive_config='dg_config=(OPPOIN19,OPHPOINTIMC)'--stby->primary
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=OPPOIN19'--stby
*.log_archive_dest_2='SERVICE=OPHPOINTIMC1 ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=OPHPOINTIMC'--primary1,->primary
*.log_archive_dest_state_2='DEFER'
*.log_archive_format='arch_%t_%s_%r.arc'
OPPOIN192.log_archive_format='arch_%t_%s_%r.arc'
OPPOIN191.log_archive_format='arch_%t_%s_%r.arc'
*.log_archive_max_processes=30
*.log_archive_min_succeed_dest=1
OPPOIN192.log_archive_trace=0
OPPOIN191.log_archive_trace=0
*.log_file_name_convert='+DATAIMC/OPHPOINTIMC','+DATAIMC/OPPOIN19','+RECOIMC/OPHPOINTIMC','+RECOIMC/OPPOIN19'--prim,stby --> prim,stby
*.open_cursors=300
*.pga_aggregate_target=8589934592
*.processes=1325
*.remote_listener='exaimcpdb-scan:1521'
*.remote_login_passwordfile='exclusive'
*.sessions=1655,1200
*.sga_max_size=37580963840
*.sga_target=37580963840
*.shared_pool_reserved_size=838860800
*.shared_pool_size=8388608000
*.sort_area_retained_size=65536000
*.sort_area_size=65536000
*.standby_file_management='AUTO'
OPPOIN192.thread=2
OPPOIN191.thread=1
*.undo_retention=90000
OPPOIN191.undo_tablespace='UNDOTBS1'
OPPOIN192.undo_tablespace='UNDOTBS2'


Note!
setelah di sesuaikan, lalu save pfile_OPHPOIN19_stby
dan Copy PFILE nya ke server standby 
scp /home/oracle/ssi/slam/OPHPOINT19/pfile_OPHPOIN19_stby.txt oracle@10.250.192.181:/home/oracle/ss/slam/OPHPOINT19/pfile_OPHPOIN19_stby.txt


--------------------------------------------------------------------------------------------------------

9. CREATE PROFILE DI SERVER STANDBY (done)

--NODE1: 
vi .OPHPOIN19_profile
export ORACLE_SID=OPPOIN191
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

--NODE2:
vi .OPHPOIN19_profile
export ORACLE_SID=OPPOIN192
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib


--------------------------------------------------------------------------------------------------------

10. START INSTANCE DI STANDBY DATABASE (NOMOUNT) MENGGUNAKAN PFILE YANG DIBUAT DI STEP NOMOR 7 

SQL> startup nomount pfile ='/home/oracle/ssi/slam/OPHPOINT19/pfile_OPHPOIN19_stby.txt';


--------------------------------------------------------------------------------------------------------

11. TES KONEKSI DARI SERVER PRIMARY KE STANDBY DATABASE :

--PRIMARY KE STANDBY
tnsping OPPOIN19
tnsping OPPOIN191
tnsping OPPOIN192
sqlplus sys@OPPOIN19 as sysdba
sqlplus sys@OPPOIN191 as sysdba
sqlplus sys@OPPOIN192 as sysdba

--STANDBY KE PRIMARY
tnsping OPHPOINTIMC 
tnsping OPHPOINTIMC1
tnsping OPHPOINTIMC2
sqlplus sys@OPHPOINTIMC  as sysdba
sqlplus sys@OPHPOINTIMC1 as sysdba
sqlplus sys@OPHPOINTIMC2 as sysdba

OR4cl35y5#2015

--TEST AUXILIARY 
$ORACLE_HOME/bin/rman target sys/OR4cl35y5#2015@OPHPOINTIMC1 AUXILIARY sys/OR4cl35y5#2015@OPPOIN191
--------------------------------------------------------------------------------------------------------

12. DI SERVER PRIMARY, PERFORM RMAN DUPLICATE DARI PRIMARY DATABASE 

vi duplicate_ophpoint_29032021.sh
---------------------------
export ORACLE_SID=OPHPOINTIMC1
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
$ORACLE_HOME/bin/rman target sys/OR4cl35y5#2015@OPHPOINTIMC1 AUXILIARY sys/OR4cl35y5#2015@OPPOIN191 trace=/home/oracle/ssi/slam/OPHPOINT19/duplicate_OPHPOIN19_24022021.log << EOF
run {
--allocate channel c1 device type disk;
--allocate channel c2 device type disk;
--allocate channel c3 device type disk;
--allocate channel c4 device type disk;
--allocate auxiliary channel d1 device type disk;
--allocate auxiliary channel d2 device type disk;
--allocate auxiliary channel d3 device type disk;
--allocate auxiliary channel d4 device type disk;
duplicate target database for standby from active database;  
}
exit
EOF

--RUNNING DUPLICATE
$ nohup ./duplicate_ophpoint.sh &

Note!
1. Kalau error di bagian device dkk, coba kuraing allocate channel, sisakan 2
2. Di sesuaikan juga dengan size database

--------------------------------------------------------------------------------------------------------

13. DI SERVER STANDBY, SETELAH SELESAI DUPLICATE DATABASE STANDBY, Check STATUS DATABASE STANDBY DI NODE 1 

SQL> select name, database_role from v$database;

--------------------------------------------------------------------------------------------------------

14. DI SERVER STANDBY, CREATE SPFILE FROM PFILE

--CREATE SPFILE FROM PFILE:
SQL> create spfile='+DATAIMC/OPHPOIN19/PARAMETERFILE/spfileOPHPOIN19.ora' from pfile='/home/oracle/ssi/slam/OPHPOINT19/pfile_OPHPOIN19_stby.txt';

Note!
1. Kalau tidak bisa, di Check lagi pfile nya, pastikan yang ke asm sudah pakai +DISKGROUP
2. Kalau belum -> shutdown database -> bring it to nompount stage -> lalu alter contorl file -> then restart.
example: SQL> alter system set control_files ='+DATAC1/OPIRIS62A/CONTROLFILE/OPIRIS_stby.ctl' sid='*' scope=spfile;

--------------------------------------------------------------------------------------------------------

15. DI SERVER STANDBY, SHUTDOWN DATABASE DI NODE 1 

SQL> SHUTDOWN IMMEDIATE;


--------------------------------------------------------------------------------------------------------

16. DI SERVER STANDBY, REGISTER STANDBY DATABASE RESOURCES WITH CLUSTERWARE 
. .OPCCM19_profile
$ srvctl add database -d OPCCM19 -o /u01/app/oracle/product/12.1.0.2/dbhome_1
$ srvctl add instance -d OPCCM19 -i OPCCM191 -n exa62pdb1-mgt
$ srvctl add instance -d OPCCM19 -i OPCCM192 -n exa62pdb2-mgt
$ srvctl modify database -d OPCCM19 -r physical_standby
$ srvctl modify database -d OPCCM19 -p '+DATAC1/OPCCM19/PARAMETERFILE/spfileOPCCM19.ora'
--------------------------------------------------------------------------------------------------------

17. DI SERVER STANDBY, START STANDBY DATABASE 

$ srvctl start database -d OPHPOIN19 -o mount


--------------------------------------------------------------------------------------------------------

18. Di server primary, defer status LOG_ARCHIVE_DEST_STATE_3
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_3=DEFER sid='*' scope=both;

--------------------------------------------------------------------------------------------------------

19. Di server standby, Enable MRP dan recover database 
select sequence#, process, status from v$managed_standby where process like 'MRP%';
alter database recover managed standby database using current logfile disconnect;
select sequence#, process, status from v$managed_standby where process like 'MRP%';

--------------------------------------------------------------------------------------------------------

18. Di server primary, enable status LOG_ARCHIVE_DEST_STATE_3
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_3=ENABLE sid='*' scope=both;

--------------------------------------------------------------------------------------------------------

20. DI SERVER STANDBY, MONITOR APPLY PROCESS 

select thread#,sequence#,archived,applied from v$archived_log order by first_time;
select inst_id, process, status, thread#, sequence#, block#, blocks from gv$managed_standby where process in ('RFS','LNS','MRP0');
select DEST_ID,dest_name,status,type,srl,recovery_mode from v$archive_dest_status where dest_id=1;
select name, open_mode, database_role,open_mode from gv$database;


--------------------------------------------------------------------------------------------------------

21. DI SERVER PRIMARY, CHECK STATUS ARCHIVE DESTINATION 

set line 200
col dest_name for a50
col binding for a10
select dest_id,dest_name,status,binding,error from v$archive_dest where status<>'INACTIVE';

--------------------------------------------------------------------------------------------------------

22. DI SERVER STANDBY, OPEN READ ONLY STANDBY DATABASE 

alter database recover managed standby database cancel;
alter database open read only;
alter database recover managed standby database using current logfile disconnect from session;

--------------------------------------------------------------------------------------------------------

23. DI SERVER STANDBY, MONITOR MRP - MANAGED RECOVER PROCESS: 
--untuk otomatis proses apply archive yang sudah diterima dari primary proses 
select process, status, thread#, sequence#, block#, blocks from v$managed_standby;
select name, applied from v$archived_log where applied = 'NO' order by name;
select * from v$archive_gap;
select group#,status from v$standby_log;
select start_time,type, item,units,sofar,timestamp from v$recovery_progress where iteM='Last Applied Redo';
select max(sequence#) from v$log_history; (di database primary & standby)
select name, instance_name, open_mode, database_role, flashback_on , current_scn from v$database,v$instance;  (di database primary & standby)











Kalau Logical
=========================================================================================================================




10. Jalankan 
BEGIN
  dbms_logstdby.skip('DML','SYS','AUD$');
  dbms_logstdby.skip('SCHEMA_DDL','SYS','AUD$');
END;
/



11. jalankan ini
EXECUTE DBMS_LOGSTDBY.APPLY_SET('MAX_SERVERS', 30);
EXECUTE DBMS_LOGSTDBY.APPLY_SET('APPLY_SERVERS', 15);
EXEC DBMS_LOGSTDBY.APPLY_SET('_MAX_TRANSACTION_COUNT',12);
EXEC DBMS_LOGSTDBY.APPLY_SET('_EAGER_SIZE',100);
execute dbms_logstdby.apply_set('PREPARE_SERVERS', 5);
execute dbms_logstdby.apply_set('MAX_SGA', 4000);
execute dbms_logstdby.apply_set ('_HASH_TABLE_SIZE', 10000000);
EXECUTE DBMS_LOGSTDBY.APPLY_SET('PRESERVE_COMMIT_ORDER', 'TRUE');


ALTER DATABASE CREATE STANDBY CONTROLFILE AS '/home/oracle/ssi/slam/OPHPOINT19/OPHPOINTIMC_stby.ctl';


5. backup control file (on primary)

SQL> alter database backup controlfile to trace as '/home/oracle/ssi/slam/OPHPOINT19/controlfile.txt';


--RESTART MRP LOGICAL
alter database stop logical standby apply;
alter database start logical standby apply immediate;


10. set cluster database to true
SQL> alter system set cluster_database=true scope=spfile sid='*';

11. restart database
SQL> shutdown immediate;
$ srvctl status database -d OPPOIN19
$ srvctl start database -d OPPOIN19



alter system set log_archive_dest_state_3=DEFER scope=both sid='*';
alter system set log_archive_dest_state_3=ENABLE scope=both sid='*';



5. copy passwordfile ke path ORACLE_HOME/dbs versi 19c nya (dikedua node)

/u01/app/oracle/product/19.0.0.0/dbhome_1/jdk/bin/java -jar /u01/app/oracle/product/19.0.0.0/dbhome_1/rdbms/admin/preupgrade.jar TERMINAL TEXT


ssh -o ServerAliveInterval=30 10.250.192.181 -l oracle

OR4cl35y5#2015

alter system set log_archive_dest_state_3=DEFER scope=both sid='*';
alter system set log_archive_dest_state_3=ENABLE scope=both sid='*';


EXECUTE DBMS_LOGSTDBY.APPLY_SET('MAX_SERVERS', 30);
EXECUTE DBMS_LOGSTDBY.APPLY_SET('APPLY_SERVERS', 15);
EXEC DBMS_LOGSTDBY.APPLY_SET('_MAX_TRANSACTION_COUNT',12);
EXEC DBMS_LOGSTDBY.APPLY_SET('_EAGER_SIZE',100);
execute dbms_logstdby.apply_set('PREPARE_SERVERS', 5);
execute dbms_logstdby.apply_set('MAX_SGA', 4000);
execute dbms_logstdby.apply_set ('_HASH_TABLE_SIZE', 10000000);
EXECUTE DBMS_LOGSTDBY.APPLY_SET('PRESERVE_COMMIT_ORDER', 'TRUE');




$ cp /u01/app/oracle/product/11.2.0/dbhome_1/dbs/orapwOPPOIN19* /u01/app/oracle/product/19.0.0.0/dbhome_1/dbs

-- CREATE AND COPY PASSWORD FILE:
cd /u01/app/oracle/product/11.2.0/dbhome_1/dbs/
orapwd file='orapwOPHPOINTIMC1' password=OR4cl35y5#2015 force=y ignorecase=Y

-- COPY TO NODE 2 AND STANDBY 
scp orapwOPHPOINTIMC1 oracle@exaimcpdb02-mgt:/u01/app/oracle/product/11.2.0/dbhome_1/dbs/orapwOPHPOINTIMC2

scp orapwOPHPOINTIMC1 /u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/orapwOPPOIN191
scp orapwOPHPOINTIMC1 oracle@10.250.192.182:/u01/app/oracle/product/19.0.0.0/dbhome_1/dbs/orapwOPPOIN192




