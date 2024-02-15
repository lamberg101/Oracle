A. OPCMC

IP			: 10.251.33.86
DATABASE 	: OPCMC
TABLSPACE	: TRACKINGSTREAM_102021 
PATH		: /datadump5/opcmc/expdp

--CHECK TABLE and PARTITION LIST
select table_owner,table_name,partition_name,tablespace_name, high_value from DBA_TAB_PARTITIONS 
where table_owner = 'CAMPAIGN_TRACKING' 
and tablespace_name='TRACKINGSTREAM_102021';


--COLLECT TABLE AND PARTITION
select table_owner||'.'||table_name||':'||partition_name from DBA_TAB_PARTITIONS 
where table_owner = 'CAMPAIGN_TRACKING' 
and tablespace_name='TRACKINGSTREAM_102021';


--CREATE FILE .PAR 
Create the par file and put the necesarry parameters into it.

vi TRACKINGSTREAM_test.par
--------------------------------------------------------------------------
DIRECTORY=DATADUMP2
LOGFILE=TRACKINGSTREAM_102021.log
DUMPFILE=TRACKINGSTREAM_102021_%U.dmp
PARALLEL=4
COMPRESSION=all
TABLES=
CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM:SYS_P4608380
CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM:SYS_P4608381
CAMPAIGN_TRACKING.CMS_TRACKINGSTREAM:SYS_P4608382

--------------------------------------------------------------------------


--CHMOD AND RUNN THE BACKUP
chmod the par file and then run the expdp command on background mode.

$ chmod 777 TRACKINGSTREAM_102021.par
$ --nohup expdp \"/ as sysdba\" parfile=TRACKINGSTREAM_102021.par &


==================================================================================================================================

B. OPCMC

IP			: 10.251.33.86
DATABASE 	: OPCMC
TABLSPACE	: DELIVERYTRACKING_102021
PATH		: /datadump5/opcmc/expdp

--CHECK TABLE and PARTITION LIST
select table_owner,table_name,partition_name,tablespace_name, high_value 
from DBA_TAB_PARTITIONS 
where table_owner = 'CAMPAIGN_TRACKING' 
and tablespace_name='DELIVERYTRACKING_102021';


--COLLECT TABLE AND PARTITION
select table_owner||'.'||table_name||':'||partition_name 
from DBA_TAB_PARTITIONS 
where table_owner = 'CAMPAIGN_TRACKING' 
and tablespace_name='DELIVERYTRACKING_102021';


--CREATE FILE .PAR
Create the par file and put the necesarry parameters into it.
--------------------------------------------------------------------------
DIRECTORY=DATADUMP2
LOGFILE=DELIVERYTRACKING_102021.log
DUMPFILE=DELIVERYTRACKING_102021_%U.dmp
PARALLEL=4
COMPRESSION=all
TABLES=
CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING:SYS_P4608322
CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING:SYS_P4608323
CAMPAIGN_TRACKING.CMS_DELIVERYTRACKING:SYS_P4608324
--------------------------------------------------------------------------

--CHMOD AND RUNN THE BACKUP
chmod the par file and then run the expdp command on background mode.

$ chmod 777 DELIVERYTRACKING_102021.par
$ --nohup expdp \"/ as sysdba\" parfile=DELIVERYTRACKING_102021.par &

==================================================================================================================================


D. OPTOIP 

IP			: 10.250.192.181/10.250.192.182
DATABASE 	: OPTOIP
TABLSPACE	: partition_name like '%202110%%'
PATH		: /zfssa/testet/backup3/optoip/temp_data_backup


--CHECK PARTITION TABLE 
select table_owner,table_name,partition_name,tablespace_name from dba_tab_partitions 
where partition_name like '%202110%%';


--COLLECT PARTITION TABLE  
select table_owner||'.'||table_name||':'||partition_name from dba_tab_partitions 
where partition_name like '%202110%';


--CREATE FILE .PAR 
--------------------------------------------------------------------------
DIRECTORY=DATADUMP
LOGFILE=TBS_PART_TBL_TOIP_202110.log
DUMPFILE=TBS_PART_TBL_TOIP_202110.dmp
COMPRESSION=all
TABLES=
ITCRREPORT.REVLACCI_CLUSTER_PP:P_202110
ITCRREPORT.TMP_HLR_OSDSS_REV_PP_L3_AGG:P202110
ITCRREPORT.TMP_HLR_OSDSS_REV_PP_L3_NEW:P202110

--------------------------------------------------------------------------


--CHMOD AND RUNN THE BACKUP
chmod the par file and then run the expdp command on background mode.

$ chmod 777 TBS_PART_TBL_TOIP_202110.par
$ --nohup expdp \"/ as sysdba\" parfile=TBS_PART_TBL_TOIP_202110.par &

exaimcpdb01-mgt 
/zfssa/testet/backup3/optoip/temp_data_backup/TBS_PART_TBL_TOIP_202110.dmp


==================================================================================================================================

E. OPPOINBSD

IP			: 10.49.132.94
DATABASE 	: OPHPOINT
TABLSPACE	: partition_name like '%202110%%'
PATH		: /zfssa/testet/backup1/ophpoint/expdp


--CHECK PARTITION TABLE 
select table_owner,table_name,partition_name,tablespace_name from dba_tab_partitions 
where partition_name like '%202110%%';


--COLLECT PARTITION TABLE  
select table_owner||'.'||table_name||':'||partition_name from dba_tab_partitions 
where partition_name like '%202110%';


--CREATE FILE .PAR 
--------------------------------------------------------------------------
DIRECTORY=DATADUMP_POIN
LOGFILE=TBS_PART_TBL_POIN_202110.log
DUMPFILE=TBS_PART_TBL_POIN_202110_%U.dmp
PARALLEL=4
COMPRESSION=all
TABLES=
NEWTSPOIN.ATP_EXPIRED_VOUCHER:P_202110
NEWTSPOIN.ADM_ACTIVITY_LOG:ADM_ACTIVITY_LOG_202110
NEWTSPOIN.ATP_DETAIL_LOG:P202110
NEWTSPOIN.ATP_DETAIL_OUTSTANDING:P202110
NEWTSPOIN.ATP_DET_REDEEM_DAILY:P202110
--------------------------------------------------------------------------


--CHMOD AND RUNN THE BACKUP
chmod the par file and then run the expdp command on background mode.

$ chmod 777 TBS_PART_TBL_POIN_202110.par
$ --nohup expdp \"/ as sysdba\" parfile=TBS_PART_TBL_POIN_202110.par &



==================================================================================================================================

C. OPSELREP 

IP			: 10.49.132.94
DATABASE 	: OPSELREP
TABLSPACE	: DT_RATEDATA_202110, IDX_RATEDATA_202110
PATH		: /datadump3/opselrep/dumpdata


--nohup expdp \"/ as sysdba\" tablespaces=DT_RATEDATA_202110,IDX_RATEDATA_202110 directory=DATAPUMP1 dumpfile=DT_RATEDATA_202110_%U.dmp logfile=DT_RATEDATA_202110.log PARALLEL=4 COMPRESSION=all &


==================================================================================================================================

F. OPSMSICA

IP			: 10.39.64.38/10.39.64.39
DATABASE 	: OPSMSICA
TABLSPACE	: DT_RATEDATA_202011,IDX_RATEDATA_202011
PATH		: /datadump1/OPICASMSTBS/expdp/

--nohup expdp \"/ as sysdba\" tablespaces=DT_RATEDATA_202110,IDX_RATEDATA_202110 directory=DATAPUMP1 dumpfile=DT_RATEDATA_202110_%U.dmp logfile=DT_RATEDATA_202110.log PARALLEL=4 COMPRESSION=all &





