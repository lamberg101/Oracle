ketika ada gap di zdlra

--Check USER NYA
select * from v$pwfile_users;


kalau tidak ada, create
--CREATE USER RAVPC1 on protected database
SQL> create user ravpc1 identified by Welcome123;


--CREATE NEW ORAPW WITH ENTRIES
$ orapwd file='/u01/app/oracle/product/11.2.0.4/dbhome_1/dbs/orapwOPRCS1' password=OR4cl35y5#2015 entries=5


--GRAND SYSOPER TO RAVPC1
SQL> grant sysoper,create session to ravpc1;


--COPY ORAPW TO INSTANCE 2 
$ scp orapwOPRCS1 oracle@10.54.128.7:/u01/app/oracle/product/11.2.0.4/dbhome_1/dbs/orapwOPRCS2


--ALTER DEST_STATE BELONGS TO STANDBY DATABASE TO DEFER  
SQL> ALTER SYSTEM SET log_archive_dest_state_2='DEFER' SCOPE=BOTH;


--ALTER DEST_STATE BELONGS TO STANDBY DATABASE TO ENABLE
SQL> ALTER SYSTEM SET log_archive_dest_state_2='ENABLE' SCOPE=BOTH;


--CHECK ON ALL INSTANCE (primary and standby), it must has same result
SQL> select * from v$pwfile_users;


--SWITCH LOGFILE
SQL> alter system switch all logfile;