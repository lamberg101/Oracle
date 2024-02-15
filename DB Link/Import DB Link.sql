source 	= TCSISRM1
target	= OPPRN 

#table yg akan di import
RM1_PACKAGE
RM1_RESOURCE

------------------------------------------------------------------------------------------------------------------------------------

STEP-STEP
1. Pre-check
- tnsping dari target ke source --tnsping TCSISRM
- add tns di target dan source --kalau belum bisa

3. create user SOURCE dan TARGET  
CREATE USER DBASIG IDENTIFIED BY oracle;
 
4. grant dba ke user tersebut
GRANT DBA TO DBASIG;


5. create dbalink di TARGET
CREATE PUBLIC DATABASE LINK linkmig
CONNECT TO dbasig 
IDENTIFIED BY oracle
USING 'TCSISRM';


6. sebelum proses import, check tablespace yg ada di source.
select owner,segment_name,tablespace_name 
from dba_segments 
where segment_name in('RM1_PACKAGE','RM1_RESOURCE') 
and owner = 'TCSISRMAPPO' 
group by owner,segment_name,tablespace_name 
order by 1 desc;


7. create tablespace di target (sesuai dengan yg akan di remap)
CREATE TABLESPACE RM1_PACKAGE DATAFILE '+DATAC4' SIZE 100M AUTOEXTEND ON NEXT 100M MAXSIZE 31G;
CREATE TABLESPACE RM1_RESOURCE DATAFILE '+DATAC4' SIZE 100M AUTOEXTEND ON NEXT 100M MAXSIZE 31G;


8. craete directory di source untuk tahapan proses import dan di kasih grant.
CREATE OR REPLACE DIRECTORY DATA_PUMP_DIR AS '/datadump1/OPPRN/dblink/';
GRANT READ, WRITE ON DIRECTORY tdblink.DATA_PUMP_DIR TO EXP_FULL_DATABASE;
GRANT READ, WRITE ON DIRECTORY tdblink.DATA_PUMP_DIR TO IMP_FULL_DATABASE;


9. di proses import, remap tablespacenya 
nohup impdp dbasig/oracle 
DIRECTORY=DATA_PUMP_DIR 
LOGFILE=RM1_PACKAGE_imp.log 
tables=TCSISRMAPPO.RM1_PACKAGE 
NETWORK_LINK=linkmig 
EXCLUDE=STATISTICS/MARKER 
REMAP_TABLESPACE=DATAM01:RM1_PACKAGE 
REMAP_TABLESPACE=IXM01:RM1_PACKAGE &


------------------------------------------------------------------------------------------------------------------------------------

Note!
1. untuk network link tidak support type data LONG
ORA-31679: Table data object "SIBADI"."SIBADI_KEGIATAN" has long columns, and longs can not be loaded/unloaded using a network link

--Check long
select owner, table_name, column_name, data_type from all_tab_columns where table_name in ('RM1_PACKAGE','RM1_RESOURCE') and data_type like 'LONG%' order by 1;  

--Check segment owner apa aja yang ada datanya
select round(sum(bytes/1024/1024/1024)), owner from dba_segments group by owner order by 1 desc;

--Check Long
select owner, table_name, column_name, data_type from all_tab_columns where owner in ('SIMWAS','LHBU_SIMWAS')  and data_type like 'LONG%' order by 1;

-- Check Size table Long
select sum(bytes)/1024/1024,owner,segment_name from dba_segments where segment_name in
( select table_name from all_tab_columns where owner in ('SIMWAS','LHBU_SIMWAS') and data_type like 'LONG%' )
group by owner,segment_name order by 3;




