Doc:
https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=266139838745141&parent=EXTERNAL_SEARCH&sourceId=REFERENCE&id=1097154.1&_afrWindowMode=0&_adf.ctrl-state=1bbotnoebj_4


--Check SESSION LAST ONE HOUR

SELECT sql_id, count(*), round(count(*)/sum(count(*)) over(), 2) pctload
FROM gv$active_session_history
WHERE sample_time > SYSDATE - 1/24
AND session_type = 'FOREGROUND'
--AND session_type = 'BACKGROUND'
GROUP BY sql_id
ORDER BY COUNT(*) DESC;

---------------------------------------------------------------------------------------------------------------------

--Check WAIT EVENTS

SELECT sample_time, event, wait_time
FROM gv$active_session_history
WHERE session_id = &1
AND session_serial# = &2;


select SQL_ID,event,count(*) 
from gv$session 
where type!='BACKGROUND' 
and status='ACTIVE' 
group by SQL_ID,event 
order by 3;

---------------------------------------------------------------------------------------------------------------------

--MOST I/O INTENSIVE SQL IN LAST 1 HOUR

SELECT sql_id, COUNT(*)
FROM gv$active_session_history ash, gv$event_name evt
WHERE ash.sample_time > SYSDATE - 1/24
AND ash.session_state = 'WAITING'
AND ash.event_id = evt.event_id
AND evt.wait_class = 'User I/O'
GROUP BY sql_id
ORDER BY COUNT(*) DESC;


---------------------------------------------------------------------------------------------------------------------

--TOP SQLS SPENT MORE ON CPU/WAIT/IO
select
ash.SQL_ID ,
sum(decode(a.session_state,'ON CPU',1,0)) "CPU",
sum(decode(a.session_state,'WAITING',1,0)) -
sum(decode(a.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0)) "WAIT" ,
sum(decode(a.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0)) "IO" ,
sum(decode(a.session_state,'ON CPU',1,1)) "TOTAL"
from v$active_session_history a,v$event_name en
where SQL_ID is not NULL and en.event#=ash.event#;


---------------------------------------------------------------------------------------------------------------------

--TOP SESSION ON CPU in last 15 minutes

SELECT * FROM
(
SELECT s.username, s.module, s.sid, s.serial#, s.sql_id,count(*)
FROM v$active_session_history h, v$session s
WHERE h.session_id = s.sid
AND h.session_serial# = s.serial#
AND session_state= 'ON CPU' AND
sample_time > sysdate - interval '15' minute
GROUP BY s.username, s.module, s.sid, s.serial#,s.sql_id
ORDER BY count(*) desc
)
where rownum <= 10;