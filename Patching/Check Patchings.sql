
--Check QUORUM

col failgroup for a20
col PATH for a60 
set pages 500
set lines 500
select inst_id, group_number,disk_number, name, path, header_status,MODE_STATUS, 
mount_status, redundancy, failgroup,FAILGROUP_TYPE, MOUNT_DATE 
from gv$asm_disk where name like '%QD_%' order by name, inst_id;

-------------------------------------------------------------------------------------------------------------

--Check PROSES
select group_number,pass,state,power,(sofar/est_work)*100,est_rate,est_minutes 
from gv$asm_operation 
where state='RUN';

-------------------------------------------------------------------------------------------------------------

--Check PATCHES
$ORACLE_HOME/OPatch/opatch lsinventory

==============================================================================================================

--COLLECT 
hostname
date
ps -ef | grep pmon | sort -k8
ps -ef | grep pmon | sort -k8 | wc -l
ps -ef | grep inherit
. .grid_profile
crsctl stat res -t
asmcmd lsdg
lsnrctl status
lsnrctl status | wc -l
df -hP
srvctl status scan_listener
crsctl query css votedisk
--imc cd /u01/app/agent13c/agent_13.4.0.0.0/bin
cd /u01/app/emagent/agent13c/agent_13.4.0.0.0/bin
./emctl status agent

sqlplus / as sysdba
SQL>
set linesize 300 
set pagesize 200 
col path for a60 
select group_number,disk_number, name, os_mb,total_mb, free_mb, path, header_status,mode_status 
from v$asm_disk;

sqlplus / as sysasm
SQL>
set linesize 200
set pages 99
select * from gv$asm_operation;

Note!
jangan lupa kalau ada restart di exa-tbs, prodhr listener nya di up in manual

ada 2 oracle home versi 12.1
- /u01/app/oracle/product/12.1.0.2_EBS/dbhome_1 (tambahan untuk db prodhr/EBS)
- /u01/app/oracle/product/12.1.0.2/dbhome_1 
dan ada 2 listener (LISTENER dan LISTENER_PRODHR1/LISTENER_PRODHR2)

untuk cek status/start/stop listener LISTENER_PRODHR1/LISTENER_PRODHR2 agak berbeda, caranya
1. masuk ke profile 
$> .PRODHR

2. Masuk ke oracle home
$> cd $ORACLE_HOME

3. Lalu jalankan profile nya
$> . ./PRODHR1_exa62tbspdb1-mgt.env

4. Step nya
$> lsnrctl status LISTENER_PRODHR1 (untuk cek stattus nya)
$> lsnrctl stop LISTENER_PRODHR1 (untuk stop)
$> lsnrctl start LISTENER_PRODHR1 (untuk start)


==================================================================================================================================

alter diskgroup DATAC5 rebalance power 32; 
--cara liat datac5 yg perlu di naikin itu gimana?



listenerlepas:
--------------
alter system set remote_listener='exapdb62a-scan:1521' scope=both sid='*'; 
alter system set remote_listener='exaimcpdb-scan:1521' scope=both sid='*';
alter system set remote_listener='exa62bsda-scan:1521' scope=both sid='*';

change local_listener:
-----------------------
alter system set local_listener='(ADDRESS=(PROTOCOL=TCP)(HOST=10.39.64.131)(PORT=1521))'  scope=both sid='instance1'
alter system set local_listener='(ADDRESS=(PROTOCOL=TCP)(HOST=10.39.64.132)(PORT=1521))'  scope=both sid='instance2'

==================================================================================================================================


select failgroup, count( (failgroup) )
from v$asm_disk
where group_number=1
group by (failgroup);


set linesize 300 
set pagesize 200 
col path for a60 
select group_number,disk_number, name, os_mb,total_mb, free_mb, path, header_status,mode_status 
from gv$asm_disk where path like '%quorum%';

==================================================================================================================================


script kill:
-----------
select 'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;' 
FROM gv$session where last_call_et > (60*60*3) 
AND status = 'INACTIVE';


set pages 999
set lines 999
select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' IMMEDIATE;' 
from gv$session 
where username in ('DOM_USER','DOM')
and last_call_et > (60*60*6) 
and status = 'INACTIVE' 
order by inst_id;


==================================================================================================================================

open database manual:
----------------------
select status from v$instance;
alter database mount;
alter database open;
--setelah itu baru di alter remote dan local listenernya, diCheck dlu
==================================================================================================================================
