
--COLLECT/EXPORT 

set trimspool ON
set headsep off
set pagesize 0
set linesize 500
set echo off
set feedback off
col ERROR for 9999999999.99
spool DAS_10MINUTE_SR_INSTANCE.csv
select '"' || DATETIME || '","' || MODUL || '","' || INSTANCE || '","' || SR || '","' || TOTAL || '","' || WARNING || '","' || ERROR || '","' || SUCCESS || '","' || SITE || '","' || LATENCY || '"' as text 
from REPORT.DAS_10MINUTE_SR_INSTANCE;
spool off

Note! Check kolom nya dan sesuaikan 

--------------------------------------------------------------------------------------------------------------------------------------------

--COLLECT/EXPORT ALL

set trimspool ON
set headsep off
set pagesize 0
set linesize 500
set echo off
set feedback off
col ERROR for 9999999999.99

spool DAS_10MINUTE_SR_INSTANCE.csv
select * from REPORT.DAS_10MINUTE_SR_INSTANCE;
spool off