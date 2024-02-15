set linesize 200
set pagesize 200
col ts_type for a15
spool optoip_tbs2.txt
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
   AND NOT d.contents = 'UNDO%'
   AND NOT ( d.extent_management = 'LOCAL' AND d.contents = 'TEMPORARY' ) 
--   AND d.status ='OFFLINE'
--   AND NVL(s.segcnt,0)= 0;
spool off