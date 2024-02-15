
--Check SHARED_POOL UTIL
$sqlplus / as sysdba 
SQL>@shared_pool_memory_usage.sql


---Check 
select * from gv$sgastat
where pool='shared pool'
order by bytes asc;

select inst_id,round(sum(S.SHARABLE_MEM)/(1024*1024),1) as Memory_MB
from gv$sql s
group by inst_id
order by 2 desc;


--------------------------------------------------------------------------------------------------

--FLUSH SHARED_POOL

SQL> alter system flush shared_pool;
--setelah itu restart database nya