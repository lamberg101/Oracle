1. Check sql_text using SID

select a.serial#, a.sid,a.program,b.sql_text 
from gv$session a, v$sqltext b 
where a.sql_hash_value = b.hash_value 
and a.sid in (4653) 
--and a.serial# in (23) 
order by a.sid,hash_value,piece;


--------------------------------------------------------------------------------------------------

2. SQL_FULLTEXT

set linesize 132 pagesize 999
column sql_fulltext format a60 word_wrap 
break on sql_text skip 1 
select 
replace(translate(sql_fulltext,'0123456789','999999999'),'9','') 
SQL_FULLTEXT 
from v$sql 
where sql_id ='6k553438m6j36'
group by replace(translate(sql_fulltext,'0123456789','999999999'),'9','') 
/


--------------------------------------------------------------------------------------------------

3. Check long query/sql full text

set linesize 999
set pagesize 999
col MODULE for a40
col PROGRAM for a40
col TIME for a10
col sid for 9+-+9999
select sid,program,a.module,sql_fulltext,
(case
     when trunc(last_call_et)<60 then to_char(trunc(last_call_et))||' Sec(s)'
     when trunc(last_call_et/60)<60 then to_char(trunc(last_call_et/60))||' Min(s)'
     when trunc(last_call_et/60/60)<24 then to_char(trunc(last_call_et/60/60))||' Hour(s)'
     when trunc(last_call_et/60/60/24)>=1  then to_char(trunc(last_call_et/60/60/24))||' Day(s)'
 end) as time
from gv$session a,gv$sqlarea b
where a.sql_address=b.address
and a.sql_hash_value=b.hash_value
and users_executing>0
order by time desc;

--------------------------------------------------------------------------------------------------

set linesize 999
set pagesize 999
col INST_ID for 999
col TIME for a10
col MACHINE for a35
col USERNAME for a10
col osuser for a15
col event for a30
  select 
  a.INST_ID,
  a.machine,
  a.osuser,
  a.username,
  a.sid,
  a.serial#,
  a.SQL_ID,
--  a.EVENT,
  (case
     when trunc(last_call_et)<60 then to_char(trunc(last_call_et))||' Sec(s)'
     when trunc(last_call_et/60)<60 then to_char(trunc(last_call_et/60))||' Min(s)'
     when trunc(last_call_et/60/60)<24 then to_char(trunc(last_call_et/60/60))||' Hour(s)'
     when trunc(last_call_et/60/60/24)>=1  then to_char(trunc(last_call_et/60/60/24))||' Day(s)'
   end) as time,sql_fulltext
from gv$session a,gv$sqlarea b
where a.sql_address=b.address
and a.sql_hash_value=b.hash_value 
and a.username is not null
and a.username ='EPC'
  --and a.status='ACTIVE'
and users_executing>0 order by time desc;