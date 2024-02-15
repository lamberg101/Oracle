1. Offline Datafile

set heading off
col file_name for a80
set linesize 600
spool OPAPMOLD_DATAFILE_20190629.sql
select 'ALTER DATABASE DATAFILE '''||file_name||''' OFFLINE;' 
from dba_data_files 
where tablespace_name='APMUIMOLD';
spool off