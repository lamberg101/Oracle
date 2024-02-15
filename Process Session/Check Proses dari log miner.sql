CASE:
- ada yang drop table jam 15:12 tapi tidak ada yang mengaku
- Check dari log/session/hisoty tidak ada
- akhrinya di Check dari log miner

================================================================================================================================

begin
	begin
		sys.dbms_logmnr.end_logmnr;
	exception
		when others then null;
	end;

	sys.dbms_logmnr.add_logfile('+RECOC5/OPPOMTBS/ARCHIVELOG/2021_12_27/thread_1_seq_5048.53575.1092410371');
	sys.dbms_logmnr.start_logmnr ( options => dbms_logmnr.dict_from_online_catalog );
end;
/

ALTER SESSION SET NLS_DATE_FORMAT = 'MM/DD/RRRR HH24:MI:SS' ;
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'MM/DD/RRRR HH24:MI:SS' ;
col SEG_NAME format a30
col USERNAME format a30
col machine_name format a30
set lines 200
select TIMESTAMP,SEG_NAME,USERNAME,machine_name from  V$LOGMNR_CONTENTS where OPERATION='DDL' and SEGMENT_NAME='CB_MULTIDIM_2021_12_27';

BEGIN
  DBMS_LOGMNR.end_logmnr;
END;
/

*****

begin
	begin
		sys.dbms_logmnr.end_logmnr;
	exception
		when others then null;
	end;

	sys.dbms_logmnr.add_logfile('+RECOC5/OPPOMTBS/ARCHIVELOG/2021_12_27/thread_2_seq_5190.42685.1092409937');
	sys.dbms_logmnr.start_logmnr ( options => dbms_logmnr.dict_from_online_catalog );
end;
/

ALTER SESSION SET NLS_DATE_FORMAT = 'MM/DD/RRRR HH24:MI:SS' ;
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'MM/DD/RRRR HH24:MI:SS' ;
col SEG_NAME format a30
col USERNAME format a30
col machine_name format a30
set lines 200
select TIMESTAMP,SEG_NAME,USERNAME,machine_name from  V$LOGMNR_CONTENTS where OPERATION='DDL' and SEGMENT_NAME='CB_MULTIDIM_2021_12_27';

BEGIN
  DBMS_LOGMNR.end_logmnr;
END;
/

******
begin
	begin
		sys.dbms_logmnr.end_logmnr;
	exception
		when others then null;
	end;

	sys.dbms_logmnr.add_logfile('+RECOC5/OPPOMTBS/ARCHIVELOG/2021_12_27/thread_2_seq_5191.43418.1092410497');
	sys.dbms_logmnr.start_logmnr ( options => dbms_logmnr.dict_from_online_catalog );
end;
/

ALTER SESSION SET NLS_DATE_FORMAT = 'MM/DD/RRRR HH24:MI:SS' ;
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'MM/DD/RRRR HH24:MI:SS' ;
col SEG_NAME format a30
col USERNAME format a30
col machine_name format a30
set lines 200
select TIMESTAMP,SEG_NAME,USERNAME,machine_name from  V$LOGMNR_CONTENTS where OPERATION='DDL' and SEGMENT_NAME='CB_MULTIDIM_2021_12_27';

BEGIN
  DBMS_LOGMNR.end_logmnr;
END;
/