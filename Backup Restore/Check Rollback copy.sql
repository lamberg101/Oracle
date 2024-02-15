select segment_name, tablespace_name, status
from sys.dba_rollback_segs
where segment_name='customer_kpi';

--CHECK RECOVER ROLLBACK
select usn, state, undoblockstotal "Total", undoblocksdone "Done", 
undoblockstotal-undoblocksdone "ToDo",
decode(cputime,0,'unknown',to_char(sysdate+(((undoblockstotal-undoblocksdone) / (undoblocksdone / cputime)) / 86400), 
'YYYY/MM/DD HH24:MI')) "Estimated time to complete" 
from gv$fast_start_transactions;