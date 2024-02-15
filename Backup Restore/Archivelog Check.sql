
--Check squence, applied
set lines 999
set pages 999
select sequence#,applied 
from gv$archived_log 
where applied='YES' 
order by 1;


---------------------------------------------------------------------------------------------------------------------

--Check archive log list
SQL> show parameter db_recovery_file_dest


--Check recovery_area_usage
SQL> SELECT * FROM V$RECOVERY_AREA_USAGE;


--Check recovery_file_dest
SQL> SELECT * FROM V$RECOVERY_FILE_DEST;

----------------------------------------------------------------------------------------------------------------------

5. sebelum HK FRA standby.
--ODG Check manual. primary & standby

SQL> archive log list; 
Database log mode	       Archive Mode
Automatic archival	       Enabled
Archive destination	       USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     35021
Next log sequence to archive   35025
Current log sequence	       35025

note! 
- kadang hasilnya di standby 0, makanya Check manual pake script dibawah.
- thread# itu node.

select sequence#,applied from v$archived_log where thread#=1 order by 1;
select sequence#,applied from v$archived_log where thread#=2 order by 1;

-----------------------------------------------------------------------------------------------------------------------------------------------
