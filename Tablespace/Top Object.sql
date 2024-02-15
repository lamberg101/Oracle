OWNER|SEGMNET_NAME|SEGMENT_TYPE|TABLESPACE_NAME|MB 
------------------------------------------------------

set pagesize 15000
col owner for a30
col segment_name for a40
col segment_type for a30
select * from ( select owner||'|'||segment_name||'|'||segment_type||'|'||tablespace_name||'|'||bytes/1024/1024 
from dba_segments 
where tablespace_name='MRA_TBS'
--and rownum<=250
order by bytes/1024/1024 desc);





set linesize 300
set pagesize 999
col segment_name format a35
col owner format a20
col tablespace_name format a30
select * from ( select owner, segment_name, segment_type, tablespace_name, round(sum(bytes/1024/1024),2) size_mb 
from dba_segments group by segment_name, owner, segment_type, tablespace_name order by 5 desc ) 
where tablespace_name='&tablespace_name'
and rownum<=100
order by tablespace_name;



select group_kfdat "group #",
       number_kfdat "disk #",
       count(*) "# AU's"
from x$kfdat a
where v_kfdat = 'V'
and not exists (select *
                from x$kfdat b
                where a.group_kfdat = b.group_kfdat
                and a.number_kfdat = b.number_kfdat
                and b.v_kfdat = 'F')
group by GROUP_KFDAT, number_kfdat;

select disk_number "Disk #", free_mb
from v$asm_disk
where group_number=3
order by 2;

select name, file_number
from v$asm_alias
where group_number in (select group_kffxp
                                           from x$kffxp
                                           where group_kffxp=3
                                           and disk_kffxp in (30,16)
                                           and au_kffxp != 4294967294
                                           and number_kffxp >= 256)
and file_number in (select number_kffxp
                                  from x$kffxp
                                  where group_kffxp=3
                                  and disk_kffxp in (30,16)
                                  and au_kffxp != 4294967294
                                  and number_kffxp >= 256)
and system_created='Y';


set linesize 300 
  set pagesize 200 
  col path for a60
  select group_number,disk_number, name, os_mb,total_mb, free_mb, path, header_status,mode_status 
from v$asm_disk 
where group_number=3
and disk_number in (16,30)
;


--------------------------------------------------------------------------------------------------------------------------------------

--Check ALL OBJECT
set linesize 300
set pagesize 999
col segment_name format a35
col owner format a20
col tablespace_name format a30
select * from ( select owner, segment_name, segment_type, tablespace_name, round(sum(bytes/1024/1024),2) size_mb 
from dba_segments group by segment_name, owner, segment_type, tablespace_name order by 5 desc ) 
where tablespace_name='&tablespace_name'
--and rownum<=100
order by tablespace_name;


--------------------------------------------------------------------------------------------------------------------------------------

set linesize 200
set pagesize 200
col ts_type for a15
WITH df AS (SELECT tablespace_name, SUM(bytes) bytes, COUNT(*) cnt, DECODE(SUM(DECODE(autoextensible,'NO',0,1)), 0, 'NO', 'YES') autoext, sum(DECODE(maxbytes,0,bytes,maxbytes)) maxbytes FROM dba_data_files GROUP BY tablespace_name), 
     tf AS (SELECT tablespace_name, SUM(bytes) bytes, COUNT(*) cnt, DECODE(SUM(DECODE(autoextensible,'NO',0,1)), 0, 'NO', 'YES') autoext, sum(DECODE(maxbytes,0,bytes,maxbytes)) maxbytes FROM dba_temp_files GROUP BY tablespace_name), 
     tm AS (SELECT tablespace_name, used_percent FROM dba_tablespace_usage_metrics),
     ts AS (SELECT tablespace_name, COUNT(*) segcnt FROM dba_segments GROUP BY tablespace_name),
   zz AS (SELECT tablespace_name,count(segment_name) zzzz from dba_extents group by tablespace_name)
SELECT d.tablespace_name, d.status,
       DECODE(d.contents,'PERMANENT',DECODE(d.extent_management,'LOCAL','LM','DM'),'TEMPORARY','TEMP',d.contents)||'-'||DECODE(d.allocation_type,'UNIFORM','UNI','SYS')||'-'||decode(d.segment_space_management,'AUTO','ASSM','MSSM') ts_type,
       a.cnt files,
     NVL(z.zzzz,0) objects,
       NVL(s.segcnt,0) segments,
       ROUND(NVL(a.bytes / 1024 / 1024, 0), 3) Allocated_MB, 
       ROUND(NVL(a.bytes - NVL(f.bytes, 0), 0)/1024/1024,3) Used_MB, 
       ROUND(NVL(f.bytes, 0) / 1024 / 1024, 3) Free_MB, 
       ROUND(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0), 2) Used_pct, 
       ROUND(a.maxbytes / 1024 / 1024, 3)  max_ext_mb,
       ROUND(NVL(m.used_percent,0), 2) Max_used_pct
  FROM dba_tablespaces d,zz z, df a, tm m, ts s, (SELECT tablespace_name, SUM(bytes) bytes FROM dba_free_space GROUP BY tablespace_name) f 
 WHERE d.tablespace_name = a.tablespace_name(+) 
   AND d.tablespace_name = f.tablespace_name(+) 
   AND d.tablespace_name = m.tablespace_name(+) 
   AND d.tablespace_name = s.tablespace_name(+)
   AND d.tablespace_name = z.tablespace_name(+)
   AND NOT d.contents = 'UNDO'
   AND NOT ( d.extent_management = 'LOCAL' AND d.contents = 'TEMPORARY' ) 
--   AND d.tablespace_name in (tbs1,tbs2) 
--   AND NVL(s.segcnt,0)= 0
   /

--------------------------------------------------------------------------------------------------------------------------------------

Select owner, object_type, count(*) 
from dba_objects group by owner, object_type 
where owner in ('xxx','xxx') 
order bsy 1;

col owner for a30
set colsep '|'
set lines 300
set pages 999
Select owner, object_type, count(*) 
from dba_objects 
where owner like 'TELKOM%'
--and OBJECT_NAME='ESB_UPD_1_UPS_AO'
group by owner, object_type 
order by 1;

EAI_SCHED_GEN & EAI_SCHED_GEN_2.


select owner, object_type, object_name
from dba_objects 
where owner='ESBPAPP' 
--or owner ='TR_USER'
order by object_name;


set lines 300
set pages 100
col TABLE_NAME for a30
col TABLE_OWNER for a30
col TABLESPACE_NAME for a20
col PARTITION_NAME for a40
select TABLE_OWNER, TABLE_NAME, TABLESPACE_NAME, PARTITION_NAME
from dba_tab_partitions
where 
--TABLE_NAME='TBAP_ITEM' 
--and 
TABLE_OWNER = 'ESBPAPP'
order by PARTITION_NAME;

