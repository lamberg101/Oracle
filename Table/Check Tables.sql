--Check fragmated table	
set pages 50000 
set lines 32767s
select owner, table_name,
round((blocks*8),2)||'kb' "Fragmented size", 
round((num_rows*avg_row_len/1024),2)||'kb' "Actual size", 
round((blocks*8),2)-round((num_rows*avg_row_len/1024),2)||'kb',
((round((blocks*8),2)-round((num_rows*avg_row_len/1024),2))/round((blocks*8),2))*100 -10 "reclaimable space % " 
from dba_tables 
where table_name ='&table_Name' 
and owner like '&schema_name';


--DBA_SEGMENTS
set lines 300
col segment_name for a35
col owner for a35
select  owner, tablespace_name, segment_type, segment_name,sum(bytes/1024/1024) MB 
from dba_segments 
where segment_name in ('TABLE_NAME')
group by owner, tablespace_name, segment_name, segment_type
order by segment_type;


-------------------------------------------------------------------------------------------------------------------

select count(*) 
from dba_tables 
where table_name like 'CMP%';

-------------------------------------------------------------------------------------------------------------------

--DBA_TABLES
set lines 999
set pages 999
col owner for a30
col table_name for a30
col tablespace_name for a30
select owner, table_name, STATUS, tablespace_name, SEGMENT_CREATED
from DBA_TABLES
where owner='FCC114';



-------------------------------------------------------------------------------------------------------------------

--DBA_OBJECTS
SELECT OBJECT_NAME, owner, object_type, created 
FROM dba_objects 
WHERE object_name like '%TSEL_REPORT_PLAFOND%' ;
AND object_type = 'TABLE';


-------------------------------------------------------------------------------------------------------------------

--Check size tbs SYS.AUD$%
set lines 150
col owner for a30
col segment_name for a30
SELECT OWNER, SEGMENT_NAME,SEGMENT_TYPE, TABLESPACE_NAME, BYTES/1024/1024 MB 
FROM DBA_SEGMENTS  
WHERE SEGMENT_NAME in ('MDS_CDR_ROAMWARE_MAP');


--------------------------------------------------------------------------------------------------------------


--Cari table nya LOBSEGMENT
col OWNER for a30
col TABLE_NAME for a30
col ABLESPACE_NAME for a30
col COLUMN_NAME for a30
col SEGMENT_NAME  for a30
SELECT OWNER,TABLE_NAME,TABLESPACE_NAME,COLUMN_NAME,SEGMENT_NAME 
FROM DBA_LOBS 
WHERE TABLE_NAME in ('TABLE_NAME');

--------------------------------------------------------------------------------------------------------------

--Check TABLE ROWS
SELECT COUNT(*) FROM SCHEMA.TABLE;
SELECT COUNT(*) FROM SCHEMA.TABLE where rownum < 10;
SELECT /*+ PARALLEL 4 */ COUNT(*) FROM DGPOS.REWARD_LEDGER where rownum < 10;

select /*+ PARALLEL 8 */ COUNT(*) 
from ACTB_HISTORY 
where TRN_DT  
BETWEEN to_date(to_char('23-AUG-2017 00:00:00'),'DD-MON-YYYY HH24:MI:SS')
AND to_date(to_char('23-AUG-2022 20:00:00'),'DD-MON-YYYY HH24:MI:SS'); 



--INSERT INTO /*+ PARALLEL (4) */ INTO REWARD_LEDGER 
--SELECT /*+ PARALLEL(8) */* FROM REWARD_LEDGER_OLD WHERE CREATED_AT > TIMESTAMP '2021-08-01 00:00:00';

--INSERT INTO  /*+  PARALLEL(8) */  C2P_PROD.ACTIVE_OFFER;
--SELECT /*+ PARALLEL(12) */* FROM DGPOS.PHYSICAL_VOUCHER_OLD WHERE CREATED_AT between timestamp '2021-03-11 00:00:00' and timestamp '2021-03-12 00:00:00';
--commit;



OEM = Schema > Database Object > Tables > Input owner/table name 

--------------------------------------------------------------------------------------------------------------

--Check LAST ANALYZED
col owner for a30
col table_name for a30
SELECT OWNER,TABLE_NAME, LAST_ANALYZED 
FROM DBA_TABLES 
WHERE TABLE_NAME in ('T_BPM_HT_TASK','T_BPM_HT_ASSIGNEE','T_BPM_PRIMITIVE_VARIABLES','T_BPM_PROCESSINSTANCE')
;



--------------------------------------------------------------------------------------------------------------

--Check CONSTRAINT

select OWNER, CONSTRAINT_NAME, STATUS, INDEX_NAME from dba_constraints
where INDEX_NAME='USER_MESSAGES_HASH_IDX';