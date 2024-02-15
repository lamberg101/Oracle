1. CHANGE DEFAULT ATTRIBUTES TABLESPACE

set heading off
set linesize 200
set pagesize 0
spool tbs_def_tab.sql
select 'ALTER TABLE '||owner||'.'||table_name||' MODIFY DEFAULT ATTRIBUTES TABLESPACE TB_NAME;' 
from dba_part_tables 
where def_tablespace_name like '%201%' 
and def_tablespace_name not like '$2019%';
spool off

