
--Check SIZE TEMP
select b.Total_MB,
       b.Total_MB - round(a.used_blocks*8/1024) Current_Free_MB,
       round(used_blocks*8/1024)                Current_Used_MB,
      round(max_used_blocks*8/1024)             Max_used_MB
from v$sort_segment a,
 (select round(sum(bytes)/1024/1024) Total_MB from dba_temp_files ) b;	


---------------------------------------------------------------------------------------------------------------------------

--CHECK TEMP 2

set pages 999
set lines 400
SELECT df.tablespace_name tablespace_name,
 max(df.autoextensible) auto_ext,
 round(df.maxbytes / (1024 * 1024), 2) max_ts_size,
 round((df.bytes - sum(fs.bytes)) / (df.maxbytes) * 100, 2) max_ts_pct_used,
 round(df.bytes / (1024 * 1024), 2) curr_ts_size,
 round((df.bytes - sum(fs.bytes)) / (1024 * 1024), 2) used_ts_size,
 round((df.bytes-sum(fs.bytes)) * 100 / df.bytes, 2) ts_pct_used,
 round(sum(fs.bytes) / (1024 * 1024), 2) free_ts_size,
 nvl(round(sum(fs.bytes) * 100 / df.bytes), 2) ts_pct_free
FROM dba_free_space fs,
 (select tablespace_name,
 sum(bytes) bytes,
 sum(decode(maxbytes, 0, bytes, maxbytes)) maxbytes,
 max(autoextensible) autoextensible
 from dba_data_files
 group by tablespace_name) df
WHERE fs.tablespace_name (+) = df.tablespace_name AND fs.tablespace_name='TEMP'
GROUP BY df.tablespace_name, df.bytes, df.maxbytes
UNION ALL
SELECT df.tablespace_name tablespace_name,
 max(df.autoextensible) auto_ext,
 round(df.maxbytes / (1024 * 1024), 2) max_ts_size,
 round((df.bytes - sum(fs.bytes)) / (df.maxbytes) * 100, 2) max_ts_pct_used,
 round(df.bytes / (1024 * 1024), 2) curr_ts_size,
 round((df.bytes - sum(fs.bytes)) / (1024 * 1024), 2) used_ts_size,
 round((df.bytes-sum(fs.bytes)) * 100 / df.bytes, 2) ts_pct_used,
 round(sum(fs.bytes) / (1024 * 1024), 2) free_ts_size,
 nvl(round(sum(fs.bytes) * 100 / df.bytes), 2) ts_pct_free
FROM (select tablespace_name, bytes_used bytes
 from V$temp_space_header
 group by tablespace_name, bytes_free, bytes_used) fs,
 (select tablespace_name,
 sum(bytes) bytes,
 sum(decode(maxbytes, 0, bytes, maxbytes)) maxbytes,
 max(autoextensible) autoextensible
 from dba_temp_files
 group by tablespace_name) df
WHERE fs.tablespace_name (+) = df.tablespace_name AND fs.tablespace_name='TEMP'
GROUP BY df.tablespace_name, df.bytes, df.maxbytes
ORDER BY 4 DESC;

-----------------------------------------------------------------------------------------------------------------------------

--CHECK TEMP 3
set lines 999
col name for a20 
col type for a20
SELECT d.tablespace_name "Name", d.contents "Type",
TO_CHAR(NVL(a.bytes / 1024 / 1024, 0),'99,999,990.900') "Size (M)", TO_CHAR(NVL(t.bytes,
0)/1024/1024,'99999,999.999') ||'/'||TO_CHAR(NVL(a.bytes/1024/1024, 0),'99999,999.999') "Used (M)",
TO_CHAR(NVL(t.bytes / a.bytes * 100, 0), '990.00') "Used %"
FROM sys.dba_tablespaces d, (select tablespace_name, sum(bytes) bytes from dba_temp_files group by
tablespace_name) a,
(select tablespace_name, sum(bytes_cached) bytes from
v$temp_extent_pool group by tablespace_name) t
WHERE d.tablespace_name = a.tablespace_name(+) AND d.tablespace_name = t.tablespace_name(+)
AND d.extent_management like 'LOCAL' AND d.contents like 'TEMPORARY'
and TO_CHAR(NVL(t.bytes / a.bytes * 100, 0), '990.00') > 1;


--------------------------------------------------------------------------------------------------------------------------------

--CHECK TEMP 4
select 
	tablespace_name "TEMP TBS NAME",
	bytes/(1024*1024) "SIZE(MBs)",
	bytes_used/(1024*1024) "BYTES USED(MBs)",
	bytes_free/(1024*1024) "BYTES FREE(MBs)" 
from 
	sys.v_$temp_space_header,
	v$tempfile ;


----------------------------------------------------------------------------------------------------------------------------------

--WHO IS USING TEMP SEGMENTS	

SELECT 
	b.tablespace, 
	ROUND(((b.blocks*p.value)/1024/1024),2)||'M' "SIZE", 
	a.sid||','||a.serial# SID_SERIAL, 
	a.username,
	a.program
FROM 
	sys.v_$session a, 
	sys.v_$sort_usage b,  
	sys.v_$parameter p
WHERE p.name = 'db_block_size'
AND a.saddr = b.session_addr
ORDER BY b.tablespace, b.blocks;


----------------------------------------------------------------------------------------------------------------------------------

--CHECK TEMP 5

SELECT A.tablespace_name tablespace, D.mb_total, round(SUM (A.used_blocks * D.block_size) / (1024*1024),2) mb_used,
D.mb_total - SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_free 
FROM v$sort_segment A, (
	SELECT B.name, C.block_size, round(SUM (C.bytes) / (1024*1024),2) mb_total
	FROM v$tablespace B, v$tempfile C
	WHERE B.ts#= C.ts#
	GROUP BY B.name, C.block_size) D
WHERE A.tablespace_name = D.name
GROUP by A.tablespace_name, D.mb_total;



=====================================================================================================================================

--Check SESSION YANG CONSUME TEMP

col hash_value for a40
col tablespace for a10
col username for a15
set linesize 132 pagesize 1000
SELECT s.sid, s.username, u.tablespace, s.sql_hash_value||'/'||u.sqlhash hash_value, u.segtype, u.contents, u.blocks
FROM v$session s, v$tempseg_usage u
WHERE s.saddr=u.session_addr
order by u.blocks;

Note --segtype yg sort perlu di Check

----------------------------------------------------------------------------------------------------------------------------------------

--Check USAGE
set pages 999
set lines 300
col username for a10
col sid for 99999
col pid for a5
col status for a8
col sql_id for a13
col event for a30
col connnected_from for a22
col tablespace for a10
col segtype for a10
SELECT * FROM TEMP_USAGE WHERE STATUS='ACTIVE' AND TEMP_USED_GB>0;
 

