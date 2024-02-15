1. Check status tablespace

select status, tablespace_name 
from DBA_TABLESPACES
where tablespace_name like '%2006%';


select status, tablespace_name 
from DBA_TABLESPACES
where status='OFFLINE';

select status, count(*)
from DBA_TABLESPACES
group by status;


--------------------------------------------------------------------------------------------------------------

2. Check size tablespace

select owner, TABLESPACE_NAME,sum(bytes/1024/1024/1024) GB 
from dba_segments 
where TABLESPACE_NAME like '%2021%' 
group by owner, TABLESPACE_NAME
order by owner, TABLESPACE_NAME;


=============================================================================================================


1. Check TABLESPACE (search)

set linesize 100
set pagesize 200
col "MAXSIZE (MB)" for 999999999.99
col "USED (MB)" for 999999999.99
col "FREE (MB)" for 999999999.99
col "% USED" for 999.99
Select  ddf.TABLESPACE_NAME "TABLESPACE",
		ddf.MAXBYTES "MAXSIZE (MB)",
		(ddf.BYTES - dfs.bytes) "USED (MB)",
		ddf.MAXBYTES-(ddf.BYTES - dfs.bytes) "FREE (MB)",
		round(((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) "% USED"
		from (select TABLESPACE_NAME,
		round(sum(BYTES)/1024/1024,2) bytes,
		round(sum(decode(autoextensible,'NO',BYTES,MAXBYTES))/1024/1024,2) maxbytes
		from   dba_data_files
		group  by TABLESPACE_NAME) ddf,
		(select TABLESPACE_NAME,
		round(sum(BYTES)/1024/1024,2) bytes
from dba_free_space
group by TABLESPACE_NAME) dfs
where ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME
--and ddf.TABLESPACE_NAME='&TABLESPACE_NAME'
--and ddf.TABLESPACE_NAME like '%FCCDATASM%'
order by (((ddf.BYTES - dfs.BYTES))/ddf.MAXBYTES) desc, (ddf.MAXBYTES-(ddf.BYTES - dfs.bytes));

-----------------------------------------------------------------------------------------------------------


2. Check TABLESPACE LAMA

Select   ddf.TABLESPACE_NAME "TABLESPACE",
         ddf.MAXBYTES "MAXSIZE (MB)",
         (ddf.BYTES - dfs.bytes) "USED (MB)",
         ddf.MAXBYTES-(ddf.BYTES - dfs.bytes) "FREE (MB)",
         round(((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) "USED %"
from    (select TABLESPACE_NAME,
         round(sum(BYTES)/1024/1024,2) bytes,
         round(sum(decode(autoextensible,'NO',BYTES,MAXBYTES))/1024/1024,2) maxbytes
         from   dba_data_files
         group  by TABLESPACE_NAME) ddf,
        (select TABLESPACE_NAME,
                round(sum(BYTES)/1024/1024,2) bytes
         from   dba_free_space
         group  by TABLESPACE_NAME) dfs
where    ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME 
--and ddf.TABLESPACE_NAME in ('FCC114','FCCDATASML')
order by "USED (MB)" ASC ;

-----------------------------------------------------------------------------------------------------------

3. Check TABLESPACE (BARU)

set timing on
set linesize 100
set pagesize 3000
col "MAXSIZE (MB)" for 999999999.99
col "USED (MB)" for 999999999.99
col "FREE (MB)" for 999999999.99
col "% USED" for 999.99
Select   ddf.TABLESPACE_NAME "TABLESPACE",
		ddf.BYTES "bytes (MB)",
         ddf.MAXBYTES "MAXSIZE (MB)",
         (ddf.BYTES - dfs.bytes) "USED (MB)",
         ddf.MAXBYTES-(ddf.BYTES - dfs.bytes) "FREE (MB)",
         round(((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) "% USED"
from    (select TABLESPACE_NAME,
         round(sum(BYTES)/1024/1024,2) bytes,
         round(sum(decode(autoextensible,'NO',BYTES,MAXBYTES))/1024/1024,2) maxbytes
         from   dba_data_files
         group  by TABLESPACE_NAME) ddf,
        (select TABLESPACE_NAME,
                round(sum(BYTES)/1024/1024,2) bytes
         from   dba_free_space
         group  by TABLESPACE_NAME) dfs
where    ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME
order by (((ddf.BYTES - dfs.BYTES))/ddf.MAXBYTES) desc, (ddf.MAXBYTES-(ddf.BYTES - dfs.bytes));


tcltc614t_hrn, tcnpm023t dan CMP3$412834

-------------------------------------------------------------------------------------------------------------

--Check TBS CONTAINER
SET LINES 132 PAGES 100 
COL con_name FORM A15 HEAD "Container|Name" 
COL tablespace_name FORM A30
COL fsm FORM 999,999,999,999 HEAD "Free|Space Meg." 
COL apm FORM 999,999,999,999 HEAD "Alloc|Space Meg." 
WITH x AS (SELECT c1.con_id, cf1.tablespace_name, SUM(cf1.bytes)/1024/1024 fsm FROM cdb_free_space cf1 ,v$containers c1
WHERE cf1.con_id = c1.con_id GROUP BY c1.con_id, cf1.tablespace_name), 
y AS (SELECT c2.con_id, cd.tablespace_name, SUM(cd.bytes)/1024/1024 apm 
FROM cdb_data_files cd ,v$containers c2 WHERE cd.con_id = c2.con_id GROUP BY c2.con_id ,cd.tablespace_name) 
SELECT x.con_id, v.name con_name, x.tablespace_name, x.fsm, y.apm FROM x, y, 
v$containers v WHERE x.con_id = y.con_id AND x.tablespace_name = y.tablespace_name 
AND v.con_id = y.con_id UNION SELECT vc2.con_id, vc2.name, tf.tablespace_name, null, 
SUM(tf.bytes)/1024/1024 FROM v$containers vc2, cdb_temp_files tf 
WHERE vc2.con_id = tf.con_id GROUP BY vc2.con_id, vc2.name, tf.tablespace_name ORDER BY 1, 2;

-------------------------------------------------------------------------------------------------------------

set linesize 200
set pagesize 200
col ts_type for a15
WITH df AS (SELECT tablespace_name, SUM(bytes) bytes, COUNT(*) cnt, DECODE(SUM(DECODE(autoextensible,'NO',0,1)), 0, 'NO', 'YES') autoext, sum(DECODE(maxbytes,0,bytes,maxbytes)) maxbytes FROM dba_data_files GROUP BY tablespace_name), 
     tf AS (SELECT tablespace_name, SUM(bytes) bytes, COUNT(*) cnt, DECODE(SUM(DECODE(autoextensible,'NO',0,1)), 0, 'NO', 'YES') autoext, sum(DECODE(maxbytes,0,bytes,maxbytes)) maxbytes FROM dba_temp_files GROUP BY tablespace_name), 
     tm AS (SELECT tablespace_name, used_percent FROM dba_tablespace_usage_metrics),
     ts AS (SELECT tablespace_name, COUNT(*) segcnt FROM dba_segments GROUP BY tablespace_name)
SELECT d.tablespace_name, 
       d.status,
       DECODE(d.contents,'PERMANENT',DECODE(d.extent_management,'LOCAL','LM','DM'),'TEMPORARY','TEMP',d.contents)||'-'||DECODE(d.allocation_type,'UNIFORM','UNI','SYS')||'-'||decode(d.segment_space_management,'AUTO','ASSM','MSSM') ts_type,
       a.cnt files,  
       NVL(s.segcnt,0) segments,
       ROUND(NVL(a.bytes / 1024 / 1024, 0), 3) Allocated_MB, 
       ROUND(NVL(a.bytes - NVL(f.bytes, 0), 0)/1024/1024,3) Used_MB, 
       ROUND(NVL(f.bytes, 0) / 1024 / 1024, 3) Free_MB, 
       ROUND(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0), 2) Used_pct, 
       ROUND(a.maxbytes / 1024 / 1024, 3)  max_ext_mb,
       ROUND(NVL(m.used_percent,0), 2) Max_used_pct
  FROM dba_tablespaces d, df a, tm m, ts s, (SELECT tablespace_name, SUM(bytes) bytes FROM dba_free_space GROUP BY tablespace_name) f 
 WHERE d.tablespace_name = a.tablespace_name(+) 
   AND d.tablespace_name = f.tablespace_name(+) 
   AND d.tablespace_name = m.tablespace_name(+) 
   AND d.tablespace_name = s.tablespace_name(+)
   AND NOT d.contents = 'UNDO'
   AND NOT ( d.extent_management = 'LOCAL' AND d.contents = 'TEMPORARY' ) 
AND d.tablespace_name in (
'TBS_OS_BNS_TR_201705',
'TBS_OS_BNS_TR_201709',
'TBS_OS_BNS_TR_201708',
'TBS_OS_BNS_TR_201707',
'TBS_OS_BNS_TR_201706',
'TBS_OS_BNS_TR_201711',
'TBS_OS_BNS_TR_201712',
'TBS_OS_BNS_TR_201710'
)


-----------------------------------------------------------------------------------------------------------

4.  Check TABLESPACE not in ('tbs1','tbs2') 


Select   ddf.TABLESPACE_NAME "TABLESPACE",
       ddf.MAXBYTES "MAXSIZE (MB)",
       (ddf.BYTES - dfs.bytes) "USED (MB)",
       ddf.MAXBYTES-(ddf.BYTES - dfs.bytes) "FREE (MB)",
       round(((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) "% USED"
from    (select TABLESPACE_NAME,
       round(sum(BYTES)/1024/1024,2) bytes,
       round(sum(decode(autoextensible,'NO',BYTES,MAXBYTES))/1024/1024,2) maxbytes
       from   dba_data_files
       group  by TABLESPACE_NAME) ddf,
      (select TABLESPACE_NAME,
          round(sum(BYTES)/1024/1024,2) bytes
       from   dba_free_space
       group  by TABLESPACE_NAME) dfs
where    ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME 
and ddf.TABLESPACE_NAME like '%2020%'
order by 3 DESC ;


-----------------------------------------------------------------------------------------------------------


5. Check TABLESPACE size/used% > 70

Select 
	ddf.TABLESPACE_NAME "TABLESPACE",
	ddf.MAXBYTES "MAXSIZE (MB)",
	(ddf.BYTES - dfs.bytes) "USED (MB)",
	ddf.MAXBYTES-(ddf.BYTES - dfs.bytes) "FREE (MB)",
round (((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) "% USED" 
from (select TABLESPACE_NAME,round(sum(BYTES)/1024/1024,2) bytes,
round (sum(decode(autoextensible,'NO',
	BYTES,MAXBYTES))/1024/1024,2) maxbytes 
from dba_data_files group  by TABLESPACE_NAME) ddf,
	(select TABLESPACE_NAME,
	round(sum(BYTES)/1024/1024,2) bytes 
	from dba_free_space group by TABLESPACE_NAME) dfs 
where ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME 
and round(((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) > 50 
order by 5;


-----------------------------------------------------------------------------------------------------------


6. Check TABLESPACE LIKE 201* AND NOT LIKE 2019

select * from (Select   ddf.TABLESPACE_NAME "TABLESPACE",
      ddf.MAXBYTES "MAXSIZE (MB)",
      (ddf.BYTES - dfs.bytes) "USED (MB)",
       ddf.MAXBYTES-(ddf.BYTES - dfs.bytes) "FREE (MB)",
       round(((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) "% USED"
from    (select TABLESPACE_NAME,
       round(sum(BYTES)/1024/1024,2) bytes,
       round(sum(decode(autoextensible,'NO',BYTES,MAXBYTES))/1024/1024,2) maxbytes
       from   dba_data_files
       group  by TABLESPACE_NAME) ddf,
      (select TABLESPACE_NAME,
          round(sum(BYTES)/1024/1024,2) bytes
       from   dba_free_space
       group  by TABLESPACE_NAME) dfs
where    ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME
and  ddf.TABLESPACE_NAME like '%2022%') 
--where TABLESPACE not like '%2017%'
--and  TABLESPACE not like '%2018%'
--and  TABLESPACE not like '%2016%'
order by TABLESPACE desc;


-----------------------------------------------------------------------------------------------------------


7. Check TBS 201*

set linesize 100
set pagesize 3000
col "MAXSIZE (MB)" for 999999999.99
col "USED (MB)" for 999999999.99
col "FREE (MB)" for 999999999.99
col "% USED" for 999.99
select * from ( Select   ddf.TABLESPACE_NAME "TABLESPACE",
		ddf.BYTES "bytes (MB)",
         ddf.MAXBYTES "MAXSIZE (MB)",
         (ddf.BYTES - dfs.bytes) "USED (MB)",
         ddf.MAXBYTES-(ddf.BYTES - dfs.bytes) "FREE (MB)",
         round(((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) "% USED"
from    (select TABLESPACE_NAME,
         round(sum(BYTES)/1024/1024,2) bytes,
         round(sum(decode(autoextensible,'NO',BYTES,MAXBYTES))/1024/1024,2) maxbytes
         from   dba_data_files
         group  by TABLESPACE_NAME) ddf,
        (select TABLESPACE_NAME,
                round(sum(BYTES)/1024/1024,2) bytes
         from   dba_free_space
         group  by TABLESPACE_NAME) dfs
where    ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME
and  ddf.TABLESPACE_NAME like '%PROV_TS_INDX_201%') 
where  TABLESPACE not like '%2018%'
and TABLESPACE not like '%2010%'
and  TABLESPACE not like '%2019%'
order by TABLESPACE asc;

-----------------------------------------------------------------------------------------------------------


8. Check TERBARU diatas 2018/2019/2017

set linesize 100
set pagesize 3000
col "MAXSIZE (MB)" for 999999999.99
col "USED (MB)" for 999999999.99
col "FREE (MB)" for 999999999.99
col "% USED" for 999.99
Select   ddf.TABLESPACE_NAME "TABLESPACE"
		ddf.BYTES "bytes (MB)",
         ddf.MAXBYTES "MAXSIZE (MB)",
         (ddf.BYTES - dfs.bytes) "USED (MB)",
         ddf.MAXBYTES-(ddf.BYTES - dfs.bytes) "FREE (MB)",
         round(((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) "% USED"
from    (select TABLESPACE_NAME,
         round(sum(BYTES)/1024/1024,2) bytes,
         round(sum(decode(autoextensible,'NO',BYTES,MAXBYTES))/1024/1024,2) maxbytes
         from   dba_data_files
         group  by TABLESPACE_NAME) ddf,
        (select TABLESPACE_NAME,
                round(sum(BYTES)/1024/1024,2) bytes
         from   dba_free_space
         group  by TABLESPACE_NAME) dfs
where    ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME
and  ddf.TABLESPACE_NAME in ('ESB_ILMUPED_TBS', 
order by (((ddf.BYTES - dfs.BYTES))/ddf.MAXBYTES) desc, (ddf.MAXBYTES-(ddf.BYTES - dfs.bytes));



--------------------------------------------------------------------------------------------------------------

9. Check TABLESPACE (LAMA) 2003


select   ddf.TABLESPACE_NAME "TABLESPACE",
      ddf.MAXBYTES "MAXSIZE (MB)",
      (ddf.BYTES - dfs.bytes) "USED (MB)",
       ddf.MAXBYTES-(ddf.BYTES - dfs.bytes) "FREE (MB)",
       round(((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) "% USED"
from    (select TABLESPACE_NAME,
       round(sum(BYTES)/1024/1024,2) bytes,
       round(sum(decode(autoextensible,'NO',BYTES,MAXBYTES))/1024/1024,2) maxbytes
       from   dba_data_files
       group  by TABLESPACE_NAME) ddf,
      (select TABLESPACE_NAME,
          round(sum(BYTES)/1024/1024,2) bytes
       from   dba_free_space
       group  by TABLESPACE_NAME) dfs
where    ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME
and  ddf.TABLESPACE_NAME like 'TLOB_%' 
order by TABLESPACE desc;



--------------------------------------------------------------------------------------------------------------

#Check TABLESPACE NUMERIC

set linesize 100
set pagesize 9900
col "MAXSIZE (MB)" for 999999999.99
col "USED (MB)" for 999999999.99
col "FREE (MB)" for 999999999.99
col "% USED" for 999.99
Select   ddf.TABLESPACE_NAME "TABLESPACE",
         ddf.MAXBYTES "MAXSIZE (MB)",
         (ddf.BYTES - dfs.bytes) "USED (MB)",
         ddf.MAXBYTES-(ddf.BYTES - dfs.bytes) "FREE (MB)",
         round(((ddf.BYTES - dfs.BYTES)/ddf.MAXBYTES)*100,2) "% USED"
from    (select TABLESPACE_NAME,
         round(sum(BYTES)/1024/1024,2) bytes,
         round(sum(decode(autoextensible,'NO',BYTES,MAXBYTES))/1024/1024,2) maxbytes
         from   dba_data_files
         group  by TABLESPACE_NAME) ddf,
        (select TABLESPACE_NAME,
                round(sum(BYTES)/1024/1024,2) bytes
         from   dba_free_space
         group  by TABLESPACE_NAME) dfs
where    ddf.TABLESPACE_NAME=dfs.TABLESPACE_NAME and REGEXP_LIKE(ddf.TABLESPACE_NAME,'_[0-9]+$')
order by 2;

--------------------------------------------------------------------------------------------------------------

#CHECK TABLESPACE GROWTH RATA2 PER HARI SELAMA 1 BULAN

SELECT part.tsname tablespace_name,
  Max(part.used_size) "Current Size (MB)",  /* Current size of tablespace */
  Round(Avg(inc_used_size), 2) "Growth Per Day(MB)" /* Growth of tablespace per day */
FROM (SELECT sub.days, sub.tsname, used_size, used_size - Lag (used_size, 1)
  over (PARTITION BY sub.tsname ORDER BY sub.tsname, sub.days) inc_used_size /* getting delta increase using analytic function */
FROM (SELECT TO_CHAR(hsp.begin_interval_time,'MM-DD-YYYY') days,
  hs.tsname, MAX((hu.tablespace_usedsize* dt.block_size )/(1024*1024)) used_size
from
  dba_hist_tbspc_space_usage hu, /* historical tablespace usage statistics */
  dba_hist_tablespace_stat hs , /* tablespace information from the control file */
  dba_hist_snapshot hsp, /* information about the snapshots in the Workload Repository */
  dba_tablespaces dt
where hu.snap_id = hsp.snap_id
  and hu.TABLESPACE_ID = hs.ts#
  and hs.tsname = dt.tablespace_name
  and dt.tablespace_name='TS_ATP_SUBS_N3'
  AND hsp.begin_interval_time > SYSDATE - 14 /* gathering info about last 30 days */
GROUP  BY To_char(hsp.begin_interval_time, 'MM-DD-YYYY'),   hs.tsname
order by  hs.tsname,days) sub) part
GROUP  BY part.tsname
ORDER  BY part.tsname; 



======================= DARI BANG ABDUL ====================================

--------DB SIZE GROWTH
set linesize 200
set pagesize 200
COL "Database Size" FORMAT a16
COL "Used Space" FORMAT a16
COL "Used in %" FORMAT a16
COL "Free in %" FORMAT a16
COL "Database Name" FORMAT a13
COL "Free Space" FORMAT a16
COL "Growth DAY" FORMAT a17
COL "Growth WEEK" FORMAT a16
COL "Growth DAY in %" FORMAT a16
COL "Growth WEEK in %" FORMAT a16

SELECT
(select min(creation_time) from v$datafile) "Create Time",
(select name from v$database) "Database Name",
ROUND((SUM(USED.BYTES) / 1024 / 1024 ),2) || ' MB' "Database Size",
ROUND((SUM(USED.BYTES) / 1024 / 1024 ) - ROUND(FREE.P / 1024 / 1024 ),2) || ' MB' "Used Space",
ROUND(((SUM(USED.BYTES) / 1024 / 1024 ) - (FREE.P / 1024 / 1024 )) / ROUND(SUM(USED.BYTES) / 1024 / 1024 ,2)*100,2) || '% MB' "Used in %",
ROUND((FREE.P / 1024 / 1024 ),2) || ' MB' "Free Space",
ROUND(((SUM(USED.BYTES) / 1024 / 1024 ) - ((SUM(USED.BYTES) / 1024 / 1024 ) - ROUND(FREE.P / 1024 / 1024 )))/ROUND(SUM(USED.BYTES) / 1024 / 1024,2 )*100,2) || '% MB' "Free in %",
ROUND(((SUM(USED.BYTES) / 1024 / 1024 ) - (FREE.P / 1024 / 1024 ))/(select sysdate-min(creation_time) from v$datafile),2) || ' MB' "Growth DAY",
ROUND(((SUM(USED.BYTES) / 1024 / 1024 ) - (FREE.P / 1024 / 1024 ))/(select sysdate-min(creation_time) from v$datafile)/ROUND((SUM(USED.BYTES) / 1024 / 1024 ),2)*100,3) || '% MB' "Growth DAY in %",
ROUND(((SUM(USED.BYTES) / 1024 / 1024 ) - (FREE.P / 1024 / 1024 ))/(select sysdate-min(creation_time) from v$datafile)*7,2) || ' MB' "Growth WEEK",
ROUND((((SUM(USED.BYTES) / 1024 / 1024 ) - (FREE.P / 1024 / 1024 ))/(select sysdate-min(creation_time) from v$datafile)/ROUND((SUM(USED.BYTES) / 1024 / 1024 ),2)*100)*7,3) || '% MB' "Growth WEEK in %"
FROM    (SELECT BYTES FROM V$DATAFILE
UNION ALL
SELECT BYTES FROM V$TEMPFILE
UNION ALL
SELECT BYTES FROM V$LOG) USED,
(SELECT SUM(BYTES) AS P FROM DBA_FREE_SPACE) FREE
GROUP BY FREE.P;




---TABLESPACE GROWTH
set serverout on
set verify off
set lines 200
set pages 2000
DECLARE
v_ts_id number;
not_in_awr EXCEPTION;
v_ts_name varchar2(200) := UPPER('&Tablespace_Name');
v_ts_block_size number;
v_begin_snap_id number;
v_end_snap_id number;
v_begin_snap_date date;
v_end_snap_date date;
v_numdays number;
v_ts_begin_size number;
v_ts_end_size number;
v_ts_growth number;
v_count number;
v_ts_begin_allocated_space number;
v_ts_end_allocated_space number;
BEGIN
SELECT ts# into v_ts_id FROM v$tablespace where name = v_ts_name;
SELECT count(*) INTO v_count FROM dba_hist_tbspc_space_usage where tablespace_id=v_ts_id;
IF v_count = 0 THEN 
RAISE not_in_awr;
END IF ;
SELECT block_size into v_ts_block_size FROM dba_tablespaces where tablespace_name = v_ts_name;
SELECT min(snap_id), max(snap_id), min(trunc(to_date(rtime,'MM/DD/YYYY HH24:MI:SS'))), max(trunc(to_date(rtime,'MM/DD/YYYY HH24:MI:SS')))
into v_begin_snap_id,v_end_snap_id, v_begin_snap_date, v_end_snap_date from dba_hist_tbspc_space_usage where tablespace_id=v_ts_id;
v_numdays := v_end_snap_date - v_begin_snap_date;

SELECT round(max(tablespace_size)*v_ts_block_size/1024/1024,2) into v_ts_begin_allocated_space from dba_hist_tbspc_space_usage where tablespace_id=v_ts_id and snap_id = v_begin_snap_id;
SELECT round(max(tablespace_size)*v_ts_block_size/1024/1024,2) into v_ts_end_allocated_space from dba_hist_tbspc_space_usage where tablespace_id=v_ts_id and snap_id = v_end_snap_id;
SELECT round(max(tablespace_usedsize)*v_ts_block_size/1024/1024,2) into v_ts_begin_size from dba_hist_tbspc_space_usage where tablespace_id=v_ts_id and snap_id = v_begin_snap_id;
SELECT round(max(tablespace_usedsize)*v_ts_block_size/1024/1024,2) into v_ts_end_size from dba_hist_tbspc_space_usage where tablespace_id=v_ts_id and snap_id = v_end_snap_id;
v_ts_growth := v_ts_end_size - v_ts_begin_size;
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('Tablespace Block Size: '||v_ts_block_size);
DBMS_OUTPUT.PUT_LINE('---------------------------');
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('Summary');
DBMS_OUTPUT.PUT_LINE('========');
DBMS_OUTPUT.PUT_LINE('1) Allocated Space: '||v_ts_end_allocated_space||' MB'||' ('||round(v_ts_end_allocated_space/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('2) Used Space: '||v_ts_end_size||' MB'||' ('||round(v_ts_end_size/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('3) Used Space Percentage: '||round(v_ts_end_size/v_ts_end_allocated_space*100,2)||' %');
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('History');
DBMS_OUTPUT.PUT_LINE('========');
DBMS_OUTPUT.PUT_LINE('1) Allocated Space on '||v_begin_snap_date||': '||v_ts_begin_allocated_space||' MB'||' ('||round(v_ts_begin_allocated_space/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('2) Current Allocated Space on '||v_end_snap_date||': '||v_ts_end_allocated_space||' MB'||' ('||round(v_ts_end_allocated_space/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('3) Used Space on '||v_begin_snap_date||': '||v_ts_begin_size||' MB'||' ('||round(v_ts_begin_size/1024,2)||' GB)' );
DBMS_OUTPUT.PUT_LINE('4) Current Used Space on '||v_end_snap_date||': '||v_ts_end_size||' MB'||' ('||round(v_ts_end_size/1024,2)||' GB)' );
DBMS_OUTPUT.PUT_LINE('5) Total growth during last '||v_numdays||' days between '||v_begin_snap_date||' and '||v_end_snap_date||': '||v_ts_growth||' MB'||' ('||round(v_ts_growth/1024,2)||' GB)');
IF (v_ts_growth <= 0 OR v_numdays <= 0) THEN
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('!!! NO DATA GROWTH WAS FOUND FOR TABLESPCE '||V_TS_NAME||' !!!');
ELSE
DBMS_OUTPUT.PUT_LINE('6) Per day growth during last '||v_numdays||' days: '||round(v_ts_growth/v_numdays,2)||' MB'||' ('||round((v_ts_growth/v_numdays)/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('Expected Growth');
DBMS_OUTPUT.PUT_LINE('===============');
DBMS_OUTPUT.PUT_LINE('1) Expected growth for next 30 days: '|| round((v_ts_growth/v_numdays)*30,2)||' MB'||' ('||round(((v_ts_growth/v_numdays)*30)/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('2) Expected growth for next 60 days: '|| round((v_ts_growth/v_numdays)*60,2)||' MB'||' ('||round(((v_ts_growth/v_numdays)*60)/1024,2)||' GB)');
DBMS_OUTPUT.PUT_LINE('3) Expected growth for next 90 days: '|| round((v_ts_growth/v_numdays)*90,2)||' MB'||' ('||round(((v_ts_growth/v_numdays)*90)/1024,2)||' GB)');
END IF;

EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('!!! TABLESPACE DOES NOT EXIST !!!');
WHEN NOT_IN_AWR THEN
DBMS_OUTPUT.PUT_LINE(CHR(10));
DBMS_OUTPUT.PUT_LINE('!!! TABLESPACE USAGE INFORMATION NOT FOUND IN AWR !!!');

END;
/
