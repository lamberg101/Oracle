1. Disable Auditing

In a RAC database:
SQL> ALTER SYSTEM SET audit_trail=NONE SCOPE=spfile sid='*';

In a Single Instance Database:
SQL> ALTER SYSTEM SET audit_trail=NONE SCOPE=spfile ;

Restart the database to have the change take affect, or do a rolling restart, one instance at a time.


-------------------------------------------------------------------------------------------------------------------------

2. Check size Table AUD.

select segment_name, sum(bytes/1024/1024/1024) GB 
from dba_segments 
where SEGMENT_NAME like '%AUD$%'
group by segment_name; 



desc sys.aud$
desc dba_audit_trail

-------------------------------------------------------------------------------------------------------------------------

select OS_USERNAME, USERNAME, TIMESTAMP from dba_audit_trail
where OWNER='ESBSVOC'
and OBJ_NAME='KYC';

select SESSIONID, ACTION#, USERID, STATEMENT from SYS.AUD$
where OBJ$NAME like '%KYC%';
select * from SYS.AUD$ where rownum <5;



-------------------------------------------------------------------------------------------------------------------------

3. Audit file/path.

> Formatnya ora_OSID.aud
> Berisi history koneksi dari user sysdba (sys). 
> Juga berisi hasil audit aktivitas user untuk AUDIT_TRAIL=OS. 
> Lokasinya ditunjukkan oleh parameter audit_file_dest 
> The first default directory is $ORACLE_BASE/admin/$ORACLE_SID/adump.
SQL> sho parameter audit_file_dest


lanjut
https://docs.oracle.com/cd/E11882_01/server.112/e10575/tdpsg_auditing.htm#TDPSG55284