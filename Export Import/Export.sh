Check ALERT
cat alertexport.log | grep "exported" | wc -l


NOTE untuk parameter!
1. paralel = pakai cpu 
2. _%U = kalau tidak pakai parelel ini di hapus
3. content=METADATA_ONLY (yg di expdp hanya struktur table saja)
4. content=DATA_ONLY (yg di expdp hanya isinya)
5. QUERY= yg di expdp data dari tanggal tertentu saja (minta query nya ke tim apps)



1. PARFILE
nohup expdp \"/ as sysdba\" parfile=file.par &		

Note!
untuk parfile, buat file par nya dulu
lalu semua parameter dimasukan ke dalam file par tersebut.

------------------------------------------------------------------------------------------------------------------------------------------------

2. FULL DB
nohup expdp \"/ as sysdba\" 
directory=DIR 
dumpfile=FILE_NAME_DATE.dmp 
logfile=FILE_NAME_DATE.log 
FULL=Y 
compression=all &


nohup expdp \"/ as sysdba\" 
directory=DIR 
dumpfile=FILE_NAME_DATE_%U.dmp 
logfile=FILE_NAME_DATE.log 
FULL=Y 
parallel=8 
filesize=100G &

------------------------------------------------------------------------------------------------------------------------------------------------

3. TABLESPACE

nohup expdp \"/ as sysdba\" directory=DIR 
tablespaces=TBS_1,TBS_2 
dumpfile=FILE_NAME_DATE_%U.dmp 
logfile=FILE_NAME_DATE.log 
parallel=4 
filesize=100G 
compression=all &

------------------------------------------------------------------------------------------------------------------------------------------------

4. SCHEMA

nohup expdp \"/ as sysdba\" (nohup expdp system/OR4cl35y5#2015)
directory=DIR 
schemas=SCHEMA_NAME1, SCHEMA_NAME2 
dumpfile=FILE_NAME_DATE_%U.dmp 
logfile=FILE_NAME_DATE.log 
parallel=4 &




------------------------------------------------------------------------------------------------------------------------------------------------

5. TABLES
nohup expdp \'/ as sysdba\' 
DIRECTORY=DIR
dumpfile=FILE_NAME.dmp 
logfile=FILE_NAME_DATE.log 
tables=OWNER.TABLE &

nohup expdp \'/ as sysdba\' DIRECTORY=backup dumpfile=STTM_CUST_ACCOUNT_ori-01.dmp logfile=STTM_CUST_ACCOUNT_oir-01.log tables=FCC114.STTM_CUST_ACCOUNT &

select count(*) from fcc114.STTM_CUSTOMER_MASK;
select count(*) from fcc114.STTM_CUST_ACCOUNT_MASK;

import fut: /fcubs/backup/dumps
export uat: /backup/dumps
------------------------------------------------------------------------------------------------------------------------------------------------

6. PARTISI
nohup expdp \'/ as sysdba\' 
DIRECTORY=DATADUMP 
dumpfile=FILE_NAME_DATE_%U.dmp 
logfile=FILE_NAME_DATE.log 
tables=OWNER.TABLE:PARTISI1, OWNER.TABLE:PARTISI2 
parallel=4 
compression=all &


=======================================================================================================================================================


--Check DIRECTORY
set lines 300
col owner for a20
col directory_name for a30
col directory_path for a70
select owner, directory_name, directory_path from dba_directories;
where directory_name='DUMP_ODC2P3';


--CREATE AND GRANT DRECTORY
create or replace directory backup as '/fcubs/backup/dumps/bkp';
grant read, write on directory backup to SYS;
grant read, write on directory backup to system;


nohup expdp \'/ as sysdba\' directory=DUMP_BI 
dumpfile=opc2pevn_tables_clone_%U.dmp 
logfile=expdp_opc2pevn_tables_clone.log 
PARALLEL=4 tables=C2P_PROD.POSTPAID_ACTIVE_OFFER,C2P_PROD.POSTPAID_ACTIVE_OFFER_SPEC &



nohup expdp \"/ as sysdba\" 
directory=DUMP_BI 
schemas=CC_MAIN,CI_AUDIT
dumpfile=expdp_CCMAIN_CIAUDIT_24032022_%U.dmp 
logfile=expdp_CCMAIN_CIAUDIT_24032022.log 
parallel=8 &


nohup expdp \"/ as sysdba\" directory=DUMP_BI schemas=CC_MAIN dumpfile=expdp_CCMAIN_24032022_%U.dmp logfile=expdp_CCMAIN_24032022.log parallel=8 &

expdp '"sys/OR4cl35y5#2015 as sysdba"' attach=SYS_EXPORT_SCHEMA_01






set lines 500
set pages 500
COLUMN sid FORMAT 9999
COLUMN serial# FORMAT 9999999
COLUMN machine FORMAT A32
COLUMN progress_pct FORMAT 99999999.00
COLUMN elapsed FORMAT A10
COLUMN remaining FORMAT A10
col MESSAGE for a95

SELECT s.sid,
       s.serial#,
       s.machine,
     sl.message,
       ROUND(sl.elapsed_seconds/60) || ':' || MOD(sl.elapsed_seconds,60) elapsed,
       ROUND(sl.time_remaining/60) || ':' || MOD(sl.time_remaining,60) remaining,
       ROUND(sl.sofar/sl.totalwork*100, 2) progress_pct
FROM   gv$session s,
       gv$session_longops sl
WHERE  s.sid     = sl.sid
AND    s.serial# = sl.serial#
and sl.message like '%EXPORT%'
and sl.totalwork>sl.sofar;



--Check CURRENT_SCN
col current_scn for 999999999999999999
select current_scn from v$database;




=======================================================================================================================================================

1. VERSION
nohup expdp \'/ as sysdba\' 
directory=xxx schemas=xxx dumpfile=xxx_%U.dmp 
logfile=xxx.log compression=all PARALLEL=4 
version=12.1.0.2.0 & (or version=12.1)
------------------------------------------------------------------------------------------------------------------------------------------------

2. QUERY 
nohup expdp \"/ as sysdba\" directory=xxx 
dumpfile=xxx logfile=xxx tables=xxx 
query='PROAPP.PRO_PAYLOAD:"where UPDATED_DATE < to_date"' \"\(\'29-NOV-2019\',\'DD-MON-YYYY\'\)\" &

nohup expdp \"/ as sysdba\" parfile=pro_order_tm_juli.par &		
directory=xxx umpfile=xxx logfile=xxx tables=xxx
QUERY="WHERE COMPLETION_DATE>=to_date('01-JUL-2020 00:00:00','DD-MON-YYYY HH24:MI:SS')"

-----------------------------------------------------------------------------------------------------------------------------------------------

3. METADATA_ONLY
nohup expdp \"/ as sysdba\" directory=xxx schemas=xxx dumpfile=xxx.dmp logfile=xxx.log compression=all 
content=METADATA_ONLY &

-----------------------------------------------------------------------------------------------------------------------------------------------

4. INCLUDE & EXCLUDE SCEMA
--in linux
EXCLUDE=SCHEMA:"in\('SYSTEM'\)" 
EXCLUDE=SCHEMA:"in\('SYSTEM','FIN'\)".

--in file par
INCLUDE=TABLE:"IN ('COUNTER','COUNTER_LIFETIME')"
INCLUDE=PROCEDURE:"IN ('ESB_GET_CTR_1_MSISDN_OID_BUNDLE','ESB_UPD_6B_UPS_FAM_CTR')"

-----------------------------------------------------------------------------------------------------------------------------------------------

5. FLASHBACK_SCN
nohup expdp \'/ as sysdba\' 
DIRECTORY=DIR
dumpfile=FILE_NAME.dmp 
logfile=FILE_NAME_DATE.log 
tables=OWNER.TABLE 
flashback_scn=xxxxxxxx &

-----------------------------------------------------------------------------------------------------------------------------------------------

5. EXP
#TABLE
nohup exp \'/ as sysdba\' 
file='/path/path/FILE_NAME.dmp' 
log='/path/path/file_name.log' 
tables=sys.aud\$ 
statistic=none &

#OWNER
nohup exp \'/ as sysdba\' 
file='/path/path/FILE_NAME.dmp' 
log='/path/path/file_name.log' 
owner=OWNER_NAME rows=N 
grants=Y constraints=Y &


-----------------------------------------------------------------------------------------------------------------------------------------------

Check alert
cat alertexport.log | grep "exported" | wc -l




