
--CHECK GAP MANUAL --SEBELUM HK FRA STANDBY. (PRIMARY & STANDBY)

SQL> archive log list; 
Database log mode	       		Archive Mode
Automatic archival	       		Enabled
Archive destination	       		USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     	35021
Next log sequence to archive   	35025
Current log sequence	       	35025

Note! Kadang hasilnya di standby 0, makanya Check manual pake script dibawah.
SQL> select sequence#,applied from v$archived_log where thread#=1 order by 1;
SQL> select sequence#,applied from v$archived_log where thread#=2 order by 1;


------------------------------------------------------------------------------------------------------------------------------------

--Check SYNC PRIMARY/STANDBY (ODG or GAP)


set linesize 200
select dest_id,thread#,max(primary) primary, max(transf) maxtransf,
	   max(standby) standby, MAX(primary)-MAX(transf) mintransf_gap, MAX(primary)-MAX(standby) apply_gap,
	   max(timegap) hoursgap
from (
SELECT dest_id,thread#,max(sequence#) primary, 0 transf, 0 standby, 0 timegap
	 FROM v$archived_log
	WHERE STANDBY_DEST='YES'
	  and archived = 'YES'
	  AND resetlogs_change# = ( select d.resetlogs_change# from v$database d )
GROUP BY dest_id,thread#
union all
SELECT dest_id,thread#,0 primary, max(sequence#) transf, 0 standby, 0 timegap
	 FROM v$archived_log
	WHERE STANDBY_DEST='YES'
	  and archived = 'YES'
	AND resetlogs_change# = ( select d.resetlogs_change# from v$database d )
	GROUP BY dest_id,thread#
	union all
SELECT dest_id,thread#,0 primary, 0 transf, max(sequence#) standby, trunc((sysdate-max(FIRST_TIME))*24) timegap
	 FROM v$archived_log
	WHERE STANDBY_DEST='YES'
	  and applied = 'YES'
	  AND resetlogs_change# = ( select d.resetlogs_change# from v$database d )
 GROUP BY dest_id,thread#
) asd
group by dest_id,thread#
order by thread#,dest_id;


--------------------------------------------------------------------------------------------------------------------------------

--CHECK SETELAH ODG
SELECT sid, serial#, context,sofar, totalwork,
round(sofar/totalwork*100,2) "% Complete"
FROM v$session_longops
WHERE opname LIKE 'RMAN%'
AND opname NOT LIKE '%aggregate%'
AND totalwork != 0
AND sofar != totalwork;
