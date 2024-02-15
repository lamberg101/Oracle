1. Check session 

select distinct username,machine, osuser,inst_id, count(*) 
from gv$session  
where osuser != 'oracle' 
--and logon_time < sysdate -7 
and last_call_et > 21600 
group by username,machine, osuser, inst_id 
order by count(*) desc;

---------------------------------------------------------------------------------------------------------

1. Check session inactive (exclude sys, dkk)

SELECT NVL(s.username, '(oracle)') AS username,
       --s.osuser,
		to_char(s.logon_time,'dd/mm/yyyy hh24:mi:ss')   slogon_time,
       s.sid,
       s.serial#,
       p.spid,
       --s.lockwait,
       s.status,
       --s.module,
       --s.machine,
     s.program,
     s.sql_id,
     s.last_call_et AS last_call_et_secs
     --SUBSTR(sa.sql_text, 1, 600) current_sql
FROM   gv$session s,
       gv$process p,
     gv$sqlarea sa
WHERE  s.paddr = p.addr 
  AND s.sql_address    =  sa.address(+) 
  AND s.sql_hash_value =  sa.hash_value(+)
AND s.USERNAME NOT LIKE '%oracle%'
AND s.USERNAME NOT in ('SYS','DBSNMP','SSIDBA','SYSTEM')
and s.last_call_et > 3600
and s.logon_time < sysdate -7
and s.status='INACTIVE'
--and osuser != 'oracle'
--and s.program like '%rman%'
--and s.sid=267
ORDER BY s.username, s.osuser;


ARADMIN 		       13/08/2019 11:39:39	 1540	   28749 77942			  INACTIVE arserverd@remedypapp1 (TNS V1-V3)					     643658
ARADMIN 		       13/08/2019 11:39:39	 1480	   12923 77931			  INACTIVE arserverd@remedypapp1 (TNS V1-V3)					    1680203
ARADMIN 		       13/08/2019 11:39:38	 1465	   59403 77893			  INACTIVE arserverd@remedypapp1 (TNS V1-V3)					    1062355
ARADMIN 		       13/08/2019 11:39:37	  865	    1679 77595			  INACTIVE arserverd@remedypapp1 (TNS V1-V3)					    3580165
ARADMIN 		       29/08/2019 21:48:39	  706	     939 77575			  INACTIVE arserverd@helpdeskpapp7 (TNS V1-V3)					    2161224
ARADMIN 		       29/08/2019 21:54:44	  525	    9399 77555			  INACTIVE arserverd@remedypapp2 (TNS V1-V3)					    1746399
ARADMIN 		       05/09/2019 17:46:58	  353	    9995 121978 		  INACTIVE arserverd@helpdeskpapp6 (TNS V1-V3)					      39518
ARADMIN 		       05/09/2019 17:46:58	  318	   15287 121976 		  INACTIVE arserverd@helpdeskpapp6 (TNS V1-V3)					      20484
ARADMIN 		       05/09/2019 17:46:57	 1486	   13019 121974 		  INACTIVE arserverd@helpdeskpapp6 (TNS V1-V3)					      20460
ARADMIN 		       29/08/2019 21:48:43	 1441	   49667 164357 		  INACTIVE arserverd@helpdeskpapp7 (TNS V1-V3)					      39517

