disable flashback:
--------------------
select name,open_mode,log_mode,flashback_on from v$database;

alter database flashback off;

drop restore point:
-------------------
SQL> select GUARANTEE_FLASHBACK_DATABASE,NAME ,TIME from v$restore_point;

GUA NAME       TIME
--- --------------------------------------------------------------------------------------------------------------------------------
YES PRE_UPGRADE_PRI 27-AUG-20 07.49.01.000000000 PM


SQL> drop restore point BEFORE_ACTIVATE_OPSCM19;