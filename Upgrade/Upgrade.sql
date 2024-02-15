B. UPGRADE 19C

1. Flashback must be on (done)
SQL> select name,open_mode,log_mode,flashback_on from v$database;
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
SQL> alter database flashback on;

2. Create Restore poin before activate (done)
SQL> create restore point pre_upgrade_opscm guarantee flashback database;


3. Defer Dest_2 on Primary
SQL> alter system set log_archive_dest_state_2=defer sid='*' scope=both;

4. Shutdown Database Primary
#> srvctl stop database -d OPSCM
#> srvctl status database -d OPSCM


4. Cancel MRP and activate Database on standby
SQL> alter database recover managed standby database cancel;
SQL> alter database activate standby database;


5. Make sure parameter java_jit_enable=false;
SQL> select dbms_java.longname(‘TEST’) from dual;
Note! Kalau tidak muncul, run the following command, then check again!

SQL> alter system set "_system_trig_enabled"=false scope memory;
SQL> alter system set java_jit_enabled=false;

select dbms_java.longname('TEST') from dual;

execute sys.dbms_registry.loaded('JAVAVM');
execute sys.dbms_registry.valid('JAVAM');
alter system set "_system_trig_enabled"=false scope=memory;
alter system set java_jit_enabled=false;
create or replace java system;


6. Percise parameter
alter system set cpu_count=88 scope=both sid='*';          
alter system set resource_manager_plan='default_plan' scope=both sid='*';  
alter system set allow_group_access_to_sga=TRUE sid='*' scope=spfile;


7. DBMS_TRANSACTION
Check execute DBMS_TRANSACTION and make sure no row selected
SQL> SELECT 'EXECUTE DBMS_TRANSACTION.PURGE_LOST_DB_ENTRY('''||LOCAL_TRAN_ID||''');' PURGE_COMMAND FROM dba-2pc_pending;


8. Restart Database (change to primary)
#> srvctl stop database -d OPSCM19
#> srvctl config database -d OPSCM19
#> srvctl modify database -d OPSCM19 -r primary
#> srvctl start database -d OPSCM19



10. STOP JOBS APPS (if needed)
Check DBA_JOBS
select JOB, SCHEMA_USER, BROKEN from dba_jobs;
--broken yes means the job is invalid (has broken)

stop JOBS
select 'EXEC DBMS_JOB.BROKEN('||job||',TRUE);' from dba_jobs where SCHEMA_USER='TELKOMSEL' and broken='N';
--disable job using user telkomsel

Contoh:
EXEC DBMS_JOB.BROKEN(52,TRUE);





11. Kill session (if needed)
select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' immediate;' 
from gv$session where username in ('TELKOMSEL');


13. DBUA
Menggunakan profile 19c
$ . .OPSCM19_profile_new
$ dbua -ignorePrereqs
 


Pilih source database (unique name) yang akan di upgrade

Pastikan tidak ada yang failed.
 
Di continue aja apabila warning nya bisa di ignore.
 
Re-compile invalid object di uncentang (karena sudah tidak ada invalid object)
Di next
 
Pilih I have my own backup
 
Di uncheck aja untuk configure Enterprise manager nya
 
Klik finish
 
Progress upgrade, pastikan ngak ada yang failed

Klik close


kelar ke 19 balikin lagi ke default cpu nya sama seting sga allow 

alter system set cpu_count=8 scope=both sid='*';          
alter system set resource_manager_plan='default_plan' scope=both sid='*';  
alter system set allow_group_access_to_sga=TRUE sid='*' scope=spfile;

@$ORACLE_HOME/rdbms/admin/utlrp.sql


alter system set cpu_count=8 scope=both sid='*';          
alter system set resource_manager_plan='default_plan' scope=both sid='*';  
alter system set allow_group_access_to_sga=TRUE sid='*' scope=spfile;
srvctl status database -d OPSCM19
srvctl stop database -d OPSCM19
srvctl start database -d OPSCM19







CHANGE SERVICE_NAME
Warna Untuk STANDBY (instance_name/uniqname OPCBDLTBS)
Warna untuk PRIMARY (instance_name/uniqname OPCBDL19)



Stop mrp logical standby:

SQL> alter database stop logical standby apply immediate; 

defer parameter log_archive_dest_state_2

SQL> alter system set log_archive_dest_state_2=DEFER sid='*' scope=both;
ganti parameter LOG_ARCHIVE_DEST_2 (di primary dan standby)

SQL> alter system set LOG_ARCHIVE_DEST_2='SERVICE=OPCBDL19 ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=OPCBDLTBS sid='*' scope=both;  

SQL> alter system set LOG_ARCHIVE_DEST_2='SERVICE=OPCBDL19 ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=OPCBDL19 sid='*' scope=both
ganti service name 
SQL> alter system set service_names=OPCBDLTBS sid='*' scope=both;

SQL> alter system set service_names=OPSCM sid='*' scope=both;

enable parameter log_archive_dest_state_2
SQL> alter system set log_archive_dest_state_2=ENABLE sid='*' scope=both;
SQL> alter database start logical standby apply immediate;









