1. Check SEGMENT

set linesize 300
set pagesize 50
col SEGMENT_NAME format a35
col OWNER format a20
col TABLESPACE_NAME format a30
select * from ( select owner, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, round(sum(bytes/1024/1024),2) Size_MB 
from dba_segments 
where SEGMENT_NAME in ('SYS_C0010456')
--and owner='HRNDATA'
group by segment_name, owner, SEGMENT_TYPE, TABLESPACE_NAME 
order by 5 desc) ;



set lines 300
col segment_name for a35
col owner for a35
select  owner, sum(bytes/1024/1024) MB 
from dba_segments 
where owner in ('TSEL_VERONAEI')
group by owner
order by owner;

select segment_name, sum(bytes/1024/1024/1024) GB 
from dba_segments 
where SEGMENT_NAME like '%AUD$%'
group by segment_name; 


TR_USER.TRACK_LOGIN 
------------------------------------------------------------------------------------------------------------------------------------

select owner, sum(bytes/1024/1024/1024) "segment in GB" from dba_segments where segment_name='APPS' group by owner;

select owner, segment_name,sum(bytes/1024/1024/1024) "segment in GB" from dba_segments where segment_name='TCPUR043T' group by owner,segment_name;

where segment_name='TCPUR043T'
and owner='TELKOMSEL'

------------------------------------------------------------------------------------------------------------------------------------


2. Check SEGMENT/TBS diatas tahun 2018

select * from (
select owner,segment_name,tablespace_name,segment_type,bytes/1024/1024/1024 GB 
from dba_segments 
order by bytes/1024/1024 desc
) 
where rownum=44 
and segment_type not like '%LOB%' 
and tablespace_name not like '%2018%' 
and tablespace_name not like '%2017%' 
and TABLESPACE_NAME not like 'SYSTEM%' 
and TABLESPACE_NAME not like 'SYSAUX%' 
order by 5 desc;  


------------------------------------------------------------------------------------------------------------------------------------


10. Check SEGMENT/TABLESPACE_NAME

set linesize 300
set pagesize 50
col SEGMENT_NAME format a35
col OWNER format a20
col TABLESPACE_NAME format a30
select * from (select owner, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, round(sum(bytes/1024/1024/1024),2) Size_GB 
from dba_segments 
where TABLESPACE_NAME like '%201%'
and TABLESPACE_NAME not like '%2019%'
group by segment_name, owner, SEGMENT_TYPE, TABLESPACE_NAME 
order by Size_GB desc) ;

