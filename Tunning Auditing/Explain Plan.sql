--Using sqlrpt.
@?/rdbms/admin/sqltrpt.sql

------------------------------------------------------------------------------------------------------------------------------

--Check SQL_ID
select database_id, sql_id count(1) 
from v$cell_ofl_thread_history 
where group_name<>'CELLSRV' 
and SNAPSHOT_TIME > sysdate-1/1440 
group by database_id, sql_id;


------------------------------------------------------------------------------------------------------------------------------

--USING SQL_ID
SELECT * FROM TABLE(dbms_xplan.display_awr('&sqlid','&plan_hash'));

------------------------------------------------------------------------------------------------------------------------------

--USING QUERY.

explain:
--------
EXPLAIN PLAN FOR 
--put the query here
explain plan for
DELETE FROM FCC114.ICTBS_UDEVALS U WHERE U.PROD = :B5 AND U.COND_TYPE = :B4 AND U.COND_KEY = :B3 AND U.UDE_ID = :B2 AND U.UDE_EFF_DT = :B1

Display:
--------
set lines 150
set pages 1000
select * from  table(dbms_xplan.display);

select * from table(dbms_xplan.display(format=>'advanced'));


explain plan for select outlet-id from dgpos.product_sales where msisdn='6281225552096' --pake char
explain plan for select outlet-id from dgpos.product_sales where msisdn=6281225552096 --pake number


37q1s2su7d6r0
------------------------------------------------------------------------------------------------------------------------------

--Check THE EXPLAIN PLAN IN CURSOR
col operation for a20
col object_name for a20
col options for a20
col optimizer for a12
col child_number a3
SELECT child_number, id , lpad (' ', depth) || operation operation , options , object_name , optimizer , cost
FROM V$SQL_PLAN
WHERE sql_id = '&sql_id'
ORDER BY child_number, id;

OR
select * from table(dbms_xplan.display_cursor('&1', NULL, 'ALL'));

OR
select * from table( DBMS_XPLAN.display_cursor('&1', NULL,'ADVANCED ROWS ALLSTATS'));
The above statement will provide lot of additional information


------------------------------------------------------------------------------------------------------------------------------


--Check DARI AWR (kalau di execute in the past)
select * from table( DBMS_XPLAN.DISPLAY_AWR('&1', NULL,NULL,'ADVANCED ROWS ALLSTATS'));

------------------------------------------------------------------------------------------------------------------------------

--Check HASH HISTORY HASH PLAN
set lines 700 pages 10000 long 10000
col sql_id from a30
col snaptime for a30 
select to_char(begin_interval_time,'yy-mm-dd hh24:mi')|| ' - ' || to_char(end_interval_time,'hh24:mi') 
snaptime,sql_id,plan_hash_value plan_hash, (case executions_delta when 0 then 1 else executions_delta end) exec_delta,
trunc((elapsed_time_delta/1000000)) elap_delta_sec,
trunc((elapsed_time_delta/1000000)/(case executions_delta when 0 then 1 else executions_delta end),3) avg_elap_sec, rows_processed_delta rows_delta,
trunc(rows_processed_delta/(case executions_delta when 0 then 1 else executions_delta end)) avg_row,
trunc(disk_reads_delta/(case executions_delta when 0 then 1 else executions_delta end)) disk_reads
from dba_hist_sqlstat a join dba_hist_snapshot b on (a.snap_id=b.snap_id and a.instance_number=b.instance_number)
and begin_interval_time > trunc(sysdate-7) and sql_id= '&sqlid' and b.instance_number=1 order by 1;

------------------------------------------------------------------------------------------------------------------------------

1. masuk sqlplus 
2. run coe_xfr_sql_profile.sql
3. masukan smallest hashplan dengan avg_et_sec 
4. hasilnya (file .sql) di jalankan dari sqlplus


--select * from C2PEVEN_SIT11.ACTIVE_OFFER WHERE CREATED_DT >= '06-AUG-2020' and CREATED_DT < '07-AUG-2020' and END_DT >= 

explain plan for
select a.api_keyword from NEWTSPOIN.ATP_DRAW_PRIZES a, NEWTSPOIN.ATP_KEYWORDS b where a.program_id=0 and a.status=0 
and a.evt_id=b.evt_id_reff and a.program_id=b.program_id and b.pt_id=0 
and sysdate between a.eff_date and a.exp_date and a.api_keyword is not null;
