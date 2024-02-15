
--Check TABLE SKIP
col error for a20
col owner for a30
col name for a30
col proc for a30
col statement_opt for a30
select * from dba_logstdby_skip
where owner like '%NEWTSPOIN%';

col error for a20
col owner for a30
col name for a30
col proc for a30
col STATEMENT_OPT for a30
select * from dba_logstdby_skip where owner in ('TELKOMSEL','DEDY_WIDYANTO')
and name not like '%CMP%'
;

TCPUR043T
------------------------------------------------------------------------------------------------------------------------------


--CONTOH SKIP
alter database stop logical standby apply;
EXECUTE DBMS_LOGSTDBY.SKIP(stmt => 'DML', schema_name => 'EAI', object_name =>'CMP3$972168');
alter database start logical standby apply immediate;


------------------------------------------------------------------------------------------------------------------------------

--Kalau create dkk pake ini
alter database stop logical standby apply;
BEGIN
  dbms_logstdby.skip('DML','TELKOMSEL','CMP3$339619');
  dbms_logstdby.skip('SCHEMA_DDL','TELKOMSEL','CMP3$339619');
END;
/
alter database start logical standby apply immediate;









------------------------------------------------------------------------------------------------------------------------------

--CONTOH UNSKIP
alter database stop logical standby apply;
EXECUTE DBMS_LOGSTDBY.INSTANTIATE_TABLE( SCHEMA_NAME => 'LACIMA', TABLE_NAME => 'LCM_OSS_VALIDASI_MASTER_SAD', dblink => 'TEST');
exec dbms_logstdby.unskip('DML','LACIMA','LCM_OSS_VALIDASI_MASTER_SAD');
alter database start logical standby apply immediate;

alter database stop logical standby apply;
EXECUTE DBMS_LOGSTDBY.INSTANTIATE_TABLE( SCHEMA_NAME => 'LACIMA', TABLE_NAME => 'CORE_BATAS_DES_NATIONAL_REGION', dblink => 'TEST');
exec dbms_logstdby.unskip('SCHEMA_DDL','LACIMA','CORE_BATAS_DES_NATIONAL_REGION');
alter database start logical standby apply immediate;