post setting redolog shipping zdlra with dataguard

1. create user RAVPC1 on protected database

create user ravpc1 identified by Welcome1;

2. create new orapw with entries

orapwd file='/u01/app/oracle/product/12.1.0.2/dbhome_1/dbs/orapwOPRFSODBSD1' password=OR4cl35y5#2015 entries=5

3. grand sysoper to ravpc1

grant sysoper,create session to ravpc1;

4. copy orapw to instance 2 and standby database

5. alter dest_state belongs to standby database to defer  

ALTER SYSTEM SET log_archive_dest_state_3='DEFER' SCOPE=BOTH;

6. alter dest_state belongs to standby database to enable

ALTER SYSTEM SET log_archive_dest_state_3='ENABLE' SCOPE=BOTH;

7. check on all instance (primary and standby), it must has same result

select * from v$pwfile_users;