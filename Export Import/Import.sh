Check ALERT
cat alertexport.log | grep "imported" | wc -l


1. PAR FILE
nohup impdp \"/ as sysdba\" parfile=IMP_TABLE_OPRD016_TCASH_TRX_DAILY.par &

-----------------------------------------------------------------------------------------------------------------------------------

2. FULL DB
nohup impdp \"/ as sysdba\" 
directory=DIR 
dumpfile=FILE_NAME.dmp 
logfile=impdp_file_name.log 
FULL=Y &

Note! create tbs nya dulu
-----------------------------------------------------------------------------------------------------------------------------------

3. TABLES
nohup impdp \"/ as sysdba\" 
directory=DIR 
dumpfile=FILE_NAME.dmp 
logfile=impdp_file_name.log 
tables=SCHEMA.TABLE &
	
nohup impdp \'/ as sysdba\' DIRECTORY=backup dumpfile=STTM_CUST_ACCOUNT_ori-01.dmp logfile=STTM_CUST_ACCOUNT_ori-01-imp.log tables=FCC114.STTM_CUST_ACCOUNT TABLE_EXISTS_ACTION=REPLACE &




select count(*) from fcc114.STTM_CUSTOMER_MASK; --5050
select count(*) from fcc114.STTM_CUST_ACCOUNT_MASK; --27.572

select count(*) from STTM_CUST_ACCOUNT; -- 6.255.678

-----------------------------------------------------------------------------------------------------------------------------------

4. SCHEMA
nohup impdp import_nbp/Telkomsel@OPNBP1 
directory=DIR
schemas=SCHEMA1,SCHEMA2,DST 
dumpfile=FILE_NAME.dmp 
logfile=impdp_file_name.log 
exclude=STATISTICS 
cluster=N 
PARALLEL=4 
network_link=NBPDB &


NOTE URUTAN (FULL --> TABLESPACE --> SCHEMA --> TABLE)

===================================================================================================================================

1. NETWORK_LINK
#tables with network/db link
nohup impdp user/pass directory=xxx logfile=xxx.log tables=xxx.xxx 
NETWORK_LINK=NBP_EXPDP &


------------------------------------------------------------------------------------------------------

2. REMAP (note kalau remap table/schema, perlu di perhatikan juga tbs nya, jika beda di remap)

#TABLESPACE
nohup impdp user/pass directory=xxx tables=xxx.xxx logfile=xxx network_link=xxx exclude=STATISTICS/MARKER 
remap_tablespace=SOURCE_TBS:TARGET_TBS &

#SCHEMA
nohup impdp \"/ as sysdba\" directory=xxx dumpfile=xxx logfile=xxx 
remap_schema=SCHEMA(old):SCHEMA(new) cluster=N table_exists_action=REPLACE &

#TABLE
nohup impdp \"/ as sysdba\" directory=xxx dumpfile=xxx logfile=xxx parallel=xxx 
tables=SCV_LOAD_USR.KPI_RECHARGE 
remap_table=SCHEMA.KPI_RECHARGE(source):KPI_RECHARGE_20191201(dest) 
QUERY=SCV_LOAD_USR.KPI_RECHARGE:"WHERE etc etc" &
------------------------------------------------------------------------------------------------------

3. QUERY (restore by range tertentu)

nohup impdp \"/ as sysdba\" directory=xxx dumpfile=xxx logfile=xxx parallel=xxx 
remap_table=SCHEMA.KPI_RECHARGE(source):KPI_RECHARGE_20191201(dest) 
TABLES=SCV_LOAD_USR.KPI_RECHARGE 
QUERY=SCV_LOAD_USR.KPI_RECHARGE:"WHERE DT>=to_date('01-12-2019 00:00:00','DD-MM-YYYY HH24:MI:SS') AND DT<to_date('09-01-2020 00:00:00','DD-MM-YYYY HH24:MI:SS')" &



-----------------------------------------------------------------------------------------------------------------------------------

OTHERS PARAMETER:
TABLE_EXISTS_ACTION=APPEND/REPLACE/SKIP
transportable=ALWAYS
CLUSTER=N 


==================================================================================================================================

Check PROSES IMPORT
impdp system/oracle@ODC2P3 attach=SYSTEM.SYS_IMPORT_FULL_02




















