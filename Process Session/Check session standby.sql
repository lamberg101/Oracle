set linesize 500
set pagesize 1000
column username format a15
column event format a50
column osuser format a15
column spid format a6
column sid format 99999
column serial# format 99999
column lockwait format 99999999
column service_name format a15
column module format a55
column machine format a35
column logon_time format a20
column current_sql format a55
col event for a30
SELECT NVL(s.username, '(oracle)') AS username,
		--s.inst_id,
        --s.osuser,
        to_char(s.logon_time,'dd/mm/yyyy hh24:mi:ss')   logon_time,
        s.sid,
        s.serial#,
        p.spid,
        --s.lockwait,
        s.status,
        --s.module,
        s.machine,
        s.program,
        --s.event,
        s.sql_id,
        round(s.last_call_et/60,0) last_call,
        SUBSTR(sa.sql_text, 1, 100) current_sql
    FROM gv$session s,
         gv$process p,
         gv$sqlarea sa
    WHERE s.paddr = p.addr 
        and s.sql_address    =  sa.address(+) 
        and s.sql_hash_value =  sa.hash_value(+)
		--and s.username not like '%oracle%'
		--and s.machine='e-billpapp1'
		--and s.username in ('PUBLIC','SYS')
        and s.username not in ('(oracle)')
		--and s.last_call_et > (60*60*24)
		--and s.logon_time < sysdate -1
		and s.status='ACTIVE'
		--and osuser != 'oracle'
		--and osuser = 'jboss'
		--and s.program like '%rman%'
		--and s.sid =1951
		--and s.sql_id='3y6pgnk2ubw7g'
		--and s.inst_id=1
		--and s.module='WEBACCESS-RVPROFORMA'
    ORDER BY s.last_call_et,s.username, s.osuser;