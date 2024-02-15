set pagesize 25 
set linesize 120 
select inst_id, to_char(begin_time,'MM/DD/YYYY HH24:MI') begin_time, 
UNXPSTEALCNT "# Unexpired|Stolen", 
EXPSTEALCNT "# Expired|Reused", 
SSOLDERRCNT "ORA-1555|Error", 
NOSPACEERRCNT "Out-Of-space|Error", 
MAXQUERYLEN "Max Query|Length" 
from gv$undostat 
where begin_time between to_date('05/12/2022 09:00:00','MM/DD/YYYY HH24:MI:SS') and 
to_date('05/13/2022 21:42:10','MM/DD/YYYY HH24:MI:SS') order by inst_id, begin_time;