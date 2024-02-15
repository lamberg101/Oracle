--Check PARAMETER 
set lines 200
col name for a35
col value for a25
select name,value,isdefault,isses_modifiable,issys_modifiable 
from v$parameter 
where name like '%utl%';



--issys_mod value: (false >> static) (else >> dynamic)

pga=process x 5mb (versi19)  kalu versi laen? 3mb?

9022 x 5MB = 45110 MB
Sedangkan value pga limitnya 38400M --perlu di naikan

mas/mba mau tanya, kalau misal kita mau naikin parameter process 
process 9022
session 13560
dengan pga limit 38400
untuk parameter semaphorenya ini cukup ga ya di server exa82absd, sama ada parameter OS lain yang perlu diperhatikan ga ya?


2. Check HIDEN PARAMETER
col Parameter for a30
col "Session Value" for a20
col "Instance Value" for a20
SELECT x.ksppinm "Parameter", Y.ksppstvl "Session Value", Z.ksppstvl "Instance Value"
FROM   x$ksppi X, x$ksppcv Y, x$ksppsv Z
WHERE  x.indx = Y.indx
AND    x.indx = z.indx
AND    x.ksppinm LIKE '/_%' escape '/'
and x.ksppinm LIKE '%securefiles_concurrency_estimate%'
order by x.ksppinm;



3. BACKUP SPFILE
SQL> create pfile='/home/oracle/pfile_odc2p3.txt' from spfile;



4. ALTER
alter system set "_securefiles_concurrency_estimate"=50 scope=spfile sid='*';
alter system set pga_aggregate_limit=0 scope=both sid='*';
alter system set pga_aggregate_target=3g scope=both sid='*';
alter system set sga_max_size=8g scope=spfile sid='*';
alter system set sga_target=4g scope=spfile sid='*';
alter system set processes=6000 scope=spfile sid='*';
alter system set sessions=9022 scope=spfile sid='*';
alter system set transactions=6600 scope=spfile sid='*';
alter system set undo_retention=42200 scope=both sid='*';
alter system set db_flashback_retention_target=33120 scope=both sid='*';
alter system set db_keep_cache_size=800 scope=both sid='*';
alter system set cursor_sharing=force scope=both sid='*';
alter system set open_cursors=1000 scope=both sid='*';
alter system set session_cached_cursors=1000 scope=both sid='*';
alter system set query_rewrite_integrity=trusted scope=both sid='*';
alter system set query_rewrite_enabled=true scope=both sid='*';
alter system set max_dispatchers=0 scope=both sid='*';
alter system set max_shared_servers=0 scope=both sid='*';
alter system set distributed_lock_timeout=1400 scope=both sid='*';
alter system set filestystemio_options=setall scope=both sid='*';
alter system set sga_target=6gb scope=both sid='*';
alter system set pga_aggregate_target=2gb scope=both sid='*';
alter system set session = 4522 scope=spfile sid='*';
alter system set processes = 3000 scope = spfile sid='*';
alter system set transactions = 4974  scope = spfile sid='*';
alter session set ddl_lock_timeout=300;
alter system set redo_trasnport_user='sys' scope=both sid='*';


alter system set cpu_count=16 scope=both sid='*';					
alter system set resource_manager_plan='default_plan' scope=both sid='*';					

rollback plan:					
alter system reset cpu_count scope=both sid='*';					
alter system set resource_manager_plan='' scope=both sid='*';	


create pfile='/home/oracle/pfile_odc2p3_07052022.txt' from spfile;
show parameter cpu
alter system set cpu_count=8 scope=both sid='*';
show parameter cpu
========================================================================================================================

process default sekarang 500 
butuh naik double dari sekarang jadi 1000
1,5*1000+22 = 1522
session (1,5x1522)+22 =2305
transactions=sessions*1.1

--OTOMTIS VALE SESSION menyesuaikan



========================================================================================================================


4. Rolling restart
--INSTANCE 1: 
$> srvctl status database -d OPPOMTBS
$> srvctl stop instance -d OPPOMTBS -i OPPOMTBS1
$> srvctl start instance -d OPPOMTBS -i OPPOMTBS1
$> srvctl status database -d OPPOMTBS

--INSTANCE 2: 
$> srvctl status database -d OPPOMTBS
$> srvctl stop instance -d OPPOMTBS -i OPPOMTBS2
$> srvctl start instance -d OPPOMTBS -i OPPOMTBS2
$> srvctl status database -d OPPOMTBS

