Jadi, begini.. ODG OPUIM sedang gap gede, 
sementara ini dest_2 yg primary gue DEFER, 
MRP nya masih jalan, archive yang sudah kekirim 1200an, 
lagi tunggu apply dulu perlahan2, cuma impactnya agak tinggi nanti di OPHPOINT/db2 IMC.


------------------------------------------------------------------------------------------------------------------------------------

THREAD 1 --HK NYA PAKE RMAN

set pages 999
set lines 999
select dest_id, thread#, sequence#, first_time, next_time, blocks, standby_dest, archived, registrar, applied, deleted, status, fal 
from gv$archived_log 
where thread#=1 
and applied='YES' 
and deleted='NO' 
order by first_change# 
desc fetch first 1000 row only;


delete force archivelog from sequence 206358 until sequence 206419 thread 1;


------------------------------------------------------------------------------------------------------------------------------------

THREAD 2--HK NYA PAKE RMAN

set pages 999
set lines 999
select dest_id, thread#, sequence#, first_time, next_time, blocks, standby_dest, archived, registrar, applied, deleted, status, fal 
from gv$archived_log 
where thread#=2 
and applied='YES' 
and deleted='NO' 
order by first_change# 
desc fetch first 1000 row only;

delete force archivelog from sequence 117170 until sequence 117250 thread 2;



