--Check MEMBER
col member for a60
set lines 999
set pages 999
SELECT a.group#, a.member, (b.bytes/1024/1024) FROM v$logfile a, v$log b WHERE a.group# = b.group# order by 1,2;
 
    GROUP# MEMBER							(B.BYTES/1024/1024)
---------- ------------------------------------------------------------ -------------------
	 1 +DATAC4/OPC2PODD/ONLINELOG/group_1.21573.1038824543			       1024
	 1 +RECOC4/OPC2PODD/ONLINELOG/group_1.110457.1038824543 		       1024
	 2 +DATAC4/OPC2PODD/ONLINELOG/group_2.21557.1038824545			       1024
	 2 +RECOC4/OPC2PODD/ONLINELOG/group_2.12312.1038824547			       1024
	 3 +DATAC4/OPC2PODD/ONLINELOG/group_3.29485.1038824547			       1024
	 3 +RECOC4/OPC2PODD/ONLINELOG/group_3.2638.1038824549			       1024
	 4 +DATAC4/OPC2PODD/ONLINELOG/group_4.29486.1038824549			       1024
	 4 +RECOC4/OPC2PODD/ONLINELOG/group_4.23647.1038824551			       1024
	 5 +DATAC4/OPC2PODD/ONLINELOG/group_5.2887.1038824551			       1024
	 5 +RECOC4/OPC2PODD/ONLINELOG/group_5.109283.1038824553 		       1024
	 6 +DATAC4/OPC2PODD/ONLINELOG/group_6.2888.1038824555			       1024
	 6 +RECOC4/OPC2PODD/ONLINELOG/group_6.1832.1038824555			       1024
	 7 +DATAC4/OPC2PODD/ONLINELOG/group_7.2889.1038824557			       1024
	 7 +RECOC4/OPC2PODD/ONLINELOG/group_7.21520.1038824557			       1024
	 8 +DATAC4/OPC2PODD/ONLINELOG/group_8.2890.1038824559			       1024
	 8 +RECOC4/OPC2PODD/ONLINELOG/group_8.5098.1038824559			       1024
	 9 +DATAC4/OPC2PODD/ONLINELOG/group_9.2891.1038824561			       1024
	 9 +RECOC4/OPC2PODD/ONLINELOG/group_9.113142.1038824563 		       1024
	10 +DATAC4/OPC2PODD/ONLINELOG/group_10.2892.1038824563			       1024
	10 +RECOC4/OPC2PODD/ONLINELOG/group_10.109558.1038824565		       1024



--Check STATUS
select group#,thread#,archived,status,bytes/1024/1024 from v$log;

    GROUP#    THREAD# ARC STATUS	   BYTES/1024/1024
---------- ---------- --- ---------------- ---------------
	 1	    1 YES ACTIVE		      1024
	 2	    1 NO  ACTIVE		      1024
	 3	    1 NO  CURRENT		      1024
	 4	    1 YES ACTIVE		      1024
	 5	    1 YES ACTIVE		      1024
	 6	    2 YES ACTIVE		      1024
	 7	    2 YES ACTIVE		      1024
	 8	    2 YES ACTIVE		      1024
	 9	    2 NO  CURRENT		      1024
	10	    2 YES ACTIVE		      1024

10 rows selected.




--Check SIZE and STATUS STANDBY LOG
select group#,sum(bytes/1024/1024)"Size in MB" from v$standby_log group by group# order by 1;

    GROUP# Size in MB
---------- ----------
	14	 1024
	23	 1024
	15	 1024
	11	 1024
	12	 1024
	21	 1024
	22	 1024
	26	 1024
	13	 1024
	16	 1024
	24	 1024
	25	 1024

12 rows selected.


#STATUS
select group#,thread#,archived,status,bytes/1024/1024 from v$standby_log;

    GROUP#    THREAD# ARC STATUS     BYTES/1024/1024
---------- ---------- --- ---------- ---------------
	11	    1 YES UNASSIGNED		1024
	12	    1 YES UNASSIGNED		1024
	13	    1 YES UNASSIGNED		1024
	14	    1 YES UNASSIGNED		1024
	15	    1 YES UNASSIGNED		1024
	16	    1 YES UNASSIGNED		1024
	21	    2 YES UNASSIGNED		1024
	22	    2 YES UNASSIGNED		1024
	23	    2 YES UNASSIGNED		1024
	24	    2 YES UNASSIGNED		1024
	25	    2 YES UNASSIGNED		1024
	26	    2 YES UNASSIGNED		1024



-----------------------------------------------------------------------------------------------------------------------------------------

1. Check STATUS LOG FILE --sebelum di drop

#ADD logfile --satu per satu
#THRED1
alter database add logfile THREAD 1 group 31 ('+DATAC4','+RECOC4') size 10G;
alter database add logfile THREAD 1 group 32 ('+DATAC4','+RECOC4') size 10G;
alter database add logfile THREAD 1 group 33 ('+DATAC4','+RECOC4') size 10G;
alter database add logfile THREAD 1 group 34 ('+DATAC4','+RECOC4') size 10G;
alter database add logfile THREAD 1 group 35 ('+DATAC4','+RECOC4') size 10G;
#THRED2
alter database add logfile THREAD 2 group 36 ('+DATAC4','+RECOC4') size 10G;
alter database add logfile THREAD 2 group 37 ('+DATAC4','+RECOC4') size 10G;
alter database add logfile THREAD 2 group 38 ('+DATAC4','+RECOC4') size 10G;
alter database add logfile THREAD 2 group 39 ('+DATAC4','+RECOC4') size 10G;
alter database add logfile THREAD 2 group 40 ('+DATAC4','+RECOC4') size 10G;

alter system switch logfile;

SELECT GROUP#, STATUS FROM V$LOG;
SELECT GROUP#,THREAD#,ARCHIVED,STATUS,BYTES/1024/1024 FROM V$LOG;


#DROP logfile --inactive can be dropped

ALTER SYSTEM CHECKPOINT GLOBAL; 

alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;
alter database drop logfile group 4;
alter database drop logfile group 5;
alter database drop logfile group 7;
alter database drop logfile group 8;	
alter database drop logfile group 9;	
alter database drop logfile group 10;	


#CROSSCHECK
select GROUP#,THREAD#,SEQUENCE#,bytes/1024/1024,MEMBERS,STATUS from gv$log;

     
2. DROP standby_log 
SELECT GROUP#,THREAD#,ARCHIVED,STATUS,BYTES/1024/1024 FROM V$STANDBY_LOG;


#ADD STANDBY_LOG --+1 dari logfile
alter database add standby logfile THREAD 1 group 11 ('+DATAC4','+RECOC4') SIZE 10G;
alter database add standby logfile THREAD 1 group 12 ('+DATAC4','+RECOC4') SIZE 10G;
alter database add standby logfile THREAD 1 group 13 ('+DATAC4','+RECOC4') SIZE 10G;
alter database add standby logfile THREAD 1 group 14 ('+DATAC4','+RECOC4') SIZE 10G;
alter database add standby logfile THREAD 1 group 15 ('+DATAC4','+RECOC4') SIZE 10G;
alter database add standby logfile THREAD 1 group 16 ('+DATAC4','+RECOC4') SIZE 10G;
alter database add standby logfile THREAD 2 group 17 ('+DATAC4','+RECOC4') SIZE 10G;
alter database add standby logfile THREAD 2 group 18 ('+DATAC4','+RECOC4') SIZE 10G;
alter database add standby logfile THREAD 2 group 19 ('+DATAC4','+RECOC4') SIZE 10G;
alter database add standby logfile THREAD 2 group 20 ('+DATAC4','+RECOC4') SIZE 10G;
alter database add standby logfile THREAD 2 group 21 ('+DATAC4','+RECOC4') SIZE 10G;
alter database add standby logfile THREAD 2 group 22 ('+DATAC4','+RECOC4') SIZE 10G;   

alter system switch logfile;

alter database drop standby logfile group 11;
alter database drop standby logfile group 12;
alter database drop standby logfile group 13;
alter database drop standby logfile group 14;
alter database drop standby logfile group 15;
alter database drop standby logfile group 16;
alter database drop standby logfile group 21;
alter database drop standby logfile group 22;
alter database drop standby logfile group 23;
alter database drop standby logfile group 24;
alter database drop standby logfile group 25;
alter database drop standby logfile group 26;
