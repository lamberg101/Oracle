set echo off   linesize 200  pages 1000  head on  feedback on
  col sid head "Sid" form 999999 trunc
  col serial# form 99999 trunc head "Ser#"
  col username form a30 trunc
  col osuser form a30 trunc
  col machine form a50 trunc head "Client|Machine"
  col program form a20 trunc head "Client|Program"
  col login form a11
  col "last call" form 9999999 trunc head "Last Call|In Secs"
  col status form a10 trunc
  select sid,serial#,substr(username,1,30) username,substr(osuser,1,30) osuser,
  substr(program||module,1,30) program,substr(machine,1,40) machine,
  to_char(logon_time,'ddMon hh24:mi') login,
  last_call_et "last call",status,sql_hash_value
  from v$session
  where username is not null
  order by 7 desc
  /