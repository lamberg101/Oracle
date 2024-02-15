
--CHECK PGA DETAIl
select * from v$pga_stats;

------------------------------------------------------------------------------------------------

--check for all session
select name, value
from v$statname n, v$sesstat t
where n.statistic# = t.statistic#
and t.sid = ( select sid from v$mystat where rownum = 1 )
and n.name in ( 'session pga memory', 'session pga memory max','session uga memory', 'session uga memory max');


------------------------------------------------------------------------------------------------

-- check the pga usage by all session
select s.osuser osuser,s.serial# serial,se.sid,n.name,max(se.value) maxmem
from v$sesstat se, v$statname n ,v$session s
where n.statistic# = se.statistic#
and n.name in ('session pga memory','session pga memory max','session uga memory','session uga memory max')
and s.sid=se.sid
group by n.name,se.sid,s.osuser,s.serial#
order by 2;


------------------------------------------------------------------------------------------------

--find PGA usage for a specific session
SELECT SID, b.NAME, ROUND(a.VALUE/(1024*1024),2) MB 
FROM v$sesstat a, v$statname b
WHERE (NAME LIKE '%session uga memory%' OR NAME LIKE '%session pga memory%')
AND a.statistic# = b.statistic#
--AND SID = 80;




