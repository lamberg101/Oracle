--Check LAST LOGIN
col machine for a35
select username, machine, to_char(logon_time,'HH:MM:SS')
from gv$session 
and rownum<100;

----------------------------------------------------------------------------------------------------

--DBA_AUDIT_TRAIL
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';
select  max(timestamp), a.username 
from dba_audit_trail a 
where action_name = 'LOGON' 
and username='CMDB'
group by username order by 1 desc;


----------------------------------------------------------------------------------------------------

set lines 300
set pages 9999
col machine for a32
col username for a32
col event for a32
select /* PARALLEL(12) */ DISTINCT  a.machine,to_char(sample_time,'DD-MON-YYYY') "TGL", a.user_id, b.user_id, b.USERNAME, event
from dba_hist_active_sess_history a, dba_users b
where sample_time  
between to_date('01-JAN-2020 00:00:00','DD-MON-YYYY HH24:MI:SS')
and to_date('03-SEP-2020 23:59:00','DD-MON-YYYY HH24:MI:SS')
and a.user_id=b.user_id
and b.USERNAME='ITBP'
order by to_char(sample_time,'DD-MON-YYYY') desc;

