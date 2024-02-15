yuyu: mintul last dml nya kayak gini yak bram

select max(ora_rowscn), scn_to_timestamp(max(ora_rowscn)) from DOM.OM_RESERVATION_FIRSTPAY;


SELECT TABLE_OWNER,TABLE_NAME,INSERTS,UPDATES,DELETES,TIMESTAMP AS LAST_CHANGE
FROM  DBA_TAB_MODIFICATIONS
WHERE TO_CHAR(TIMESTAMP,'DD.MM.YYYY') = TO_CHAR(sysdate,'DD.MM.YYYY') 
and table_owner='DOM'
and table_name in ('OM_RESERVATION_FIRSTPAY')


--CEK LAST DDL
set linesize 200
set pagesize 30
col owner for a10
col object_name for a40
select owner, object_name, object_type, created, to_char(last_ddl_time,'YYYY-MM-DD HH24:mi:ss')
from dba_objects 
where owner='DOM'
and object_name='OM_RESERVATION_FIRSTPAY' 
order by 5;

