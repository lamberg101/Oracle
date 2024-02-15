1. CARI/Check SID pake SPID

select b.spid,a.sid, a.serial#,a.username, a.osuser
from v$session a, v$process b
where a.paddr= b.addr
and B.SPID='&spid'
order by b.spid;
2895

atau >>>>>

SELECT P.Spid
     , S.Sid
     , S.Serial#
     , S.Username
--     , S.Status
--     , S.Last_Call_Et
--     , P.Program
--     , P.Terminal
--     , Logon_Time
--     , Module
     , S.Osuser
FROM V$process P, V$session S
WHERE S.Paddr = P.Addr
--AND S.Status = 'ACTIVE'
AND S.Username NOT LIKE '%SYS%'
--AND S.username='TUNAIREPORT'
and P.Spid=2895;



8. Check SID & PID 

select s.sid, p.spid, substr(s.username,1,20) username, s.terminal, p.Program
from v$session s, v$process p
where s.paddr = p.addr
and s.sid = (select sid from v$mystat where rownum=1);