--Check
exec DBMS_STATS.FLUSH_DATABASE_MONITORING_INFO; --for right info

--Check STATUS (stal yes means belum di gather)
col owner for a30
col table_name for a30
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
select owner,table_name,last_analyzed,stale_stats 
from dba_tab_statistics 
where table_name in (
'STTM_CUST_ACCOUNT',
'QRTZ_TRIGGERS',
'QRTZ_FIRED_TRIGGERS',
'STTB_JOB_MASTER',
'QRTZ_JOB_DETAILS',
'QRTZ_SIMPLE_TRIGGERS'
);

col owner for a30
col table_name for a30
set pages 999
set lines 999
select distinct table_name
from dba_tab_statistics where owner='FCC114'
and stale_stats='YES';


ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
select distinct table_name ,last_analyzed,stale_stats 
from dba_tab_statistics 
where table_name in (
'STTM_CUST_ACCOUNT',
'QRTZ_TRIGGERS',
'QRTZ_FIRED_TRIGGERS',
'STTB_JOB_MASTER',
'QRTZ_JOB_DETAILS',
'QRTZ_SIMPLE_TRIGGERS'
)
and stale_stats='YES'
order by last_analyzed;

------------------------------------------------------------------------------------------------------------

--TABLE
exec dbms_stats.gather_table_stats('DGPOS','MESSAGES', DEGREE => 20, estimate_percent => dbms_stats.auto_sample_size,cascade => true);
exec dbms_stats.gather_table_stats('DIGIPOSRPT','ARP_REQUEST', DEGREE => 20, estimate_percent => dbms_stats.auto_sample_size,cascade => true);
exec dbms_stats.gather_table_stats(ownname=>'DGPOS', tabname=>'TCASH_REQUEST' , estimate_percent=>10, cascade=>TRUE, degree=>5);



set time on;
set timing on;
exec dbms_stats.gather_table_stats('FCC114','STTM_CUST_ACCOUNT', DEGREE => 24, estimate_percent => dbms_stats.auto_sample_size,cascade => true);
commit;
exit;




--DATABASE 
EXEC DBMS_STATS.GATHER_DATABASE_STATS(ESTIMATE_PERCENT=>DBMS_STATS.AUTO_SAMPLE_SIZE,degree=>6);
EXEC DBMS_STATS.GATHER_DATABASE_STATS(ESTIMATE_PERCENT=>dbms_stats.auto_sample_size,CASCADE => TRUE,degree => 4);


--SCHEMA 
exec DBMS_STATS.FLUSH_DATABASE_MONITORING_INFO;
select OWNER,TABLE_NAME,LAST_ANALYZED,STALE_STATS from DBA_TAB_STATISTICS where STALE_STATS='YES' and OWNER='&owner';

exec dbms_stats.gather_schema_stats(ownname=>'&schema_name', CASCADE=>TRUE,ESTIMATE_PERCENT=>dbms_stats.auto_sample_size,degree =>4);
exec dbms_stats.gather_schema_stats(ownname=>'&schema_name',ESTIMATE_PERCENT=>dbms_stats.auto_sample_size,degree =>4);
-- CASCADE is not included here. Let Oracle will determine whether to collect statatics on indexes or not.


--INDEX STATISTICS
exec DBMS_STATS.GATHER_INDEX_STATS(ownname => '&OWNER',indname =>'&INDEX_NAME',estimate_percent =>DBMS_STATS.AUTO_SAMPLE_SIZE);

------------------------------------------------------------------------------------------------------------

--Gather STATS

CASCADE => TRUE : Gather statistics on the indexes as well. If not used Oracle will determine whether to collect it or not.
DEGREE => 4: Degree of parallelism.
ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE : (DEFAULT) Auto set the sample size % for skew(distinct) values (accurate and faster than setting a manual sample size).
METHOD_OPT=> : For gathering Histograms:
FOR COLUMNS SIZE AUTO : You can specify one column between “” instead of all columns.
FOR ALL COLUMNS SIZE REPEAT : Prevent deletion of histograms and collect it only for columns already have histograms.
FOR ALL COLUMNS : Collect histograms on all columns.
FOR ALL COLUMNS SIZE SKEWONLY : Collect histograms for columns have skewed value should test skewness first
FOR ALL INDEXED COLUMNS : Collect histograms for columns have indexes only.


================================================================================================================

SELECT
   STATE
FROM
   DBA_SCHEDULER_JOBS
WHERE
   JOB_NAME = 'GATHER_STATS_JOB';

If not disabled, use the following command to disable the job:

SQL> exec dbms_scheduler.disable('SYS.GATHER_STATS_JOB');