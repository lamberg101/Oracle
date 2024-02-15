Masuk ke profile capture di OEM13
Pakai owner SYSTEM
kalau tidak bisa, Check lagi table itu ownernya siapa

select owner,segment_name,tablespace_name
from dba_segments
where segment_name in ('TBL_TPS_DETAIL','TBL_TPS');


select a.instance_name, a.AVG_Month ,b. MINIMAL, b.MAXSIMAL 
from (
	select DISTINCT a.instance_name , to_char(AVG(a.avg_transperseconds),'999.99') AVG_Month 
		from SYSTEM.TBL_TPS a 
		where to_char(TPS_DATE,'MMYYYY')='112019' 
		group BY a.instance_name
		order by a.instance_name) a, 
	(
	select distinct INSTANCE_NAME, MIN(tranxpersecond) Minimal, MAX(tranxpersecond) maxsimal 
		from SYSTEM.TBL_TPS_DETAIL 
		where to_char(BEGIN_TIME,'MMYYYY')='112019' 
		group BY INSTANCE_NAME) b
where b.INSTANCE_NAME=a.INSTANCE_NAME  
and a.instance_name in ('OPSCV1','OPSCV2')
order by a.instance_name;



sama yg 2 ini paan yak?
/home/oracle/Oracle_Alert/tps.sh  
/home/oracle/Oracle_Alert/tps_detail.sh
Itu Check TPS, pastikan dblink nya connect semua